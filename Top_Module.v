`timescale 1ns / 1ns
module Top_Module (
    input wire clk,
    input wire rst,
    input wire key_clk,
    input wire key_data,
    input wire flag_player,
    output wire [11:0]disp_rgb,
    output wire hsync,
    output wire vsync,
    output wire pwm
);

    wire [99:0] Player_Red;
    wire [99:0] Player_Green;
    wire [99:0] former_ball;
    wire [9:0]  ball_x_pos;
    wire [9:0]  ball_y_pos;

    wire [4:0] ctrl;
Game_Control game_control(
    .clk                        (clk)          ,
    .rst                        (rst)          ,
    .flag_player                (flag_player)  ,
    .ctrl                       (ctrl),
    .ball_x_pos                 (ball_x_pos)   ,
    .ball_y_pos                 (ball_y_pos)   ,
    .Player_Red                 (Player_Red)   ,
    .Player_Green               (Player_Green) ,
    .former_ball                (former_ball)
);
Vga_Display vga_display(
    .clk                        (clk)          ,
    .rst                        (rst)          ,
    .flag_player                (flag_player)  ,
    .ball_x_pos                 (ball_x_pos)   ,
    .ball_y_pos                 (ball_y_pos)   ,
    .Player_Red                 (Player_Red)   ,
    .Player_Green               (Player_Green) ,
    .former_ball                (former_ball)  ,

    .disp_rgb                   (disp_rgb)     ,
    .hsync                      (hsync)        ,
    .vsync                      (vsync)
);

Keyboard_Driver keyboard_Driver(
    .clk_in(clk),				//系统时钟
    .rst_n_in(~rst),			//系统复位，低有效
    .key_clk(key_clk),			//PS2键盘时钟输入
    .key_data(key_data),			//PS2键盘数据输入
    .key_state(),			//键盘的按下状态，按下为1，松开为0
    .key_ctrl(ctrl)
);

Audio_Player audio_player (
    .clk(clk),
    .rst(rst),
    .pwm(pwm)
);
endmodule