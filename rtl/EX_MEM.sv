`timescale 1ns / 1ps
module EX_MEM(
    input  logic clk,
    input  logic reset,

    input  logic regWrite_in,
    input  logic memWrite_in,
    input  logic memRead_in,
    input  logic memToReg_in,
    input  logic wbFromPC4_in,

    input  logic [31:0] pc4_in,
    input  logic [31:0] aluY_in,
    input  logic [31:0] store_in,
    input  logic [4:0]  rd_in,

    output logic regWrite_out,
    output logic memWrite_out,
    output logic memRead_out,
    output logic memToReg_out,
    output logic wbFromPC4_out,

    output logic [31:0] pc4_out,
    output logic [31:0] aluY_out,
    output logic [31:0] store_out,
    output logic [4:0]  rd_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            regWrite_out <= 0; 
            memWrite_out <= 0; 
            memRead_out <= 0; 
            memToReg_out <= 0; 
            wbFromPC4_out <= 0;
            pc4_out <= 0; 
            aluY_out <= 0; 
            store_out <= 0; 
            rd_out <= 0;
        end 
        else begin
            regWrite_out <= regWrite_in;
            memWrite_out <= memWrite_in;
            memRead_out  <= memRead_in;
            memToReg_out <= memToReg_in;
            wbFromPC4_out<= wbFromPC4_in;

            pc4_out <= pc4_in;
            aluY_out <= aluY_in;
            store_out <= store_in;
            rd_out <= rd_in;
        end
    end
endmodule