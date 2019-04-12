`define BIAS 3

endmodule

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

assign FRC_multiplicand = {1,multiplicand[3:0]};
assign FRC_multiplier = {1,multiplier[3:0]};

assign sign_product = (multiplicand[7]^multiplier[7]);

reg [4:0] EXP_product;
reg [9:0] FRC_product;

reg [1:0] curr_state;
reg [1:0] next_state;

initial begin
    done = 0;
    V = 0;
    product = 0;
    EXP_difference = 0;
    EXP_product = 0;
    FRC_product = 0;
    curr_state = 0;
    next_state = 0;
end

always @(*) begin
    case(curr_state)
        0: begin
            if(start) begin
                next_state <= 1;
            end
            else begin
                next_state <= 0;
            end
        end
        1: begin
            EXP_product = EXP_multiplicand+EXP_multiplier - `BIAS;
            FRC_product = FRC_multiplicand*FRC_multiplier;
            next_state = 2;
        end
        2: begin
            if(FRC_product == 0) begin
                EXP_product = 0;
                next_state = 3;
            end
            else begin
                if(FRC_product > 64) begin//If fraction is larger than 5 bits long
                    FRC_product = {0,FRC_product[9:1]};
                    EXP_product = EXP_product + 1;
                    next_state = 2;
                end
                else begin
                    if(!FRC_product[4]) begin
                        FRC_product = {FRC_product[8:0],0};
                        EXP_product = EXP_product - 1;
                        next_state = 2;
                    end
                    else
                        next_state = 3;
                end
            end
        end
        3: begin
            if(EXP_product[4])
                v = 1;
            else
                v = 0;
            product = {sign_product,EXP_product[2:0],FRC_product[3:0]};
            done = 1;
        end
    endcase
end

always @(posedge clk) begin
    curr_state <= next_state;
end

endmodule
