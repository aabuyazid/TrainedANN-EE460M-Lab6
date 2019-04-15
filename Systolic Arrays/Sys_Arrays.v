module Sys_Arrays(
    input start,
    input clk,
    input [7:0] a00,
    input [7:0] a01,
    input [7:0] a02,
    input [7:0] a10,
    input [7:0] a11,
    input [7:0] a12,
    input [7:0] a20,
    input [7:0] a21,
    input [7:0] a22,
    input [7:0] b00,
    input [7:0] b01,
    input [7:0] b02,
    input [7:0] b10,
    input [7:0] b11,
    input [7:0] b12,
    input [7:0] b20,
    input [7:0] b21,
    input [7:0] b22,
    output [7:0] c00,
    output [7:0] c01,
    output [7:0] c02,
    output [7:0] c10,
    output [7:0] c11,
    output [7:0] c12,
    output [7:0] c20,
    output [7:0] c21,
    output [7:0] c22,
    output done
);

wire [7:0] a[3][3];
wire [7:0] b[3][3];
reg [7:0] c[3][3];

assign a[0][0] = a00;
assign a[0][1] = a01;
assign a[0][2] = a02;
assign a[1][0] = a10;
assign a[1][1] = a11;
assign a[1][2] = a12;
assign a[2][0] = a20;
assign a[2][1] = a21;
assign a[2][2] = a22;
assign b[0][0] = b00;
assign b[0][1] = b01;
assign b[0][2] = b02;
assign b[1][0] = b10;
assign b[1][1] = b11;
assign b[1][2] = b12;
assign b[2][0] = b20;
assign b[2][1] = b21;
assign b[2][2] = b22;

assign c00 = c[0][0];
assign c01 = c[0][1];
assign c02 = c[0][2];
assign c10 = c[1][0];
assign c11 = c[1][1];
assign c12 = c[1][2];
assign c20 = c[2][0];
assign c21 = c[2][1];
assign c22 = c[2][2];

integer i,j;

reg stMAC[3][3];
wire doneMAC[3][3];

reg [7:0] a0X_in, a1X_in, a2X_in;
reg [7:0] bX0_in, bX1_in, bX2_in;

wire [7:0] pass_a[3][3];
wire [7:0] pass_b[3][3];


// This is the 3x3 assignment
/*
MAC c_00 (clk,a0X_in,bX0_in,stMAC[0][0],c[0][0],pass_a[0][0],pass_b[0][0],doneMAC[0][0]);
MAC c_01 (clk,pass_a[0][0],bX1_in,stMAC[0][1],c[0][1],pass_a[0][1],pass_b[0][1],doneMAC[0][1]);
MAC c_02 (clk,pass_a[0][1],bX2_in,stMAC[0][2],c[0][2],pass_a[0][2],pass_b[0][2],doneMAC[0][2]);
MAC c_10 (clk,a1X_in,pass_b[0][0],stMAC[1][0],c[1][0],pass_a[1][0],pass_b[1][0],doneMAC[1][0]);
MAC c_11 (clk,pass_a[1][0],pass_b[0][1],stMAC[1][1],c[1][1],pass_a[1][1],pass_b[1][1],doneMAC[1][1]);
MAC c_12 (clk,pass_a[1][1],pass_b[0][2],stMAC[1][2],c[1][2],pass_a[1][2],pass_b[1][2],doneMAC[1][2]);
MAC c_20 (clk,a2X_in,pass_b[1][0],stMAC[2][0],c[2][0],pass_a[2][0],pass_b[2][0],doneMAC[2][0]);
MAC c_21 (clk,pass_a[2][0],pass_b[1][1],stMAC[2][1],c[2][1],pass_a[2][1],pass_b[2][1],doneMAC[2][1]);
MAC c_22 (clk,pass_a[2][1],pass_b[1][2],stMAC[2][2],c[2][2],pass_a[2][2],pass_b[2][2],doneMAC[2][2]);
*/


// This is the 2x2 assignment
/*
MAC c_00 (clk,a0X_in,bX0_in,stMAC[0][0],c[0][0],pass_a[0][0],pass_b[0][0],doneMAC[0][0]);
MAC c_01 (clk,pass_a[0][0],bX1_in,stMAC[0][1],c[0][1],pass_a[0][1],pass_b[0][1],doneMAC[0][1]);
MAC c_10 (clk,a1X_in,pass_b[0][0],stMAC[1][0],c[1][0],pass_a[1][0],pass_b[1][0],doneMAC[1][0]);
MAC c_11 (clk,pass_a[1][0],pass_b[0][1],stMAC[1][1],c[1][1],pass_a[1][1],pass_b[1][1],doneMAC[1][1]);
*/

initial begin

    for(i = 0; i < 3; i = i+1) begin
        for(j = 0; j < 3; j = j+1) begin
            c[i][j] = 0;
            stMAC[i][j] = 0;
        end
    end

    a0X_in = 0;
    a1X_in = 0;
    a2X_in = 0;
    bX0_in = 0;
    bX1_in = 0;
    bX2_in = 0;

end



endmodule
