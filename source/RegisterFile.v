module RegisterFile(
    input clk, rst,
    input [3:0] src1, src2, Dest_wb,
    input [31:0] Result_WB,
    input writeBackEn,
    output [31:0] reg1, reg2
);

    reg [31:0] registerfile [0:14];

    integer i;
    always @(posedge rst, negedge clk) begin
        if (rst) begin
            for (i = 0; i < 15; i = i + 1) begin
                registerfile[i] <= i;
            end
        end

        else if (writeBackEn == 1'b1)
            registerfile[Dest_wb] <= Result_WB; 
    end

    assign reg1 = registerfile[src1];
    assign reg2 = registerfile[src2];

endmodule
