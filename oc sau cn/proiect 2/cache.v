module struct(
    input clk,
    input rst,
    input bgn,
    input write,
    input read,
    input [511:0] data,//folosi ca datele care sunt aduse din MM
    input [31:0] address,//adresa ceruta
    output reg [511:0] outbus,// Bus pentru datele de ieșire
    output reg hit,//Indicator pentru hit
	output reg [3:0]state,// Starea curentă
	output reg miss // Indicator pentru miss
);
	//Registri folositi pentru a stoca datele primite
	
	
	//cache size data
    reg [511:0] cache_size_data [511:0];
    //cache tag
    reg [18:0] cache_tag [511:0];
    //cache valid bit
    reg [511:0] cache_valid_bit;
    //cache dirty bit
    reg [3:0] cache_dirty_bit [127:0];
	
	localparam var =128;
    //adresa
    reg [18:0] tag;
    reg [6:0] index;
    reg [5:0] offset;


    //LRU pentru fiecare bloc dintr un set 
    reg [2:0]lru1 [127:0];
	reg [2:0]lru2 [127:0];
	reg [2:0]lru3 [127:0];
	reg [2:0]lru4 [127:0];
    integer i;


	reg [3:0] satte_reg;
	//codificare stari
	parameter IDLE =            4'b0000;
	parameter GET_ADDRESS =     4'b0001;
	parameter READ =            4'b0010;
	parameter WRITE =           4'b0011;
	parameter READ_MISS =       4'b0100;
	parameter READ_HIT =        4'b0101;
	parameter WRITE_MISS =      4'b0110;
	parameter WRITE_HIT =       4'b0111;
	parameter CHECK =           4'b1000;
	parameter EVICT =           4'b1001;
	
	//initializare variabile punem valid pe 0
	initial begin 
	for( i=0;i<512;i=i+1)
	begin
		cache_valid_bit[i]=0;
	end
	outbus=0;
	hit=0;
	miss=0;
	satte_reg=IDLE;
	end
	
	
	always @(*) begin
		case(satte_reg)
			IDLE : begin //vedem daca putem incepe
				hit<=0;
				miss<=0;
				if(bgn == 1'b0)begin
					satte_reg <= IDLE;
				end
				else begin
					satte_reg <= GET_ADDRESS;
				end
				
			end
			GET_ADDRESS : begin //vedem ce fel de insstructiune avem
				tag = address[31:13];
				index = address[12:6];
				offset = address[5:0];
				if(read == 1'b1) begin
					satte_reg <= READ;
				end
				else if(write == 1'b1) begin
					satte_reg <= WRITE;
				end
				else begin
					satte_reg <= GET_ADDRESS;
				end
			end
			READ : begin//stabilim daca avem hit sau mis daca gasim un set valid cu acelasi tag hit(la indexul specificat) altfel miss
				if((cache_valid_bit[index]&&(cache_tag[index]==tag ))||(cache_valid_bit[index+var]&&(cache_tag[index+var]==tag ))||
				(cache_valid_bit[index+var*2]&&(cache_tag[index+var*2]==tag ))||(cache_valid_bit[index+var*3]&&(cache_tag[index+var*3]==tag ))) 
				begin
					satte_reg <= READ_HIT;
				end
				else  begin
					satte_reg <= READ_MISS;	
				end
			end
			WRITE : begin
				if( (cache_valid_bit[index]&&(cache_tag[index]==tag ))||(cache_valid_bit[index+var]&&(cache_tag[index+var]==tag ))||
				(cache_valid_bit[index+var*2]&&(cache_tag[index+var*2]==tag ))||(cache_valid_bit[index+var*3]&&(cache_tag[index+var*3]==tag ))) //satbilim daca avem hit sau miss daca gasim un set valid cu aclasi tag hit(la indexul specificat) altfel miss
				begin
					satte_reg <= WRITE_HIT;
				end
				else  begin
					satte_reg <= WRITE_MISS;
				end
			end
			READ_HIT : begin
				#40
				hit<=1;
				#5
				//facem update la lru 
				if(cache_valid_bit[index]==1&&(cache_tag[index]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
				begin
					if(cache_valid_bit[index+var]==0 && lru2[index]<=lru1[index])
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru3[index]<=lru1[index])
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru4[index]<=lru1[index])
					lru4[index]<=lru4[index]+3'b001;
					
					lru1[index]<=1'b0;
				end
				if(cache_valid_bit[index+var]==1&&(cache_tag[index+var]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
				begin
					if(cache_valid_bit[index+var]==0 && lru1[index]<=lru2[index])
					lru1[index]<=lru1[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru3[index]<=lru2[index])
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru4[index]<=lru2[index])
					lru4[index]<=lru4[index]+1'b1;
					
					lru2[index]<=1'b0;
				end
				if(cache_valid_bit[index+var*2]==1&&(cache_tag[index+var*2]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
					begin
					if(cache_valid_bit[index+var]==0 && lru1[index]<=lru3[index])
					lru1[index]<=lru1[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru2[index]<=lru3[index])
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru4[index]<=lru3[index])
					lru4[index]<=lru4[index]+1'b1;
					
					lru3[index]<=1'b0;
					end
				if(cache_valid_bit[index+var*3]==1&&(cache_tag[index+var*3]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
					begin
					if(cache_valid_bit[index+var]==0 && lru2[index]<=lru4[index])
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru3[index]<=lru4[index])
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru1[index]<=lru4[index])
					lru1[index]<=lru1[index]+1'b1;
					
					lru4[index]<=1'b0;
					end
				outbus<=cache_size_data[index];//trimitem datele citite pe bus
				satte_reg <= IDLE;
			end
			WRITE_HIT : begin
				#40
				hit<=1;
				#5
				if(cache_valid_bit[index]==1&&(cache_tag[index]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
				begin
					if(cache_valid_bit[index+var]==0 && lru2[index]<=lru1[index])
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru3[index]<=lru1[index])
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru4[index]<=lru1[index])
					lru4[index]<=lru4[index]+3'b001;
					
					lru1[index]<=1'b0;
					cache_dirty_bit[index][2]<=1'b1;//Setam bitul de dirty
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele cerute pe bus
					cache_tag[index]<=tag;
					cache_valid_bit<=1'b1;
				end
				if(cache_valid_bit[index+var]==1&&(cache_tag[index+var]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
				begin
					if(cache_valid_bit[index+var]==0 && lru1[index]<=lru2[index])
					lru1[index]<=lru1[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru3[index]<=lru2[index])
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru4[index]<=lru2[index])
					lru4[index]<=lru4[index]+3'b001;
					
					lru2[index]<=1'b0;
					cache_dirty_bit[index][1]<=1'b1;//Setam bitul de dirty
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele cerute pe bus
					cache_tag[index]<=tag;
					cache_valid_bit<=1'b1;
				end
				if(cache_valid_bit[index+var*2]==1&&(cache_tag[index+var*2]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
					begin
					if(cache_valid_bit[index+var]==0 && lru1[index]<=lru3[index])
					lru1[index]<=lru1[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru2[index]<=lru3[index])
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru4[index]<=lru3[index])
					lru4[index]<=lru4[index]+3'b001;
					
					lru3[index]<=1'b0;
					cache_dirty_bit[index][2]<=1'b1;//Setam bitul de dirty
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele cerute pe bus
					cache_tag[index]<=tag;
					cache_valid_bit<=1'b1;
					end
				if(cache_valid_bit[index+var*3]==1&&(cache_tag[index+var*3]&&tag))//verificam daca acesta este setul cerut daca acesta este actualizam lru biti corespunzator
					begin
					if(cache_valid_bit[index+var]==0 && lru2[index]<=lru4[index])
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 && lru3[index]<=lru4[index])
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 && lru1[index]<=lru4[index])
					lru1[index]<=lru1[index]+3'b001;
					
					lru4[index]<=1'b0;
					cache_dirty_bit[index][3]<=1'b1;//Setam bitul de dirty
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele cerute pe bus
					cache_tag[index]<=tag;
					cache_valid_bit<=1'b1;
					end
				satte_reg <= IDLE;
			end
			WRITE_MISS : begin
				satte_reg <= CHECK;
			end
			READ_MISS : begin
				satte_reg <= CHECK;
			end
			CHECK : begin 
				#40
				miss<=1;
				#5
				//verificam bitul de valid(adica daca exista deja date acolo)
				if(cache_valid_bit[index]==0)//verificam setul si actualizam lru biti corespunzator
				begin
					if(cache_valid_bit[index+var]==0 )
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 )
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 )
					lru4[index]<=lru4[index]+3'b001;
					
					lru1[index]<=1'b0;
					
					cache_dirty_bit[index][0]<=1'b0;//Resetam bitul de dirty
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele cerute pe bus
					cache_tag[index]<=tag;
					cache_valid_bit[index]<=1'b1;//setam bitul valid
					satte_reg<=IDLE;
				end
				if(cache_valid_bit[index+var]==0)//verificam setul si actualizam lru biti corespunzator
				begin
					if(cache_valid_bit[index+var]==0 )
					lru1[index]<=lru1[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0)
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 )
					lru4[index]<=lru4[index]+3'b001;
					
					lru2[index]<=1'b0;
					
					cache_valid_bit[index+var]<=1'b1;//setam bitul de valid
					cache_dirty_bit[index][1]<=1'b0;//Resetam bitul de dirty
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele cerute pe bus
					cache_tag[index]<=tag;
					satte_reg<=IDLE;
				end
				if(cache_valid_bit[index+var*2]==0)//verificam setul si actualizam lru biti corespunzator
				begin
					
					if(cache_valid_bit[index+var]==0 )
					lru1[index]<=lru1[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 )
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 )
					lru4[index]<=lru4[index]+3'b001;
					
					lru3[index]<=1'b0;
					
					cache_valid_bit[index+var*2]<=1'b1;//setam bitul de valid
					cache_dirty_bit[index][2]<=1'b0;//resetam bitul de dirty
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele pe bus
					cache_tag[index]<=tag;
					satte_reg<=IDLE;
				end
				if(cache_valid_bit[index+var*3]==0)//verificam setul si actualizam lru biti corespunzator
				begin
					
					if(cache_valid_bit[index+var]==0 )
					lru2[index]<=lru2[index]+3'b001;
					
					if(cache_valid_bit[index+var*2]==0 )
					lru3[index]<=lru3[index]+3'b001;
					
					if(cache_valid_bit[index+var*3]==0 )
					lru1[index]<=lru1[index]+3'b001;
					
					lru4[index]<=1'b0;
					
					cache_valid_bit[index+var*3]<=1'b1;//setam bitul de valid
					cache_dirty_bit[index][3]<=1'b0;//resetam bitul de dirty
					cache_tag[index]<=tag;
					cache_size_data[index]=data;//retinem datele
					outbus<=data;//scoatem datele pe bus
					satte_reg<=IDLE;
				end
				satte_reg <= EVICT;//daca bitul este valid mergem in evict(scoatem datele)
				
			end
			EVICT : begin
			#40
			//verificam bitii de lru pentru seturi
				if(lru4[index]==3)
				begin
					if(cache_dirty_bit[index][3])//verificam setul,adica daca are bitul de dirty setat,in caz afirmativ scoatem datele pe bus
					begin
						outbus<=cache_size_data[index];//punem datele pe bus
					end
					#40
					//actualizam bitii de lru corespunzatori
					lru1[index]<=lru1[index]+3'b001;
					lru2[index]<=lru2[index]+3'b001;
					lru3[index]<=lru3[index]+3'b001;
					lru4[index]<=0;
					cache_size_data[index]<=data;//retinem datele
				end
				if(lru3[index]==3)
				begin
					if(cache_dirty_bit[index][3])//verificam setul,adica daca are bitul de dirty setat,in caz afirmativ scoatem datele pe bus
					begin
						outbus<=cache_size_data[index];//punem datele pe bus
					end
					#40
					//actualizam bitii de lru corespunzatori
					lru1[index]<=lru1[index]+3'b001;
					lru2[index]<=lru2[index]+3'b001;
					lru4[index]<=lru3[index]+3'b001;
					lru3[index]<=0;
					cache_size_data[index]<=data;//retinem datele
				end
				if(lru2[index]==3)
				begin
					if(cache_dirty_bit[index][3])//verificam setul,adica daca are bitul de dirty setat,in caz afirmativ scoatem datele pe bus
					begin
						outbus<=cache_size_data[index];
					end
					#40
					//actualizam bitii de lru corespunzatori
					lru1[index]<=lru1[index]+3'b001;
					lru4[index]<=lru2[index]+3'b001;
					lru3[index]<=lru3[index]+3'b001;
					lru2[index]<=0;
					cache_size_data[index]<=data;//retinem datele
				end
				if(lru1[index]==3)
				begin
					if(cache_dirty_bit[index][3])//verificam setul,adica daca are bitul de dirty setat,in caz afirmativ scoatem datele pe bus
					begin
						outbus<=cache_size_data[index];
					end
					#40
					//actualizam bitii de lru corespunzatori
					lru4[index]<=lru1[index]+3'b001;
					lru2[index]<=lru2[index]+3'b001;
					lru3[index]<=lru3[index]+3'b001;
					lru1[index]<=0;
					cache_size_data[index]<=data;//retine datele
				end
				satte_reg <= IDLE;
			end
			
			
		endcase
		state<=satte_reg;
	end

endmodule