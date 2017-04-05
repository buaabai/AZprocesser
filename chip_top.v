module chip_top(clk_ref,reset_sw,uart_tx,uart_rx,gpio_in,gpio_out,gpio_io);
	input clk_ref,reset_sw;
	input uart_rx;
	output uart_tx;
	input[3:0] gpio_in;
	output[17:0] gpio_out;
	inout[15:0] gpio_io;
	
	clk_gen clk_gen(.clk_ref(clk_ref),.reset_sw(reset_sw),.clk(clk),.clk_(clk_),.chip_reset(chip_reset));
	
	chip chip(.clk(clk),.clk_(clk_),.reset(chip_reset),.uart_rx(uart_rx),.uart_tx(uart_tx),.gpio_in(gpio_in),
		.gpio_io(gpio_io),.gpio_out(gpio_out));
		
endmodule