`include "uvm_macros.svh"

interface h_interface # (
	parameter AW = 32,
	parameter DW = 32,
	parameter BW = 4,
	parameter TW = 16)(input logic clk , reset_n );
	logic [AW-1:0] addr;
	bit cpu , rd ,wr ;
	bit [1:0]	 ack;

	logic [BW-1:0] be ;
	logic [DW-1:0] dwr , drd;

	

endinterface

	/*	logic [31:0] addr;
	bit cpu , rd ,wr , ack;
	logic [3:0] be ;
	logic dwr , drd;
*/

