class r_sequencer extends uvm_sequencer#(r_transaction);
  `uvm_component_utils(r_sequencer)

   function new(string name, uvm_component parent);
	   super.new(name);
   endfunction
  
endclass

