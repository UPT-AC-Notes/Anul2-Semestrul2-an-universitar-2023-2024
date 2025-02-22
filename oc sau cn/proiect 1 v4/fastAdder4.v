`timescale 1ns / 1ps
module fastAdder4(
        input [3:0] G, P,
        input Cin,
        output [3:0] S
    );
    
    wire [3:0] C;
    assign C[0] = Cin;
    assign #5 C[1] = G[0] | (C[0] & P[0]);
    assign #5 C[2] = G[1] | (G[0] & P[1]) | (C[0] & P[0] & P[1]);
    assign #5 C[3] = G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (C[0] & P[0] & P[1] & P[2]);
    genvar i;
	generate for(i=0; i<4; i=i+1) begin
       assign #3 S[i] = P[i] ^ C[i];
    end
    endgenerate

endmodule
