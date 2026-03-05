`timescale 1ns / 1ps

module ALU(
    input  logic [31:0] A,      
    input  logic [31:0] B,      
    input  logic [3:0]  aluOp,

    output logic [31:0] Y,
    output logic        zero,
    output logic        overflow,
    output logic        carry,
    output logic        negative
);

    logic [32:0] temp;

    always_comb begin
        Y        = 32'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        temp     = 33'b0;

        case (aluOp)

            4'b0000: begin // ADD
                temp = {1'b0, A} + {1'b0, B};
                Y = temp[31:0];
                carry = temp[32];
                overflow = (A[31] == B[31]) && (Y[31] != A[31]);
            end

            4'b0001: begin // SUB
                temp = {1'b0, A} - {1'b0, B};
                Y = temp[31:0];
                carry = ~temp[32];
                overflow = (A[31] != B[31]) && (Y[31] != A[31]);
            end

            4'b0010: Y = A & B;          // AND
            4'b0011: Y = A | B;          // OR
            4'b0100: Y = A ^ B;          // XOR
            4'b0101: Y = ~(A | B);       // NOR

            4'b0110: Y = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT (signed)

            4'b0111: Y = A << B[4:0];                    // SLL
            4'b1000: Y = A >> B[4:0];                    // SRL
            4'b1001: Y = $signed(A) >>> B[4:0];          // SRA

            default: Y = 32'b0;
        endcase
    end

    assign zero     = (Y == 32'b0);
    assign negative = Y[31];

endmodule