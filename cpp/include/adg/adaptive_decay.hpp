#pragma once
#include "hash.hpp"
#include "phase_clock.hpp"
#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <fstream>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>

namespace prob_counting::decay {
constexpr double tick_scale = 1024.;
constexpr std::uint32_t random_scale = 65536;

struct Rule {
    std::uint16_t low, high;
    std::uint32_t threshold;
    double bias, variance;
    bool saturated;
    std::uint16_t sample(std::uint16_t word) const { return word < threshold ? high : low; }
};

struct Grid {
    std::string name;
    std::vector<std::uint64_t> ticks;
    double decode(std::uint16_t state) const { return ticks[state]/tick_scale; }
    double maximum() const { return ticks.back()/tick_scale; }
    Rule rule(double target) const {
        target = std::max(0., target);
        if (target >= maximum()) {
            const auto k = std::uint16_t(ticks.size()-1);
            return {k,k,0,maximum()-target,0.,target>maximum()};
        }
        const auto it = std::upper_bound(ticks.begin(),ticks.end(),target*tick_scale,
                                        [](double x,std::uint64_t y) {return x<double(y);});
        const auto low = std::uint16_t(it-ticks.begin()-1), high = std::uint16_t(low+1);
        const double a=decode(low), b=decode(high);
        const auto threshold=std::uint32_t(std::min(65536.,std::max(0.,std::floor((target-a)/(b-a)*65536.+.5))));
        const double p=threshold/65536.;
        return {low,high,threshold,a+p*(b-a)-target,p*(1-p)*(b-a)*(b-a),false};
    }
};

inline std::vector<Grid> read_grids(const std::string& path) {
    std::ifstream input(path,std::ios::binary);
    char magic[4];input.read(magic,4);
    std::uint32_t count=0,states=0;input.read(reinterpret_cast<char*>(&count),4);input.read(reinterpret_cast<char*>(&states),4);
    if (!input||std::string(magic,4)!="ADG1"||count!=3||states<2||states>65536)
        throw std::runtime_error("ADG1 grid bundle required");
    std::vector<Grid> grids(count);
    for (auto& grid:grids) {
        std::uint32_t length=0;input.read(reinterpret_cast<char*>(&length),4);
        if (length>64) throw std::runtime_error("grid name length");
        grid.name.resize(length);input.read(grid.name.data(),length);
        grid.ticks.resize(states);input.read(reinterpret_cast<char*>(grid.ticks.data()),states*8);
        if (!input||grid.ticks.front()!=0) throw std::runtime_error("grid contents");
        for (std::size_t k=1;k<grid.ticks.size();++k)
            if (grid.ticks[k]<=grid.ticks[k-1]) throw std::runtime_error("increasing grid required");
    }
    return grids;
}

struct Config {
    double tau_us=96817.6252924919, epsilon=.001, maximum=16777216.;
    std::uint64_t quantum_us=256,maintenance_us=500000,drain_us=1000;
    unsigned time_bits=15;
    bool short_time=true;
    std::uint64_t retention_us() const {return std::uint64_t(std::ceil(tau_us*std::log(maximum/epsilon)));}
    std::uint64_t mask() const {return (std::uint64_t{1}<<time_bits)-1;}
    std::uint64_t epoch(std::uint64_t t) const {return short_time ? (t/quantum_us)&mask() : t/quantum_us;}
    std::uint64_t age(std::uint64_t saved,std::uint64_t t) const {
        return (short_time ? (epoch(t)-saved)&mask() : epoch(t)-saved)*quantum_us;
    }
    unsigned cell_bits() const {return 16+time_bits+1;}
    static Config choose(double tau,bool short_clock=true) {
        Config c;c.tau_us=tau;c.short_time=short_clock;c.quantum_us=1;
        for (std::uint64_t q=1;q<=1024;q*=2) if (std::expm1(q/tau)<=.005) c.quantum_us=q;
        c.time_bits=1;
        while ((std::uint64_t{1}<<c.time_bits)*c.quantum_us<=
               c.retention_us()+c.maintenance_us+2*c.quantum_us+2*c.drain_us) ++c.time_bits;
        if (!short_clock) c.time_bits=32;
        return c;
    }
};

class TransferKernel {
public:
    virtual ~TransferKernel()=default;
    virtual double decode(unsigned profile,std::uint16_t state) const=0;
    virtual Rule rule(int source,int target,double increment,std::uint16_t state,std::uint64_t age) const=0;
    virtual std::size_t entries() const=0;
    virtual std::size_t bytes() const=0;
    std::uint16_t sample(int source,int target,double increment,std::uint16_t state,
                         std::uint64_t age,std::uint16_t word) const {return rule(source,target,increment,state,age).sample(word);}
};

struct Snapshot {std::uint16_t state=0;int profile=1;std::uint64_t saved_us=0;};
struct Stats {
    std::uint64_t updates=0,maintenance_visits=0,maintenance_writes=0,migrations=0,expirations=0,saturations=0,activations=0;
};
struct Transition {std::uint64_t activated_us,retire_due_us,retired_us=0;int source,target;};

class Sketch {
    void store(std::size_t index,double target,std::uint64_t now,std::uint16_t word) {
        const auto rule=grids[profiles[active_slot]].rule(target);
        state[index]=rule.sample(word);time[index]=config.epoch(now);slot[index]=std::uint8_t(active_slot);
        stats.saturations+=rule.saturated;
    }
    void transition(std::size_t p,double increment,std::uint64_t now,std::uint16_t word) {
        if (!factorized) {store(p,anchor_value(p,now)+increment,now,word);return;}
        const auto age=config.age(time[p],now);
        const bool expired=!state[p]||age>=config.retention_us();
        const int source=expired ? profiles[active_slot] : profiles[slot[p]];
        if (factorized) {
            const auto rule=factorized->rule(source,profiles[active_slot],increment,expired?0:state[p],expired?0:age/config.quantum_us);
            state[p]=rule.sample(word);stats.saturations+=rule.saturated;
        }
        time[p]=config.epoch(now);slot[p]=std::uint8_t(active_slot);
    }
public:
    const std::vector<Grid>& grids;
    Config config;
    std::size_t width,rows;
    std::uint64_t seed,now_us=0,visits=0,retire_at=0;
    std::vector<std::uint16_t> state;
    std::vector<std::uint64_t> time;
    std::vector<std::uint8_t> slot;
    std::array<int,2> profiles;
    int active_slot=0,retiring_slot=-1;
    Stats stats;
    std::vector<Transition> transitions;
    const TransferKernel* factorized=nullptr;
    const PhaseClock* phase_clock=nullptr;
    Sketch(std::size_t w,const std::vector<Grid>& g,Config c,std::uint64_t s=1729,int profile=1,std::size_t r=2)
        :grids(g),config(c),width(w),rows(r),seed(s),state(w*r),time(w*r),slot(w*r),profiles{profile,-1} {
        if (!w||!r) throw std::invalid_argument("positive sketch dimensions");
    }
    std::size_t index(std::uint64_t key,std::size_t row) const {
        return row*width+mix64(key^mix64(seed+UINT64_C(0x9e3779b97f4a7c15)*(row+1)))%width;
    }
    double anchor_value(std::size_t p,std::uint64_t now) const {
        if (!state[p]) return 0.;
        const auto age=config.age(time[p],now);
        if (config.short_time&&age>=config.retention_us()) return 0.;
        return grids[profiles[slot[p]]].decode(state[p])*std::exp(-double(age)/config.tau_us);
    }
    double arrival_weight(std::uint64_t now) const {return phase_clock?phase_clock->increment(now):1.;}
    double phase_scale(std::uint64_t now) const {return phase_clock?phase_clock->query_scale(now):1.;}
    double value(std::size_t p,std::uint64_t now) const {return anchor_value(p,now)*phase_scale(now);}
    Snapshot snapshot(std::size_t p,std::uint64_t now) const {
        return {state[p],state[p]?profiles[slot[p]]:profiles[active_slot],
                now/config.quantum_us*config.quantum_us-config.age(time[p],now)};
    }
    void maintain(std::size_t p,std::uint64_t now,std::uint16_t word) {
        ++stats.maintenance_visits;
        if (!state[p]) return;
        if (config.short_time&&config.age(time[p],now)>=config.retention_us()) {
            state[p]=0;slot[p]=std::uint8_t(active_slot);time[p]=config.epoch(now);
            ++stats.expirations;++stats.maintenance_writes;
        } else if (slot[p]!=active_slot) {
            transition(p,0,now,word);
            ++stats.migrations;++stats.maintenance_writes;
        }
    }
    void advance_to(std::uint64_t now) {
        if (now<now_us) throw std::invalid_argument("monotone scheduler time");
        const auto cells=state.size(),due=now*cells/config.maintenance_us;
        while (visits<due) {
            ++visits;const auto p=(visits-1)%cells;
            const auto when=(visits*config.maintenance_us+cells-1)/cells;
            maintain(p,when,std::uint16_t(mix64(seed^visits^(std::uint64_t(p)<<32))));
        }
        now_us=now;
        if (retiring_slot>=0&&now>=retire_at) {
            for (std::size_t p=0;p<cells;++p)
                if (state[p]&&slot[p]==retiring_slot) throw std::runtime_error("old version remains live");
            profiles[retiring_slot]=-1;retiring_slot=-1;transitions.back().retired_us=now;
        }
    }
    bool activate(int profile,std::uint64_t now) {
        advance_to(now);
        if (profile==profiles[active_slot]||retiring_slot>=0) return false;
        const int old=active_slot;active_slot=1-old;profiles[active_slot]=profile;retiring_slot=old;
        retire_at=now+config.maintenance_us+2*config.drain_us;
        transitions.push_back({now,retire_at,0,profiles[old],profile});++stats.activations;
        return true;
    }
    void update(std::uint64_t key,std::uint64_t now,std::uint16_t word) {
        advance_to(now);
        const double weight=arrival_weight(now);
        for (std::size_t r=0;r<rows;++r) {
            const auto p=index(key,r);
            if (state[p]&&slot[p]!=active_slot) ++stats.migrations;
            transition(p,weight,now,word);
        }
        ++stats.updates;
    }
    double query(std::uint64_t key,std::uint64_t now) const {
        if (now!=now_us) throw std::invalid_argument("query epoch must equal scheduler time");
        double answer=std::numeric_limits<double>::infinity();
        for (std::size_t r=0;r<rows;++r) answer=std::min(answer,anchor_value(index(key,r),now));
        return answer*phase_scale(now);
    }
    std::vector<double> bucket_values(std::uint64_t now) const {
        std::vector<double> result(state.size());
        const double scale=phase_scale(now);
        for (std::size_t p=0;p<state.size();++p) result[p]=anchor_value(p,now)*scale;
        return result;
    }
    std::size_t logical_state_bytes() const {return (state.size()*config.cell_bits()+7)/8;}
};

struct Selection {
    std::uint64_t ended_us;
    int source,recommended,activated=-1;
    std::array<double,3> losses;
    double predicted_gain,coverage;
    unsigned agreement;
    bool eligible;
};


} // namespace prob_counting::decay
