`default_nettype none


module tt_um_ran_DanielZhu (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


  assign ui_in[0] =startring ; 
  assign ui_in[1] =pulse; 
  assign ui_in[2] =sample ; 
  assign ui_in[3] =diplaychoose ; 
  assign uo_[7:4]= 4'b0000;
  assign uio_out = 0;
  assign uio_oe  = 8'b11111111;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};



        logic startring;
        logic pulse;
	logic sample;
        logic diplaychoose;
	logic [13:0] displaypin;



logic inverterringout;
logic ranprocessout;
logic ran16out;
logic ranbitstring;
logic [3:0] samplednum;



tt_invring tt_invring(
		.clk(clk),
		.startring(startring),
                .inverterringout(inverterringout)


);
tt_process tt_process(
		.clk(clk),
		.rst_n(rst_n),
                .num(inverterringout),
		.ranprocessout(ranprocessout)


);
tt_16bitran tt_16bitran(
		.clk(clk),
		.rst_n(rst_n),
                .ran16out(ran16out)


);

always@(*)
ranbitstring = ran16out^ranprocessout;

tt_samplekey tt_samplekey(
	.clk(clk),
	.sample(sample),
	.num(ranbitstring),
	.samplednum(samplednum));

tt_finalprocess tt_finalprocess(
.pulse(pulse),
.switchAB(diplaychoose),
.key_4(samplednum),
.disppinout(displaypin));




endmodule 




