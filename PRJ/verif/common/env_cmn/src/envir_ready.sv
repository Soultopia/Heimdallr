//--------------------------------------------------
// File Name    : envir_ready.sv
// Module Name  : envir_ready
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_READY_SV
`define ENVIR_READY_SV

class envir_ready#(type BUS) extends uvm_driver#(uvm_sequence_item);

    `uvm_component_utils(envir_ready)

    virtual BUS bus;
            bit active;
            envir_ready_cfg cfg;

    uvm_blocking_get_port#(uvm_sequence_item) get_port;

    extern         function      new(string name = "envir_ready", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task          main_phase(uvm_phase phase);
    extern virtual task          rdy_tr(envir_rdytxn rdy_tr);
    extern virtual task          rdy_idle();
    extern virtual task          refresh_objection(uvm_phase phase);
    extern virtual function bit  reset();

endclass

function envir_ready::new(string name = "envir_ready", uvm_component parent);
    super.new(name, parent);
    this.get_port = new("get_port", this);
    `debug_phase("new")
endfunction

function void envir_ready::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual BUS)::get(this, "", "bus", bus))
        `uvm_error(get_name(), "Failed to fetch bus !!!")
    if(this.cfg == null) begin
        this.cfg = envir_ready_cfg::type_id::create("envir_ready_cfg");
        this.cfg.randomize() with {
            cfg.rst_mode == envir_config::IMMEDIATE;
            cfg.rdy_mode == envir_config::RDY0;
        };
    end
    `debug_phase("build_phase")
endfunction

task envir_ready::main_phase(uvm_phase phase);
    uvm_sequence_item tr;
    envir_rdytxn rdy_tr;
    super.main_phase(phase);
    fork 
        if(cfg.rst_mode != envir_config::IGNORE) refresh_objection(phase);
    join_none
    while(1) begin
        @this.bus.rdy_cb;
        if(!reset()) begin
            this.active = 1;
            this.get_port.get(tr);
            if(!$cast(rdy_tr, tr)) `uvm_error(get_name(), "Rdy trans cast failed !!!")
            if(rdy_tr.bp_en) begin
                while(1) begin
                    if(reset() || /* brkdef */ this.bus.booth_data_in_vld) break;
                    @this.bus.rdy_cb;
                end
            end
            this.rdy_tr(rdy_tr);
        end
        else begin
            this.active = 0;
            this.rdy_idle();
        end
    end
endtask

task envir_ready::rdy_tr(envir_rdytxn rdy_tr);
    if(rdy_tr.hi_cycle != 0) begin
        // rdy1def
        this.bus.rdy_cb.booth_data_in_rdy    <= 'h1;
        repeat(rdy_tr.hi_cycle) begin
            if(reset()) break;
            @this.bus.rdy_cb;
        end
    end
    if(rdy_tr.lw_cycle != 0) begin
        // rdy0def
        this.bus.rdy_cb.booth_data_in_rdy    <= 'h0;
        repeat(rdy_tr.lw_cycle) begin
            if(reset()) break;
            @this.bus.rdy_cb;
        end
    end
endtask

task envir_ready::rdy_idle();
    case(this.cfg.rdy_mode)
        envir_config::DRV0: begin
            // drv0def
            this.bus.rdy_cb.booth_data_in_rdy    <= 'h0;
        end
        envir_config::DRV1: begin
            // drv1def
            this.bus.rdy_cb.booth_data_in_rdy    <= 'h1;
        end
        envir_config::DRVX: begin
            // drvxdef
            this.bus.rdy_cb.booth_data_in_rdy    <= 'hx;
        end
        envir_config::DRVR: begin
            // drvrdef
            this.bus.rdy_cb.booth_data_in_rdy    <= $urandom;
        end
    endcase
endtask

task envir_ready::refresh_objection(uvm_phase phase);
    while(1) begin
        @(this.active);
        if(this.active == 1) begin
            if(phase.phase_done.get_objection_count(this) == 0) phase.raise_objection(this);
        end
        else begin
            if(phase.phase_done.get_objection_count(this) == 1) phase.drop_objection(this);
        end
    end
endtask

function bit envir_ready::reset();
    if(this.bus.rst_n == 0) begin
        if(this.cfg.rst_mode == envir_config::IGNORE) begin
            return 0;
        end
        else if(this.cfg.rst_mode == envir_config::IMMEDIATE) begin
            this.active = 0;
            return 1;
        end
        else if(this.active == 0) begin
            return 1;
        end
    end
endfunction

`endif // ENVIR_READY_SV
