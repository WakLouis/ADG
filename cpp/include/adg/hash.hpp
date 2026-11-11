#pragma once
#include <cstdint>
namespace prob_counting {
inline std::uint64_t mix64(std::uint64_t x) {
    x = (x ^ (x >> 30)) * UINT64_C(0xbf58476d1ce4e5b9);
    x = (x ^ (x >> 27)) * UINT64_C(0x94d049bb133111eb);
    return x ^ (x >> 31);
}
} // namespace prob_counting
