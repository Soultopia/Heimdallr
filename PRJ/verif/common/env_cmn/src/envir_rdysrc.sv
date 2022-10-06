//--------------------------------------------------
// File Name    : envir_rdysrc.sv
// Module Name  : envir_rdysrc
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_RDYSRC_SV
`define ENVIR_RDYSRC_SV

class envir_rdysrc extends uvm_component;

    `uvm_component_utils(envir_rdysrc)

    envir_ready_cfg cfg;

    uvm_blocking_get_imp#(uvm_sequence_item, envir_rdysrc) get_imp;

    extern         function      new(string name = "envir_rdysrc", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task          get(output uvm_sequence_item tr);

endclass

function envir_rdysrc::new(string name = "envir_rdysrc", uvm_component parent);
    super.new(name, parent);
    `debug_phase("new")
endfunction

function void envir_rdysrc::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(this.cfg == null) begin
        this.cfg = envir_ready_cfg::type_id::create("ready_cfg");
        this.cfg.randomize();
    end
    this.get_imp = new("get_imp", this);
    `debug_phase("build_phase")
endfunction

task envir_rdysrc::get(output uvm_sequence_item tr);
    envir_rdytxn rdy_tr;
    rdy_tr = envir_rdytxn::type_id::create("rdy_tr", this);
    if(!rdy_tr.randomize() with {rdy_tr.rdy_mode == envir_config::RDYR;}) 
        `uvm_error(get_name(), "Failed to randomize configration !!!")
    case(this.cfg.rdy_mode)
        envir_config::RDY0: rdy_tr.hi_cycle = 0;
        envir_config::RDY1: rdy_tr.lw_cycle = 1;
    endcase
    tr = rdy_tr;
endtask

`endif // ENVIR_RDYSRC_SV
