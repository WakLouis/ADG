#pragma once
#include <cmath>
#include <cstdint>
#include <vector>

namespace prob_counting::decay {

// Store mass at the bucket's quantized anchor. A packet arriving d after
// that anchor contributes exp(d/tau); queries project to physical time.
class PhaseClock {
    std::uint64_t quantum;
    double tau,scale;
    std::vector<std::uint32_t> weights;
public:
    PhaseClock(std::uint64_t quantum_us,double tau_us,unsigned fraction_bits=16)
        :quantum(quantum_us),tau(tau_us),scale(std::ldexp(1.,int(fraction_bits))),weights(quantum_us) {
        for (std::size_t d=0;d<weights.size();++d)
            weights[d]=std::uint32_t(std::llround(std::exp(double(d)/tau)*scale));
    }
    double increment(std::uint64_t now) const {return weights[now%quantum]/scale;}
    double query_scale(std::uint64_t now) const {return std::exp(-double(now%quantum)/tau);}
    double coefficient_error_bound() const {return .5/scale;}
    std::size_t table_bytes() const {return weights.size()*sizeof(weights[0]);}
};
} // namespace prob_counting::decay
