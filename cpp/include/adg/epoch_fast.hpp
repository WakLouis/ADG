#pragma once
#include "adaptive_decay.hpp"

namespace prob_counting::decay {

struct DensePrefix {
    std::uint32_t step_ticks=0,end_state=0;
    explicit DensePrefix(const Grid& grid) {
        step_ticks=std::uint32_t(grid.ticks[1]);end_state=1;
        while (end_state+1<grid.ticks.size()&&grid.ticks[end_state+1]-grid.ticks[end_state]==step_ticks)
            ++end_state;
        if (end_state+1<grid.ticks.size()&&grid.ticks[end_state+1]-grid.ticks[end_state]<step_ticks)
            throw std::invalid_argument("dense boundary gap");
    }
    std::uint32_t delta(std::uint32_t injection_q16,std::uint16_t word) const {
        const auto gap=std::uint64_t(step_ticks)<<16,value=std::uint64_t(injection_q16)<<10;
        const auto threshold=((value%gap)*65536+gap/2)/gap;
        return std::uint32_t(value/gap+(word<threshold));
    }
};

struct ExecutionStats {
    std::uint64_t packets=0,fast_rows=0,slow_rows=0;
    std::array<std::uint64_t,4> masks{};
    std::array<std::uint64_t,3> reason_rows{},reason_packets{}; // epoch, range, version
};

class EpochFastExecutor {
    Sketch& sketch;
    const TransferKernel& transfer;
    std::array<DensePrefix,3> prefix;
public:
    ExecutionStats stats;
    EpochFastExecutor(Sketch& value,const TransferKernel& kernel)
        :sketch(value),transfer(kernel),prefix{DensePrefix(value.grids[0]),DensePrefix(value.grids[1]),DensePrefix(value.grids[2])} {}
    unsigned update(std::uint64_t key,std::uint64_t now,std::uint16_t word) {
        sketch.advance_to(now);
        const auto weight=sketch.arrival_weight(now);
        const auto injection=std::uint32_t(std::llround(weight*65536));
        const auto target=sketch.profiles[sketch.active_slot];
        const auto delta=prefix[target].delta(injection,word);
        const auto limit=prefix[target].end_state-delta;
        const auto epoch=sketch.config.epoch(now);
        unsigned mask=0,reasons=0;
        for (unsigned row=0;row<2;++row) {
            const auto p=sketch.index(key,row);
            if (sketch.state[p]&&sketch.slot[p]!=sketch.active_slot) ++sketch.stats.migrations;
            const bool same_epoch=sketch.time[p]==epoch,same_slot=sketch.slot[p]==sketch.active_slot;
            if (same_epoch&&same_slot&&sketch.state[p]<=limit) {
                sketch.state[p]=std::uint16_t(sketch.state[p]+delta);++stats.fast_rows;
            } else {
                mask|=1u<<row;++stats.slow_rows;
                // Disjoint row reasons; packet reasons form an overlapping union.
                const unsigned reason=!same_slot?2:!same_epoch?0:1;
                ++stats.reason_rows[reason];reasons|=1u<<reason;
                const auto age=sketch.config.age(sketch.time[p],now);
                const bool expired=!sketch.state[p]||age>=sketch.config.retention_us();
                const auto source=expired?target:sketch.profiles[sketch.slot[p]];
                const auto rule=transfer.rule(source,target,weight,expired?0:sketch.state[p],expired?0:age/sketch.config.quantum_us);
                sketch.state[p]=rule.sample(word);sketch.stats.saturations+=rule.saturated;
                sketch.time[p]=epoch;sketch.slot[p]=std::uint8_t(sketch.active_slot);
            }
        }
        for (unsigned reason=0;reason<3;++reason) stats.reason_packets[reason]+=(reasons>>reason)&1;
        ++stats.packets;++stats.masks[mask];++sketch.stats.updates;
        return mask;
    }
};
}
