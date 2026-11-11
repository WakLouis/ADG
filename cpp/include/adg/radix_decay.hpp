#pragma once
#include "adaptive_decay.hpp"

namespace prob_counting::decay {

// Segment words: start-state[15:0], base-Q10[50:16], log2-step[56:51].
class RadixTransfer : public TransferKernel {
    std::array<std::vector<std::uint64_t>,3> segments;
    std::vector<double> age_high,age_low;
    std::uint64_t quantum,retention;
    double maximum;
    static std::uint64_t base(std::uint64_t word) {return (word>>16)&((UINT64_C(1)<<35)-1);}
    static unsigned shift(std::uint64_t word) {return unsigned(word>>51);}
    static std::uint16_t start(std::uint64_t word) {return std::uint16_t(word);}
public:
    RadixTransfer(const std::vector<Grid>& grids,const Config& config)
        :quantum(config.quantum_us),retention(config.retention_us()),maximum(grids[0].maximum()) {
        for (unsigned j=0;j<3;++j) {
            std::uint64_t previous=0;
            for (std::size_t s=0;s+1<grids[j].ticks.size();++s) {
                auto width=grids[j].ticks[s+1]-grids[j].ticks[s];
                if (!width||(width&(width-1))) throw std::invalid_argument("dyadic grid required");
                if (width!=previous) {
                    unsigned exponent=0;for (auto x=width;x>1;x>>=1) ++exponent;
                    segments[j].push_back(std::uint64_t(s)|(grids[j].ticks[s]<<16)|(std::uint64_t(exponent)<<51));
                    previous=width;
                }
            }
        }
        age_high.resize(std::size_t{1}<<(config.time_bits-7));age_low.resize(128);
        for (std::size_t i=0;i<age_high.size();++i) age_high[i]=std::exp(-double(i*128*quantum)/config.tau_us);
        for (std::size_t i=0;i<age_low.size();++i) age_low[i]=std::exp(-double(i*quantum)/config.tau_us);
        for (unsigned j=0;j<3;++j) for (unsigned s=0;s<65536;++s)
            if (decode(j,std::uint16_t(s))!=grids[j].decode(std::uint16_t(s)))
                throw std::runtime_error("radix segment decode differs from grid");
    }
    double decode(unsigned profile,std::uint16_t state) const override {
        const auto& words=segments[profile];
        auto it=std::upper_bound(words.begin(),words.end(),state,
            [](std::uint16_t value,std::uint64_t word) {return value<start(word);});
        const auto word=*--it;
        return (base(word)+(std::uint64_t(state-start(word))<<shift(word)))/tick_scale;
    }
    Rule rule(int source,int target,double increment,std::uint16_t state,std::uint64_t age) const override {
        const double value=(age*quantum>=retention?0:decode(source,state)*age_high[age>>7]*age_low[age&127])+increment;
        if (value>=maximum) return {65535,65535,0,maximum-value,0,value>maximum};
        const double ticks=value*tick_scale;
        const auto& words=segments[target];
        auto it=std::upper_bound(words.begin(),words.end(),ticks,
            [](double value,std::uint64_t word) {return value<double(base(word));});
        const auto word=*--it;
        const auto low=std::uint16_t(start(word)+(std::uint64_t(ticks-base(word))>>shift(word)));
        const auto high=std::uint16_t(low+1);
        const double a=decode(target,low),b=decode(target,high);
        const auto threshold=std::uint32_t(std::clamp(std::floor((value-a)/(b-a)*65536.+.5),0.,65536.));
        const double p=threshold/65536.;
        return {low,high,threshold,a+p*(b-a)-value,p*(1-p)*(b-a)*(b-a),false};
    }
    std::size_t entries() const override {
        std::size_t count=age_high.size()+age_low.size();
        for (const auto& words:segments) count+=words.size();
        return count;
    }
    std::size_t bytes() const override {return entries()*8+96;}
};
} // namespace prob_counting::decay
