
//`uvm_analysis_imp_decl(_actual)
//`uvm_analysis_imp_decl(_expected)

class r_scoreboard extends uvm_scoreboard;
     `uvm_component_utils(r_scoreboard)

     uvm_analysis_export #(r_transaction) scb_export_actual;
     uvm_analysis_export #(r_transaction) scb_export_expected;

     uvm_tlm_analysis_fifo #(r_transaction) actual_fifo;
     uvm_tlm_analysis_fifo #(r_transaction) expected_fifo;

     r_transaction transaction_s;
     r_transaction transaction_h;

     function new(string name, uvm_component parent);
	super.new(name, parent);
   	transaction_s  = new("transaction_s");
   	transaction_h  = new("transaction_h");
     endfunction

     function void build_phase(uvm_phase phase);
	super.build_phase(phase);
       	scb_export_actual   = new("scb_export_actual", this);
   	scb_export_expected = new("scb_export_expected", this);
       	actual_fifo	    = new("actual_fifo", this);
   	expected_fifo	    = new("expected_fifo", this);
     endfunction

     function void connect_phase(uvm_phase phase);
       	scb_export_actual.connect(actual_fifo.analysis_export);
   	scb_export_expected.connect(expected_fifo.analysis_export);
     endfunction

     task run();
	forever begin
             actual_fifo.get(transaction_s);
             expected_fifo.get(transaction_h);
    	     compare();
	end
     endtask

     virtual function void compare();
     if(transaction_h.wr) begin
            if (transaction_s.addr == transaction_h.addr &
	        transaction_s.rd == transaction_h.rd &
	  	transaction_s.wr == transaction_h.wr &
          	transaction_s.dwr == transaction_h.dwr &
		transaction_s.be == transaction_h.be &
		transaction_s.cpu == transaction_h.cpu &
       		transaction_s.ack[0] == transaction_h.ack[0]&
       		transaction_s.ack[1] == transaction_h.ack[1]	) begin

      
	     `uvm_info("compare", {"Test_wr: OK!"}, UVM_LOW);
	     $display("addres h %d  " , transaction_h.addr , "addres s  %d " ,transaction_s.addr);
     end
     else begin
	     `uvm_error("compare", {"Test_wr: Fail!"});
	  $display("addres h :f %d  " , transaction_h.addr , "addres s :f  %d " ,transaction_s.addr);
	end
    end

     else  if (transaction_s.addr == transaction_h.addr &
	        transaction_s.rd == transaction_h.rd &
	  	transaction_s.wr == transaction_h.wr &
          	transaction_s.dwr == transaction_h.dwr &
		transaction_s.be == transaction_h.be &
		transaction_s.cpu == transaction_h.cpu &
       		transaction_s.ack[0] == transaction_h.ack[0]&
       		transaction_s.ack[1] == transaction_h.ack[1]) begin


	     if(transaction_s.data_bus_rd == transaction_h.data_bus_rd)begin
         
	     `uvm_info("compare", {"Test_rd: OK!"}, UVM_LOW);
	       $display(" h drd %d  " , transaction_h.data_bus_rd , "data bus rd  s  %d " ,transaction_s.data_bus_rd);

     end
     else begin
	     `uvm_error("compare", {"Test_rd: Fail!"}); 
	     
	       $display(" h drd %d  " , transaction_h.data_bus_rd , "data bus rd  s  %d " ,transaction_s.data_bus_rd);


	       end



end
     endfunction

endclass
