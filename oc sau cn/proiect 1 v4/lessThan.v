`timescale 1ns / 1ps

module lessThan(
    input[31:0] A, B,
    output lt
    );
    
    wire [31:0] S;
    wire Cout;
    subtractor32 unit(A, B, S, Cout);
    assign lt = !Cout;
    
endmodule
