`timescale 1ns / 1ns
module Game_Control (
    input wire clk,
    input wire rst,
    input wire flag_player,
    input wire [4:0]ctrl,

    output reg [9:0]  ball_x_pos,
    output reg [9:0]  ball_y_pos,
    output reg [99:0] Player_Red,
    output reg [99:0] Player_Green,
    output reg [99:0] former_ball
);

localparam cnt_max=7000000;                //分频计数的阈值

reg        clk_ctrl;
reg [28:0] clk_cnt;	

wire [9:0] x_pos;
wire [9:0] y_pos;

assign    x_pos=(ball_x_pos-240)/40;
assign    y_pos=(ball_y_pos-90)/40;
//对100MHz的系统时钟进行分频
always @ (posedge clk,posedge rst)  begin
  if (rst)  clk_cnt <= 'd0;
  else clk_cnt <= clk_cnt==cnt_max ? 'd0 : clk_cnt+1;
end

always @(posedge clk, posedge rst) begin
  if (rst)  clk_ctrl <= 'd0;
  else clk_ctrl <= clk_cnt==cnt_max ? ~clk_ctrl : clk_ctrl;
end

//按键控制棋子移动
//每次按下改变待选择棋子的边界坐标
always@(posedge clk_ctrl,posedge rst)
begin
  if (rst) begin
    ball_x_pos <= 10'd240 ;
    ball_y_pos <= 10'd90 ;
  end
  else begin
    case(ctrl[3:0])
        4'b0100:begin 
            if (ball_x_pos== 10'd240) 
                  ball_x_pos<=10'd600;
            else 
                  ball_x_pos<=ball_x_pos-10'd40;
        end
        4'b1000:begin 
            if (ball_x_pos==10'd600)
                  ball_x_pos<=10'd240;
            else 
                  ball_x_pos<= ball_x_pos+10'd40;
        end 
        4'b0001: begin 
            if (ball_y_pos== 10'd90)
                  ball_y_pos<=10'd450;
            else 
                  ball_y_pos<=ball_y_pos-10'd40;                                                
        end
        4'b0010: begin
            if(ball_y_pos== 10'd450)
                  ball_y_pos<=10'd90;
            else         
                  ball_y_pos<=ball_y_pos+10'd40; 
        end       
        default: begin
                  ball_x_pos<=ball_x_pos;
                  ball_y_pos<=ball_y_pos;
        end
    endcase
  end
end

always @(posedge clk_ctrl, posedge rst) begin
  if (rst) former_ball <= 'd0;
  else if (ctrl[4]) former_ball[y_pos*10+x_pos] <= 1'b1;
end

always @(posedge clk_ctrl, posedge rst) begin
  if (rst) Player_Red <= 'd0;
  else if (ctrl[4] && ~former_ball[y_pos*10+x_pos]) Player_Red[y_pos*10+x_pos] <= flag_player;
  else Player_Red<=Player_Red;
end

always @(posedge clk_ctrl, posedge rst) begin
  if (rst) Player_Green <= 'd0;
  else if (ctrl[4] && ~former_ball[y_pos*10+x_pos]) Player_Green[y_pos*10+x_pos] <= ~flag_player;
  else Player_Green<=Player_Green;
end
                                                        
endmodule