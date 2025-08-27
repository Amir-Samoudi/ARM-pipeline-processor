module IF_Stage(
    input clk, rst, freeze, Branch_taken,
    input [31:0] BranchAddr,
    output [31:0] PC, Instruction
);

    wire [31:0] PC_In, PC_Out;

    mux_2 MUX(PC, BranchAddr, Branch_taken, PC_In);
    PC PC_IF(clk, rst, freeze, PC_In, PC_Out);
    Adder Adder_IF(32'd4, PC_Out, PC);
    Instruction_Mem IM(PC_Out, Instruction);

endmodule