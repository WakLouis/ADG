# C++ implementation

## Requirements and build

Use CMake 3.16 or newer and a C++17 compiler:

```bash
cmake -S cpp -B cpp/build -DCMAKE_BUILD_TYPE=Release
cmake --build cpp/build -j 2
```

`adg` is a header-only CMake target. Its headers are under `include/adg/`,
and the C++ namespace is `prob_counting::decay`.

## Streaming interface

```bash
cpp/build/adg_stream [budget_kib=768] [tau_us=96817.6252924919]
```

Supply `update KEY TIME_US` or `query KEY TIME_US` on standard input in
nondecreasing time order. Query output is `key,time_us,estimate` in packets.
Use `tau_us=12102.2031615615` for the short setting. The example drives
maintenance and controller periods as event time advances and uses seed 15485863.

## Library layout

- `adaptive_decay.hpp`: grids, finite-bit rounding moments, time configuration,
  fused transitions, lazy migration, and observable sketch state.
- `radix_decay.hpp`: compact segment decoding and factored decay tables.
- `phase_clock.hpp`: arrival weights and query-time projection.
- `query_risk_controller.hpp`: sampled rounding-risk scores and grid activation.
- `packed_decay.hpp`: `PackedSketch<uint32_t>` with one packed word per bucket.
- `epoch_fast.hpp`: dense-prefix updates using code increments.
- `grids.hpp`: the three compact grid definitions and their decoder expansion.

`Sketch` exposes separate host arrays for controller observations.
`PackedSketch` provides the packed state layout. Decoded grid caches are host
lookup structures; the logical budget counts the packed bucket fields and
the shared numerical tables. Both row addresses use modulo the selected
integer width.

Keep the grids, transfer kernel, and phase clock alive for the lifetime of
the sketch. Call `advance_to(time_us)` before querying `Sketch` at that time.
`QueryRiskController` observes updates before they are committed and evaluates
its accumulated scores at decision-period boundaries, as shown in `stream.cpp`.
