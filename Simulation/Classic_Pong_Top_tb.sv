`include "Classic_Pong_Top.v"
`include "Pong_Top.v"
`include "Pong_Ball_Ctl.v"
`include "Pong_Paddle_Ctl.v"
`include "UART_RX.v"
`include "Debounced_Switch.v"
`include "VGA_Sync_Pulse.v"
`include "VGA_Sync_Count.v"
`include "VGA_Sync_Porch.v"

module Classic_Pong_Top_tb;

    // 25 Mhz clock
    // 115200 Baud Rate
    
    // 1 / 25 000 000 Mhz = 40 ns
    parameter CLK_PERIOD = 40;
    
    // 25 000 000 / 115 200 = 217
    parameter CLKS_PER_BIT = 217;

    // Inputs 
    reg clk;
    reg sw1, sw2, sw3, sw4;
    reg UART_RX;

    // Outputs 
    wire VGA_Hsync, VGA_Vsync;
    wire VGA_Red_0, VGA_Red_1, VGA_Red_2;
    wire VGA_Grn_0, VGA_Grn_1, VGA_Grn_2;
    wire VGA_Blu_0, VGA_Blu_1, VGA_Blu_2;

    Classic_Pong_Top UUT (
        .clk_i(clk),
        .UART_RX_i(UART_RX),
        .sw1_i(sw1),
        .sw2_i(sw2),
        .sw3_i(sw3),
        .sw4_i(sw4),
        .VGA_Hsync_o(VGA_Hsync),
        .VGA_Vsync_o(VGA_Vsync),
        .VGA_Red_0_o(VGA_Red_0),
        .VGA_Red_1_o(VGA_Red_1),
        .VGA_Red_2_o(VGA_Red_2),
        .VGA_Grn_0_o(VGA_Grn_0),
        .VGA_Grn_1_o(VGA_Grn_1),
        .VGA_Grn_2_o(VGA_Grn_2),
        .VGA_Blu_0_o(VGA_Blu_0),
        .VGA_Blu_1_o(VGA_Blu_1),
        .VGA_Blu_2_o(VGA_Blu_2)
    );


    // Clock generation
    always #(CLK_PERIOD / 2) clk_r <= ~clk_r; // 25 Mhz Clock

    initial begin
        clk = 0;
        sw1 = 0;
        sw2 = 0;
        sw3 = 0;
        sw4 = 0;
        UART_RX = 1;  // Idle state for UART
      
    
        $dumpfile("dump.vcd");
        $dumpvars(1, Classic_Pong_Top_tb);
      
        #100;

        // Game start as data valid bit is set high

        // Start bit UART
        UART_RX = 0;  
        #(CLKS_PER_BIT); 
        
        UART_RX = 1;  
        #(CLKS_PER_BIT * 8);       

        // Toggle player control switches (simulating player actions)
        sw1 = 1;  // Paddle Up Player 1
        #500;
        sw1 = 0;
        sw2 = 1;  // Paddle Down Player 1
        #500;
        sw2 = 0;

        sw3 = 1;  // Paddle Up Player 2
        #500;
        sw3 = 0;
        sw4 = 1;  // Paddle Down Player 2
        #500;
        sw4 = 0;

        // Observe VGA outputs for the Pong game visuals
        #5000;
        
        $finish();
    end

endmodule
