`timescale 1ns / 1ps
module ID_EX(
    input  logic clk,
    input  logic reset,
    input  logic flush,

    //control
    input  logic regWrite_in,
    input  logic aluSrc_in,
    input  logic memWrite_in,
    input  logic memRead_in,
    input  logic memToReg_in,
    input  logic branch_in,
    input  logic jump_in,
    input  logic jalr_in,
    input  logic [3:0] aluOpCat_in,
    input  logic [1:0]  immSel_in,

    //data
    input  logic [31:0] pc_in,
    input  logic [31:0] pc4_in,
    input  logic [31:0] r1_in,
    input  logic [31:0] r2_in,
    input  logic [31:0] immI_in,
    input  logic [31:0] immS_in,
    input  logic [31:0] immB_in,
    input  logic [31:0] immJ_in,
    input  logic [2:0]  funct3_in,
    input  logic [6:0]  funct7_in,
    input  logic [4:0]  rs1_in,
    input  logic [4:0]  rs2_in,
    input  logic [4:0]  rd_in,

    //outputs
    output logic regWrite_out,
    output logic aluSrc_out,
    output logic memWrite_out,
    output logic memRead_out,
    output logic memToReg_out,
    output logic branch_out,
    output logic jump_out,
    output logic jalr_out,
    output logic [3:0] aluOpCat_out,
    output logic [1:0]  immSel_out,

    output logic [31:0] pc_out,
    output logic [31:0] pc4_out,
    output logic [31:0] r1_out,
    output logic [31:0] r2_out,
    output logic [31:0] immI_out,
    output logic [31:0] immS_out,
    output logic [31:0] immB_out,
    output logic [31:0] immJ_out,
    output logic [2:0]  funct3_out,
    output logic [6:0]  funct7_out,
    output logic [4:0]  rs1_out,
    output logic [4:0]  rs2_out,
    output logic [4:0]  rd_out
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            regWrite_out <= 0; 
            aluSrc_out <= 0; 
            memWrite_out <= 0; 
            memRead_out <= 0; 
            memToReg_out <= 0;
            branch_out <= 0; 
            jump_out <= 0; 
            jalr_out <= 0; 
            aluOpCat_out <= 4'b0000;
            immSel_out   <= 2'b00;

            pc_out <= 0; 
            pc4_out <= 0; 
            r1_out <= 0; 
            r2_out <= 0;
            immI_out <= 0; 
            immS_out <= 0; 
            immB_out <= 0; 
            immJ_out <= 0;
            funct3_out <= 0; 
            funct7_out <= 0; 
            rs1_out <= 0; 
            rs2_out <= 0; 
            rd_out <= 0;
        end 
        else begin
            regWrite_out <= regWrite_in;
            aluSrc_out   <= aluSrc_in;
            memWrite_out <= memWrite_in;
            memRead_out  <= memRead_in;
            memToReg_out <= memToReg_in;
            branch_out   <= branch_in;
            jump_out     <= jump_in;
            jalr_out     <= jalr_in;
            aluOpCat_out <= aluOpCat_in;
            immSel_out   <= immSel_in;

            pc_out <= pc_in;
            pc4_out <= pc4_in;
            r1_out <= r1_in;
            r2_out <= r2_in;
            immI_out <= immI_in;
            immS_out <= immS_in;
            immB_out <= immB_in;
            immJ_out <= immJ_in;
            funct3_out <= funct3_in;
            funct7_out <= funct7_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
        end
    end
endmodule