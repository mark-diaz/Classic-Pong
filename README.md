# Classic Pong Game: Designed on FPGA with VGA Display

This project is a fully functional Pong game written in Verilog for an iCE40 FPGA Development Board. It utilizes the four onboard switches for player control and drives a VGA display for the game screen. The FPGA starts the game when indicated by the computer using UART via a Micro-USB cable connected to the development board's adapter.

## System Design
![System Design](https://github.com/user-attachments/assets/e4f6f87a-9fb0-4995-8ce3-9ec6c86b043e)

The design consists of 9 Verilog modules:

**Gameplay**:
- `Classic_Pong_Top.v`: The highest-level module containing the entire project (Gameplay, Utility, and VGA)
  - `Pong_Top.v`: This top-level module contains the gameplay logic (Paddle and Ball control)
    - `Paddle_Ctl.v`: Handles player paddle controls (receives switch signals)
    - `Ball_Ctl.v`: Manages the ball control in the Pong game 

**Utility**:
  - `UART_RX.v`: UART receiver to start the game (data valid pulse is used to start game)
  - `Debounced_Switch.v`: A module to debounce the switches used for gameplay (four total)

**VGA display**:
- `VGA_Sync_Pulse.v`: Generates sync pulses (Hsync and Vsync) for the active and inactive areas of the display (640 x 480 Display)
- `VGA_Sync_Porch.v`: Modifies the sync pulses to account for the front and back porch used to center the VGA display
  - `VGA_Sync_Count.v`: Helper module that identifies the index of the current pixel the display is currently on 

#### Development Board Schematic:
<img width="713" alt="image" src="https://github.com/user-attachments/assets/7363d034-a214-4906-bf56-335c7cb033d9">

- This schematic showcases the interface between the FPGA and the four switches and VGA connector (three signals for red, green and blue)

## Build Instructions
To create a bitstream and program my FPGA I used a completely open-source FPGA toolchain on a Linux (Ubuntu 22.04) machine. `build.sh` is a shell script that runs the synthesis and place and route steps, creating a binary bitstream.

**FPGA Toolchain**:
- [Yosys](https://github.com/YosysHQ/yosys): Open Source Verilog Synthesis
- [nextpnr](https://github.com/YosysHQ/nextpnr): Open Source Place and Route for ICE40 FPGA
- [icestorm](https://github.com/YosysHQ/icestorm): Open Source Programming for ICE40 FPGA

## Thank You for Checking Out This Project!
I appreciate your time and thank you for reading this!
