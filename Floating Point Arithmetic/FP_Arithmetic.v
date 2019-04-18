`define BIAS 3

module FP_Adder(clk, stAdd, a, d, e, doneAdd);
input clk, stAdd;
input [7:0] a,d;
output [7:0] e;
output doneAdd;

reg [2:0] Ea, Ed, Ee;
reg [12:0] Fa, Fd, Fe; 
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
        3'd0 : begin
            Ea <= a[6:4];
            Ed <= d[6:4];
            Fa <= {2'b01,a[3:0],7'b0000000};
            Fd <= {2'b01,d[3:0],7'b0000000};
            if (stAdd) begin
                doneR <=0; 
                state <= 3'd1;
                if(a==0)
                    state <= 3'd5;
                if(d==0)
                    state <= 3'd6;
            end
        end
        3'd1 : begin
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
                    state <= 3'd2;
            end
        end
        3'd2 : begin
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
        3'd3 : begin
            if (Fe == 0) begin
                Ee <= 0;
                state <= 3'd4;
            end else begin
                if (Fe[12]) begin
                    Ee <= Ee+1;
                    Fe <= Fe >> 1;
                end else begin
                    if(Fe[11] == 0) begin
                        Ee <= Ee-1;
                        Fe <= Fe << 1;
                    end 
                    else
                        state <= 3'd4; 
                end
            end
        end
        3'd4 : begin   
            doneR <=1;
            if (~stAdd)
                state <= 0;
        end
        3'd5 : begin
            Se <= d[7]; Ee <= d[6:4]; Fe[10:7] <= d[3:0];
            state <= 3'd4;
        end
        3'd6 : begin
            Se <= a[7]; Ee <= a[6:4]; Fe[10:7] <= a[3:0];
            state <= 3'd4;
        end
    endcase
end

endmodule


module FP_Multiplier(
    input clk,
    input start,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output reg [7:0] product,
    output reg done,
    output reg V,
);

wire [2:0] EXP_multiplicand, EXP_multiplier;
wire [4:0] FRC_multiplicand, FRC_multiplier;
wire S_multiplicand, S_multiplier;
wire sign_product;

assign S_multiplicand = multiplicand[7];
assign S_multiplier = multiplier[7];

assign EXP_multiplicand = multiplicand[6:4];
assign EXP_multiplier = multiplier[6:4];

assign FRC_multiplicand = {1'b1,multiplicand[3:0]};
assign FRC_multiplier = {1'b1,multiplier[3:0]};

assign sign_product = (multiplicand[7]^multiplier[7]);

reg [4:0] EXP_product;
reg [9:0] FRC_product;

reg [2:0] curr_state;

initial begin
    done = 0;
    V = 0;
    product = 0;
    EXP_product = 0;
    FRC_product = 0;
    curr_state = 0;
end

always @(posedge clk) begin
    case(curr_state)
        0: begin
            if(start) begin
                curr_state <= 1;
                done <= 0;
            end
            else begin
                curr_state <= 0;
            end
        end
        1: begin
            EXP_product <= EXP_multiplicand+EXP_multiplier - `BIAS;
            FRC_product <= FRC_multiplicand*FRC_multiplier;
            curr_state <= 2;
        end
        2: begin
            if(FRC_product == 0) begin
                EXP_product <= 0;
                curr_state <= 3;
            end
            else begin
                FRC_product <= FRC_product[9:4];
                curr_state <= 4;    //State will shift frac bits until 
            end
        end
        3: begin        //End State
            if(EXP_product[4])
                V <= 1;
            else
                V <= 0;
            product <= {sign_product,EXP_product[2:0],FRC_product[3:0]};
            done <= 1;
            curr_state <= 0;
        end
        4: begin
            if(FRC_product >= 32) begin //If fraction is larger than 5 bits long
                FRC_product <= {1'b0,FRC_product[9:1]};
                EXP_product <= EXP_product + 1;
                curr_state <= 4;
            end
            else begin
                if(FRC_product < 16) begin
                    FRC_product <= {FRC_product[8:0],1'b0};
                    EXP_product <= EXP_product - 1;  
                    curr_state <= 4;
                end
                else
                    curr_state <= 3;
            end
        end
    endcase
end

endmodule
