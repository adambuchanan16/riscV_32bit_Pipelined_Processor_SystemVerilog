`timescale 1ns / 1ps
module forwardUnit(
    input  logic [4:0] ex_rs1,
    input  logic [4:0] ex_rs2,

    input  logic [4:0] mem_rd,
    input  logic mem_regWrite,

    input  logic [4:0] wb_rd,
    input  logic wb_regWrite,

    output logic [1:0] fwdA,   //00=IDEX, 10=EXMEM, 01=MEMWB
    output logic [1:0] fwdB
);
    always_comb begin
        fwdA = 2'b00;
        fwdB = 2'b00;

        if (mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs1)) 
            fwdA = 2'b10;
        if (mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs2)) 
            fwdB = 2'b10;

        if (wb_regWrite && (wb_rd != 0) && !(mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs1)) && (wb_rd == ex_rs1))
            fwdA = 2'b01;

        if (wb_regWrite && (wb_rd != 0) && !(mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs2)) && (wb_rd == ex_rs2))
            fwdB = 2'b01;
    end
endmodule