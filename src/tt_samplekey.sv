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

