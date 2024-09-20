`include "Pong_Top.v"
`include "VGA_Sync_Count.v"
`include "Pong_Paddle_Ctl.v"
`include "Pong_Ball_Ctl.v"

module Pong_Top_tb;

    // 25 Mhz clock
    // 115200 Baud Rate
    
    // 1 / 25 000 000 Mhz = 40 ns
    parameter CLK_PERIOD = 40;

    // Inputs 
    reg clk;
    reg Hsync;
    reg Vsync;
    reg Game_Start;
    reg Paddle_Up_P1;
    reg Paddle_Down_P1;
    reg Paddle_Up_P2;
    reg Paddle_Down_P2;

    // Outputs 
    wire Vsync_out;
    wire [2:0] Red_Video;
    wire [2:0] Grn_Video;
    wire [2:0] Blu_Video;

    // Instantiate the module under test (MUT)
    Pong_Top #(
        .TOTAL_COLS(800), 
        .TOTAL_ROWS(525),
        .ACTIVE_COLS(640),
        .ACTIVE_ROWS(480)
    ) uut (
        .clk_i(clk),
        .Hsync_i(Hsync),
        .Vsync_i(Vsync),
        .Game_Start_i(Game_Start),
        .Paddle_Up_P1_i(Paddle_Up_P1),
        .Paddle_Down_P1_i(Paddle_Down_P1),
        .Paddle_Up_P2_i(Paddle_Up_P2),
        .Paddle_Down_P2_i(Paddle_Down_P2),
        .Hsync_o(Hsync_out),
        .Vsync_o(Vsync_out),
        .Red_Video_o(Red_Video),
        .Grn_Video_o(Grn_Video),
        .Blue_Video_o(Blu_Video)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        Hsync = 0;
        Vsync = 0;
        Game_Start = 0;
        Paddle_Up_P1 = 0;
        Paddle_Down_P1 = 0;
        Paddle_Up_P2 = 0;
        Paddle_Down_P2 = 0;

        // Generate clock signal
        always #(CLK_PERIOD/2) clk = ~clk;  // 50 MHz clock

        $dumpfile("dump.vcd");
        $dumpvars(1, Pong_Top_tb);
      
        // Start game after 100 ns
        #100;
        Game_Start = 1;
        #20;
        Game_Start = 0;

        // Player 3 Paddle movement
        #500;
        Paddle_Up_P1 = 1;
        #100;
        Paddle_Up_P1 = 0;
        Paddle_Down_P1 = 1;
        #100;
        Paddle_Down_P1 = 0;

        // Player 2 Paddle Movement
        #500;
        Paddle_Up_P2 = 1;
        #100;
        Paddle_Up_P2 = 0;
        Paddle_Down_P2 = 1;
        #100;
        Paddle_Down_P2 = 0;

        #2000;

        $finish();
    end

endmodule
