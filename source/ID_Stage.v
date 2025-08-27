module ID_Stage (

input clk, rst,
//from IF Reg
input [31:0] Instruction,
input [31:0] PC_IN,
//from WB stage
input [31:0] Result_WB,
input writeBackEn,
input [3:0] Dest_wb,
//from hazard detect module
input hazard,
//from Status Register
input [3:0] SR,
//to next stage
output WB_EN, MEM_R_EN, MEM_W_EN ,B ,S,
output [3:0] EXE_CMD,
output [31:0] Val_Rn, Val_Rm,
output imm,
output [11:0] Shift_operand,
output [23:0] Signed_imm_24,
output [3:0] Dest,
//to hazard detect module
output [3:0] srcl,src2,
output Two_src,
//to PC
output [31:0] PC
);

    wire [3:0] RF_src2;
    
    // To PC
    assign PC = PC_IN;

    assign RF_src2 = (MEM_W_EN == 1'b1) ? Instruction[15:12] : Instruction[3:0];

    RegisterFile RF(clk, rst, Instruction[19:16], RF_src2, Dest_wb, Result_WB, writeBackEn, Val_Rn, Val_Rm);

    wire [3:0] EXE_CMD_CU;
    wire MEM_R_EN_CU, MEM_W_EN_CU ,B_CU ,S_CU, WB_EN_CU;
    wire cond_flag;

    Control_Unit CU(.OP_Code(Instruction[24:21]), .mode(Instruction[27:26]), .S(Instruction[20]),
                    .EXE_CMD(EXE_CMD_CU), .MEM_R_EN(MEM_R_EN_CU), .MEM_W_EN(MEM_W_EN_CU),
                    .WB_EN(WB_EN_CU), .B(B_CU) , .S_Out(S_CU));

    assign {WB_EN, EXE_CMD, MEM_W_EN, MEM_R_EN, B, S} =
             (cond_flag == 1'b0) ? {WB_EN_CU, EXE_CMD_CU, MEM_W_EN_CU, MEM_R_EN_CU, B_CU, S_CU} : 9'b0;
    
    wire condition_check;
    Condition_Check Cond_Check(.Condition(Instruction[31:28]), .Status(SR),.condition_flag(condition_check));

    //OR and NOT
    assign cond_flag = hazard | (~condition_check);

    //HAZARD
    assign Two_src = MEM_W_EN | (~Instruction[25]);
    assign srcl = Instruction[19:16];
    assign src2 = RF_src2;

    //
    assign imm = Instruction[25];
    assign Shift_operand = Instruction[11:0];
    assign Signed_imm_24 = Instruction[23:0];
    assign Dest = Instruction[15:12];



endmodule
