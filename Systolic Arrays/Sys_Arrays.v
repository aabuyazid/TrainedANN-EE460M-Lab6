`timescale 1ns / 1ps
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
    output reg done
);

wire [7:0] a[2:0][2:0];
wire [7:0] b[2:0][2:0];

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

integer i,j;

reg stMAC[2:0][2:0];
wire doneMAC[2:0][2:0];

reg [7:0] a0X_in, a1X_in, a2X_in;
reg [7:0] bX0_in, bX1_in, bX2_in;

wire [7:0] pass_a[2:0][2:0];
wire [7:0] pass_b[2:0][2:0];

reg [4:0] curr_state;

reg clk_div;

reg [5:0] clk_counter;

// This is the 3x3 assignment

MAC c_00 (clk,a0X_in,bX0_in,stMAC[0][0],c00,pass_a[0][0],pass_b[0][0],doneMAC[0][0]);
MAC c_01 (clk,pass_a[0][0],bX1_in,stMAC[0][1],c01,pass_a[0][1],pass_b[0][1],doneMAC[0][1]);
MAC c_02 (clk,pass_a[0][1],bX2_in,stMAC[0][2],c02,pass_a[0][2],pass_b[0][2],doneMAC[0][2]);
MAC c_10 (clk,a1X_in,pass_b[0][0],stMAC[1][0],c10,pass_a[1][0],pass_b[1][0],doneMAC[1][0]);
MAC c_11 (clk,pass_a[1][0],pass_b[0][1],stMAC[1][1],c11,pass_a[1][1],pass_b[1][1],doneMAC[1][1]);
MAC c_12 (clk,pass_a[1][1],pass_b[0][2],stMAC[1][2],c12,pass_a[1][2],pass_b[1][2],doneMAC[1][2]);
MAC c_20 (clk,a2X_in,pass_b[1][0],stMAC[2][0],c20,pass_a[2][0],pass_b[2][0],doneMAC[2][0]);
MAC c_21 (clk,pass_a[2][0],pass_b[1][1],stMAC[2][1],c21,pass_a[2][1],pass_b[2][1],doneMAC[2][1]);
MAC c_22 (clk,pass_a[2][1],pass_b[1][2],stMAC[2][2],c22,pass_a[2][2],pass_b[2][2],doneMAC[2][2]);



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
            stMAC[i][j] = 0;
        end
    end

    a0X_in = 0;
    a1X_in = 0;
    a2X_in = 0;
    bX0_in = 0;
    bX1_in = 0;
    bX2_in = 0;

    curr_state = 0;
    clk_div = 0;
    clk_counter = 0;

end

always@(posedge clk) begin
    if(clk_counter == 10) begin
        clk_div = ~clk_div;
        clk_counter = 0;
    end
    else
        clk_counter = clk_counter + 1;
end


always@(posedge clk_div) begin
    case(curr_state)
        0: begin
            if(start)
                curr_state <= 1;
            else
                curr_state <= 0;
            for(i = 0; i < 3; i = i+1) begin
                for(j = 0; j < 3; j = j+1) begin
                    stMAC[i][j] = 0;
                end
            end
            done <= 0;
        end
        1: begin                // Systolic Arrays begin
            a0X_in <= a[0][0];
            a1X_in <= 0;
            a2X_in <= 0;

            bX0_in <= b[0][0];
            bX1_in <= 0;
            bX2_in <= 0;

            stMAC[0][0] <= 1;

            curr_state <= 2;
        end
        2: begin
            stMAC[0][0] <= 0;
            if(doneMAC[0][0])
                curr_state <= 16;
            else
                curr_state <= 2;
        end
        16: begin
            a0X_in = a[0][1];
            a1X_in = a[1][0];
            a2X_in = 0;

            bX0_in = b[1][0];
            bX1_in = b[0][1];
            bX2_in = 0;
            curr_state <= 3;
        end
        3: begin
            stMAC[0][0] <= 1;
            stMAC[1][0] <= 1;
            stMAC[0][1] <= 1;

            curr_state <= 4;
        end
        4: begin
            stMAC[0][0] <= 0;
            stMAC[1][0] <= 0;
            stMAC[0][1] <= 0;

            if(doneMAC[0][0] && doneMAC[0][1] && doneMAC[1][0])
                curr_state <= 17;
            else
                curr_state <= 4;
        end
        17: begin
            a0X_in = a[0][2];
            a1X_in = a[1][1];
            a2X_in = a[2][0];

            bX0_in = b[2][0];
            bX1_in = b[1][1];
            bX2_in = b[0][2];
            curr_state <= 5;
        end
        5: begin
            stMAC[0][0] <= 1;
            stMAC[1][0] <= 1;
            stMAC[0][1] <= 1;

            stMAC[2][0] <= 1;
            stMAC[1][1] <= 1;
            stMAC[0][2] <= 1;

            curr_state <= 6;
        end
        6: begin
            stMAC[0][0] <= 0;
            stMAC[1][0] <= 0;
            stMAC[0][1] <= 0;

            stMAC[2][0] <= 0;
            stMAC[1][1] <= 0;
            stMAC[0][2] <= 0;

            if(doneMAC[0][0] && doneMAC[1][0] && doneMAC[0][1] && 
                doneMAC[2][0] && doneMAC[1][1] && doneMAC[0][2])
                curr_state <= 18;
            else
                curr_state <= 6;
        end
        18: begin
            a0X_in = 0;
            a1X_in = a[1][2];
            a2X_in = a[2][1];

            bX0_in = 0;
            bX1_in = b[2][1];
            bX2_in = b[1][2];
            curr_state <= 7;
        end
        7: begin
            stMAC[1][0] <= 1;
            stMAC[0][1] <= 1;

            stMAC[2][0] <= 1;
            stMAC[1][1] <= 1;
            stMAC[0][2] <= 1;

            stMAC[1][2] <= 1;
            stMAC[2][1] <= 1;

            curr_state <= 8;
        end
        8: begin
            stMAC[1][0] <= 0;
            stMAC[0][1] <= 0;

            stMAC[2][0] <= 0;
            stMAC[1][1] <= 0;
            stMAC[0][2] <= 0;

            stMAC[1][2] <= 0;
            stMAC[2][1] <= 0;

            if(doneMAC[1][0] && doneMAC[0][1] && doneMAC[2][0] && 
                doneMAC[1][1] && doneMAC[0][2] && doneMAC[1][2] && doneMAC[2][1])
                curr_state <= 19;
            else
                curr_state <= 8;
        end
        19: begin
            a0X_in = 0;
            a1X_in = 0;
            a2X_in = a[2][2];

            bX0_in = 0;
            bX1_in = 0;
            bX2_in = b[2][2];
            curr_state <= 9;
        end
        9: begin
            stMAC[2][0] <= 1;
            stMAC[1][1] <= 1;
            stMAC[0][2] <= 1;

            stMAC[1][2] <= 1;
            stMAC[2][1] <= 1;

            stMAC[2][2] <= 1;

            curr_state <= 10;
        end
        10: begin
            stMAC[2][0] <= 0;
            stMAC[1][1] <= 0;
            stMAC[0][2] <= 0;

            stMAC[1][2] <= 0;
            stMAC[2][1] <= 0;

            stMAC[2][2] <= 0;

            if(doneMAC[2][0] && doneMAC[1][1] && doneMAC[0][2] && 
                doneMAC[1][2] && doneMAC[2][1] && doneMAC[2][2])
                curr_state <= 20;
            else
                curr_state <= 10;
        end
        20 : begin
            a0X_in = 0;
            a1X_in = 0;
            a2X_in = 0;

            bX0_in = 0;
            bX1_in = 0;
            bX2_in = 0;
            curr_state <= 11;
        end
        11: begin
            stMAC[1][2] <= 1;
            stMAC[2][1] <= 1;

            stMAC[2][2] <= 1;

            curr_state <= 12;
        end
        12: begin
            stMAC[1][2] <= 0;
            stMAC[2][1] <= 0;

            stMAC[2][2] <= 0;

            if(doneMAC[1][2] && doneMAC[2][1] && doneMAC[2][2])
                curr_state <= 21;
            else
                curr_state <= 12;
        end
        21 : begin
            a0X_in = 0;
            a1X_in = 0;
            a2X_in = 0;

            bX0_in = 0;
            bX1_in = 0;
            bX2_in = 0;
            curr_state <= 13;
        end
        13: begin 
            stMAC[2][2] <= 1;

            curr_state <= 14;
        end
        14: begin
            stMAC[2][2] <= 0;

            if(doneMAC[2][2])
                curr_state <= 15;
            else
                curr_state <= 14;
        end
        15: begin
            done <= 1;
            if(start)
                curr_state <= 0;
            else
                curr_state <= 15;
        end
    endcase
end


endmodule
