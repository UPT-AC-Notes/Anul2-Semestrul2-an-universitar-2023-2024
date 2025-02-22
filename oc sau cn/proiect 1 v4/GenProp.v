`timescale 1ns / 1ps

module GenProp(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] G,
    output [31:0] P,
    output [8:0] C
    );
	genvar i;
    generate for( i=0;i<32;i=i+1)
    begin
       assign #3 G[i]=A[i]&B[i];
       assign #3 P[i]=A[i]|B[i];
    end
    endgenerate
    
    wire [7:0] Gs, Ps;
    generate for( i=0; i<8; i=i+1) begin
        assign #3 Ps[i] = P[4*i] & P[4*i+1] & P[4*i+2] & P[4*i+3];
        assign #6 Gs[i] = (G[4*i] & P[4*i+1] & P[4*i+2] & P[4*i+3]) | (G[4*i+1] & P[4*i+2] & P[4*i+3]) | (G[4*i+2] & P[4*i+3]) | G[4*i+3];
    end
    endgenerate
    
    assign C[0] = Cin;
    
    assign #6 C[1] = Gs[0] | (C[0]&Ps[0]);
    assign #6 C[2] = Gs[1] | (Gs[0]&Ps[1]) | (C[0]&Ps[0]&Ps[1]);
    assign #6 C[3] = Gs[2] | (Gs[1]&Ps[2]) | (Gs[0]&Ps[1]&Ps[2]) | (C[0]&Ps[0]&Ps[1]&Ps[2]);
    assign #6 C[4] = Gs[3] | (Gs[2]&Ps[3]) | (Gs[1]&Ps[2]&Ps[3]) | (Gs[0]&Ps[1]&Ps[2]&Ps[3]) | (C[0]&Ps[0]&Ps[1]&Ps[2]&Ps[3]);
    assign #6 C[5] = Gs[4] | (Gs[3]&Ps[4]) | (Gs[2]&Ps[3]&Ps[4]) | (Gs[1]&Ps[2]&Ps[3]&Ps[4]) | (Gs[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]) | (C[0]&Ps[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]);
    assign #6 C[6] = Gs[5] | (Gs[4]&Ps[5]) | (Gs[3]&Ps[4]&Ps[5]) | (Gs[2]&Ps[3]&Ps[4]&Ps[5]) | (Gs[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]) | (Gs[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]) | (C[0]&Ps[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]);
    assign #6 C[7] = Gs[6] | (Gs[5]&Ps[6]) | (Gs[4]&Ps[5]&Ps[6]) | (Gs[3]&Ps[4]&Ps[5]&Ps[6]) | (Gs[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]) | (Gs[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]) | (Gs[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]) | (C[0]&Ps[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]);
    assign #6 C[8] = Gs[7] | (Gs[6]&Ps[7]) | (Gs[5]&Ps[6]&Ps[7]) | (Gs[4]&Ps[5]&Ps[6]&Ps[7]) | (Gs[3]&Ps[4]&Ps[5]&Ps[6]&Ps[7]) | (Gs[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]&Ps[7]) | (Gs[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]&Ps[7]) | (Gs[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]&Ps[7]) | (C[0]&Ps[0]&Ps[1]&Ps[2]&Ps[3]&Ps[4]&Ps[5]&Ps[6]&Ps[7]);
    
    
endmodule
