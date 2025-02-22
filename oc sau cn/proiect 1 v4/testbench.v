`timescale 1ns / 1ps
module testbench(

    );
    reg [31:0] A,B;
    reg [3:0] control;
    wire [31:0] S;
    wire carry, overflow, lessthan, equalto, zero;
    main unit(A, B, control, S, carry, overflow, lessthan, equalto, zero);
    initial begin
    
    A = 5;
    B=5;
    control = 1;
    #400
    $display("A=%d B=%d control=%d S=%d carry=%b overflow=%b lessthan=%b equalto=%b zero=%b",A,B,control,S,carry, overflow, lessthan, equalto, zero);
    A = 2147483648;
    B= 2;
    control = 1;
    #400
    $display("A=%d B=%d control=%d S=%d carry=%b overflow=%b lessthan=%b equalto=%b zero=%b",A,B,control,S,carry, overflow, lessthan, equalto, zero);
    
    end
    
    
endmodule
