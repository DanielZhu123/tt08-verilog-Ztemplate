`default_nettype none
//for LED display
module tt_display(
        input wire [3:0] number1,
        input wire [3:0] number2,
	output wire [13:0] displaypin
);

	logic [6:0] nub1dis;
	logic [6:0] nub2dis;
        assign displaypin={nub2dis,nub1dis};
	always_comb begin     
	case(number1)
		4'h0:nub1dis[6:0]=7'b0000001;
        	4'h1:nub1dis[6:0]=7'b0110000;
        	4'h2:nub1dis[6:0]=7'b1101101;
        	4'h3:nub1dis[6:0]=7'b1111001;
        	4'h4:nub1dis[6:0]=7'b0110011;
        	4'h5:nub1dis[6:0]=7'b1011011;
        	4'h6:nub1dis[6:0]=7'b1011111;
        	4'h7:nub1dis[6:0]=7'b1110000; 
        	4'h8:nub1dis[6:0]=7'b1111111;
        	4'h9:nub1dis[6:0]=7'b1111011;
        	4'ha:nub1dis[6:0]=7'b1110111;
        	4'hb:nub1dis[6:0]=7'b0011111;
        	4'hc:nub1dis[6:0]=7'b1001110;     
        	4'hd:nub1dis[6:0]=7'b0111101;
        	4'he:nub1dis[6:0]=7'b1001111;
        	4'hf:nub1dis[6:0]=7'b1000111;             
        	default:nub1dis[6:0]=7'b0000000;
       endcase
	case(number2)
		4'h0:nub2dis[6:0]=7'b0000001;
        	4'h1:nub2dis[6:0]=7'b0110000;
        	4'h2:nub2dis[6:0]=7'b1101101;
        	4'h3:nub2dis[6:0]=7'b1111001;
        	4'h4:nub2dis[6:0]=7'b0110011;
        	4'h5:nub2dis[6:0]=7'b1011011;
        	4'h6:nub2dis[6:0]=7'b1011111;
        	4'h7:nub2dis[6:0]=7'b1110000; 
        	4'h8:nub2dis[6:0]=7'b1111111;
        	4'h9:nub2dis[6:0]=7'b1111011;
        	4'ha:nub2dis[6:0]=7'b1110111;
        	4'hb:nub2dis[6:0]=7'b0011111;
        	4'hc:nub2dis[6:0]=7'b1001110;     
        	4'hd:nub2dis[6:0]=7'b0111101;
        	4'he:nub2dis[6:0]=7'b1001111;
        	4'hf:nub2dis[6:0]=7'b1000111;             
        	default:nub2dis[6:0]=7'b0000000;
       endcase
	end
endmodule


