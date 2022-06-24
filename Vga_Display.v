`timescale 1ns / 1ns

module Vga_Display (
    input wire clk,
    input wire rst,
    input wire flag_player,
    input wire [9:0]  ball_x_pos,
    input wire [9:0]  ball_y_pos,
    input wire [99:0] Player_Red,
    input wire [99:0] Player_Green,
    input wire [99:0] former_ball,

    output wire [11:0]disp_rgb,
    output wire hsync,
    output wire vsync
);
    
reg[11:0]    hcount;    	//行信号
reg[11:0]    vcount;		//列信号
reg[11:0]    data;
reg[11:0]    data_h;  			//12位的色素显示变量
reg[11:0]    data_v;
reg[11:0]    data_player;
reg[11:0]    data_gameover;
reg         flag_over;				//游戏是否结束标志
wire        hcount_ov;
wire        vcount_ov;
wire        dat_act;
reg         clk_vga;
reg         clk_cnt;

wire [9:0] x_pos;					
wire [9:0] y_pos;

wire [99:0] block;
            
assign x_pos=(hcount-220)/40;
assign y_pos=(vcount-70)/40;

//一百个格子
assign block[0] = ((hcount - 240)*(hcount - 240)+(vcount - 90)*(vcount - 90))<=400;
assign block[1] = ((hcount - 280)*(hcount - 280)+(vcount - 90)*(vcount - 90))<=400;
assign block[2] = ((hcount - 320)*(hcount - 320)+(vcount - 90)*(vcount - 90))<=400;
assign block[3] = ((hcount - 360)*(hcount - 360)+(vcount - 90)*(vcount - 90))<=400;
assign block[4] = ((hcount - 400)*(hcount - 400)+(vcount - 90)*(vcount - 90))<=400;
assign block[5] = ((hcount - 440)*(hcount - 440)+(vcount - 90)*(vcount - 90))<=400;
assign block[6] = ((hcount - 480)*(hcount - 480)+(vcount - 90)*(vcount - 90))<=400;
assign block[7] = ((hcount - 520)*(hcount - 520)+(vcount - 90)*(vcount - 90))<=400;
assign block[8] = ((hcount - 560)*(hcount - 560)+(vcount - 90)*(vcount - 90))<=400;
assign block[9] = ((hcount - 600)*(hcount - 600)+(vcount - 90)*(vcount - 90))<=400;
assign block[10] = (hcount - 240)*(hcount - 240)+(vcount - 130)*(vcount - 130)<=400;
assign block[11] = (hcount - 280)*(hcount - 280)+(vcount - 130)*(vcount - 130)<=400;
assign block[12] = (hcount - 320)*(hcount - 320)+(vcount - 130)*(vcount - 130)<=400;
assign block[13] = (hcount - 360)*(hcount - 360)+(vcount - 130)*(vcount - 130)<=400;
assign block[14] = (hcount - 400)*(hcount - 400)+(vcount - 130)*(vcount - 130)<=400;
assign block[15] = (hcount - 440)*(hcount - 440)+(vcount - 130)*(vcount - 130)<=400;
assign block[16] = (hcount - 480)*(hcount - 480)+(vcount - 130)*(vcount - 130)<=400;
assign block[17] = (hcount - 520)*(hcount - 520)+(vcount - 130)*(vcount - 130)<=400;
assign block[18] = (hcount - 560)*(hcount - 560)+(vcount - 130)*(vcount - 130)<=400;
assign block[19] = (hcount - 600)*(hcount - 600)+(vcount - 130)*(vcount - 130)<=400;
assign block[20] = (hcount - 240)*(hcount - 240)+(vcount -170)*(vcount - 170)<=400;
assign block[21] = (hcount - 280)*(hcount - 280)+(vcount -170)*(vcount - 170)<=400;
assign block[22] = (hcount - 320)*(hcount - 320)+(vcount -170)*(vcount - 170)<=400;
assign block[23] = (hcount - 360)*(hcount - 360)+(vcount -170)*(vcount - 170)<=400;
assign block[24] = (hcount - 400)*(hcount - 400)+(vcount -170)*(vcount - 170)<=400;
assign block[25] = (hcount - 440)*(hcount - 440)+(vcount -170)*(vcount - 170)<=400;
assign block[26] = (hcount - 480)*(hcount - 480)+(vcount -170)*(vcount - 170)<=400;
assign block[27] = (hcount - 520)*(hcount - 520)+(vcount -170)*(vcount - 170)<=400;
assign block[28] = (hcount - 560)*(hcount - 560)+(vcount -170)*(vcount - 170)<=400;
assign block[29] = (hcount - 600)*(hcount - 600)+(vcount -170)*(vcount - 170)<=400;
assign block[30] = (hcount - 240)*(hcount - 240)+(vcount - 210)*(vcount - 210)<=400;
assign block[31] = (hcount - 280)*(hcount - 280)+(vcount - 210)*(vcount - 210)<=400;
assign block[32] = (hcount - 320)*(hcount - 320)+(vcount - 210)*(vcount - 210)<=400;
assign block[33] = (hcount - 360)*(hcount - 360)+(vcount - 210)*(vcount - 210)<=400;
assign block[34] = (hcount - 400)*(hcount - 400)+(vcount - 210)*(vcount - 210)<=400;
assign block[35] = (hcount - 440)*(hcount - 440)+(vcount - 210)*(vcount - 210)<=400;
assign block[36] = (hcount - 480)*(hcount - 480)+(vcount - 210)*(vcount - 210)<=400;
assign block[37] = (hcount - 520)*(hcount - 520)+(vcount - 210)*(vcount - 210)<=400;
assign block[38] = (hcount - 560)*(hcount - 560)+(vcount - 210)*(vcount - 210)<=400;
assign block[39] = (hcount - 600)*(hcount - 600)+(vcount - 210)*(vcount - 210)<=400;
assign block[40] = (hcount - 240)*(hcount - 240)+(vcount - 250)*(vcount - 250)<=400;
assign block[41] = (hcount - 280)*(hcount - 280)+(vcount - 250)*(vcount - 250)<=400;
assign block[42] = (hcount - 320)*(hcount - 320)+(vcount - 250)*(vcount - 250)<=400;
assign block[43] = (hcount - 360)*(hcount - 360)+(vcount - 250)*(vcount - 250)<=400;
assign block[44] = (hcount - 400)*(hcount - 400)+(vcount - 250)*(vcount - 250)<=400;
assign block[45] = (hcount - 440)*(hcount - 440)+(vcount - 250)*(vcount - 250)<=400;
assign block[46] = (hcount - 480)*(hcount - 480)+(vcount - 250)*(vcount - 250)<=400;
assign block[47] = (hcount - 520)*(hcount - 520)+(vcount - 250)*(vcount - 250)<=400;
assign block[48] = (hcount - 560)*(hcount - 560)+(vcount - 250)*(vcount - 250)<=400;
assign block[49] = (hcount - 600)*(hcount - 600)+(vcount - 250)*(vcount - 250)<=400;
assign block[50] = (hcount - 240)*(hcount - 240)+(vcount - 290)*(vcount - 290)<=400;
assign block[51] = (hcount - 280)*(hcount - 280)+(vcount - 290)*(vcount - 290)<=400;
assign block[52] = (hcount - 320)*(hcount - 320)+(vcount - 290)*(vcount - 290)<=400;
assign block[53] = (hcount - 360)*(hcount - 360)+(vcount - 290)*(vcount - 290)<=400;
assign block[54] = (hcount - 400)*(hcount - 400)+(vcount - 290)*(vcount - 290)<=400;
assign block[55] = (hcount - 440)*(hcount - 440)+(vcount - 290)*(vcount - 290)<=400;
assign block[56] = (hcount - 480)*(hcount - 480)+(vcount - 290)*(vcount - 290)<=400;
assign block[57] = (hcount - 520)*(hcount - 520)+(vcount - 290)*(vcount - 290)<=400;
assign block[58] = (hcount - 560)*(hcount - 560)+(vcount - 290)*(vcount - 290)<=400;
assign block[59] = (hcount - 600)*(hcount - 600)+(vcount - 290)*(vcount - 290)<=400;
assign block[60] = (hcount - 240)*(hcount - 240)+(vcount -330)*(vcount - 330)<=400;
assign block[61] = (hcount - 280)*(hcount - 280)+(vcount -330)*(vcount - 330)<=400;
assign block[62] = (hcount - 320)*(hcount - 320)+(vcount -330)*(vcount - 330)<=400;
assign block[63] = (hcount - 360)*(hcount - 360)+(vcount -330)*(vcount - 330)<=400;
assign block[64] = (hcount - 400)*(hcount - 400)+(vcount -330)*(vcount - 330)<=400;
assign block[65] = (hcount - 440)*(hcount - 440)+(vcount -330)*(vcount - 330)<=400;
assign block[66] = (hcount - 480)*(hcount - 480)+(vcount -330)*(vcount - 330)<=400;
assign block[67] = (hcount - 520)*(hcount - 520)+(vcount -330)*(vcount - 330)<=400;
assign block[68] = (hcount - 560)*(hcount - 560)+(vcount -330)*(vcount - 330)<=400;
assign block[69] = (hcount - 600)*(hcount - 600)+(vcount -330)*(vcount - 330)<=400;
assign block[70] = (hcount - 240)*(hcount - 240)+(vcount - 370)*(vcount - 370)<=400;
assign block[71] = (hcount - 280)*(hcount - 280)+(vcount - 370)*(vcount - 370)<=400;
assign block[72] = (hcount - 320)*(hcount - 320)+(vcount - 370)*(vcount - 370)<=400;
assign block[73] = (hcount - 360)*(hcount - 360)+(vcount - 370)*(vcount - 370)<=400;
assign block[74] = (hcount - 400)*(hcount - 400)+(vcount - 370)*(vcount - 370)<=400;
assign block[75] = (hcount - 440)*(hcount - 440)+(vcount - 370)*(vcount - 370)<=400;
assign block[76] = (hcount - 480)*(hcount - 480)+(vcount - 370)*(vcount - 370)<=400;
assign block[77] = (hcount - 520)*(hcount - 520)+(vcount - 370)*(vcount - 370)<=400;
assign block[78] = (hcount - 560)*(hcount - 560)+(vcount - 370)*(vcount - 370)<=400;
assign block[79] = (hcount - 600)*(hcount - 600)+(vcount - 370)*(vcount - 370)<=400;
assign block[80] = (hcount - 240)*(hcount - 240)+(vcount - 410)*(vcount -410)<=400;
assign block[81] = (hcount - 280)*(hcount - 280)+(vcount - 410)*(vcount -410)<=400;
assign block[82] = (hcount - 320)*(hcount - 320)+(vcount - 410)*(vcount -410)<=400;
assign block[83] = (hcount - 360)*(hcount - 360)+(vcount - 410)*(vcount -410)<=400;
assign block[84] = (hcount - 400)*(hcount - 400)+(vcount - 410)*(vcount -410)<=400;
assign block[85] = (hcount - 440)*(hcount - 440)+(vcount - 410)*(vcount -410)<=400;
assign block[86] = (hcount - 480)*(hcount - 480)+(vcount - 410)*(vcount -410)<=400;
assign block[87] = (hcount - 520)*(hcount - 520)+(vcount - 410)*(vcount -410)<=400;
assign block[88] = (hcount - 560)*(hcount - 560)+(vcount - 410)*(vcount -410)<=400;
assign block[89] = (hcount - 600)*(hcount - 600)+(vcount - 410)*(vcount -410)<=400;
assign block[90] = (hcount - 240)*(hcount - 240)+(vcount - 450)*(vcount - 450)<=400;
assign block[91] = (hcount - 280)*(hcount - 280)+(vcount - 450)*(vcount -450)<=400;
assign block[92] = (hcount - 320)*(hcount - 320)+(vcount -450)*(vcount - 450)<=400;
assign block[93] = (hcount - 360)*(hcount - 360)+(vcount - 450)*(vcount - 450)<=400;
assign block[94] = (hcount - 400)*(hcount - 400)+(vcount - 450)*(vcount - 450)<=400;
assign block[95] = (hcount - 440)*(hcount - 440)+(vcount -450)*(vcount - 450)<=400;
assign block[96] = (hcount - 480)*(hcount - 480)+(vcount - 450)*(vcount - 450)<=400;
assign block[97] = (hcount - 520)*(hcount - 520)+(vcount -450)*(vcount - 450)<=400;
assign block[98] = (hcount - 560)*(hcount - 560)+(vcount -450)*(vcount -450)<=400;
assign block[99] = (hcount - 600)*(hcount - 600)+(vcount - 450)*(vcount - 450)<=400;

//VGA行，场扫描时序参数表
parameter hsync_end = 10'd95;
parameter hdat_begin = 10'd143;
parameter hdat_end   = 10'd783;
parameter hpixel_end = 10'd799;
parameter vsync_end  = 10'd1;
parameter vdat_begin = 10'd34;
parameter vdat_end   = 10'd514;
parameter vline_end  = 10'd524; 
parameter ball_r=20;

//分频器
always @(posedge clk, posedge rst) begin
  if (rst) clk_cnt <= 1'b0;
  else clk_cnt <= ~clk_cnt;
end

always@(posedge clk, posedge rst) begin
  if (rst) clk_vga <= 1'b0;
  else clk_vga <= clk_cnt ? ~clk_vga : clk_vga;
end             

//VGA驱动
//行扫描
always@(posedge clk_vga, posedge rst) begin
  if (rst) hcount <= 'd0;
  else if(hcount_ov) hcount <= 10'd0;
  else hcount <= hcount + 10'd1;
end

assign hcount_ov = (hcount == hpixel_end);

//场扫描
always@(posedge clk_vga, posedge rst) begin
  if (rst) vcount <= 'd0;
  else if(hcount_ov) 
  begin
    if(vcount_ov)
        vcount <= 10'd0;
    else
        vcount <= vcount + 10'd1;
  end
end

assign vcount_ov = (vcount == vline_end);
 
//数据、同步信号输入
assign dat_act = ((hcount >= hdat_begin) && (hcount < hdat_end)) && ((vcount > vdat_begin) && (vcount<vdat_end));
assign hsync   = (hcount > hsync_end);                    
assign vsync   = (vcount > vsync_end);
assign disp_rgb = (dat_act)? data : 3'h000;  

//显示模块 
always@(posedge clk_vga, posedge rst) begin
  if (rst) data <= 'd0;
  else if(flag_over==0) data <= data_v&data_h&data_player;    //与计算显示色素块
  else data <= data_gameover;//12'hff0    			//游戏结束则显示另外画面
end	 

//棋盘区域判断及上色
always@(posedge clk_vga, posedge rst) begin
  if (rst)  data_player <= 'd0;
  else if ((hcount - ball_x_pos)*(hcount - ball_x_pos)+(vcount- ball_y_pos)*(vcount - ball_y_pos)<=(ball_r * ball_r)) 
        data_player<= 12'h000;//0ff        
  else if (block[y_pos*10+x_pos]&&former_ball[y_pos*10+x_pos]&&Player_Red[y_pos*10+x_pos]) 
        data_player <= 12'hf00;//f0f
  else if (block[y_pos*10+x_pos]&&former_ball[y_pos*10+x_pos]) 
        data_player <= 12'h0f0;       
  else data_player <= 12'hfff;             
end

//产生竖长条
always@(posedge clk_vga, posedge rst) begin
  if (rst) data_v <= 'd0;
  else if(hcount<=200||hcount>=640)
	    data_v <= 12'h000;//hei
  else if(hcount ==240||hcount ==280||hcount ==320||hcount ==360||hcount ==400||hcount ==440||hcount ==480||hcount ==520||hcount==560||hcount==600)
      data_v <= 12'h000;//hei
  else 
      data_v <= 12'hfff;//bai
end

//产生横长条
always@(posedge clk_vga, posedge rst) begin
  if (rst) data_h <= 'd0;
  else if(vcount<=50||vcount>=490)
	    data_h <= 12'h000;//hei
  else if(vcount ==90||vcount ==130||vcount ==170||vcount==210 ||vcount==250||vcount ==290||vcount ==330||vcount==370 ||vcount==410||vcount==450)
      data_h <= 12'h000;
  else
      data_h <= 12'hfff;
end  

//输赢状态判断
wire U_win_a;
wire U_win_b;
wire U_win_c;
wire U_win_d;
wire V_win_a;
wire V_win_b;
wire V_win_c;
wire V_win_d;
wire U_win;
wire V_win;

assign U_win_a = (x_pos<=5) && (Player_Red[y_pos*10+x_pos]&&Player_Red[y_pos*10+x_pos+1]&&Player_Red[y_pos*10+x_pos+2]&&Player_Red[y_pos*10+x_pos+3]&&Player_Red[y_pos*10+x_pos+4]);
assign U_win_b = (y_pos<=5) && (Player_Red[y_pos*10+x_pos]&&Player_Red[(y_pos+1)*10+x_pos]&&Player_Red[(y_pos+2)*10+x_pos]&&Player_Red[(y_pos+3)*10+x_pos]&&Player_Red[(y_pos+4)*10+x_pos]);
assign U_win_c = (x_pos<=5 && y_pos<=5) && (Player_Red[y_pos*10+x_pos]&&Player_Red[(y_pos+1)*10+x_pos+1]&&Player_Red[(y_pos+2)*10+x_pos+2]&&Player_Red[(y_pos+3)*10+x_pos+3]&&Player_Red[(y_pos+4)*10+x_pos+4]);
assign U_win_d = (x_pos>=4 && y_pos>=4) && (Player_Red[y_pos*10+x_pos]&&Player_Red[(y_pos+1)*10+x_pos-1]&&Player_Red[(y_pos+2)*10+x_pos-2]&&Player_Red[(y_pos+3)*10+x_pos-3]&&Player_Red[(y_pos+4)*10+x_pos-4]);
assign U_win = U_win_a || U_win_b || U_win_c || U_win_d;

assign V_win_a = (x_pos<=5) && (Player_Green[y_pos*10+x_pos]&&Player_Green[y_pos*10+x_pos+1]&&Player_Green[y_pos*10+x_pos+2]&&Player_Green[y_pos*10+x_pos+3]&&Player_Green[y_pos*10+x_pos+4]);
assign V_win_b = (y_pos<=5) && (Player_Green[y_pos*10+x_pos]&&Player_Green[(y_pos+1)*10+x_pos]&&Player_Green[(y_pos+2)*10+x_pos]&&Player_Green[(y_pos+3)*10+x_pos]&&Player_Green[(y_pos+4)*10+x_pos]);
assign V_win_c = (x_pos<=5 && y_pos<=5) && (Player_Green[y_pos*10+x_pos]&&Player_Green[(y_pos+1)*10+x_pos+1]&&Player_Green[(y_pos+2)*10+x_pos+2]&&Player_Green[(y_pos+3)*10+x_pos+3]&&Player_Green[(y_pos+4)*10+x_pos+4]);
assign V_win_d = (x_pos>=4 && y_pos>=4) && (Player_Green[y_pos*10+x_pos]&&Player_Green[(y_pos+1)*10+x_pos-1]&&Player_Green[(y_pos+2)*10+x_pos-2]&&Player_Green[(y_pos+3)*10+x_pos-3]&&Player_Green[(y_pos+4)*10+x_pos-4]);
assign V_win = V_win_a || V_win_b || V_win_c || V_win_d;

always@(posedge clk_vga, posedge rst) begin
  if (rst) flag_over <= 0;
  else flag_over <= flag_over || (U_win || V_win);//为了显示扫描的整个过程都是over
end

//产生黑线（格子之间的黑线）
always@(posedge clk_vga, posedge rst) begin
  if (rst) data_gameover <= 'd0;
  else begin
    if(((hcount>=240&&hcount<=260)||(hcount>=300&&hcount<=320)||(hcount>=360&&hcount<=380)||(hcount>=420&&hcount<=440)||(hcount>=480&&hcount<=500)||(hcount>=560&&hcount<=580))&&(vcount >=200&&vcount <=360))
	    data_gameover <= flag_player ? 12'hf00 : 12'h0f0;//hei
    else if(hcount>=260&&hcount<=380&&vcount>=340&&vcount <=360)
      data_gameover <= flag_player ? 12'hf00 : 12'h0f0;
    else if(hcount>=500&&hcount<=560&&vcount>=200&&vcount <=220)
      data_gameover <= flag_player ? 12'hf00 : 12'h0f0;
    else
     data_gameover <= 12'h000;
  end
end
endmodule
