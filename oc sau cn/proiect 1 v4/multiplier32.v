`timescale 1ns / 1ps

module multiplier32(
   A,B,S,O
    );

parameter width = 32;
input [width-1:0] A, B;
output [width-1:0] S;
output O;
//wor p;
wire [31:0]p;
assign p[0]=0;
wire [31:0]t;
assign t[0]=0;
wire [31:0] Cout;
wire [31:0] overflow;
wire [width*width-1:0] partials;
wire [width*width-1:0] partialstemp;
//assign p=0;
assign partials[width-1 : 0] = A[0] ? B : 0;
genvar i;
generate 
    for ( i = 1; i < width; i = i+1) begin
        leftShift genu(B,i,partialstemp[width*(i+1)-1 : width*i]);
        fastAdder32 add1(1'b0,(A[i] ? partialstemp[width*(i+1)-1 : width*i] : 0),partials[width*i-1 : width*(i-1)],partials[width*(i+1)-1 : width*i],Cout[i]);
        assign t[i]=B[width-i] | t[i-1];
        assign p[i] = (Cout[i]+ A[i]&t[i]) | p[i-1];
end 
endgenerate
assign O=p[31];
assign S = partials[width*width-1 : width*(width-1)];
endmodule
