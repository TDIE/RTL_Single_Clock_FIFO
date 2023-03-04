//'timescale 10ns/1ns

module FIFO_Single_Clock_tb;

	reg rst, clk, wr_en, rd_en;
	reg [7:0] buf_in;
	wire [7:0] buf_out;
	wire buf_empty, buf_full; 
	wire [9:0] fifo_counter;


	FIFO_Single_Clock fifo_sc(
		.rst(rst),
		.clk(clk),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.buf_in(buf_in),
		.buf_out(buf_out),
		.buf_empty(buf_empty),
		.buf_full(buf_full),
		.fifo_counter(fifo_counter));
				 
	//clk generation
	always #10 clk = ~clk;
	
	integer i;

	initial begin
	
		$monitor("time = %d \t rst = %b \t clk = %b \t wr_en = %b \t rd_en = %b \t buf_in = %b \t buf_out = %b \t buf_empty= %b \t buf_full= %b \t fifo_counter = %b \t", $time, rst, clk, wr_en, rd_en, buf_in, buf_out, buf_empty, buf_full, fifo_counter);
	
		clk = 1;
		rst = 0;
		wr_en = 0;
		rd_en = 0;
		buf_in = 8'h00;

		//Reset
		#5 rst = 1;
		#25 rst = 0; 

		//Single write, single read (test buf_empty)
		#5 wr_en = 1;
	   	   buf_in = 8'hFF;
		#15 wr_en = 0;
		#10 rd_en = 1;
		#10 rd_en = 0; 

		//Fill FIFO (test buf_full, fifo_counter)
		for(i=0; i<65; i=i+1) begin
			#10 wr_en = 1;
		    	    buf_in = $random;
			#10 wr_en = 0;
		    	//rd_en = 1;
			//#20 rd_en = 0; 
		end
	
		#10 $stop;
	end
	
endmodule