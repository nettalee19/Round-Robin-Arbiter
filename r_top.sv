`include "r_pkg.sv"
`include "arbiter.v"
`include "h_interface.sv"
`include "s_interface.sv"


module r_top;
   import uvm_pkg::*;
   import r_pkg::*;
    
  bit clk;
  bit reset_n;

  
	h_interface hinf[SIZE] (clk , reset_n);
	s_interface sinf (clk , reset_n);


    //Connects the Interface to the DUT
     //Variable initializationGRE
   initial begin
	 clk <= 1'b0;
         reset_n <= 1'b0;
	
   end

   //Clock generation
   always
     #5 clk = ~clk;


   //Reset generation
   initial begin  
     #30 reset_n = 1'b1;
     
     hinf[2].cpu = 1;
   end

 arbiter DUT(
	 .mcpu  (hinf[0].cpu),
	 .maddr (hinf[0].addr),
	 .mrd   (hinf[0].rd),
	 .mwr   (hinf[0].wr),
	 .mdwr  (hinf[0].dwr),
	 .mbe   (hinf[0].be),
	 .mdrd  (hinf[0].drd),
	 .mack  (hinf[0].ack),


	 .cpu_bus	(sinf.cpu_out),
	 .add_bus	(sinf.add_bus),
	 .wr_bus	(sinf.wr_bus),
	 .rd_bus	(sinf.rd_bus),
	 .byte_en	(sinf.byte_en),
	 .data_bus_rd	(sinf.data_bus_rd),
	 .data_bus_wr	(sinf.data_bus_wr),
	 .ack_bus	 (sinf.ack_bus),

	 //4 interfece

   .scpu	(hinf[1].cpu),
   .saddr	(hinf[1].addr),
   .srd		(hinf[1].rd),
   .swr		(hinf[1].wr),
   .sbe		(hinf[1].be),
   .sdwr	(hinf[1].dwr),
   .sdrd	(hinf[1].drd),
   .sack	(hinf[1].ack),
   // Test Host
   .tcpu	(hinf[2].cpu),
   .taddr	(hinf[2].addr),
   .trd		(hinf[2].rd),
   .twr		(hinf[2].wr),
   .tbe		(hinf[2].be),
   .tdwr	(hinf[2].dwr),
   .tdrd	(hinf[2].drd),
   .tack	(hinf[2].ack),

    // Extra Host
   .ecpu	(hinf[3].cpu),
   .eaddr	(hinf[3].addr),
   .erd		(hinf[3].rd),
   .ewr		(hinf[3].wr),
   .ebe		(hinf[3].be),
   .edwr	(hinf[3].dwr),
   .edrd	(hinf[3].drd),
   .eack	(hinf[3].ack),


  
	  .clk		(clk),
          .reset_n	(reset_n)

 );


bit [SIZE-1:0]array;

   initial begin
	   //Registers the Interface in the configuration block so that other
	   //blocks can use it
     	uvm_config_db#(virtual s_interface)::set(null, "*" , "s_interface", sinf);
	uvm_config_db#(virtual h_interface)::set(null, "uvm_test_top.env.h_agent_expected[0]*" , "h_interface", hinf[0]);
	uvm_config_db#(virtual h_interface)::set(null, "uvm_test_top.env.h_agent_expected[1]*" , "h_interface", hinf[1]);
	uvm_config_db#(virtual h_interface)::set(null, "uvm_test_top.env.h_agent_expected[2]*"  , "h_interface", hinf[2]);
	uvm_config_db#(virtual h_interface)::set(null, "uvm_test_top.env.h_agent_expected[3]*"  , "h_interface", hinf[3]);

       	


 //Executes the test
      run_test("r_test");

      end


     initial begin
	      forever begin
		      @(sinf.ack_bus || hinf[1].ack[1]) //if the slace returns acl or if timeout
		      @(posedge clk)
		      @(posedge clk)


		        $display("------: [%0d]---------", hinf[0].ack[0]);
			$display("------: [%0d]---------", hinf[1].ack[0]);
			$display("------: [%0d]---------", hinf[2].ack[0]);
			$display("------: [%0d]---------", hinf[3].ack[0]);


	      end 
      end


     

      //after tun test
      property ack_0; //checks we got only one ack
	    //@(posedge clk)
	    	(sinf.ack_bus or hinf[1].ack[1]) ##2 $onehot({hinf[0].ack[0], hinf[1].ack[0], hinf[2].ack[0], hinf[3].ack[0]}); //&& (reset_n)) 
      endproperty

      assert property(ack_0);

      property is_timeout; //timeout - only 
	      @(posedge clk) ($countones({hinf[0].ack[1], hinf[1].ack[1], hinf[2].ack[1], hinf[3].ack[1]}) == 0 || $countones({hinf[0].ack[1], hinf[1].ack[1], hinf[2].ack[1], hinf[3].ack[1]}) == SIZE);
      endproperty

      assert property(is_timeout);





     
   //end

endmodule // mem_top


