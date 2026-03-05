`timescale 1ns / 1ps

module controlUnit(

    input  logic [6:0] opcode,

    output logic regWrite,
    output logic aluSrc,
    output logic memWrite,
    output logic memRead,
    output logic memToReg,
    output logic branch,
    output logic jump,        
    output logic jalr,
    output logic [1:0] immSel,        
    output logic [3:0] aluOp  

);

always_comb begin
    // defaults
    regWrite = 1'b0;
    aluSrc   = 1'b0;
    memWrite = 1'b0;
    memRead  = 1'b0;
    memToReg = 1'b0;
    branch   = 1'b0;
    jump     = 1'b0;
    jalr     = 1'b0;
    immSel = 2'b00; 
    aluOp    = 4'b0000;

    unique case (opcode)

        7'b0110011: begin   //R-type
            regWrite = 1'b1;
            aluSrc   = 1'b0;
            aluOp    = 4'b0010;   
        end

        7'b0010011: begin   //I-type
            regWrite = 1'b1;
            aluSrc   = 1'b1;     
            aluOp    = 4'b0011;   
        end

        7'b0000011: begin   //LOAD
            regWrite = 1'b1;
            aluSrc   = 1'b1;     
            memRead  = 1'b1;
            memToReg = 1'b1;      
            aluOp    = 4'b0000;   
        end

        7'b0100011: begin   //STORE
            regWrite = 1'b0;
            aluSrc   = 1'b1; 
            immSel   = 2'b01;        
            memWrite = 1'b1;
            aluOp    = 4'b0000;  
        end

        7'b1100011: begin   //BRANCH
            regWrite = 1'b0;
            aluSrc   = 1'b0;      
            branch   = 1'b1;
            aluOp    = 4'b0001;  
        end

        7'b1101111: begin   //JAL
            jump     = 1'b1;
            regWrite = 1'b1;     
            aluOp    = 4'b0100; 
        end

        7'b1100111: begin   //JALR
            jalr     = 1'b1;
            regWrite = 1'b1;      
            aluSrc   = 1'b1;    
            aluOp    = 4'b0000; 
        end

        default: begin
        end

    endcase
end

endmodule