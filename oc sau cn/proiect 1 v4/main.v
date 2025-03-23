`timescale 1ns / 1ps
module main(
    input [31:0] A, B,
    input [3:0] control,
    output [31:0] S,
    output carry, overflow, lessthan, equalto, zero
    );
    
    wire[15:0] operation;
    
    //Addition
    assign operation[0]=(!control[0])&(!control[1])&(!control[2])&(!control[3]);
   
    //Multiplication
    assign operation[1]=(control[0])&(!control[1])&(!control[2])&(!control[3]);
   
    //Subtraction
    assign operation[2]=(!control[0])&(control[1])&(!control[2])&(!control[3]);
   
    //LogLeftShift
    assign operation[3]=(control[0])&(control[1])&(!control[2])&(!control[3]);
   
    //LogRightShift
    assign operation[4]=(!control[0])&(!control[1])&(control[2])&(!control[3]);
   
    //ArithRightShift
    assign operation[5]=(control[0])&(!control[1])&(control[2])&(!control[3]);
   
    //BitwiseAND
    assign operation[6]=(!control[0])&(control[1])&(control[2])&(!control[3]);
   
    //BitwiseOR
    assign operation[7]=(control[0])&(control[1])&(control[2])&(!control[3]);
   
    //BitwiseNOT
    assign operation[8]=(!control[0])&(!control[1])&(!control[2])&(control[3]);
   
    //BItwiseXOR
    assign operation[9]=(control[0])&(!control[1])&(!control[2])&(control[3]);
    
    //Comparison
    assign operation[10]=(!control[0])&(control[1])&(!control[2])&(control[3]);

    wire [31:0] Stest[9:0];
    wire CARRY0,CARRY1,OVERFLOW, LESSTHAN, EQUALTO;    
    fastAdder32 U1(1'b0,A,B,Stest[0],CARRY0);
    multiplier32 U2(A,B,Stest[1],OVERFLOW);
    subtractor32 U3(A,B,Stest[2],CARRY1);
    logicalLeftShift U4(A,Stest[3]);
    logicalRightShift U5(A,Stest[4]);
    arithmeticRightShift U6(A,Stest[5]);
    bitwiseAND U7(A,B,Stest[6]);
    bitwiseOR U8(A,B,Stest[7]);
    bitwiseNOT U9(A,Stest[8]);
    bitwiseXOR U10(A,Stest[9]);
    lessThan U11(A,B,LESSTHAN);
    equalTo U12(A,B,EQUALTO);
	
    wire[31:0] Os [9:0];
   genvar i;
    generate for(i=0;i<32;i=i+1) begin
        assign Os[0][i]=operation[0];
        assign Os[1][i]=operation[1];
        assign Os[2][i]=operation[2];
        assign Os[3][i]=operation[3];
        assign Os[4][i]=operation[4];
        assign Os[5][i]=operation[5];
        assign Os[6][i]=operation[6];
        assign Os[7][i]=operation[7];
        assign Os[8][i]=operation[8];
        assign Os[9][i]=operation[9];

    end
    endgenerate
    
    assign S = (Stest[0]&Os[0]) | (Stest[1]&Os[1]) | (Stest[2]&Os[2]) |(Stest[3]&Os[3]) | (Stest[4]&Os[4]) | (Stest[5]&Os[5]) | (Stest[6]&Os[6]) | (Stest[7]&Os[7]) | (Stest[8]&Os[8]) | (Stest[9]&Os[9]);
    assign carry = 1'b0 | (operation[0]&CARRY0) | (operation[2]&CARRY1);
    assign overflow = 1'b0 | (operation[1]&OVERFLOW);
    assign lessthan = operation[10] & LESSTHAN;
    assign equalto = operation[10] & EQUALTO;
    assign zero = ~(S[0] | S[1] | S[2] | S[3] | S[4] | S[5] | S[6] | S[7] | S[8] | S[9] | S[10] | S[11] | S[12] | S[13] | S[14] | S[15] | S[16] | S[17] | S[18] | S[19] | S[20] | S[21] | S[22] | S[23] | S[24] | S[25] | S[26] | S[27] | S[28] | S[29] | S[30] | S[31] | operation[10]);
    
endmodule
