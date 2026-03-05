`timescale 1ns / 1ps
module aluControl(
    input  logic [3:0] aluOpCat,   
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [3:0] aluOpOut
);
    always_comb begin
        aluOpOut = 4'b0000; //default to ADD

        unique case (aluOpCat)
            4'b0000: aluOpOut = 4'b0000; //ADD
            4'b0001: aluOpOut = 4'b0001; //SUB

            4'b0010: begin //R-type
                unique case (funct3)
                    3'b000: aluOpOut = (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000; //sub/add
                    3'b111: aluOpOut = 4'b0010; //and
                    3'b110: aluOpOut = 4'b0011; //or
                    3'b100: aluOpOut = 4'b0100; //xor
                    3'b010: aluOpOut = 4'b0110; //slt
                    3'b001: aluOpOut = 4'b0111; //sll
                    3'b101: aluOpOut = (funct7 == 7'b0100000) ? 4'b1001 : 4'b1000; //sra/srl
                    default: aluOpOut = 4'b0000;
                endcase
            end

            4'b0011: begin
                aluOpOut = 4'b0000;
            end

            default: aluOpOut = 4'b0000;
        endcase
    end
endmodule