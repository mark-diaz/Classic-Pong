module Pong_Ball_Ctl #(
    parameter GAME_WIDTH = 40,
    parameter GAME_HEIGHT = 30 
) (

    input clk_i,
    input Game_Active_i,
    
    // Current gameboard unit being drawn 
    input [5:0] col_count_div_i,
    input [5:0] row_count_div_i,

    output reg Draw_Ball_o,

    // Current position of ball
    output reg [5:0] Ball_X_o = 0,
    output reg [5:0] Ball_Y_o = 0 
);
    
    // same speed as paddle
    parameter BALL_SPEED = 1250000;

    reg [5:0] Ball_X_prev_r = 0;
    reg [5:0] Ball_Y_prev_r = 0;
    reg [31:0] Ball_Count_r = 0;

    always @(posedge clk_i) 
    begin

        // Ball stays at center if not active
        if (Game_Active_i == 1'b0)
        begin
            Ball_X_o <= GAME_WIDTH / 2;
            Ball_Y_o <= GAME_HEIGHT / 2;
            Ball_X_prev_r <= (GAME_WIDTH / 2) + 1;
            Ball_Y_prev_r <= (GAME_HEIGHT / 2) + 1;
        end

        // Move ball every 1 250 000 clock cycles
        else
        begin
            if (Ball_Count_r < BALL_SPEED)
                Ball_Count_r <= Ball_Count_r + 1;
            else
            begin
                Ball_Count_r <= 0;

                // Register prev values
                Ball_X_prev_r <= Ball_X_o;
                Ball_Y_prev_r <= Ball_Y_o;

                // if moving right and hits wall or moving left and not at left wall
                if ((Ball_X_prev_r < Ball_X_o && Ball_X_o == GAME_WIDTH-1) || (Ball_X_prev_r > Ball_X_o && Ball_X_o != 0))
                    Ball_X_o <= Ball_X_o - 1; // move left
                else 
                    Ball_X_o <= Ball_X_o + 1; // move right

                // if moving down and hits wall or moving up and not at top wall
                if ((Ball_Y_prev_r < Ball_Y_o && Ball_Y_o == GAME_HEIGHT-1) || (Ball_Y_prev_r > Ball_Y_o && Ball_Y_o != 0))
                    Ball_Y_o <= Ball_Y_o - 1; // move up
                else 
                    Ball_Y_o <= Ball_Y_o + 1; // move down

            end
        end
    end

    // draw ball
    always @(posedge clk_i) 
    begin
        if (col_count_div_i == Ball_X_o && row_count_div_i == Ball_Y_o)
            Draw_Ball_o <= 1'b1;
        else
            Draw_Ball_o <= 1'b0;
    end

endmodule