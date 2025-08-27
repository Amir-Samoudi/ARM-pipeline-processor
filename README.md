# Verilog Implementation of an ARM Pipeline Processor on FPGA

This repository contains the project for the **"Computer Architecture Lab"** course, featuring a Verilog implementation of a **5-stage pipelined ARM processor**.  
The design is based on the **ARM968E-S core** from the ARM9 family and is fully synthesized and implemented on an **Altera Cyclone II FPGA**.

---

## Project Overview
The primary goal of this project was to design and implement a functional pipeline processor based on a real-world ARM architecture.  
This involved:
- Writing synthesizable Verilog code  
- Integrating **memory components**  
- Handling **pipeline hazards**

---

## Processor Architecture & Features
- **Core**: ARM968E-S (ARM9 Family)  
- **ISA**: Implements a subset of **13 key instructions**  
- **Pipeline**: 5-stage classic RISC pipeline
- **Hazard Detection**: Includes a **forwarding unit** to resolve data hazards and minimize stalls  
- **Memory System**:  
  - **Data Memory**: Utilizes the FPGA's onboard SRAM for fast data access  
  - **Cache Memory**: A cache module reduces memory latency and improves performance  

---

## Implementation and Tools
- **Hardware Description Language**: Verilog  
- **Synthesis & Implementation**: Intel Quartus  
- **Target Hardware**: Successfully implemented and tested on an **Altera Cyclone II FPGA development board**. Used Signal Tap feature to verify the processor implemented on FPGA  

---
