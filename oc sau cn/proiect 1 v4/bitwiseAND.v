`timescale 1ns / 1ps


module bitwiseAND(
    input [31:0] A, B,
    output [31:0] S
    );
    genvar i;
    generate for( i=0; i<32; i=i+1) begin
        assign #3 S[i] = A[i] & B[i];
    end
    endgenerate
    
endmodule
