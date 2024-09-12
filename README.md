# Classic Pong Game: Designed on FPGA with VGA Display

This project is a fully functional Pong game written in Verilog for the iCE40 FPGA Development Board. It utilizes the four onboard switches for player control and drives a VGA display for the game screen. The FPGA starts the game when indicated by the computer using UART via a Micro-USB cable connected to the development board's adapter.

### System Design
![System Design](https://github.com/user-attachments/assets/e4f6f87a-9fb0-4995-8ce3-9ec6c86b043e)

The design consists of 9 Verilog modules:
- `UART_RX.v`: UART receiver to start the game.
- `VGA_Sync_Pulse.v`: Generates sync pulses (Hsync and Vsync) for the active and inactive areas of the display.
- `Debounced_Switch.v`: A module to debounce the switches used for gameplay (four total).
- `VGA_Sync_Count.v`: Identifies the index of the current pixel the display is currently on.
- `Paddle_Ctl.v`: Handles player paddle controls.
- `Ball_Ctl.v`: Manages the ball control in the Pong game.
- `VGA_Sync_Porch.v`: Modifies the sync pulses to account for the front and back porch used to center the VGA display.
- `Pong_Top.v`: This top-level module contains the gameplay logic.
- `Classic_Pong_Top.v`: The highest-level module containing the entire project.

## Build Instructions
This project utilizes a completely open-source FPGA toolchain for synthesis, place and route, and programming on Linux (Ubuntu 22.04). The `build.sh` shell script optimizes the synthesis and place and route steps, creating a binary bitstream.

**Required Software**:
- [Yosys](https://github.com/YosysHQ/yosys): Open Source Verilog Synthesis
- [nextpnr](https://github.com/YosysHQ/nextpnr): Open Source Place and Route for ICE40 FPGA
- [icestorm](https://github.com/YosysHQ/icestorm): Open Source Programming for ICE40 FPGA

## Thank You for Checking Out This Project!
I appreciate your time and thank you for reading this!
