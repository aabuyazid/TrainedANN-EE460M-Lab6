`define BIAS 3

module FP_Multiplier(
    input clk,
    input start,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output reg done,
    output reg V,
    output reg [7:0] product
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
