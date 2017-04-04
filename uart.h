ifndef __UART_HEADER__
	`define __UART_HEADER__
	
	`define UART_DIV_RATE 260
	`define UART_DIV_CNT_W 9
	`define UartDivCntBus 8:0
	`define UartAddrBus 0:0
	`define UART_ADDR_W 1
	`define UartAddrLoc 0:0
	`define UART_ADDR_STATUS 1'h0
	`define UART_ADDR_DATA 1'h1
	`define UartCtrlIrqRx 0
	`define UartCtrlIrqTx 1
	`define UartCtrlBusyRx 2
	`define UartCtrlBusyTx 3
	`define UartStateBus 0:0
	`define UART_STATE_IDLE 1'b0
	`define UART_STATE_TX 1'b1
	`define UART_STATE_RX 1'b1
	`define UartBitCntBus 3:0
	`define UART_BIT_CNT_W 4
	`define UART_BIT_CNT_START 4'h0
	`define UART_BIT_CNT_MSB 4'h8
	`define UART_BIT_CNT_STOP 4'h9
	`define UART_START_BIT 1'b0
	`define UART_STOP_BIT 1'b1
`endif