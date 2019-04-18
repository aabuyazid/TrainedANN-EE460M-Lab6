`timescale 1ns / 1ps

module MAC_tb();
reg clk, stMAC;
reg [7:0] b, c;
wire [7:0] result;
wire done;

MAC dut(clk,b,c,stMAC,result,done);

initial begin
    clk = 0;
    stMAC = 0;
    b = 0;
    c = 0;
    #100 
    stMAC = 1;
    #100 
    stMAC = 0;
    c = 8'b01001100;
    b = 8'b01001000;
    #100
    stMAC = 1;
    #100
    stMAC = 0;
    c = 8'b01001000;
    b = 8'b00101000;
    #100
    stMAC = 1;
    
end

always
    #5 clk <= ~clk;

endmodule