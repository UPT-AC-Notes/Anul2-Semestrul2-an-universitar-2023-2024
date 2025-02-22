`timescale 1ns / 1ps
module rightShift(

           input [31:0]A,
        input [31:0]B,
        output [31:0]S
        
    );
    wire [31:0] S0,S1,S2,S3;
    mux2 st0(S0, A, {1'b0,A[31:1]},B[0]);
    mux2 st1(S1, S0, {2'b0,S0[31:2]},B[1]);
    mux2 st2(S2, S1, {4'b0,S1[31:4]},B[2]);
    mux2 st3(S3, S2, {8'b0,S2[31:8]},B[3]);
    mux2 st4(S, S3, {16'b0,S3[31:16]},B[4]);
endmodule
