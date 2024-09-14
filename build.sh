#!/bin/bash

set -e # exit on failure

CLEAN=false;

# Incorrect Use Output
if [[ $# -eq 0 ]]; then
    echo "Usage $0 [--clean] file_1.v [file_2.v ... file_n.v]"
    exit 1
fi

# Clean option:
if [ "$1" == "--clean" ]; then
    CLEAN=true
    shift
fi

# Synthesis: Yosys
yosys -p "read_verilog $@; synth_ice40; write_json design.json" 

# Place and Route: nextpnr
nextpnr-ice40 --hx1k --freq 25 --pcf board-constraints.pcf --json design.json --package vq100 --asc bitstream.txt

# Programmer: Icestorm
icepack bitstream.txt bitstream.bin # bitstream to binary

# Delete temp files with --clean flag
if [ "$CLEAN" == true ]; then
    echo -e "Removing temp files...\n"
    rm -f a.out design.json bitstream.txt 
fi

echo "To program the FPGA run the command:"
echo -e "iceprog bitstream.bin\n"