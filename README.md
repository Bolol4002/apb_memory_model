# APB Memory Module (Verilog)

A simple and fully functional **APB-compatible memory module** written in Verilog HDL.  
Implements a 128 × 8-bit memory array with proper **APB handshake**, **read/write operations**,  
and **file-based backdoor access** for testbench verification.

---

## 🧩 Overview

This module acts as a **slave device** on an APB (Advanced Peripheral Bus) interface.  
It supports both front-door (APB bus) and backdoor (file I/O) access to memory contents.

| Feature | Description |
|:--------|:-------------|
| Address Width | 8-bit (0–127 valid range) |
| Data Width | 8-bit |
| Memory Depth | 128 bytes |
| Bus Interface | APB (AMBA 3 compliant structure) |
| File Operations | `$readmemh` for load, `$writememh` for dump |
| Simulation Tool | Icarus Verilog (iverilog + GTKWave) |

---

## ⚙️ Module Ports

| Signal | Dir | Width | Description |
|:-------|:----|:------|:-------------|
| `pclk` | in | 1 | APB clock |
| `prst` | in | 1 | Active-high reset |
| `paddr` | in | 8 | Address input |
| `pwrite` | in | 1 | Write=1, Read=0 |
| `pwdata` | in | 8 | Data input for writes |
| `psel` | in | 1 | Slave select |
| `penable` | in | 1 | Active phase signal |
| `load` | in | 1 | Load memory contents from file (`image_i.hex`) |
| `fetch` | in | 1 | Dump memory contents to file (`image_o.hex`) |
| `prdata` | out | 8 | Data output for reads |
| `pready` | out | 1 | Handshake ready signal |
| `pslverr` | out | 1 | Error flag for invalid address |

---

## 🧠 Functional Description

### Reset Phase
- Clears all memory locations to `0x00`
- Sets outputs to known safe states

### Load Phase
- Uses `$readmemh("image_i.hex", mem)` to initialize memory
- File should contain one byte per line (hexadecimal format)

### Write Operation
- Triggered when `psel=1`, `penable=1`, and `pwrite=1`
- Writes `pwdata` to address `paddr`

### Read Operation
- Triggered when `psel=1`, `penable=1`, and `pwrite=0`
- Returns `mem[paddr]` on `prdata`

### Fetch Phase
- Dumps current memory contents into `image_o.hex` using `$writememh`

---

## 🧰 File Structure

