module FIFO_Single_Clock #(parameter FIFO_DEPTH = 64) 
	(input rst,
	input clk, 
	input wr_en,
	input rd_en,
	input [7:0] buf_in,
	output reg [7:0] buf_out,
	output reg buf_empty,
	output reg buf_full,
	output reg [9:0] fifo_counter);
	
	//reg [7:0] buf_out;
	//reg buf_empty;
	//reg buf_full;
	//reg [FIFO_COUNT_MSB:0] fifo_counter;
	reg [3:0] rd_ptr;
	reg [3:0] wr_ptr;
	reg [7:0] buf_mem[FIFO_DEPTH-1:0];
	
	always @(fifo_counter) begin //Detect full or empty FIFO
		buf_empty = (fifo_counter == 0);
		buf_full = (fifo_counter == FIFO_DEPTH);
	end
	
	always @(posedge clk or posedge rst) begin //Update fifo_counter
		if (rst)
			fifo_counter <= 0;
		//else if ( (!buf_full && wr_en) && (!buf_empty && rd_en)) 
			//fifo_counter <= fifo_counter //Write same value to register??
		else if (!buf_full && wr_en)
			fifo_counter <= fifo_counter+1;
		else if (!buf_empty && rd_en)
			fifo_counter <= fifo_counter-1;
		//else
			//fifo_counter <= fifo_counter; //Write same value to register?
	end
	always @(posedge clk or posedge rst) begin //Read from FIFO (if rd_en && !buf_empty)
		if(rst) begin
			buf_out <= 0;
			rd_ptr <= 0;
		end
		else begin
			if (rd_en && !buf_empty) begin
				buf_out <= buf_mem[rd_ptr];
				rd_ptr <= rd_ptr+1;
			end
			//else begin
				//buf_out <= buf_out;
				//rd_ptr <= rd_ptr;
			//end
		end
	end
	always @(posedge clk or posedge rst) begin //Write to FIFO (if wr_en && !buf_full)
		if(rst) begin
			wr_ptr <= 0;
		end
		else begin
			if (wr_en && !buf_full) begin
				buf_mem[wr_ptr] <= buf_in;
				wr_ptr <= wr_ptr+1;
			end
			//else
				//buf_mem[wr_ptr] = buf_mem[wr_ptr];
				//wr_ptr <= wr_ptr;
		end
	end
endmodule
	