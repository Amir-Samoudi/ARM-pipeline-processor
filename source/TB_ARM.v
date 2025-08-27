`timescale 1ns/1ns
module TB_ARM();

    reg rst = 0, clk = 0, select_Forwarding = 1;
    wire [15:0] SRAM_DQ;
    wire [17:0] SRAM_ADDR;
    wire SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OF_N;

    ARM_Topmodule UUT(clk, rst, select_Forwarding, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OF_N);

    SRAM SRam(clk, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OF_N);

    always #5 clk = ~clk;
    
    initial begin
      #10 rst = 1;
      #10 rst = 0;
      #5000 $stop; 
    end


endmodule
