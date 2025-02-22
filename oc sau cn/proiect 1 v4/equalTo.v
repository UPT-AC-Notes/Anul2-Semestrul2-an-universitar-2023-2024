`timescale 1ns / 1ps

module equalTo(
    input [31:0] A, B,
    output et
    );
    
    wire [31:0] S;
    wire Cout;
    
    subtractor32 unit(A, B, S, Cout);
    wire temp; 
    or U1(temp, S[31], S[30], S[29], S[28], S[27], S[26], S[25], S[24], S[23], S[22], S[21], S[20], S[19], S[18], S[17], S[16], S[15], S[14], S[13], S[12], S[11], S[10], S[9], S[8], S[7], S[6], S[5], S[4], S[3], S[2], S[1], S[0]);
    assign et = !temp;
    
endmodule
