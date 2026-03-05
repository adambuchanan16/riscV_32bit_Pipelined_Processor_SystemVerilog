`timescale 1ns / 1ps

module tb_instrMem;

    logic [31:0] pc;
    logic [31:0] instruction;

    instrMem dut(
        .pc(pc),
        .instruction(instruction)
    );

    initial begin
        $display("Testing instrMem...");

        pc = 32'd0;
        #1;

        pc = 32'd4;
        #1;

        pc = 32'd8;
        #1;

        pc = 32'd12;
        #1;

        $finish;
    end

endmodule