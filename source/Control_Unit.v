module Control_Unit(
    input [3:0] OP_Code,
    input [1:0] mode,
    input S,
    output reg [3:0] EXE_CMD,
    output reg MEM_R_EN, MEM_W_EN,
    output reg WB_EN,
    output reg B, S_Out );

    always @(OP_Code, mode, S) begin
        {EXE_CMD, MEM_R_EN, MEM_W_EN, WB_EN, B , S_Out} = 9'b0;
        case (mode)
           2'b10 : begin    // B
                    EXE_CMD = 4'bx;
                    B = 1'b1;
                end
           2'b01 : begin
                    if (S == 1'b1) begin   // LDR
                        EXE_CMD = 4'b0010;
                        MEM_R_EN = 1'b1;
                        WB_EN = 1'b1;
                    end
                    else if (S == 1'b0) begin // STR
                        EXE_CMD = 4'b0010;
                        MEM_W_EN = 1'b1;
                    end         
                end 
            2'b00 : begin
                case (OP_Code)
                   4'b1101 : begin  // MOV
                                EXE_CMD = 4'b0001;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end 
                   4'b1111 : begin //MVN
                                EXE_CMD = 4'b1001;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end
                   4'b0100 : begin //ADD
                                EXE_CMD = 4'b0010;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end
                   4'b0101 : begin //ADC
                                EXE_CMD = 4'b0011;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end
                   4'b0010 : begin //SUB
                                EXE_CMD = 4'b0100;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end
                   4'b0110 : begin //SBC
                                EXE_CMD = 4'b0101;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end
                    4'b0000 : begin //AND 
                                EXE_CMD = 4'b0110;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end
                   4'b1100 : begin //ORR
                                EXE_CMD = 4'b0111;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end 
                   4'b0001 : begin //EOR
                                EXE_CMD = 4'b1000;
                                WB_EN = 1'b1;
                                S_Out = S;
                   end  
                   4'b1010 : begin //CMP
                                EXE_CMD = 4'b0100;
                                S_Out = S;
                   end       
                   4'b1000 : begin // TST
                                EXE_CMD = 4'b0110;
                                S_Out = S;
                   end  
                    default: ;
                endcase
                
            end
            default: ;
        endcase
    end


endmodule
