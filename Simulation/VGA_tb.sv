`include "VGA_Sync_Porch.v"
`include "VGA_Sync_Count.v"

module VGA_Sync_Porch_tb;

    // 1 / 25 000 000 Mhz = 40 ns
    parameter CLK_PERIOD = 40;

    // Inputs 
    reg clk;
    reg Hsync;
    reg Vsync;
    reg [2:0] red_video;
    reg [2:0] grn_video;
    reg [2:0] blu_video;

    // Outputs 
    wire Hsync_out;
    wire Vsync_out;
    wire [2:0] red_video_out;
    wire [2:0] grn_video_out;
    wire [2:0] blu_video_out;

    VGA_Sync_Porch #(
        .VIDEO_WIDTH(3),
        .TOTAL_COLS(640),
        .TOTAL_ROWS(480),
        .ACTIVE_COLS(600),
        .ACTIVE_ROWS(440)
    ) uut (
        .clk_i(clk),
        .Hsync_i(Hsync),
        .Vsync_i(Vsync),
        .red_video_i(red_video),
        .grn_video_i(grn_video),
        .blu_video_i(blu_video),
        .Hsync_o(Hsync_out),
        .Vsync_o(Vsync_out),
        .red_video_o(red_video_out),
        .grn_video_o(grn_video_out),
        .blu_video_o(blu_video_out)
    );
  
    // Generate clock signal
    always #(CLK_PERIOD / 2) clk_r <= ~clk_r; // 25 Mhz Clock

    // Test stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        Hsync = 0;
        Vsync = 0;
        red_video = 3'b000;
        grn_video = 3'b000;
        blu_video = 3'b000;


        $dumpfile("dump.vcd");
        $dumpvars(1, VGA_Sync_Porch_tb);
      
        // Active video signals
        #20;
        Hsync = 1;
        Vsync = 1;
        red_video = 3'b101;
        grn_video = 3'b011;
        blu_video = 3'b110; 
        
        #2000;

        // Inactive video signals
        Hsync = 0;
        Vsync = 0;
        red_video = 3'b000;
        grn_video = 3'b000;
        blu_video = 3'b000;

        #1000;

        $finish();
    end

endmodule
