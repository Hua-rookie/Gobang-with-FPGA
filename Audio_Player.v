`timescale 1ns/1ns

module Audio_Player (
    input wire          clk,
    input wire          rst,
    output reg          pwm
);

parameter D5 = 18'd255102;
parameter D6 = 18'd227273;
parameter D7 = 18'd202429;

parameter C1 = 18'd191204;
parameter C2 = 18'd170358;
parameter C3 = 18'd151745;

parameter N0 = 18'd1;


reg [26:0] cnt_time;
reg [3:0]  cnt_note;
reg [17:0] cnt;
reg [17:0] cnt_N;

always @(posedge clk, posedge rst) begin
    if (rst) cnt_time <= 'd0;
    else cnt_time <= cnt_time[26] ? 'd0 : cnt_time+'d1;
end

always @(posedge clk, posedge rst) begin
    if (rst) cnt_note <= 'd0;
    else if (cnt_note=='d31) cnt_note <= 'd0;
    else cnt_note <= cnt_time[26] ? cnt_note+'d1 : cnt_note;
end

always @(*) begin
    case (cnt_note)
        'h0: cnt_N <= C1; 
        'h1: cnt_N <= C1;
        'h2: cnt_N <= D5;
        'h3: cnt_N <= D5;
        'h4: cnt_N <= D6; 
        'h5: cnt_N <= D6;
        'h6: cnt_N <= D5;
        'h7: cnt_N <= D6;
        'h8: cnt_N <= C1; 
        'h9: cnt_N <= C1;
        'ha: cnt_N <= D6;
        'hb: cnt_N <= C1;
        'hc: cnt_N <= C2;
        'hd: cnt_N <= C2; 
        'hf: cnt_N <= N0;
        'h10: cnt_N <= C3;
        'h11: cnt_N <= C3;
        'h12: cnt_N <= C2;
        'h13: cnt_N <= C2; 
        'h14: cnt_N <= C1;
        'h15: cnt_N <= C3;
        'h16: cnt_N <= C2;
        'h17: cnt_N <= C1; 
        'h18: cnt_N <= D6;
        'h19: cnt_N <= C2;
        'h1a: cnt_N <= D7;
        'h1b: cnt_N <= D6;
        'h1c: cnt_N <= D5; 
        'h1d: cnt_N <= D5;
        'h1f: cnt_N <= N0;
        default: cnt_N <= N0;
    endcase
end

always @(posedge clk, posedge rst) begin
    if (rst) cnt <= 18'b0;
    else if (cnt == cnt_N) cnt <= 18'b0;
    else cnt <= cnt+1;
end

always @(posedge clk, posedge rst) begin
    if (rst) pwm <= 1'b0;
    else if (cnt == cnt_N) pwm <= ~pwm;
end

endmodule