module EXE_Stage(
    input [31:0] PC_in,
    input [3:0] EXE_CMD,
    input MEM_R_EN, MEM_W_EN,
    input [31:0] Val_Rn, Val_Rm,
    input imm,
    input [11:0] Shift_operand,
    input [23:0]Signed_imm_24,
    input [3:0] SR,

    input [1:0] Sel_src1, Sel_src2,//
    input [31:0] ALU_res_MEM, WB_value,//

    output [31:0] ALU_result, Br_addr,
    output [3:0] status,

    output [31:0] Val_Rm_out, //
    output [31:0] PC

);

    wire Val2_Sel;  //OR
    assign Val2_Sel = MEM_R_EN | MEM_W_EN;

    // assign PC = PC_in;
    wire [23:0] Singed_imm_two_LSL = Signed_imm_24 << 2;
    assign Br_addr = { {8{Singed_imm_two_LSL[23]} }, Singed_imm_two_LSL} + PC_in;



    wire [31:0] Val_src1;
    mux_3 MUX3_1(.IN_1(Val_Rn), .IN_2(ALU_res_MEM), .IN_3(WB_value), .sel(Sel_src1), .out(Val_src1));

    wire [31:0] Val_src2;
    mux_3 MUX3_2(.IN_1(Val_Rm), .IN_2(ALU_res_MEM), .IN_3(WB_value), .sel(Sel_src2), .out(Val_src2));


    wire [31:0] Val2_ALU;
    Val2Generate Val2Generate(.imm(imm), .Val2_Sel(Val2_Sel),.Shift_operand(Shift_operand), .Val_Rm(Val_src2), .Val2(Val2_ALU));

    ALU ALU(.Val1(Val_src1), .Val2(Val2_ALU), .EXE_CMD(EXE_CMD),.Status(SR), .ALU_Res(ALU_result),.Status_Out(status));

    assign Val_Rm_out = Val_src2; //Memory Address

    assign PC = PC_in;
   

endmodule


