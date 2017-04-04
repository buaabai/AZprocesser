`define NEGATIVE_RESET
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "uart.h"
`timescale 1ns/1ns

module uart_ctrl(clk,reset,cs_,as_,rw,addr,wr_data,
	rd_data,rdy_,irq_rx,irq_tx,rx_busy,rx_end,rx_data,
	tx_busy,tx_end,tx_start,tx_data);
	
	input clk,reset;
	input cs_,as_;
	input rw;
	input addr;
	input[31:0] wr_data;
	
	input rx_busy;
	input rx_end;
	input[7:0] rx_data;
	input tx_busy;
	input tx_end;
	
	output[31:0] rd_data;
	output rdy_;
	output irq_rx,irq_tx;
	output tx_start;
	output[7:0] tx_data;
	
	reg[31:0] rd_data;
	reg irq_rx,irq_tx;
	reg tx_start;
	reg[7:0] tx_data;
	reg rdy_;
	
	reg[7:0] rx_buf;
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			rd_data <= #1 `WORD_DATA_W'h0;
			rdy_ <= #1 `DISABLE_;
			irq_rx <= #1 `DISABLE;
			irq_tx <= #1 `DISABLE;
			rx_buf <= #1 `BYTE_DATA_W'h0;
			tx_start <= #1 `DISABLE;
			tx_data <= #1 `BYTE_DATA_W'h0;
		end
		else
		begin
			if((cs_ == `ENABLE_) && (as_ == `ENABLE_))
			begin
				rdy_ <= #1 `ENABLE_;
			end
			else
			begin
				rdy_ <= #1 `DISABLE_;
			end
			
			if((cs_ == `ENABLE_) && (as_ == `ENABLE_)
			 && (rw == `READ))
			begin
				case(addr)
					`UART_ADDR_STATUS:
					begin
						rd_data <= #1 {{`WORD_DATA_W-4{1'b0}},
							tx_busy,rx_busy,irq_tx,irq_rx};
					end
					`UART_ADDR_DATA:
					begin
						rd_data <= #1 {{`BYTE_DATA_W*3{1'b0}},rx_buf};
					end
				endcase
			end
			else
			begin
				rd_data <= #1 `WORD_DATA_W'h0;
			end
			
			if(tx_end == `ENABLE)
			begin
				irq_rx <= #1 `ENABLE;
			end
			else if((cs_ == `ENABLE_) && (as_ == `ENABLE_)
				&& (rw == `WRITE) && (addr == `UART_ADDR_STATUS))
			begin
				irq_tx <= #1 wr_data[`UartCtrlIrqTx];
			end
			
			if(rx_end == `ENABLE)
			begin
				irq_rx <= #1 `ENABLE;
			end
			else if((cs_ == `ENABLE_) && (as_ == `ENABLE_)
				&& (rw == `WRITE) && (addr == `UART_ADDR_STATUS))
			begin
				irq_rx <= #1 wr_data[`UartCtrlIrqRx];
			end
			
			if((cs_ == `ENABLE_) && (as_ == `ENABLE_)
				&& (rw == `WRITE) && (addr == `UART_ADDR_DATA))
			begin
				tx_start <= #1 `ENABLE;
				tx_data <= #1 wr_data[`BYTE_MSB : `LSB];
			end
			else
			begin
				tx_start <= #1 `DISABLE;
				tx_data <= #1 `BYTE_DATA_W'h0;
			end
			
			if(rx_end == `ENABLE)
			begin
				rx_buf <= #1 rx_data;
			end
			
		end
	end

endmodule