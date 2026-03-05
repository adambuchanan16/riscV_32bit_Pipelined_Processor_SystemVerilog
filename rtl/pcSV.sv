`timescale 1ns / 1ps
module pcSV(
    input  logic        clk,
    input  logic        reset,
    input  logic        en,        //for handling stalls
    input  logic [31:0] pcNext,
    output logic [31:0] pc
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            pc <= 32'b0;
        else if (en) 
            pc <= pcNext;
    end
endmodule