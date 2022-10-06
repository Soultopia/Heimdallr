//--------------------------------------------------
// File Name    : envir_rdytxn.sv
// Module Name  : envir_rdytxn
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_RDYTXN_SV
`define ENVIR_RDYTXN_SV

class envir_rdytxn extends uvm_sequence_item;

    rand envir_config::rdy_mode rdy_mode;
    rand int hi_cycle;
    rand int lw_cycle;
    rand int bp_cycle;
    rand bit bp_en;

    `uvm_object_utils_begin(envir_rdytxn)
        `uvm_field_enum(envir_config::rdy_mode, rdy_mode, UVM_ALL_ON)
        `uvm_field_int(hi_cycle , UVM_ALL_ON)
        `uvm_field_int(lw_cycle , UVM_ALL_ON)
        `uvm_field_int(bp_cycle , UVM_ALL_ON)
        `uvm_field_int(bp_en    , UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name = "envir_rdytxn");
    extern constraint mode_cons;
    extern constraint hi_cons;
    extern constraint lw_cons;
    extern constraint bp_cons;
    //extern constraint pre_randomize;
    //extern constraint post_randomize;

endclass

function envir_rdytxn::new(string name = "envir_rdytxn");
    super.new(name);
    `debug_phase("new")
endfunction

constraint envir_rdytxn::mode_cons {
    soft rdy_mode == envir_config::RDYR;
    soft bp_en == 0;
}

constraint envir_rdytxn::hi_cons {
    (rdy_mode == envir_config::RDY0) -> (hi_cycle inside {[0:100]});
    (rdy_mode == envir_config::RDY1) -> (hi_cycle inside {[0:100]});
    (rdy_mode == envir_config::RDYR) -> (hi_cycle inside {[0:100]});
}

constraint envir_rdytxn::lw_cons {
    (rdy_mode == envir_config::RDY0) -> (lw_cycle inside {[0:100]});
    (rdy_mode == envir_config::RDY1) -> (lw_cycle inside {[0:100]});
    (rdy_mode == envir_config::RDYR) -> (lw_cycle inside {[0:100]});
}

constraint envir_rdytxn::bp_cons {
    soft this.bp_cycle inside {[0:1000]};
}

`endif // ENVIR_RDYTXN_SV
