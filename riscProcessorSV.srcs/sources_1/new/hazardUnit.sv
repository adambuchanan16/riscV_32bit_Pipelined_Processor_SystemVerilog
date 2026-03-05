`timescale 1ns / 1ps
module hazardUnit(
    input  logic ex_memRead,
    input  logic [4:0] ex_rd,
    input  logic [4:0] id_rs1,
    input  logic [4:0] id_rs2,

    output logic pc_en,
    output logic ifid_en,
    output logic idex_flush
);
    always_comb begin
        //if no hazard then proceed as normal
        pc_en = 1; 
        ifid_en = 1; 
        idex_flush = 0;

        if (ex_memRead && (ex_rd != 0) && ((ex_rd == id_rs1) || (ex_rd == id_rs2))) begin
            pc_en = 0;
            ifid_en = 0;
            idex_flush = 1;
        end
    end
endmodule