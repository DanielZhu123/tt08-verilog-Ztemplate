`timescale 1ns / 1ps
`default_nettype none
module tt_samplekey
(
        input wire clk,
        input wire sample,
        input wire num,
	output wire [3:0] samplednum
);


	logic [3:0] bitsadjacent;
	logic [3:0] sample_4;

        
	assign samplednum=sample_4;


        always @(posedge clk)begin
		bitsadjacent[0]<=num;
                bitsadjacent[1]<=bitsadjacent[0];
		bitsadjacent[2]<=bitsadjacent[1];
		bitsadjacent[3]<=bitsadjacent[2];
        end

	always @(posedge sample)begin
		sample_4<={bitsadjacent[3],bitsadjacent[2],bitsadjacent[1],bitsadjacent[0]};
 	end


endmodule 


module tt_samplekey_tb;
logic  [3:0] samplednum_out;
logic clk_in;
logic num_in;
logic sample_in;


tt_samplekey tt_samplekey(
.samplednum(samplednum_out),
.clk(clk_in),
.num(num_in),
.sample(sample_in)
);
initial begin
     clk_in=0;num_in=0;sample_in=0;


#1000 $stop;
end
always #10 clk_in=~clk_in;
always #30 num_in=~num_in;
always #100 sample_in=~sample_in;



endmodule