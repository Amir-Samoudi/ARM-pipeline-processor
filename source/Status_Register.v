module Status_Register(
    input clk, rst,
    input [3:0] Status_bits,
    input S,
    output reg [3:0] Status_out
);

always @(negedge clk, posedge rst) begin
    if (rst == 1'b1)
        Status_out <= 4'b0;
    else if (S == 1'b1)
        Status_out <= Status_bits;
end

endmodule
