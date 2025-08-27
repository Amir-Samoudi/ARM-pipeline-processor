module MEM_Stage(

input clk, rst, MEMread, MEMwrite, WB_EN,
input [31:0] address, data,
output [31:0] MEM_result,
output freeze_signal,
inout [15:0] SRAM_DQ,
output [17:0] SRAM_ADDR,
output SRAM_UB_N,
output SRAM_LB_N,
output SRAM_WE_N,
output SRAM_CE_N,
output SRAM_OF_N,
output WB_EN_Out
);
    wire ready;
    assign freeze_signal = (~ready);

    wire sramReady;
    wire sramMemWEnIn, sramMemREnIn;
    wire [63:0] sramReadData;

    SramController SRAM_CU(
        .clk(clk), .rst(rst),
        .wrEn(sramMemWEnIn), .rdEn(sramMemREnIn),
        .address(address),
        .writeData(data),
        .readData(sramReadData),
        .ready(sramReady),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_OE_N(SRAM_OF_N)
    );

    Cache cache(
        .clk(clk), .rst(rst),
        .wrEn(MEMwrite), .rdEn(MEMread),
        .address(address),
        .writeData(data),
        .readData(MEM_result),
        .ready(ready),
        .sramReady(sramReady),
        .sramReadData(sramReadData),
        .sramWrEn(sramMemWEnIn), .sramRdEn(sramMemREnIn)
    );

    assign WB_EN_Out = freeze_signal ? 1'b0 : WB_EN;

endmodule
