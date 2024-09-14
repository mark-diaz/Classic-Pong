module Pong_Paddle_Ctl #(
    parameter PLAYER_PADDLE_X = 0,
    parameter PADDLE_HEIGHT = 6,
    parameter GAME_HEIGHT = 30 
) (
        input clk_i,
        
        // Current gameboard unit being drawn 
        input [5:0] col_count_div_i,
        input [5:0] row_count_div_i,
        input Paddle_Up_i,
        input Paddle_Down_i,
        output reg Draw_Paddle_o,

        // current paddle position (Y)
        output reg [5:0] Paddle_Y_o 
);
   
    // Higher PADDLE_SPEED -> Slower Movement
    parameter PADDLE_SPEED = 1250000; // Once per 1 250 000 clock cycles

    reg [31:0] Paddle_Count_r = 0;

    wire Paddle_Count_en;

    // Only one direction at a time
    assign Paddle_Count_en = Paddle_Up_i ^ Paddle_Down_i;

    // Paddle counter to slow down paddle speed
    always @(posedge clk_i) 
    begin
        if (Paddle_Count_en == 1'b1)
        begin
            if (Paddle_Count_en == PADDLE_SPEED)
                Paddle_Count_r <= 0;
            else
                Paddle_Count_r <= Paddle_Count_r + 1;
        end

        // Top : 0 
        // Bottom : GAME_HEIGHT - PADDLE_HEIGHT - 1 
        // Only move paddle after PADDLE_SPEED clock cycles
        if (Paddle_Up_i == 1'b1 && Paddle_Count_r == PADDLE_SPEED && Paddle_Y_o !== 0)
            Paddle_Y_o <= Paddle_Y_o - 1;
        else if (Paddle_Down_i == 1'b1 && Paddle_Count_r == PADDLE_SPEED && Paddle_Y_o !== GAME_HEIGHT - PADDLE_HEIGHT - 1)
            Paddle_Y_o <= Paddle_Y_o + 1;
    
    end


    always @(posedge clk_i) 
    begin
        if (col_count_div_i == PLAYER_PADDLE_X && row_count_div_i >= Paddle_Y_o && row_count_div_i <= Paddle_Y_o + PADDLE_HEIGHT)
            Draw_Paddle_o <= 1'b1;
        else
            Draw_Paddle_o <= 1'b0;
    end

endmodule