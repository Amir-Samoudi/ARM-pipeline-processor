module ARM_Topmodule(
    input clk, rst, select_Forwarding,
    inout [15:0] SRAM_DQ,
    output [17:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OF_N
);

    wire [31:0] PC_Out_IF, Instruction_Out_IF;
    wire [31:0] PC_Out_IF_Reg, Instruction_Out_IF_Reg;
    wire [31:0] PC_Out_ID, PC_Out_EXE, PC_Out_EXE_Reg, PC_Out_MEM, PC_Out_MEM_Reg, PC_Out_WB;

  
    //ID Stage
    wire WB_EN_ID, MEM_R_EN_ID, MEM_W_EN_ID ,B_ID ,S_ID;
    wire [3:0] EXE_CMD_ID;
    wire [31:0] Val_Rn_ID, Val_Rm_ID;
    wire imm_ID;
    wire [11:0] Shift_operand_ID;
    wire [23:0] Signed_imm_24_ID;
    wire [3:0] Dest_ID;
    wire [3:0] src1_ID, src2_ID;
    wire Two_src_ID;
    wire [31:0] PC_ID;
    //ID Register
    wire WB_EN_ID_Reg, MEM_R_EN_ID_Reg, MEM_W_EN_ID_Reg, B_ID_Reg, S_ID_Reg,imm_ID_Reg;
    wire [3:0] EXE_CMD_ID_Reg,Dest_ID_Reg;
    wire [31:0] PC_ID_Reg,Val_Rn_ID_Reg, Val_Rm_ID_Reg;
    wire [11:0] Shift_operand_ID_Reg;
    wire [23:0] Signed_imm_24_ID_Reg;
    wire [3:0] Dest_from_EXE_ID_Reg;
    wire [3:0] src1_ID_Reg, src2_ID_Reg;
    
    //Temp wires for ID Stage
    // wire [31:0] Result_WB = 32'b0;
    // wire writeBackEn = 1'b0;
    // wire [3:0] Dest_wb = 4'b0;
    // wire [3:0] SR = 4'b0;
    // wire [3:0] Dest_from_EXE_IN = 4'b0;
   
    //EXE stage
    wire [31:0]ALU_result_EXE,Br_addr_EXE;
    wire [3:0]Status_bits_EXE;
    wire [31:0] Memory_Adr;
    wire [31:0] PC_EXE;
    //EXE Register
    wire WB_en_EXE_Reg, MEM_R_EN_EXE_Reg, MEM_W_EN_EXE_Reg;
    wire [31:0] ALU_result_EXE_Reg, ST_val_EXE_Reg;
    wire [3:0]Dest_EXE_Reg;
    wire [31:0] PC_EXE_Reg;
    wire [3:0] src1_EXE_Reg, src2_EXE_Reg;

    

    // SR
    wire [3:0] Status_Out_EXE;

    //Memory
    wire [31:0] Mem_Result;
    wire WB_en_Mem_Reg, MEM_R_en_Mem_Reg;
    wire[31:0] ALU_result_Mem_Reg, Mem_read_value_Mem_Reg;
    wire [3:0] Dest_Mem_Reg; 
    wire WB_EN_Out;

    wire freeze_signal;

    wire [3:0] src1_MEM_Reg, src2_MEM_Reg;

    //WB
    wire [31:0]WB_value;

    //hazard
    wire hazard;

    //Forwarding Unit
    wire [1:0] Sel_src1, Sel_src2;

    wire freeze_IF = hazard | freeze_signal;
    //IF_Stage
    IF_Stage IF(clk, rst, freeze_IF, B_ID_Reg, Br_addr_EXE, PC_Out_IF, Instruction_Out_IF);
    IF_Satge_Reg IF_Reg(clk, rst, freeze_IF, B_ID_Reg, PC_Out_IF, Instruction_Out_IF,
                        PC_Out_IF_Reg, Instruction_Out_IF_Reg);

    //ID_Stage
    ID_Stage ID(.clk(clk), .rst(rst), .Instruction(Instruction_Out_IF_Reg),
        .PC_IN(PC_Out_IF_Reg),.Result_WB(WB_value),.writeBackEn(WB_en_Mem_Reg),.Dest_wb(Dest_Mem_Reg),
        .hazard(hazard),.SR(Status_Out_EXE),.WB_EN(WB_EN_ID), .MEM_R_EN(MEM_R_EN_ID), .MEM_W_EN(MEM_W_EN_ID),
        .B(B_ID), .S(S_ID), .EXE_CMD(EXE_CMD_ID),.Val_Rn(Val_Rn_ID), .Val_Rm(Val_Rm_ID),
        .imm(imm_ID),.Shift_operand(Shift_operand_ID),.Signed_imm_24(Signed_imm_24_ID),
        .Dest(Dest_ID),.srcl(src1_ID),.src2(src2_ID),.Two_src(Two_src_ID),.PC(PC_ID));

    ID_Stage_Reg ID_Reg(.clk(clk), .rst(rst), .flush(B_ID_Reg),.WB_EN_IN(WB_EN_ID), .MEM_R_EN_IN(MEM_R_EN_ID),
                        .MEM_W_EN_IN(MEM_W_EN_ID),.B_IN(B_ID),.S_IN(S_ID),.EXE_CMD_IN(EXE_CMD_ID),
                        .PC_IN(PC_ID),.Val_Rn_IN(Val_Rn_ID),.Val_Rm_IN(Val_Rm_ID),.imm_IN(imm_ID),
                        .Shift_operand_IN(Shift_operand_ID),.Signed_imm_24_IN(Signed_imm_24_ID),.Dest_IN(Dest_ID),
                        .WB_EN(WB_EN_ID_Reg), .MEM_R_EN(MEM_R_EN_ID_Reg), .MEM_W_EN(MEM_W_EN_ID_Reg),.B(B_ID_Reg),
                         .S(S_ID_Reg),
                        .EXE_CMD(EXE_CMD_ID_Reg),.PC(PC_ID_Reg),.Val_Rn(Val_Rn_ID_Reg), .Val_Rm(Val_Rm_ID_Reg),
                        .imm(imm_ID_Reg),.Shift_operand(Shift_operand_ID_Reg),
                        .Signed_imm_24(Signed_imm_24_ID_Reg),
                        .Dest(Dest_ID_Reg), .Dest_from_EXE_IN(Status_Out_EXE),
                        .Dest_from_EXE(Dest_from_EXE_ID_Reg),
                        .src1_in(src1_ID), .src2_in(src2_ID), .src1(src1_ID_Reg), .src2(src2_ID_Reg),
                        .freeze(freeze_signal));

    // EXE_Stage
    EXE_Stage EXE(.PC_in(PC_ID_Reg),.EXE_CMD(EXE_CMD_ID_Reg),.MEM_R_EN(MEM_R_EN_ID_Reg),.MEM_W_EN(MEM_W_EN_ID_Reg),
                  .Val_Rn(Val_Rn_ID_Reg),.Val_Rm(Val_Rm_ID_Reg),.imm(imm_ID_Reg),.Shift_operand(Shift_operand_ID_Reg),.Signed_imm_24(Signed_imm_24_ID_Reg),
                  .SR(Dest_from_EXE_ID_Reg),
                  .ALU_result(ALU_result_EXE),.Br_addr(Br_addr_EXE),.status(Status_bits_EXE),
                  .Sel_src1(Sel_src1), .Sel_src2(Sel_src2), .ALU_res_MEM(ALU_result_EXE_Reg), .WB_value(WB_value), .Val_Rm_out(Memory_Adr), .PC(PC_EXE));
    

    EXE_Stage_Reg EXE_Reg(.clk(clk),.rst(rst),.WB_en_in(WB_EN_ID_Reg),.MEM_R_EN_in(MEM_R_EN_ID_Reg),.MEM_W_EN_in(MEM_W_EN_ID_Reg),
    .ALU_result_in(ALU_result_EXE),.ST_val_in(Memory_Adr),.Destin(Dest_ID_Reg),
    .WB_en(WB_en_EXE_Reg),.MEM_R_EN(MEM_R_EN_EXE_Reg),.MEM_W_EN(MEM_W_EN_EXE_Reg),.ALU_result(ALU_result_EXE_Reg), .ST_val(ST_val_EXE_Reg),  
     .Dest(Dest_EXE_Reg),
     .PC_IN(PC_EXE), .PC(PC_EXE_Reg), .src1_IN(src1_ID_Reg), .src2_IN(src2_ID_Reg), .src1(src1_EXE_Reg), .src2(src2_EXE_Reg),
     .freeze(freeze_signal));

     // Status Register
     Status_Register SR(.clk(clk), .rst(rst), .Status_bits(Status_bits_EXE), .S(S_ID_Reg),.Status_out(Status_Out_EXE));


    // MEM_Stage        
    MEM_Stage MEM(.clk(clk), .rst(rst), .MEMread(MEM_R_EN_EXE_Reg),.MEMwrite(MEM_W_EN_EXE_Reg), .WB_EN(WB_en_EXE_Reg),
                .address(ALU_result_EXE_Reg),.data(ST_val_EXE_Reg),.MEM_result(Mem_Result), .freeze_signal(freeze_signal),
                .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR), .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .SRAM_WE_N(SRAM_WE_N),
                .SRAM_CE_N(SRAM_CE_N), .SRAM_OF_N(SRAM_OF_N), .WB_EN_Out(WB_EN_Out));
                

    MEM_Reg MEM_Reg(.clk(clk),.rst(rst),.WB_en_in(WB_EN_Out),.MEM_R_en_in(MEM_R_EN_EXE_Reg),
                    .ALU_result_in(ALU_result_EXE_Reg),.Mem_read_value_in(Mem_Result),.Dest_in(Dest_EXE_Reg),
                    .WB_en(WB_en_Mem_Reg),.MEM_R_en(MEM_R_en_Mem_Reg),.ALU_result(ALU_result_Mem_Reg),.Mem_read_value(Mem_read_value_Mem_Reg),
                    .Dest(Dest_Mem_Reg),
                    .src1_in(src1_EXE_Reg), .src2_in(src2_EXE_Reg), .src1(src1_MEM_Reg), .src2(src2_MEM_Reg),
                    .freeze(freeze_signal));
    
    // WB_Stage
    WB_Stage WB_stage(.ALU_result(ALU_result_Mem_Reg),.MEM_result(Mem_read_value_Mem_Reg),.MEM_R_en(MEM_R_en_Mem_Reg),
                        .out(WB_value));

    //Hazard
    hazard_Detection_Unit Hazard(.src1(src1_ID),.src2(src2_ID),.Exe_Dest(Dest_ID_Reg),.Exe_WB_EN(WB_EN_ID_Reg),.Mem_Dest(Dest_EXE_Reg),.Mem_WB_EN(WB_en_EXE_Reg),
    .EXE_Mem_R_EN(MEM_R_EN_ID_Reg),.Two_src(Two_src_ID), .hazard(hazard), .select_Forwarding(select_Forwarding) );

    Forwarding_Unit forwarding(.src1(src1_ID_Reg), .src2(src2_ID_Reg), .Mem_Dest(Dest_EXE_Reg), .Mem_WB_EN(WB_en_EXE_Reg),
                                .WB_Dest(Dest_Mem_Reg), .WB_WB_EN(WB_en_Mem_Reg), .select_Forwarding(select_Forwarding),
                                .Sel_src1(Sel_src1), .Sel_src2(Sel_src2));

endmodule