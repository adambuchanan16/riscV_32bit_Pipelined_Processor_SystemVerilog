`timescale 1ns / 1ps

module instrMem(
        input logic [31:0] pc,
        output logic [31:0] instruction
    );
    
    //4 KB memory
    logic [7:0] memory [0:4095];
        
    integer i;

    initial begin
        for (i = 0; i < 4096; i = i + 1)
            memory[i] = 8'h00;
    
        $readmemh("C:/Users/HandCannon/riscProcessorSV/program.mem", memory);
    end
    
    always_comb begin
        instruction = {memory[pc + 32'd3],
                       memory[pc + 32'd2],
                       memory[pc + 32'd1],
                       memory[pc + 32'd0]};
    end
    
endmodule
