`default_nettype none
module tt_multblock #(
	parameter integer mult_len =12)
	
	(input wire pulse,
	input wire [3:0] key_4,
	output wire multblockout);

	wire [mult_len:0] A;//A B are wire to connect the switch
	wire [mult_len:0] B;
	wire [mult_len-1:0] key;
	logic [0:1]anda;
	logic andaout;
	logic [0:1]andb;
	logic andbout;

	assign A[0]=pulse;
	assign B[0]=pulse;

	
	genvar i;
	generate
		//4 Oscillator
		for (i = 0; i < mult_len; i = i + 1) begin
			tt_mult mult(
				.a (A[i]),
				.b (B[i]),
 				.c(A[i+1]),
				.d(B[i+1]),
				.key(key[i])
			);
		end
       
	endgenerate

        assign key[0]=key_4[0];
        assign key[1]=key_4[0];
        assign key[2]=key_4[0];
        assign key[3]=key_4[1];
        assign key[4]=key_4[1];
        assign key[5]=key_4[1];
        assign key[6]=key_4[2];
        assign key[7]=key_4[2];
        assign key[8]=key_4[2];
        assign key[9]=key_4[3];
        assign key[10]=key_4[3];
        assign key[11]=key_4[3];
	assign anda[0]=A[12];
	assign andb[0]=B[12];
	assign anda[1]=andbout;
	assign andb[1]=andaout;
	assign multblockout=andaout;

        
	always_comb begin
               andaout=~(anda[0]&anda[1]);
               andbout=~(andb[0]&andb[1]);
	end


	
	
       
endmodule 

