class r_environment extends uvm_env;
     `uvm_component_utils(r_environment)

     s_agent   s_agent_actual;
     
     h_agent h_agent_expected[]; //dynamic array

     r_scoreboard     scb;

     function new(string name, uvm_component parent);
	
	     super.new(name, parent);

     endfunction

     function void build_phase(uvm_phase phase);
	super.build_phase(phase);
        s_agent_actual     = s_agent::type_id::create("s_agent_actual" , this);
       
        h_agent_expected = new[SIZE];

        for(int i= 0; i < SIZE ; i++) 
	       h_agent_expected[i] = h_agent::type_id::create($sformatf("h_agent_expected[%0d]", i), this);

        scb	           = r_scoreboard::type_id::create("scb" , this);
	
     endfunction

     function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
     	s_agent_actual.agent_ap_actual.connect(scb.scb_export_actual);

	for(int i= 0; i < SIZE ; i++) 
	              	h_agent_expected[i].agent_ap_expected.connect(scb.scb_export_expected);

      endfunction
endclass
