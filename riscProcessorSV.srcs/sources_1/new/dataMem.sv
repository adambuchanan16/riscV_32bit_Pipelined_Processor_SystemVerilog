`timescale 1ns / 1ps
module dataMem(
    input  logic clk,
    input  logic memRead,
    input  logic memWrite,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);
    logic [31:0] mem [0:1023]; //4KB of words

    wire [9:0] wa = addr[31:2];

    always_comb begin
        rdata = memRead ? mem[wa] : 32'b0;
    end

    always_ff @(posedge clk) begin
        if (memWrite) mem[wa] <= wdata;
    end
endmodule