`timescale 1ns / 1ps

module fastAdder32(
        input Cin,
        input [31:0] A, B,
        output [31:0] S,
        output Cout
    );
    wire [31:0] G, P;
    wire [8:0] Cg;
    GenProp GP(A, B, Cin, G, P, Cg);
	genvar i;
    generate for(i=0; i<8; i=i+1) begin
        fastAdder4 f4(G[4*i+3 : 4*i], P[4*i+3 : 4*i], Cg[i], S[4*i+3 : 4*i]);
    end
    endgenerate
    
    assign Cout = Cg[8];
    
endmodule
