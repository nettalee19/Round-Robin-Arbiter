package r_pkg;

	parameter AW = 32;
	parameter DW = 32;
	parameter BW = 4;
	parameter TW = 16;
	parameter SIZE = 4;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "r_transaction.sv"
	`include "r_sequence.sv"
	`include "r_sequencer.sv"
	`include "s_monitor.sv"
	`include "h_monitor.sv"
	`include "r_driver.sv"
	`include "s_driver.sv"

	`include "s_agent.sv"
	`include "h_agent.sv"
	`include "r_scoreboard.sv"
	`include "r_config.sv"
	`include "r_environment.sv"
	`include "r_test.sv"
endpackage
