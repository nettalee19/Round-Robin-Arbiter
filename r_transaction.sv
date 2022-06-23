
class r_transaction extends uvm_sequence_item;
	//	`uvm_object_utils(r_transaction)

	rand logic [AW-1:0]addr;
	rand logic [DW-1:0] dwr ;
	rand bit [BW-1:0] be;
 	rand bit rd;
	rand bit wr;
 	bit cpu;
        logic [DW-1:0] data_bus_rd;
	//logic [31:0] drd;
	logic [1:0] ack;

	constraint c {wr != rd;}
	function new(string name = "");
		super.new(name);
	endfunction

	

	 	`uvm_object_utils_begin(r_transaction)
		  `uvm_field_int(addr, UVM_ALL_ON)
	    	  `uvm_field_int(ack, UVM_ALL_ON)
                  `uvm_field_int(wr, UVM_ALL_ON)
		  `uvm_field_int(dwr, UVM_ALL_ON)
		   `uvm_field_int(rd, UVM_ALL_ON)
		   //`uvm_field_int(drd, UVM_ALL_ON)
		    `uvm_field_int(data_bus_rd, UVM_ALL_ON)
		`uvm_field_int(cpu, UVM_ALL_ON)

  		  `uvm_field_int(be, UVM_ALL_ON)
		 	`uvm_object_utils_end

endclass
