module Classic_Pong_Top (
    
    // switches
    input sw1_i,
    input sw2_i,
    input sw3_i,
    input sw4_i,

    // VGA
    output VGA_Hsync_o,
    output VGA_Vsync_o,
    output VGA_Red_0_o,
    output VGA_Red_1_o,
    output VGA_Red_2_o,
    output VGA_Grn_0_o,
    output VGA_Grn_1_o,
    output VGA_Grn_2_o,
    output VGA_Blu_0_o,
    output VGA_Blu_1_o,
    output VGA_Blu_2_o

);

    // 25 000 000 / 115 200 = 217
    parameter CLKS_PER_BIT = 217;

    // VGA Constants
    parameter VIDEO_WIDTH = 3;
    parameter TOTAL_COLS = 800;
    parameter TOTAL_ROWS = 525;
    parameter ACTIVE_COLS = 640;
    parameter ACTIVE_ROWS = 480;

    // Common VGA Signals
    wire [VIDEO_WIDTH-1:0] Red_Video_Pong_w, Red_Video_Porch_w;
    wire [VIDEO_WIDTH-1:0] Grn_Video_Pong_w, Grn_Video_Porch_w;
    wire [VIDEO_WIDTH-1:0] Blu_Video_Pong_w, Blu_Video_Porch_w;

    // Receiver to start game
    wire rx_dv_w;

    UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_Inst
    (
        .clk_i(clk_i),
        .rx_serial_i(UART_RX_i),
        .rx_dv_o(rx_dv_w),
        .rx_byte_o()
    );

    // Generate Hsync and Vsync to run VGA

    wire Hsync_w, Vsync_w;

    VGA_Sync_Pulse #( .TOTAL_COLS(TOTAL_COLS),
                      .TOTAL_ROWS(TOTAL_ROWS),
                      .ACTIVE_COLS(ACTIVE_COLS),
                      .ACTIVE_ROWS(ACTIVE_ROWS) ) 
    VGA_Sync_Inst 
    (
        .clk_i(clk_i),
        .Hsync_o(Hsync_w),
        .Vsync_o(Vsync_w),
        .col_count_o(),
        .row_count_o()
    );

    // Debounce Switches
    wire sw1_w, sw2_w, sw3_w, sw4_w;

    Debounced_Switch sw_1
    (
        .clk_i(clk_i),
        .sw_i(sw1_i),
        .sw_o(sw1_w)
    );

    Debounced_Switch sw_2
    (
        .clk_i(clk_i),
        .sw_i(sw2_i),
        .sw_o(sw2_w)
    );

    Debounced_Switch sw_3
    (
        .clk_i(clk_i),
        .sw_i(sw3_i),
        .sw_o(sw3_w)
    );

    Debounced_Switch sw_4
    (
        .clk_i(clk_i),
        .sw_i(sw4_i),
        .sw_o(sw4_w)
    );
    
    // Pong Top: Handles game logic
    wire Hsync_Pong_w, Vsync_Pong_w;

    Pong_Top #( .TOTAL_COLS(TOTAL_COLS),
                      .TOTAL_ROWS(TOTAL_ROWS),
                      .ACTIVE_COLS(ACTIVE_COLS),
                      .ACTIVE_ROWS(ACTIVE_ROWS) ) 
    Pong_Top_Inst (
        .clk_i(clk_i),
        .Hsync_i(Hsync_w),
        .Vsync_i(Vsync_w),
        .Game_Start_i(rx_dv_w),
        .Paddle_Up_P1_i(sw1_w),
        .Paddle_Down_P1_i(sw2_w),
        .Paddle_Up_P2_i(sw3_w),
        .Paddle_Down_P2_i(sw4_w),
        .Hsync_o(Hsync_Pong_w),
        .Vsync_o(Vsync_Pong_w),
        .Red_Video_o(Red_Video_Pong_w),
        .Grn_Video_o(Grn_Video_Pong_w),
        .Blue_Video_o(Blu_Video_Pong_w)
    );

    // Add front and back porch to VGA signals
    VGA_Sync_Porch #(
        .VIDEO_WIDTH(VIDEO_WIDTH),  // Use parameter directly
        .TOTAL_COLS(TOTAL_COLS),
        .TOTAL_ROWS(TOTAL_ROWS),
        .ACTIVE_COLS(ACTIVE_COLS),
        .ACTIVE_ROWS(ACTIVE_ROWS)
    ) VGA_Sync_Porch_Inst (
        .clk_i(clk_i),
        .Hsync_i(Hsync_Pong_w),
        .Vsync_i(Vsync_Pong_w),
        .red_video_i(Red_Video_Pong_w),
        .grn_video_i(Grn_Video_Pong_w),
        .blu_video_i(Blu_Video_Pong_w),
        .Hsync_o(Hsync_porch_w),
        .Vsync_o(Vsync_porch_w),
        .red_video_o(Red_Video_Porch_w),
        .grn_video_o(Grn_Video_Porch_w),
        .blu_video_o(Blu_Video_Porch_w)
    );

    assign { VGA_Red_2_o, VGA_Red_1_o, VGA_Red_0_o } = Red_Video_Porch_w; 

    assign { VGA_Grn_2_o, VGA_Grn_1_o, VGA_Grn_0_o } = Grn_Video_Porch_w; 

    assign { VGA_Blu_2_o, VGA_Blu_1_o, VGA_Blu_0_o } = Blu_Video_Porch_w; 

    
endmodule