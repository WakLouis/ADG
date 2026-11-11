# Tofino 2 implementation

## Layout

- `p4src/epoch_tofino2_long.p4` and `epoch_tofino2_short.p4`: T2NA programs.
- `config/long/` and `config/short/`: clock parameters and numerical BFRT rules.
- `control/epoch_control.py`: table installation, slot configuration, and queries.
- `control/adg_controller.py`: configurable command-line BFRT and maintenance access.
- `scripts/`: build, switch-daemon, and controller entrypoints.

Each program has two rows of 65,536 32-bit buckets. Fine, balanced, and medium
grids share the numerical pipeline; the active slot selects the destination
grid. The return writeback carries both row addresses and a two-bit mask.

| Clock | Time constant | Clock interval | Time-tag bits |
|---|---:|---:|---:|
| Long | 96.818 ms | 262.144 us | 14 |
| Short | 12.102 ms | 32.768 us | 15 |

## Requirements and build

Use Intel P4 Studio SDE 9.12 with Tofino 2 support and its Python BFRT bindings.
Set `SDE` and expose the SDE Python packages in `PYTHONPATH`.

```bash
export SDE=/path/to/bf-sde-9.12.0
export SDE_INSTALL="$SDE/install"
bash p4/scripts/build_p4.sh long
bash p4/scripts/start_switchd.sh long
```

Use `short` in both commands for the short-clock program.

## Install and operate

With the matching program running, provide the egress and internal return
device ports used by your deployment:

```bash
bash p4/scripts/run_controller.sh install --clock long --pipe 0 \
    --egress-port 0 --return-port 6
bash p4/scripts/run_controller.sh words --clock long --pipe 0 --indices 0 0
bash p4/scripts/run_controller.sh query --clock long --pipe 0 \
    --indices 0 0 --now-ns 100000000 --profiles 0 1
```

Port numbers are command-line deployment settings. Physical ports can be
configured through your existing SDE port manager; `--install-port` installs
the selected egress port at 100 Gb/s. Mirror session 1 directs return packets
to the supplied return port. The program matches local return port 6.

`configure --active 0 --profiles 0 1` publishes the active slot and the two
grid identifiers (fine=0, balanced=1, medium=2). Keep a source slot immutable
while buckets or in-flight operations refer to it.

## Time and maintenance interface

IPv4 TCP/UDP packets use the ASIC timestamp and random source. Control packets
with EtherType `0x88b9` carry an operation, 48-bit time, two 16-bit row addresses,
two state words, a 16-bit random word, and a sequence field. Operation 0 updates,
1 reads, 2 performs maintenance, and 3 loads explicit state.

Run a maintenance sweep with a timestamp in the same clock domain as updates:

```bash
sudo python3 p4/control/adg_controller.py sweep --interface eth0 --now-ns 100000000
```

Each sweep visits both rows. Schedule scans within the selected retention and
tag-period coverage bound. BFRT queries also take the update-clock timestamp
explicitly and decode each bucket through its source slot.
