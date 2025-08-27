module Val2Generate(
input imm, Val2_Sel,
input [11:0] Shift_operand,
input [31:0] Val_Rm,
output reg [31:0] Val2
);
wire [63:0] Reg1 , Reg2, Val_Rm_ASR;
wire[1:0] shift;
wire [3:0] rotate_imm1;
wire [4:0] rotate_imm2;

assign shift = Shift_operand[6:5];


assign Reg1 = {24'b0, Shift_operand[7:0], 24'b0, Shift_operand[7:0]};

assign Reg2 = {Val_Rm, Val_Rm};


assign rotate_imm1 = Shift_operand[11:8];
assign rotate_imm2 = Shift_operand[11:7];


always @(Shift_operand, imm, Val2_Sel, Val_Rm, shift) begin
    Val2 = 32'b0;

    if (Val2_Sel == 1'b1)  // Load and Store
        Val2 = { {20{Shift_operand[11]}} , Shift_operand};

    else begin
        if (imm == 1'b1)
            // Val2 = Reg1[2*rotate_imm1+31 : 2*rotate_imm1];
            Val2 = Reg1[31 + (rotate_imm1<<1) -: 32];

        else begin

            case (shift)
                // 2'b00 : Val2 = { Val_Rm[31 - 2*rotate_imm2:0], {2*rotate_imm2{1'b0}} }; //LSL
                 2'b00 : Val2 = Val_Rm << (rotate_imm2);


                // 2'b01 : Val2 = { {2*rotate_imm2{1'b0}}, Val_Rm[31:2*rotate_imm2] };  //LSR
                2'b01 : Val2 = Val_Rm >> (rotate_imm2);
                
                // 2'b10 : Val2 = { {2*rotate_imm2{Val_Rm[31]}}, Val_Rm[31:2*rotate_imm2] };  // ASR
                2'b10 : Val2 = Val_Rm >>> (rotate_imm2);
                
                // 2'b11 : Val2 = Reg2[2*rotate_imm2+31:2*rotate_imm2];     //ROR
                2'b11 : Val2 = Reg2[31 + (rotate_imm2) -: 32];  //ROR

                default: ;
            endcase

        end

    end

end
    
endmodule
