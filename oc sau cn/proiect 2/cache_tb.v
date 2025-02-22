module struct_tb;

reg clk;
reg rst;
reg bgn;
reg write;
reg read;
reg [511:0] data;
reg [31:0] address;
wire [511:0] outbus;
wire hit;
wire miss;
wire [3:0] and_val;


struct uut (
    .clk(clk),
    .rst(rst),
    .bgn(bgn),
    .write(write),
    .read(read),
    .data(data),
    .address(address),
    .outbus(outbus),
    .hit(hit),
	.state(and_val),
	.miss(miss)
);


initial begin
    clk = 0;
    repeat (500) begin
        #10 clk = ~clk;
    end
    //$stop; 
end 

initial begin
    
    rst = 1;
    bgn = 0;
    write = 0;
    read = 0;

    //Initial test: testare generala a functionalitatii cache 
	/*	
	#40;
	bgn=1;
	
	//Read Miss
	data = 512'hA1B2734615F60789_9876543210FEDCBA_BBCCDDEEDD001122_33445566778899AA_1122334455667788_99AABBCCDDEEFF00_0011223344556677_8899AABBCCDDEEFF;
    address = 32'b12355628;
	#40;
	read=1;
	#40;
	read=0;
	#200;
	
	//Read Hit
	data = 512'hA1B2C3D4E5F60789_9876543210FEDCBA_BBABCDEEFF001122_33445566778899AA_1122334455667788_99AABBCCDDEEFF00_0011223344556677_8899AABBCCDDEEFF;
    address = 32'b22345278;
	#40;
	read=1;
	#40;
	read=0;
	
	
    //Write Miss
    data = 512'hCAFEBABEDEADBEEF_1234567890ABCDEF_FEDCBA3216543210_0A1B2C3D4E5F6789_AABBCCDDEEFF0011_99AABBCCDDEEFF00_1122334455667788_8899AABBCCDDEEFF;
    address = 32'hEFFFEF0A;
    #40;
    write = 1;
    #40;
    write = 0;
    #40;
	
	//READ Hit
	address = 32'h12345678;
	#40;
	read=1;
	#40;
	read=0;
	#40;
	
	//WRITE Hit
	data = 512'hCAFEBABEDEADBEEF_1234567890ABCDEF_FEDCBA9876543210_0A1BABC6545F6789_AABBC45698FF0011_99AABBCCDDEEFF00_11223ABDC5667788_8899AABBCCDDEEFF;
	address = 32'h12345678;
	
	#40;
	write=1;
	#40;
	write=0;
	#40;
    */
	//Initial test testare generala a functionalitatii cache sfarsit

    //CASE 1 scriem/apoi citim  de mai multe ori variabile la acelasi index trebie sa da miss consecutive

	 /*
    
    address = 32'hFF000000;
    data = 512'hf1B2C3D4E5F60789_9876123410FEDCBA_BBCCDACCFF001122_33445566712399AA_1ABCCB4455667788_99AABBCCDDEEFF00_0011223654556677_8899AABBCCDDEEFF;

    
     //WRITE
	#40;
     bgn = 1;
     #40;
    // bgn = 0;
     #40;
     write = 1;
     #20;
     write = 0;
    #200;

    address =  32'hEE000000;
     data = 512'hA1B2C3D4E5F60789_98765AAAA0FEDCBA_BBCCDDEEFF001122_33B45566778899AA_11AA334455667788_99AABBCAADEEFF00_0011223344556677_8899AABBCCDDEEFF;

    
     //WRITE
		#40;
		 bgn = 1;
		#40;
		
		 write = 1;
	   #20;
	  write = 0;
		#200;

    address = 32'hDD000000;
    data = 512'h91B2C3D4E5F60789_9876543210FEDCBA_BBCCDDEEBBDC1122_33445566778899AA_112233DEF5667788_99AABBCCDDEEFF00_001122FED4558877_8899AABBCCDDEEFF;

    
     //WRITE
     #40;
     bgn = 1;
     #40;
     
     write = 1;
     #20;
     write = 0;
     #200;

     address = 32'hCC000000;
     data = 512'h81B2C3D4E5F60789_987654AAA0FEDCBA_BBCCDDEEFF001122_33445566778899AA_11223ABBAE667788_99AABBCCDDEEFF00_0011964344556677_8899AABBCCDDEEFF;

    
     //WRITE
     #40;
     bgn = 1;
    #40;

    write = 1;
    #20;
    write = 0;
    #200;


    address = 32'hEFAFEF0A;

    //READ
    #40;
    bgn = 1;
    #40;
    read = 1;
    #40;
    
    read = 0;
    #200;


    address = 32'hAFAFEF0A;

    //READ
    #40;
    bgn = 1;
    #40;
    read = 1;
    #40;
    
    read = 0;
    #200;


    address = 32'hBFAFEF0A;

    //READ
    #40;
    bgn = 1;
    #40;
    read = 1;
    #40;
    
    read = 0;
    #200;

    address = 32'hCFAFEF0A;

    //READ
    #40;
    bgn = 1;
    #40;
    read = 1;
    #40;
    
    read = 0;
    #200;
    */
	
    //-----------------------------------------------------------------------------------------------------------------------------------------------

	
    //CASE 2 
	
    address = 32'hCFAFEF0A;
    data = 512'hA1B2C3D4E5F60789_9832123210FEDCBA_BBCCDDE553001122_33445566778899AA_1122334455667788_99AABBCDCDEEFF00_0011ADADA4556677_8899AAB7896DEEFF;

    //WRITE
    #40;
    bgn = 1;
    #40;
    write = 1;
    #20;
    write = 0;
    #200;


    //WRITE
    #40;
    write = 1;
    #20;
    write = 0;
    #200;


    address = 32'hBFAFEF0A;
    data = 512'h81B2C3D4E5F60789_9876543997FEDCBA_BB624BEEFF001122_33445566778899AA_11223ABDA5667788_99AABBCCDDEEFF00_0011223999556677_8899AABBCCDDEEFF;

    //WRITE
    #40;
    write = 1;
    #20;
    write = 0;
    #200;

    //WRITE
    #40;
    write = 1;
    #20;
    write = 0;
    #200;

    address = 32'hCFAFEF0A;

    //READ
    #40;
    read = 1;
    #40;
    read = 0;
    #200;


    address = 32'hCAAFEF0A;
    data = 512'h55DCABC876543210_0123456789ABCDEF_FEDCBA9159D43210_0ABDEF3789ABCDEF_FEDCBA778DA43210_0123456307ABCDEF_FEDCBA9876993210_0123456789ABCDEF;

    //WRITE
    #40;
    write = 1;
    #20;
    write = 0;
    #200;

    //READ
    #40;
    read = 1;
    #40;
    read = 0;
    #200;

    //READ
    #40;
    read = 1;
    #40;
    read = 0;
    #200;
    
   
end


endmodule