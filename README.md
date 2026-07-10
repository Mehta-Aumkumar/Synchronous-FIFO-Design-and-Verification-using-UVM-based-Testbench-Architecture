# Synchronous-FIFO-Design-and-Verification-using-UVM-based-Testbench-Architecture

A UVM-style (class-based) SystemVerilog testbench for verifying a synchronous FIFO design using randomized stimulus, functional checking, and a queue-based scoreboard.

## Overview

This project implements a synchronous FIFO in Verilog and verifies it using a layered SystemVerilog testbench built around the Generator-Driver-Monitor-Scoreboard architecture, connected via mailboxes and events.

## FIFO Design Specs

- Data Width: 8 bits (parameterizable)
- Depth: 16 (parameterizable)
- Synchronous read/write with active-high reset
- Full and empty flag generation based on internal counter

## Testbench Architecture

| Component | Role |
|---|---|
| `transaction` | Randomized stimulus item (read/write operation, data) |
| `generator` | Generates randomized transactions and sends them via mailbox |
| `driver` | Drives transactions onto the DUT interface |
| `monitor` | Samples DUT interface signals and forwards to scoreboard |
| `scoreboard` | Maintains a reference queue and checks read data against expected values |
| `environment` | Instantiates and connects all components, handles run phases |
| `fifo_if` | SystemVerilog interface connecting DUT and testbench |

### Verification Flow

1. `generator` randomizes `oper` (50/50 read/write split) and `data_in`, sends via mailbox to `driver`.
2. `driver` drives the FIFO interface signals accordingly.
3. `monitor` samples the interface every clock and forwards a snapshot to `scoreboard`.
4. `scoreboard` pushes write data into a queue and pops/compares on reads, flagging mismatches.
5. `environment` runs all components in parallel using `fork...join_any` and reports total errors at the end.

## Key Verification Features

- Constrained-random stimulus generation (`dist` constraint for read/write ratio)
- Mailbox-based inter-component communication
- Event-based synchronization between generator and scoreboard
- Self-checking scoreboard using a queue-based reference model
- Waveform dumping for debug (`dump.vcd`)

## Tools Used

- SystemVerilog (class-based OOP testbench)
- xilinx vivado
