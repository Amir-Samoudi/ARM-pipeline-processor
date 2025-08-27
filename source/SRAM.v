module SRAM(
    input clk,
    inout [15:0] SRAM_DQ,
    input [17:0] SRAM_ADDR,
    input SRAM_UB_N,
    input SRAM_LB_N,
    input SRAM_WE_N,
    input SRAM_CE_N,
    input SRAM_OF_N
);
    reg [15:0] RAM [0 : 15];

    //read
    assign SRAM_DQ = SRAM_WE_N ? RAM[SRAM_ADDR] : 16'bz;

    //write
    always @(posedge clk) begin
        if(SRAM_WE_N == 0)
            RAM[SRAM_ADDR] <= SRAM_DQ;
    end
endmodule
