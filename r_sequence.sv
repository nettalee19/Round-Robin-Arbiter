class r_sequence extends uvm_sequence#(r_transaction);
	`uvm_object_utils(r_sequence)

	function new(string name = "");
		super.new(name);
	endfunction

	task body();
		r_transaction r_tran;
		
		repeat(3) begin
			`uvm_do(r_tran)
/*	mem_tran = mem_transaction::type_id::create("mem_tran");

		start_item(mem_tran);
		assert(mem_tran.randomize());
		finish_item(mem_tran);*/
		end
	endtask
endclass

