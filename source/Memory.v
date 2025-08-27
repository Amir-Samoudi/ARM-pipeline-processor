module Memory #(
    parameter WORDLENGHT
) (
    input clk, rst,
    input [5:0] addr,
    input wr_en,
    input [WORDLENGHT-1 : 0] wr_data,
    output [WORDLENGHT-1 : 0] rd_data
);

    reg [WORDLENGHT-1 : 0] mem [0: 63];

    integer i;
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            for (i = 0; i < 64; i = i + 1) begin
                mem[i] <= 0;
            end
        end

        else if (wr_en == 1'b1)
            mem[addr] <= wr_data; 
    end

    assign rd_data = mem[addr];
    
endmodule
