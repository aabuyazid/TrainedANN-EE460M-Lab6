`timescale 1ns / 1ps

module Adder(clk, stAdd, a, d, e, doneAdd);
input clk, stAdd;
input [7:0] a,d;
output [7:0] e;
output doneAdd;

reg [2:0] Ea, Ed, Ee;
reg [12:0] Fa, Fd, Fe; //{[11] overflow, [10:8] shift left space, [7] implied one, [6:3], original fraction, [2:0] shift right space};
reg [2:0] state=0;
reg Se,doneR;
initial begin
    doneR = 0;
    Ee = 0;
    Fe = 0;
    Se = 0;
end

assign e = {Se, Ee, Fe[10:7]};
assign doneAdd = doneR;
//state machine
// S0 load values into place
// S1 compare exponents to shift fractions and incrament exponets
// S2 add fractions
// done
always@ (posedge clk) begin
    case(state)
        2'd0 : begin
            Ea <= a[6:4];
            Ed <= d[6:4];
            Fa <= {2'b01,a[3:0],7'b0000000};
            Fd <= {2'b01,d[3:0],7'b0000000};
            if (stAdd) begin
                doneR <=0; 
                state <= 2'd1;
            end
        end
        2'd1 : begin
            if (Ea > Ed) begin
                Ed <= Ed + 1;
                Fd <= Fd >> 1;
            end
            else begin
                if (Ea < Ed) begin
                    Ea <= Ea + 1;
                    Fa <= Fa >> 1;
                end
                else 
                    state <= 2'd2;
            end
        end
        2'd2 : begin
            Ee <= Ea;
            state <= 3'd3;
            if({a[7] & d[7]}) begin
                    Fe <= Fa+Fd;
                    Se <= 1;
            end 
            else begin
                if({~a[7] & ~d[7]}) begin
                    Fe <= Fa+Fd;
                    Se <= 0;
                end 
                else begin
                    if({~a[7] & d[7]}) begin
                        if(Fa<Fd) begin
                            Fe <= Fd-Fa;
                            Se <= 1;
                        end
                        else begin
                            Fe <= Fa-Fd;
                            Se <= 0;
                        end
                    end
                    else begin
                        if(Fd<Fa) begin
                            Fe <= Fa-Fd;
                            Se <= 1;
                        end
                        else begin
                            Fe <= Fd-Fa;
                            Se <= 0;
                        end
                    end
                end
            end            
        end
        2'd3 : begin
            if (Fe[12]) begin
                Ee <= Ee+1;
                Fe <= Fe >> 1;
            end 
            else begin
                if(Fe[11] == 0) begin
                    Ee <= Ee-1;
                    Fe <= Fe << 1;
                end 
                else begin
                    doneR <=1;
                    if (~stAdd)
                        state <= 0;
                end
            end
        end             
    endcase
end

endmodule

module multiply(clk, stMul, c, b, d, doneMul);
input clk, stMul;
input [7:0] c, b;
output [7:0] d;
output doneMul;
    assign d = b;
    assign doneMul = 1;
endmodule
