# ADG: Adaptive Decay Grids

ADG maintains exponentially decayed per-key counts with a 16-bit count code,
a short time tag, and a configuration-slot bit. Arrivals add one packet;
the contribution of each packet decreases exponentially with age.

This repository provides two implementation paths:

- [`cpp/`](cpp/README.md): C++17 count encoding, fused updates, arrival-phase
  correction, short timestamps, maintenance, and online grid selection.
- [`p4/`](p4/README.md): Tofino 2 P4 programs for the long and short clocks,
  numerical table configuration, and BFRT control interfaces.

The compact grid definitions shared by both implementations are in
[`config/grids.json`](config/grids.json). All three grids contain 65,536
codes and cover counts through 2^24.

## Mechanism map

| Mechanism | C++ | P4 / BFRT |
|---|---|---|
| Count encoding and stochastic rounding | `Grid`, `RadixTransfer` | Source decoding and destination encoding tables |
| Fused decay and packet update | `Sketch`, `PackedSketch` | Ingress/egress numerical pipeline and masked return writeback |
| Arrival-phase correction | `PhaseClock` | Shared phase-weight tables |
| Short timestamps and expiration | `Config`, `advance_to` | Packed time tags, read-time expiration, maintenance packets |
| Grid selection and two slots | `QueryRiskController`, `activate` | Slot metadata and `EpochControl.configure` |
| Dense-prefix direct updates | `EpochFast` | Conditional register actions |

## Quick start

```bash
cmake -S cpp -B cpp/build -DCMAKE_BUILD_TYPE=Release
cmake --build cpp/build -j 2
printf 'update 7 0\nquery 7 0\nquery 7 10000\n' | cpp/build/adg_stream 768
```

The C++ program chooses the largest integer bucket count that fits the supplied
logical memory budget, including shared numerical and phase tables. At 768 KiB,
the long and short settings use 97,822 and 97,806 buckets per row.
The Tofino 2 programs use two 65,536-entry register arrays.
