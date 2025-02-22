`timescale 1ns / 1ps

module logicalLeftShift(
    input [31:0]A,
    output [31:0]B
    );
    assign B[0]=0;
	genvar i;
    generate for( i=1;i<32;i=i+1)
    begin
        assign B[i]=A[i-1];
    end
    endgenerate
endmodule
