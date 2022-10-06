//--------------------------------------------------
// File Name    : envir_agent_cfg.sv
// Module Name  : envir_agent_cfg
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_AGENT_CFG_SV
`define ENVIR_AGENT_CFG_SV

class envir_agent_cfg extends uvm_object;
    
    envir_config::trigger sqr_en;
    envir_config::trigger drv_en;
    envir_config::trigger rdy_en;
    envir_config::trigger mon_en;

    rand envir_config::agt_mode agent_mode;
    rand envir_driver_cfg           drv_cfg;
    rand envir_ready_cfg            rdy_cfg;
    rand envir_monitor_cfg          mon_cfg;
    
    `uvm_object_utils_begin(envir_agent_cfg)
        `uvm_field_enum(envir_config::agt_mode, agent_mode, UVM_ALL_ON)
        `uvm_field_enum(envir_config::trigger, sqr_en, UVM_ALL_ON)
        `uvm_field_enum(envir_config::trigger, drv_en, UVM_ALL_ON)
        `uvm_field_enum(envir_config::trigger, rdy_en, UVM_ALL_ON)
        `uvm_field_enum(envir_config::trigger, mon_en, UVM_ALL_ON)
        `uvm_field_object(drv_cfg, UVM_ALL_ON)
        `uvm_field_object(rdy_cfg, UVM_ALL_ON)
        `uvm_field_object(mon_cfg, UVM_ALL_ON)
    `uvm_object_utils_end

    extern function      new(string name = "envir_agent_cfg");
    extern function void post_randomize();

endclass

function envir_agent_cfg::new(string name = "envir_agent_cfg");
    super.new(name);
    //this.drv_cfg = envir_driver_cfg::type_id::create("drv_cfg");
    //this.rdy_cfg = envir_ready_cfg::type_id::create("rdy_cfg");
    this.mon_cfg = envir_monitor_cfg::type_id::create("mon_cfg");
    `debug_phase("new")
endfunction

function void envir_agent_cfg::post_randomize();
    case(this.agent_mode)
        envir_config::ALL: begin
            this.sqr_en = envir_config::ON;
            this.drv_en = envir_config::ON;
            this.mon_en = envir_config::ON;
            this.rdy_en = envir_config::ON;
        end
        envir_config::MASTER: begin
            this.sqr_en = envir_config::ON;
            this.drv_en = envir_config::ON;
            this.mon_en = envir_config::ON;
            this.rdy_en = envir_config::OFF;
        end
        envir_config::ONLY_DRV: begin
            this.sqr_en = envir_config::ON;
            this.drv_en = envir_config::ON;
            this.mon_en = envir_config::OFF;
            this.rdy_en = envir_config::OFF;
        end
        envir_config::SLAVE: begin
            this.sqr_en = envir_config::OFF;
            this.drv_en = envir_config::OFF;
            this.mon_en = envir_config::ON;
            this.rdy_en = envir_config::ON;
        end
    endcase
endfunction

`endif // ENVIR_AGENT_CFG_SV
