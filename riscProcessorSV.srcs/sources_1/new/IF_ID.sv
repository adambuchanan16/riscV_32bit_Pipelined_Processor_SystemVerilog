`timescale 1ns / 1ps

module IF_ID(
    input  logic clk,
    input  logic reset,

    input  logic en,
    input  logic flush,

    input  logic [31:0] pc_in,
    input  logic [31:0] pc4_in,
    input  logic [31:0] instr_in,

    output logic [31:0] pc_out,
    output logic [31:0] pc4_out,
    output logic [31:0] instr_out
);

    //setting NOP as a local value to save time LOL
    localparam logic [31:0] NOP = 32'h0000_0013;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out    <= 32'b0;
            pc4_out   <= 32'b0;
            instr_out <= NOP;
        end
        else if (flush) begin
            pc_out    <= 32'b0;
            pc4_out   <= 32'b0;
            instr_out <= NOP;
        end
        else if (en) begin
            pc_out    <= pc_in;
            pc4_out   <= pc4_in;
            instr_out <= instr_in;
        end
    end

endmodule