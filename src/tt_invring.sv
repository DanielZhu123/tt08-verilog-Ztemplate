`default_nettype none
//4 inverter rings
module tt_invring #(
	parameter integer OSC_LEN_1 = 11,//length of each inverter
        parameter integer OSC_LEN_2 = 19,
        parameter integer OSC_LEN_3 = 23,
        parameter integer OSC_LEN_4 = 29)
	
	(input wire clk,
	input wire startring,//rings oscillate,else rings stop oscillate
	output wire inverterringout);//generate random bit string

	wire [OSC_LEN_1-1:0] osc_1;//wire for connecting inverters
	wire [OSC_LEN_2-1:0] osc_2;
	wire [OSC_LEN_3-1:0] osc_3;
	wire [OSC_LEN_4-1:0] osc_4;
        logic [3:0] ringout;//collect each rings last inverters output
        logic [3:0] ringoutsam;//after sample
        logic  rannum;//bit string this system generate

	assign ringout ={osc_4[OSC_LEN_4-1],osc_3[OSC_LEN_3-1],osc_2[OSC_LEN_2-1],osc_1[OSC_LEN_1-1]};
        assign inverterringout=rannum;

	genvar i;
	generate
		//4 Oscillator
		for (i = 0; i < OSC_LEN_1; i = i + 1) begin: ringosc1
			wire y;
			if (i == 0)
				assign y = startring? osc_1[OSC_LEN_1 - 1]:0;//if start is off,the ring will not connect its head and tail
			else
				assign y = osc_1[i - 1];
			
			tt_inv inv (
				.a (y),
				.y (osc_1[i])
			);
		end

		for (i = 0; i < OSC_LEN_2; i = i + 1) begin: ringosc2
			wire y;
			if (i == 0)
				assign y = startring? osc_2[OSC_LEN_2 - 1]:0;
			else
				assign y = osc_2[i - 1];
			
			tt_inv inv (
				.a (y),
				.y (osc_2[i])
			);
		end

		for (i = 0; i < OSC_LEN_3; i = i + 1) begin: ringosc3
			wire y;
			if (i == 0)
				assign y = startring? osc_3[OSC_LEN_3 - 1]:0;
			else
				assign y = osc_3[i - 1];
			
			tt_inv inv (
				.a (y),
				.y (osc_3[i])
			);
		end

		for (i = 0; i < OSC_LEN_4; i = i + 1) begin: ringosc4
			wire y;
			if (i == 0)
				assign y = startring? osc_4[OSC_LEN_4 - 1]:0;
			else
				assign y = osc_4[i - 1];
			
			tt_inv inv (
				.a (y),
				.y (osc_4[i])
			);
		end

	endgenerate

       	always @(posedge clk)begin//sample ringout each clk cycle
        	ringoutsam[0]<=ringout[0];
		ringoutsam[1]<=ringout[1];
		ringoutsam[2]<=ringout[2];
		ringoutsam[3]<=ringout[3];
		end
        always_comb
               rannum= ringoutsam[0]^^ringoutsam[1]^^ringoutsam[2]^^ringoutsam[3];//create random number by xor
       
endmodule 



