`timescale 1ns / 1ps
module immGen(
    input  logic [31:0] instr,
    output logic [31:0] immI,
    output logic [31:0] immS,
    output logic [31:0] immB,
    output logic [31:0] immJ
);
    assign immI = {{20{instr[31]}}, instr[31:20]};
    assign immS = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    assign immB = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    assign immJ = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
endmodule