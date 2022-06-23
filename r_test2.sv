class r_test extends uvm_test;
		`uvm_component_utils(r_test)

		r_environment env;
		bit [3:0]cpu_array;
		
		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
          		env = r_environment::type_id::create("env" , this);
		endfunction

		task run_phase(uvm_phase phase);
			
			r_sequence seq[3:0];

			std::randomize(cpu_array) with {cpu_array inside {1,2,4,8};};
			foreach(cpu_array[i])
				$display("cpu_array[%d] == %b", i, cpu_array[i]);
			
			phase.raise_objection(.obj(this));
			for(int i = 0; i < 4; i++)begin
				seq[i] = r_sequence::type_id::create($sformatf("seq[%0d]", i), this);
			end
			// 4 seq
			//
			
			
	fork
		begin
	 		//seq[0] = r_sequence::type_id::create("seq[0]");
			//assert(seq[0].randomize()); 
          		assert(seq[0].randomize(cpu) with {
				cpu = cpu_array[0];
				};
			); 
          		seq[0].start(env.h_agent_expected[0].seqer);
		end

		begin
          		//seq[1] = r_sequence::type_id::create("seq[1]");
          		assert(seq[1].randomize()); 
          		seq[1].start(env.h_agent_expected[1].seqer);
		end

		begin
          		//seq[2] = r_sequence::type_id::create("seq[2]");
          		assert(seq[2].randomize()); 
          		seq[2].start(env.h_agent_expected[2].seqer);
		end

		begin
          		//seq[3] = r_sequence::type_id::create("seq[3]");
          		assert(seq[3].randomize()); 
          		seq[3].start(env.h_agent_expected[3].seqer);
		end

	join


			//seq_name.agent_name......
			phase.drop_objection(.obj(this));
		endtask
endclass
