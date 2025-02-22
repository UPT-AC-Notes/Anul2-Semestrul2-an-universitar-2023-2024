`timescale 1ns / 1ps
module mux2(
 output [31:0] S,
 input [31:0] A0,A1,
 input sel
);
wire [31:0] selector;
genvar i;
generate for( i=0;i<32;i=i+1)
begin
    assign selector[i]=sel;
end
endgenerate
//assign S = sel? A1 : A0;
assign S=selector&A1 | (~selector)&A0;
endmodule
