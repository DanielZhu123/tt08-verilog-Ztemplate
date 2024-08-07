`default_nettype none
//16unit MLS
module tt_16bitran #(
	parameter integer count = 16

)
(
        input wire clk,
        input wire rst_n,
	output wire ran16out
);

	logic [count:0] connection;//connect all filpflop
        assign ran16out =connection[0];


	always@(posedge clk)begin//pass down bit each clk 
		connection[16]<=connection[15];
		connection[15]<=connection[14];
		connection[14]<=connection[13];
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
        
    	always@(posedge rst_n)begin//reset all to 0000_0000_0000_0001
		connection[16:1]<=16'b1;
	end

        assign connection[0] = connection[4]^^connection[13]^^connection[15]^^connection[16];

	
endmodule 


