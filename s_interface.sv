`include "uvm_macros.svh"

interface s_interface # (
	parameter AW = 32,
	parameter DW = 32,
	parameter BW = 4,
	parameter TW = 16)(input logic clk , reset_n );
	logic [AW-1:0] add_bus;
	bit  ack_bus;
	bit cpu_out , rd_bus	,wr_bus ;
	logic [BW-1:0] byte_en ;
	logic [DW-1:0]data_bus_wr , data_bus_rd;

	

endinterface


