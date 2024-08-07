`default_nettype none
//13 flipflop in series and all output of the flipflop do xor gate
module tt_13n #(
	parameter integer count = 13

)
(
        input wire clk,
        input wire rst_n,//set all flipflop to 0
        input wire num,//bit string to be preccess
	output wire ran13nout
);

	logic [count:0] connection;//all of the wire required in the connection
	assign connection[0]=num;
	always@(posedge clk)begin//pass down bit each clk 
		connection[13]<=connection[12];
		connection[12]<=connection[11];
		connection[11]<=connection[10];
		connection[10]<=connection[9];
		connection[9]<=connection[8];
		connection[8]<=connection[7];
		connection[7]<=connection[6];
		connection[6]<=connection[5];
		connection[5]<=connection[4];		
		connection[4]<=connection[3];
		connection[3]<=connection[2];
		connection[2]<=connection[1];
		connection[1]<=connection[0];
	end
        
    	always@(posedge rst_n)begin//reset all to 0
		connection[13:1]<=0;
	end

		
                
	assign ran13nout = connection[1]^^connection[2]^^connection[3]^^connection[4]
			 ^^connection[5]^^connection[6]^^connection[7]^^connection[8]
                         ^^connection[9]^^connection[10]^^connection[11]^^connection[12]^^connection[13];

endmodule 


