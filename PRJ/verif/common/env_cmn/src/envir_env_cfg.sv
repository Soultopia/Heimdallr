//--------------------------------------------------
// File Name    : envir_env_cfg.sv
// Module Name  : envir_env_cfg
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-07-10  Sunday  AM 10:14:42
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_ENV_CFG_SV
`define ENVIR_ENV_CFG_SV

class envir_env_cfg extends uvm_sequence_item;

    // agtcfg
    rand int envir_roi_en = 1;
    rand envir_roi_cfg envir_roi_cfg;
    rand int envir_seq_en = 1;
    rand envir_seq_cfg envir_seq_cfg;
    rand int envir_ime_en = 1;
    rand envir_ime_cfg envir_ime_cfg;
    rand int envir_scb_en = 1;
    rand envir_scb_cfg envir_scb_cfg;
    rand int envir_rml_en = 1;
    rand envir_rml_cfg envir_rml_cfg;

    `uvm_object_utils_begin(envir_env_cfg)
        // agtdef
        `uvm_field_int(envir_roi_en, UVM_ALL_ON)
        `uvm_field_object(envir_roi_cfg, UVM_ALL_ON)
        `uvm_field_int(envir_seq_en, UVM_ALL_ON)
        `uvm_field_object(envir_seq_cfg, UVM_ALL_ON)
        `uvm_field_int(envir_ime_en, UVM_ALL_ON)
        `uvm_field_object(envir_ime_cfg, UVM_ALL_ON)
        `uvm_field_int(envir_scb_en, UVM_ALL_ON)
        `uvm_field_object(envir_scb_cfg, UVM_ALL_ON)
        `uvm_field_int(envir_rml_en, UVM_ALL_ON)
        `uvm_field_object(envir_rml_cfg, UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "envir_env_cfg");
    extern function void pre_randomize;
    extern constraint cons;
    extern function void post_randomize;

endclass

function envir_env_cfg::new(string name = "envir_env_cfg");
    super.new(name);
    // agtnew
    if(this.envir_roi_en == 1) envir_roi_cfg::type_id::create("envir_roi_cfg");
    if(this.envir_seq_en == 1) envir_seq_cfg::type_id::create("envir_seq_cfg");
    if(this.envir_ime_en == 1) envir_ime_cfg::type_id::create("envir_ime_cfg");
    if(this.envir_scb_en == 1) envir_scb_cfg::type_id::create("envir_scb_cfg");
    if(this.envir_rml_en == 1) envir_rml_cfg::type_id::create("envir_rml_cfg");
    `debug_phase("new")
endfunction

function void envir_env_cfg::pre_randomize();
    super.pre_randomize();
endfunction

constraint envir_env_cfg::cons{
    // agtcon
    if(this.envir_roi_en == 1) this.envir_roi_cfg.agent_mode == envir_dec::MASTER;
    if(this.envir_seq_en == 1) this.envir_seq_cfg.agent_mode == envir_dec::MASTER;
    if(this.envir_ime_en == 1) this.envir_ime_cfg.agent_mode == envir_dec::SLAVE;
    if(this.envir_scb_en == 1) this.envir_scb_cfg.agent_mode == envir_dec::SLAVE;
    if(this.envir_rml_en == 1) this.envir_rml_cfg.agent_mode == envir_dec::SLAVE;
}

function void envir_env_cfg::post_randomize();
    super.post_randomize();
endfunction

`endif // ENVIR_ENV_CFG_SV
