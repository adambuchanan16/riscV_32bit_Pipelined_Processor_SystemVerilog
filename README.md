# 32-bit RISC-V Pipelined Processor (SystemVerilog)

A custom **32-bit RV32I pipelined CPU** implemented in SystemVerilog and verified in simulation using Xilinx Vivado.

## Features

* 5-stage pipeline: **IF → ID → EX → MEM → WB**
* Hazard detection unit (pipeline stall logic)
* Forwarding unit (data hazard resolution)
* Branch and jump support (BEQ, JAL, JALR)
* Instruction and data memory
* SystemVerilog verification testbench
* RISC-V assembly toolchain support

Simulation verified in **Xilinx Vivado**.

## Repository Structure

```
rtl/   -> CPU RTL modules (pipeline stages, ALU, control logic, hazard/forward units)
sim/   -> SystemVerilog testbenches
asm/   -> RISC-V assembly programs executed by the CPU
```

Key modules:

* `cpuPipelined.sv` – Top-level CPU pipeline implementation
* `controlUnit.sv` – Instruction decode and control signal generation
* `hazardUnit.sv` – Pipeline stall logic
* `forwardUnit.sv` – Data forwarding logic
* `ALU.sv` – Arithmetic logic unit

## Example Program

The included assembly program demonstrates pipeline execution and arithmetic operations.
Example output from simulation:

```
x1 = 11
x2 = 55
PASS: sum 1..10 program
```

## Tools Used

* SystemVerilog
* Xilinx Vivado Simulator
* RISC-V GNU Toolchain
