`timescale 1ns / 1ps

module TB_pc;

    logic clk;
    logic reset;
    
    logic branch;
    logic jump;
    logic zero;
    
    logic [31:0] branchTarget;
    logic [31:0] jumpTarget;
    
    logic [31:0] pc;

    pcSV DUT(
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .jump(jump),
        .zero(zero),
        .branchTarget(branchTarget),
        .jumpTarget(jumpTarget),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    
        reset = 1;
        branch = 0;
        jump = 0;
        zero = 0;
        branchTarget = 0;
        jumpTarget = 0;
        #10;
        
        reset = 0;
        
        #50;
        
        reset = 1;
        
        #10;
        
        reset = 0;
        
        #40;
        
    $finish;
    
    end

endmodule
