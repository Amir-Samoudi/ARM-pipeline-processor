module ALU(
input [31:0] Val1 , Val2,
input [3:0] EXE_CMD,Status,
output reg[31:0] ALU_Res,
output [3:0] Status_Out
);

reg overflow , co;

always @(EXE_CMD, Val1, Val2, Status) begin
    {overflow, co} = 2'b0;
    ALU_Res = 32'b0;
    case (EXE_CMD) 
        4'b0001 : ALU_Res = Val2;                            //MOV
        4'b1001 : ALU_Res = ~Val2;                           //MVN
        4'b0010 : begin                                      //ADD
            {co ,ALU_Res} = Val1 + Val2;  
            // overflow = co ^ ALU_Res[31] ^ Val1[31] ^ Val2[31]; //?
            overflow = (Val1[31] == Val2[31]) && (Val1[31] != ALU_Res[31]);
        end                  

        4'b0011 : begin                             //ADC
            {co ,ALU_Res} = Val1 + Val2 + {31'b0, Status[1]};
            // overflow = co ^ ALU_Res[31] ^ Val1[31] ^ Val2[31];
            overflow = (Val1[31] == Val2[31]) && (Val1[31] != ALU_Res[31]);
        end                                                
       
        4'b0100 :begin                            //SUB
            {co ,ALU_Res} = Val1 - Val2;
            // overflow = (Val1[31] & (~Val2[31]) & ALU_Res[31]) | ((~Val1[31]) & Val2[31] & (~ALU_Res[31]));
            overflow = (Val1[31] != Val2[31]) && (Val1[31] != ALU_Res[31]);


        end      

        4'b0101 :begin                            //SBC
        ALU_Res = Val1 - Val2 - {31'b0, ~Status[1]}; 
        //  overflow = (Val1[31] & (~Val2[31]) & ALU_Res[31]) | ((~Val1[31]) & Val2[31] & (~ALU_Res[31]));
            overflow = (Val1[31] != Val2[31]) && (Val1[31] != ALU_Res[31]);

        end      

        4'b0110 : ALU_Res = Val1 & Val2;                     //AND
        4'b0111 : ALU_Res = Val1 | Val2;                     //ORR
        4'b1000 : ALU_Res = Val1 ^ Val2;                     //EOR
        4'b0100 :begin                                       //CMP
                    ALU_Res = Val1 - Val2; 
                    // overflow = (Val1[31] & (~Val2[31]) & ALU_Res[31]) | ((~Val1[31]) & Val2[31] & (~ALU_Res[31]));  
                    overflow = (Val1[31] != Val2[31]) && (Val1[31] != ALU_Res[31]);

                end                 

        4'b0110 : ALU_Res = Val1 & Val2;                      //TST
                                                           
        4'b0010 :begin                                        //LDR & STR
            {co ,ALU_Res} = Val1 + Val2;  
            // overflow = co ^ ALU_Res[31] ^ Val1[31] ^ Val2[31];
            overflow = (Val1[31] == Val2[31]) && (Val1[31] != ALU_Res[31]);

        end                   

        default: ; 
    endcase
end

    //assign overflow = ((Val1[31] & Val2[31] & ~((Val1+Val2)[31])) | (~Val1[31] & ~Val2[31] & (Val1+Val2)[31]));

    assign Status_Out[0] = overflow;
    assign Status_Out[1] = co;
    assign Status_Out[2] = ~|ALU_Res;      //Z
    assign Status_Out[3] = ALU_Res[31];                          //N

endmodule
