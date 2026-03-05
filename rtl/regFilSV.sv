`timescale 1ns / 1ps

module regFilSV(
    input  logic clk,
    input  logic reset,
    input  logic we,

    input  logic [4:0] regAdd1,
    input  logic [4:0] regAdd2,
    input  logic [4:0] rd,
    input  logic [31:0] wd,

    output logic [31:0] ro1,
    output logic [31:0] ro2
);

    logic [31:0] registers [31:0];
    integer i;

    always_comb begin
        //ro1
        if (regAdd1 == 0) ro1 = 32'b0;
        else if (we && (rd != 0) && (rd == regAdd1)) ro1 = wd;
        else ro1 = registers[regAdd1];

        //ro2
        if (regAdd2 == 0) ro2 = 32'b0;
        else if (we && (rd != 0) && (rd == regAdd2)) ro2 = wd;
        else ro2 = registers[regAdd2];
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else begin
            if (we && (rd != 0))
                registers[rd] <= wd;
            registers[0] <= 32'b0; //x0 always zero
        end
    end

endmodule