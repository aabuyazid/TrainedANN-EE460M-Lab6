`timescale 1ns / 1ps

module MAC(
input clk,
input [7:0] b,
input [7:0] c,
input stMAC,
output [7:0] result,
output done);
reg [7:0] a=0;
reg stAdd=0, stMul=0, doneR=0; 
wire [7:0] e,d; 
wire doneAdd,doneMul;
reg [2:0] stateMAC=0;
assign result = a;
assign done = doneR;
always@( posedge clk) begin
    case(stateMAC)
        3'd0 : begin// start MAC
            if(stMAC) begin
                doneR <=0;
                stateMAC <= 1;
            end
        end
        3'd1 : begin// start multiply of B and C to D
            stMul<= 1;
            stateMAC <= 2;
        end
        3'd2 : begin// when multiply is done start the add of D and A to E
            stMul <= 0;
            stateMAC <= 3;
        end
        3'd3 : begin// when multiply is done start the add of D and A to E
            if(doneMul) begin
                stAdd <= 1;
                stateMAC <= 4;
            end
        end
        3'd4 : begin// when add is done MAC is done
            stAdd <= 0;
            stateMAC <= 5;
        end
        3'd5 : begin// when add is done MAC is done
            if(doneAdd) begin
                a <= e;
                stateMAC <= 6;
            end
        end
        3'd6: begin// when add is done MAC is done
            doneR <= 1;
            if(stMAC == 0)
                stateMAC <= 0;
        end
    endcase
end
//multiply b and c add with a store back in a 
FP_Multiplier mul (clk, stMul, c, b, d, doneMul);
FP_Adder add (clk, stAdd, d, a, e, doneAdd);

endmodule
