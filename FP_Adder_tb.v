`timescale 1ns / 1ps

module FP_Adder_tb();
reg clk, stAdd;
reg [7:0] a, d;
wire [7:0] e;
wire doneAdd;

Adder ut (clk, stAdd, a, d, e, doneAdd);

initial begin
    clk = 0;
    stAdd = 0;
    a = 0;
    d = 0;
    #100 
    stAdd = 1;
    #100 
    stAdd = 0;
    a = 8'b01001100;
    d = 8'b01001000;
    #100
    stAdd = 1;
    #100
    stAdd = 0;
    a = 8'b01001001;
    d = 8'b00000000;
    #100
    stAdd = 1;
    #100 
    stAdd = 0;
    a = 8'b11001000;
    d = 8'b01001000;
    #100
    stAdd = 1;
    
end

always
    #5 clk <= ~clk;

endmodule
