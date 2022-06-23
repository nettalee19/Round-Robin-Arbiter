class s_driver extends uvm_driver#(r_transaction);
   `uvm_component_utils(s_driver)

   virtual s_interface sinf;
   bit [31:0] rpt;
   bit time_out;
   bit [15:0] timeout_limit = ({16{1'b1}} -1) ;

   function new(string name, uvm_component parent);
	   super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
	   super.build_phase(phase);
      	   uvm_config_db#(virtual s_interface)::get(this , "" , "s_interface", sinf);
endfunction

   task run_phase(uvm_phase phase);
	  
	   wait(!sinf.reset_n);
	   wait(sinf.reset_n);

	   drive();
   endtask

   virtual task drive();
       
     forever
    	 begin
	 //@(sinf.rd_bus == 1 || sinf.wr_bus == 1) //begin
	    
	 	time_out = 0; //flag
	 	rpt = $urandom_range(10,1); // rpt = timeout_limit+1;
 	  
	 	if(rpt > timeout_limit) 
			time_out=1;
     	  	
		repeat (rpt)   
		@(posedge sinf.clk);
	   
  		if(sinf.rd_bus & time_out == 0)begin
	        	sinf.data_bus_rd =$random;
               		sinf.ack_bus = 1'b1;
	       		`uvm_info("drv_ss" , $sformatf(" %d --------time_out    %d --------rpt   %h------ addres" , time_out , rpt , sinf.add_bus) , UVM_MEDIUM)
     	     	end

             	else if(sinf.wr_bus & time_out == 0)
	        	sinf.ack_bus = 1'b1;

       	 
     		@(posedge sinf.clk);
	      		sinf.ack_bus = 1'b0;

           end
    //end
   endtask
endclass
