`timescale 1ns / 1ps

module TB_ALU;

    logic [31:0] A;
    logic [31:0] B;
    logic [3:0] aluOp;
    
    logic [31:0] Y;
    logic zero;
    logic overflow;
    logic carry;
    logic negative;
    
    ALU DUT(
        .A(A),
        .B(B),
        .aluOp(aluOp),
        .Y(Y),
        .zero(zero),
        .overflow(overflow),
        .carry(carry),
        .negative(negative)
    ); 
    
    initial begin
    
        A = 10;
        B = 5;
        aluOp = 4'b0000;
        #10;
        
        aluOp = 4'b0001;
        #10;
        
        aluOp = 4'b0010;
        #10;
        
        aluOp = 4'b0011;
        #10
        
        aluOp = 4'b0100;
        #10
        
        aluOp = 4'b0101;
        #10
        
        aluOp = 4'b0110;
        #10
        
        aluOp = 4'b0111;
        #10
        
        aluOp = 4'b1000;
        #10
        
        aluOp = 4'b1001;
        #10
        
        $finish;
    end
    
endmodule
