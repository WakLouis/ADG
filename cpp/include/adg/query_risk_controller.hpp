#pragma once
#include "adaptive_decay.hpp"

namespace prob_counting::decay {

// Constant-gap model: V=v/(1-alpha^2), integrated RMS over one gap equals
// tau*sqrt(v)*sqrt((1-alpha)/(1+alpha)); constant local bias integrates to
// tau*abs(bias). Actual varying trajectories use this as a causal score.
inline double integrated_query_risk(double variance,double bias,double gap,double tau) {
    const double alpha=std::exp(-gap/tau);
    return tau*(std::sqrt(variance*(-std::expm1(-gap/tau))/(1+alpha))+std::abs(bias));
}

class QueryRiskController {
    Sketch& sketch;
    std::array<double,3> energy{};
    std::uint64_t period_exports=0,points=0,last_change=0;
    int previous_best=-1;
    unsigned agreement=0,required_agreement;
    bool spacing_envelope;
public:
    std::vector<Selection> records;
    std::uint64_t export_records=0,export_bytes=0;
    static constexpr std::uint64_t residence_us=2000000;
    const std::uint64_t period_us;
    explicit QueryRiskController(Sketch& state,unsigned confirmations,bool envelope=false,
                                 std::uint64_t interval_us=1000000)
        :sketch(state),required_agreement(confirmations),spacing_envelope(envelope),period_us(interval_us) {}
    void observe(std::uint64_t key,std::uint64_t now,std::uint64_t serial) {
        const auto selected=mix64(sketch.seed^UINT64_C(0xd6e8feb86659fd93)^
                                  (serial*UINT64_C(0x9e3779b97f4a7c15)));
        if ((selected&2047)!=0) return;
        sketch.advance_to(now);++period_exports;++export_records;export_bytes+=48;
        for (std::size_t row=0;row<sketch.rows;++row) {
            const auto index=sketch.index(key,row),age=sketch.config.age(sketch.time[index],now);
            const bool expired=!sketch.state[index]||age>=sketch.config.retention_us();
            const double projected=expired?0:sketch.grids[sketch.profiles[sketch.slot[index]]]
                .decode(sketch.state[index])*std::exp(-double(age)/sketch.config.tau_us);
            const double gap=double(std::max(age,sketch.config.quantum_us));
            const auto current=sketch.profiles[sketch.active_slot];
            for (unsigned j=0;j<3;++j) {
                // Score the actual fused target once, with no pre-conversion.
                const auto update=sketch.grids[j].rule(projected+sketch.arrival_weight(now));
                const double width=sketch.grids[j].decode(update.high)-sketch.grids[j].decode(update.low);
                double score=integrated_query_risk(spacing_envelope?width*width/4:update.variance,
                    spacing_envelope?width/(2*random_scale):update.bias,gap,sketch.config.tau_us);
                if (int(j)!=current) {
                    const auto conversion=sketch.grids[j].rule(projected);
                    const double exposure=std::min(1.,gap/residence_us);
                    score+=sketch.config.tau_us*
                           (std::sqrt(conversion.variance)+std::abs(conversion.bias))*exposure;
                }
                energy[j]+=score*sketch.phase_scale(now);
            }
            ++points;
        }
    }
    void through(std::uint64_t now) {
        if (!now||now%period_us) return;
        const int source=sketch.profiles[sketch.active_slot];
        auto loss=energy;
        for (auto& value:loss) value=points?value/points:0;
        const bool complete=points&&period_exports<=100000*period_us/1000000;
        const int best=int(std::min_element(loss.begin(),loss.end())-loss.begin());
        if (complete) {agreement=previous_best==best?agreement+1:1;previous_best=best;}
        else {agreement=0;previous_best=-1;}
        const double gain=loss[source]>0?(loss[source]-loss[best])/loss[source]:0;
        const bool eligible=complete&&agreement>=required_agreement&&gain>=.1&&
                            now-last_change>=residence_us&&best!=source;
        records.push_back({now,source,best,-1,loss,gain,complete?1.:0.,agreement,eligible});
        if (eligible&&sketch.activate(best,now)) {
            records.back().activated=best;last_change=now;agreement=0;previous_best=-1;
        }
        energy={0,0,0};period_exports=0;points=0;
    }
};
} // namespace prob_counting::decay
