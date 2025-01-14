`timescale 1ns/1ps
module test_bench;
	reg clk;
	reg rst_n;
	reg start;
	reg miso;
	reg [7:0] data_in;
	wire mosi;
	wire sck;
	wire cs;
	wire [7:0] data_out;
	wire done;

reg [7:0] exp_data;

	master dut(
		.clk(clk),
		.rst_n(rst_n),
		.start(start),
		.miso(miso),
		.data_in(data_in),
		.mosi(mosi),
		.sck(sck),
		.cs(cs),
		.data_out(data_out),
		.done(done)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	task verify;
		input [7:0] sent_data;
		input [7:0] received_data;
		begin
			$display("At time: %t, rst_n = 1'b%b, start = 1'b%b", $time, rst_n, start);
			if( sent_data == received_data) begin
				$display("---------------------------------------------------------------------------------------------------------------");
				$display("PASSED: Sent data: 8'h%h, Received_data: 8'h%h",sent_data, received_data);
				$display("---------------------------------------------------------------------------------------------------------------");
			end else begin
				$display("---------------------------------------------------------------------------------------------------------------");
				$display("FAILED: Sent data: 8'h%h, Received_data: 8'h%h",sent_data, received_data);
				$display("---------------------------------------------------------------------------------------------------------------");
			end
		end
	endtask

	initial begin
		$dumpfile("test_bench.vcd");
		$dumpvars(0, test_bench);
		
		$display("------------------------------------------------------------------------------------------------------------------");	
		$display("----------------------------TESTBENCH FOR SPI MASTER--------------------------------------------------------------");
		$display("------------------------------------------------------------------------------------------------------------------");	

		rst_n = 0;
		start = 0;
		miso = 0;
		data_in = 0;
		@(posedge clk);
		verify(8'h00, 8'h00);

		rst_n = 1;
		@(posedge clk);
		data_in = 8'hf0;
		exp_data = data_in;
		start = 1;
		@(posedge clk);
		start = 0;
		wait(done);
		@(posedge clk);
		verify(exp_data, data_out);

		data_in = 8'h55;
		exp_data = data_in;
		start = 1;
		@(posedge clk);
		start = 0;
		wait(done);
		@(posedge clk);
		verify(exp_data, data_out);

		data_in = 8'haa;
		exp_data = 8'h00;
		@(posedge clk);
		verify(exp_data, data_out);
		
		data_in = 8'h78;
		exp_data = data_in;
		start = 1;
		@(posedge clk);
		start = 0;
		wait(done);
		@(posedge clk);
		verify(exp_data, data_out);
		
		data_in = 8'h33;
		exp_data = data_in;
		start = 1;
		@(posedge clk);
		start = 0;
		wait(done);
		@(posedge clk);
		verify(exp_data, data_out);

		#200;
		$finish;
		
	end

	// Simulate miso data
	always @(posedge dut.sck) begin
    		if (!dut.cs) begin
        	miso <= dut.mosi; // Echo mosi back to miso for test
   	end
end
endmodule

