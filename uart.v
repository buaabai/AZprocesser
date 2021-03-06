`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
`include "uart.h"

module uart(irq_rx,irq_tx,cs_,as_,rw,addr,wr_data,
	rd_data,rdy_,clk,reset,tx,rx);
	
	input cs_,as_,rw;
	input[29:0] addr;
	input[31:0] wr_data;
	input clk,reset;
	input rx;
	
	output irq_rx,irq_tx;
	output[31:0] rd_data;
	output rdy_;
	output tx;
	
	wire[7:0] rx_data,tx_data;
	
	uart_ctrl uart_ctrl(.irq_rx(irq_rx),.irq_tx(irq_tx),.cs_(cs_),
		.as_(as_),.rw(rw),.addr(addr),.wr_data(wr_data),.rd_data(rd_data),
		.rdy_(rdy_),.clk(clk),.reset(reset),.tx_start(tx_start),
		.tx_data(tx_data),.tx_busy(tx_busy),.tx_end(tx_end),.rx_busy(rx_busy),
		.rx_end(rx_end),.rx_data(rx_data));
	
	uart_tx uart_tx(.tx_start(tx_start),.tx_data(tx_data),.tx_busy(tx_busy),
		.tx_end(tx_end),.clk(clk),.reset(reset),.tx(tx));
	
	uart_rx uart_rx(.rx_busy(rx_busy),.rx_end(rx_end),.rx_data(rx_data),
		.clk(clk),.reset(reset),.rx(rx));
	
endmodule
