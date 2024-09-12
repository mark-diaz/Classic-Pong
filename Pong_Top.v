module Pong_Top 
    #(parameter TOTAL_COLS = 800, 
    parameter TOTAL_ROWS = 525, 
    parameter ACTIVE_COLS = 640, 
    parameter ACTIVE_ROWS = 480)
(
    input clk_i,
    input Hsync_i,
    input Vsync_i,
    
    // Start game signal
    input Game_Start_i, 

    // P1 and P2 Controls
    input Paddle_Up_P1_i,
    input Paddle_Down_P1_i,
    input Paddle_Up_P2_i,
    input Paddle_Down_P2_i,
    
    // VGA Out
    output reg Hsync_o,
    output reg Vsync_o,
    output [2:0] Red_Video_o,
    output [2:0] Grn_Video_o,
    output [2:0] Blue_Video_o
);
    
    // Game Constants
    parameter GAME_WIDTH = 40;
    parameter GAME_HEIGHT = 30;
    parameter SCORE_LIMIT = 9;
    parameter PADDLE_HEIGHT = 6;

    // Paddle locations
    parameter PADDLE_COL_P1 = 0;
    parameter PADDLE_COL_P2 = GAME_WIDTH - 1;  

    // Game States
    parameter IDLE = 3'b000;
    parameter RUNNING = 3'b001;
    parameter P1_Wins = 3'b010;
    parameter P2_Wins = 3'b011;
    parameter CLEANUP = 3'b100;

    reg [2:0] state_r = IDLE;

    wire Hsync_w, Vsync_w;
    wire [9:0] col_count_w, row_count_w;

    wire Draw_Paddle_P1_w, Draw_Paddle_P2_w; 

    wire [5:0] Paddle_Y_P1_w, Paddle_Y_P2_w;
    wire Draw_Ball_w, Draw_Any_w;

    wire [5:0] Ball_X_w, Ball_Y_w;

    reg [3:0] P1_Score_r;
    reg [3:0] P2_Score_r;

    // Divided row and col counters to make board 40x30
    wire [5:0] col_count_div_w, row_count_div_w;

    VGA_Sync_Count #(.TOTAL_COLS(TOTAL_COLS),
                  .TOTAL_ROWS(TOTAL_ROWS)) VGA_Sync_Count_Inst 
    (
        .clk_i(clk_i),
        .Hsync_i(Hsync_i),
        .Vsync_i(Vsnyc_i),
        .Hsync_o(Hsync_w),
        .Vsync_o(Vsync_w),
        .col_count_o(col_count_w),
        .row_count_o(row_count_w)
    );

    // register syncs with output
    always @(posedge clk_i) 
    begin
        Hsync_o <= Hsync_w;
        Vsync_o <= Vsync_w;
    end

    // Divide by 16 by shifting to the right
    assign col_count_div_w = col_count_w[9:4];
    assign row_count_div_w = row_count_w[9:4];

    // Player 1 Paddle
    Pong_Paddle_Ctl 
    #(.PLAYER_PADDLE_X(PADDLE_COL_P1),
    .GAME_HEIGHT(GAME_HEIGHT)) P1_Inst
    (
        .clk_i(clk_i),
        .col_count_div_i(col_count_div_w),
        .row_count_div_i(row_count_div_w),
        .Paddle_Up_i(Paddle_Up_P1_i),
        .Paddle_Down_i(Paddle_Down_P1_i),
        .Draw_Paddle_o(Draw_Paddle_P1_w),
        .Paddle_Y_o(Paddle_Y_P1_w) );

    // Player 2 Paddle
    Pong_Paddle_Ctl 
    #(.PLAYER_PADDLE_X(PADDLE_COL_P2),
    .GAME_HEIGHT(GAME_HEIGHT)) P2_Inst
    (
        .clk_i(clk_i),
        .col_count_div_i(col_count_div_w),
        .row_count_div_i(row_count_div_w),
        .Paddle_Up_i(Paddle_Up_P2_i),
        .Paddle_Down_i(Paddle_Down_P2_i),
        .Draw_Paddle_o(Draw_Paddle_P2_w),
        .Paddle_Y_o(Paddle_Y_P2_w) );

    // Ball 
    wire Game_Active_w;
    Pong_Ball_Ctl Ball_Inst
    (
        .clk_i(clk_i),
        .Game_Active_i(Game_Active_w),
        .col_count_div_i(col_count_div_w),
        .row_count_div_i(row_count_div_w),
        .Draw_Ball_o(Draw_Ball_w),
        .Ball_X_o(Ball_X_w),
        .Ball_Y_o(Ball_Y_w) );

    always @(posedge clk_i) 
    begin
        case (state_r)
            IDLE : 
            begin
                if (Game_Start_i <= 1'b1)
                    state_r <= RUNNING;
            end

            RUNNING : 
            begin
                // Ball reached left side and no paddle currently touching ball
                if (Ball_X_w == 0 && (Ball_Y_w < Paddle_Y_P1_w || Ball_Y_w > Paddle_Y_P1_w + PADDLE_HEIGHT))
                    state_r <= P2_Wins;
                            
                // Ball reached right side and no paddle currently touching ball
                else if (Ball_X_w == GAME_WIDTH-1 && (Ball_Y_w < Paddle_Y_P2_w || Ball_Y_w > Paddle_Y_P2_w + PADDLE_HEIGHT))
                    state_r <= P1_Wins;
            end

            P1_Wins : 
            begin
                if (P1_Score_r == SCORE_LIMIT - 1)
                    P1_Score_r <= 0;
                else
                begin
                    P1_Score_r <= P1_Score_r + 1;
                    state_r <= CLEANUP;
                end
            end

            P2_Wins : 
            begin
                if (P2_Score_r == SCORE_LIMIT - 1)
                    P2_Score_r <= 0;
                else
                begin
                    P2_Score_r <= P2_Score_r + 1;
                    state_r <= CLEANUP;
                end
            end

            CLEANUP :
                state_r <= IDLE;
        endcase
    end
     
    // Game is active when current state is running
    assign Game_Active_w = (state_r == RUNNING) ? 1'b1 : 1'b0;
    assign Draw_Any_w = Draw_Ball_w | Draw_Paddle_P1_w | Draw_Paddle_P2_w;

    // Assign colors 
    assign Red_Video_o = Draw_Any_w ? 4'b1111 : 4'b0000;
    assign Grn_Video_o = Draw_Any_w ? 4'b1111 : 4'b0000;
    assign Blu_Video_o = Draw_Any_w ? 4'b1111 : 4'b0000;

endmodule