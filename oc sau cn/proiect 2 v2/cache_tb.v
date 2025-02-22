module CacheController_tb;

    reg clk;
    reg rst_b;
    reg [31:0] address;
    reg [31:0] write_data;
    reg read;
    reg write;
    wire [31:0] read_data;
    wire hit;
    wire miss;
    wire spaceAlreadyTakenByAnotherBlock;

    // Instantiate the CacheController module
    CacheController uut (
        .clk(clk),
        .rst_b(rst_b),
        .address(address),
        .write_data(write_data),
        .read(read),
        .write(write),
        .read_data(read_data),
        .hit(hit),
        .miss(miss),
        .spaceAlreadyTakenByAnotherBlock(spaceAlreadyTakenByAnotherBlock)
    );

    // Clock generation
  
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_b = 1;
        address = 0;
        write_data = 0;
        read = 0;
        write = 0;
		
        // Reset the CacheController
        #10 rst_b = 0;
        #10 rst_b = 1;

        // Test 1: Read Hit
        read = 1;
        address = 32'h0000_0000;
        #20;
        read = 0;
        if (hit)
            $display("Test 1 Passed: Read Hit");
        else
            $display("Test 1 Failed: Read Hit");

        // Test 2: Write Hit
        write = 1;
        address = 32'h0000_0004;
        write_data = 32'hCAFE_BABE;
        #20;
        write = 0;
        if (hit)
            $display("Test 2 Passed: Write Hit");
        else
            $display("Test 2 Failed: Write Hit");

        // Test 3: Read Miss, then Read Hit
        read = 1;
        address = 32'h0000_0008;
        #20;
        read = 0;
        #10;
        read = 1;
        address = 32'h0000_0008;
        #20;
        read = 0;
        if (hit)
            $display("Test 3 Passed: Read Miss then Read Hit");
        else
            $display("Test 3 Failed: Read Miss then Read Hit");

        // Test 4: Write Miss, then Write Hit
        write = 1;
        address = 32'h0000_000C;
        write_data = 32'hDEAD_BEEF;
        #20;
        write = 0;
        #10;
        write = 1;
        address = 32'h0000_000C;
        write_data = 32'hCAFE_BABE;
        #20;
        write = 0;
        if (hit)
            $display("Test 4 Passed: Write Miss then Write Hit");
        else
            $display("Test 4 Failed: Write Miss then Write Hit");

        // Test 5: Read Miss, then Write Hit
        read = 1;
        address = 32'h0000_0010;
        #20;
        read = 0;
        #10;
        write = 1;
        address = 32'h0000_0010;
        write_data = 32'hCAFE_BABE;
        #20;
        write = 0;
        if (hit)
            $display("Test 5 Passed: Read Miss then Write Hit");
        else
            $display("Test 5 Failed: Read Miss then Write Hit");

        // Test 6: Read Miss (Expected Fail)
        read = 1;
        address = 32'h1234_5678; // Address not in cache
        #20;
        read = 0;
        if (miss)
            $display("Test 6 Passed: Read Miss (Expected Fail)");
        else
            $display("Test 6 Failed: Read Miss (Expected Fail)");

        // Test 7: Write Miss (Expected Fail)
        write = 1;
        address = 32'h1234_5678; // Address not in cache
        write_data = 32'hDEAD_BEEF;
        #20;
        write = 0;
        if (miss)
            $display("Test 7 Passed: Write Miss (Expected Fail)");
        else
            $display("Test 7 Failed: Write Miss (Expected Fail)");

        // Test 8: Read Hit with Wrong Data (Expected Fail)
        read = 1;
        address = 32'h0000_0014;
        #20;
        read = 0;
        if (read_data != 32'hCAFE_BABE)
            $display("Test 8 Passed: Read Hit with Wrong Data (Expected Fail)");
        else
            $display("Test 8 Failed: Read Hit with Wrong Data (Expected Fail)");

        // Test 9: Write Hit with Incorrect Data (Expected Fail)
        write = 1;
        address = 32'h0000_0018;
        write_data = 32'hABCD_EF01;
        #20;
        write = 0;
        if (hit)
            $display("Test 9 Passed: Write Hit with Incorrect Data (Expected Fail)");
        else
            $display("Test 9 Failed: Write Hit with Incorrect Data (Expected Fail)");

        // Test 10: Read Miss with Incorrect Data (Expected Fail)
        read = 1;
        address = 32'h0000_001C;
        #20;
        read = 0;
        if (read_data != 32'hDEAD_BEEF)
            $display("Test 10 Passed: Read Miss with Incorrect Data (Expected Fail)");
        else
            $display("Test 10 Failed: Read Miss with Incorrect Data (Expected Fail)");

        // Test 11: Write Miss with Incorrect Data (Expected Fail)
        write = 1;
        address = 32'h0000_0020;
        write_data = 32'hABCD_EF01;
        #20;
        write = 0;
        if (miss)
            $display("Test 11 Passed: Write Miss with Incorrect Data (Expected Fail)");
        else
            $display("Test 11 Failed: Write Miss with Incorrect Data (Expected Fail)");

        // Test 12: Read Hit with Wrong Data (Expected Fail)
        read = 1;
        address = 32'h0000_0024;
        #20;
        read = 0;
        if (read_data != 32'hCAFE_BABE)
            $display("Test 12 Passed: Read Hit with Wrong Data (Expected Fail)");
        else
            $display("Test 12 Failed: Read Hit with Wrong Data (Expected Fail)");

        // Test 13: Write Hit with Incorrect Data (Expected Fail)
        write = 1;
        address = 32'h0000_0028;
        write_data = 32'hABCD_EF01;
        #20;
        write = 0;
        if (hit)
            $display("Test 13 Passed: Write Hit with Incorrect Data (Expected Fail)");
        else
            $display("Test 13 Failed: Write Hit with Incorrect Data (Expected Fail)");

        // Test 14: Read Miss with Incorrect Data (Expected Fail)
        read = 1;
        address = 32'h0000_002C;
        #20;
        read = 0;
        if (read_data != 32'hDEAD_BEEF)
            $display("Test 14 Passed: Read Miss with Incorrect Data (Expected Fail)");
        else
            $display("Test 14 Failed: Read Miss with Incorrect Data (Expected Fail)");

        // Test 15: Write Miss with Incorrect Data (Expected Fail)
        write = 1;
        address = 32'h0000_0030;
        write_data = 32'hABCD_EF01;
        #20;
        write = 0;
        if (miss)
            $display("Test 15 Passed: Write Miss with Incorrect Data (Expected Fail)");
        else
            $display("Test 15 Failed: Write Miss with Incorrect Data (Expected Fail)");
        
        // End simulation
        //$finish;
    end
	initial  begin
	clk=0;
repeat(50000)	
       #5 clk = ~clk;
	end

endmodule

