#pragma once
#include "adaptive_decay.hpp"

namespace prob_counting::decay {

template<class Word>
class PackedSketch {
    std::vector<Word> cells;
    const TransferKernel& codec;
    Config config;
    std::size_t width;
    std::uint64_t seed,visits=0,now_us=0,retire_at=0;
    std::array<int,2> profiles{1,-1};
    const PhaseClock* phase_clock;
    unsigned active=0;
    int retiring=-1;
    std::uint16_t state(std::size_t p) const {return std::uint16_t(cells[p]);}
    unsigned slot(std::size_t p) const {return unsigned((std::uint64_t(cells[p])>>(16+config.time_bits))&1);}
    std::uint64_t stamp(std::size_t p) const {return (std::uint64_t(cells[p])>>16)&config.mask();}
    void store(std::size_t p,std::uint16_t value,std::uint64_t now) {
        cells[p]=Word(std::uint64_t(value)|(config.epoch(now)<<16)|(std::uint64_t(active)<<(16+config.time_bits)));
    }
    void transition(std::size_t p,double increment,std::uint64_t now,std::uint16_t word) {
        const auto age=config.age(stamp(p),now);
        const bool expired=!state(p)||age>=config.retention_us();
        const auto code=codec.sample(expired?profiles[active]:profiles[slot(p)],profiles[active],increment,
                                     expired?0:state(p),expired?0:age/config.quantum_us,word);
        store(p,code,now);
    }
public:
    PackedSketch(std::size_t w,const TransferKernel& map,Config c,std::uint64_t s,const PhaseClock* phase=nullptr)
        :cells(w*2),codec(map),config(c),width(w),seed(s),phase_clock(phase) {
        if (c.cell_bits()>sizeof(Word)*8) throw std::invalid_argument("packed word width");
    }
    std::size_t index(std::uint64_t key,unsigned row) const {
        return row*width+mix64(key^mix64(seed+UINT64_C(0x9e3779b97f4a7c15)*(row+1)))%width;
    }
    double value(std::size_t p,std::uint64_t now) const {
        if (!state(p)) return 0;
        const auto age=config.age(stamp(p),now);
        if (age>=config.retention_us()) return 0;
        return codec.decode(profiles[slot(p)],state(p))*std::exp(-double(age)/config.tau_us)*
               (phase_clock?phase_clock->query_scale(now):1.);
    }
    void advance_to(std::uint64_t now) {
        const auto due=now*cells.size()/config.maintenance_us;
        while (visits<due) {
            ++visits;const auto p=(visits-1)%cells.size();
            const auto when=(visits*config.maintenance_us+cells.size()-1)/cells.size();
            if (!state(p)) continue;
            if (config.age(stamp(p),when)>=config.retention_us()) store(p,0,when);
            else if (slot(p)!=active) transition(p,0,when,std::uint16_t(mix64(seed^visits^(std::uint64_t(p)<<32))));
        }
        now_us=now;
        if (retiring>=0&&now>=retire_at) {profiles[retiring]=-1;retiring=-1;}
    }
    bool activate(int profile,std::uint64_t now) {
        advance_to(now);
        if (profile==profiles[active]||retiring>=0) return false;
        retiring=int(active);active=1-active;profiles[active]=profile;
        retire_at=now+config.maintenance_us+2*config.drain_us;
        return true;
    }
    void update(std::uint64_t key,std::uint64_t now,std::uint16_t word) {
        advance_to(now);
        const double weight=phase_clock?phase_clock->increment(now):1.;
        for (unsigned row=0;row<2;++row) transition(index(key,row),weight,now,word);
    }
    double query(std::uint64_t key,std::uint64_t now) const {
        return std::min(value(index(key,0),now),value(index(key,1),now));
    }
    bool matches(const Sketch& reference) const {
        for (std::size_t p=0;p<cells.size();++p)
            if (state(p)!=reference.state[p]||slot(p)!=reference.slot[p]||
                (stamp(p)&reference.config.mask())!=(reference.time[p]&reference.config.mask())) return false;
        return true;
    }
    std::size_t array_bytes() const {return cells.size()*sizeof(Word);}
};
}
