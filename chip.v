`include "global_config.h"
`include "stddef.h"
`include "nettype.h"

module chip(reset,clk,clk_,uart_tx,uart_rx,gpio_in,gpio_out,gpio_io);
	input reset,clk,clk_;
	input uart_rx;
	output uart_tx;
	input[3:0] gpio_in;
	output[17:0] gpio_out;
	inout[15:0] gpio_io;
	
	wire irq_uart_rx,irq_uart_tx,irq_timer;
	wire[4:0] cpu_irq = {{5{`DISABLE}},irq_uart_rx,irq_uart_tx,irq_timer};
	cpu cpu(.reset(reset),.clk(clk),.clk_(clk_),.cpu_irq(cpu_irq),.if_bus_rd_data(m_rd_data),
		.if_bus_rdy_(m_rdy_),.if_bus_req_(m0_req_),.if_bus_addr(m0_addr),.if_bus_as_(m0_as_),
		.if_bus_rw(m0_rw),.if_bus_wr_data(m0_wr_data),.if_bus_grnt_(m0_grnt_),
		.mem_bus_rd_data(m_rd_data),.mem_bus_rdy_(m_rdy_),.mem_bus_req_(m1_req_),.mem_bus_addr(m1_addr),
		.mem_bus_as_(m1_as_),.mem_bus_rw(m1_rw),.mem_bus_wr_data(m1_wr_data),.mem_bus_grnt_(m1_grnt_));
	
	wire m2_req_ = `DISABLE_;
	wire m3_req_ = `DISABLE_;
	wire[29:0] m2_addr = `WORD_ADDR_W'h0;
	wire[29:0] m3_addr = `WORD_ADDR_W'h0;
	wire m2_as_ = `DISABLE_;
	wire m3_as_ = `DISABLE_;
	wire m2_rw = `READ;
	wire m3_rw = `READ;
	wire[29:0] m2_wr_data = `WORD_DATA_W'h0;
	wire[29:0] m3_wr_data = `WORD_DATA_W'h0;
	wire[31:0] s5_rd_data = `WORD_DATA_W'h0;
	wire[31:0] s6_rd_data = `WORD_DATA_W'h0;
	wire[31:0] s7_rd_data = `WORD_DATA_W'h0;
	wire s5_rdy_ = `DISABLE_;
	wire s6_rdy_ = `DISABLE_;
	wire s7_rdy_ = `DISABLE_;
	
	bus bus(.m_rd_data(m_rd_data),.m_rdy_(m_rdy_),.m0_req_(m0_req_),.m0_addr(m0_addr),.m0_as_(m0_as_),
		.m0_rw(m0_rw),.m0_wr_data(m0_wr_data),.m0_grnt_(m0_grnt_),.m1_req_(m1_req_),.m1_addr(m1_addr),
		.m1_as_(m1_as_),.m1_rw(m1_rw),.m1_wr_data(m1_wr_data),.m1_grnt_(m1_grnt_),.m2_req_(m2_req_),
		.m3_req_(m3_req_),.m2_addr(m2_addr),.m3_addr(m3_addr),.m2_as_(m2_as_),.m3_as_(m3_as_),
		.m2_rw(m2_rw),.m3_rw(m3_rw),.m2_wr_data(m2_wr_data),.m3_wr_data(m3_wr_data),
		.s_as_(s_as_),.s_rw(s_rw),.s_addr(s_addr),.s_wr_data(s_wr_data),.s0_rd_data(s0_rd_data),
		.s0_rdy_(s0_rdy_),.s0_cs_(s0_cs_),.s2_rd_data(s2_rd_data),.s2_rdy_(s2_rdy_),.s2_cs_(s2_cs_),
		.s3_rd_data(s3_rd_data),.s3_rdy_(s3_rdy_),.s3_cs_(s3_cs_),.s4_rd_data(s4_rd_data),
		.s4_rdy_(s4_rdy_),.s4_cs_(s4_cs_),.s5_rd_data(s5_rd_data),.s6_rd_data(s6_rd_data),
		.s7_rd_data(s7_rd_data),.s5_rdy_(s5_rdy_),.s6_rdy_(s6_rdy_),.s7_rdy_(s7_rdy_));
	
	rom rom(.rd_data(s0_rd_data),.rdy_(s0_rdy_),.cs_(s0_cs_),.reset(reset),.clk(clk),.as_(s_as_),
		.addr(s_addr));
	
	timer timer(.rd_data(s2_rd_data),.rdy_(s2_rdy_),.cs_(s2_cs_),.reset(reset),.clk(clk),.as_(s_as_),
		.rw(s_rw),.addr(s_addr),.wr_data(s_wr_data),.irq(irq_timer));
		
	uart uart(.rd_data(s3_rd_data),.rdy_(s3_rdy_),.cs_(s3_cs_),.reset(reset),.clk(clk),.as_(s_as_),
		.rw(s_rw),.addr(s_addr),.wr_data(s_wr_data),.irq_tx(irq_uart_tx),.irq_rx(irq_uart_rx),
		.uart_tx(uart_tx),.uart_rx(uart_rx));
	
	gpio gpio(.rd_data(s4_rd_data),.rdy_(s4_rdy_),.cs_(s4_cs_),.reset(reset),.clk(clk),.as_(s_as_),
		.rw(s_rw),.addr(s_addr),.wr_data(s_wr_data),.gpio_in(gpio_in),.gpio_out(gpio_out),
		.gpio_io(gpio_io));
		
endmodule