.PHONY : mkdir help

#----arguments after make----{{{

tc        ?= zeus
pl        ?= UVM_LOW
wave      ?= fsdb
mode      ?= default
ccov      ?= off
cov_mode  ?= only_fcov
gui       ?= off
sim_prof  ?= off
auto_part ?= off
xprop     ?= off
initreg   ?= off
assert    ?= off
post_sim  ?= off
no_tmp    ?= on
seed      ?= 0

ifeq ($(tc), $(null))
    $(warning Please setup the uvm_testname !)
endif

ifeq ($(mode), $(null))
    $(warning Please setup the mode of vcs !)
endif

#{{{

help:
	@$(ECHO) "$(echo_g)Help with this Makefile$(echo_end)"
	@$(ECHO) "$(echo_g)1. Arguments for this Makefile as follow:$(echo_end)"
	@$(ECHO) "make tc=zeus        Description: this arg specifies case name (signed string in uvm)"
	@$(ECHO) "make pl=UVM_LOW     Description: this arg specifies print level (UVM_LOW or UVM_HIGHT)"
	@$(ECHO) "make wave=fsdb      Description: this arg specifies wave type (fsdb or vdp)"
	@$(ECHO) "make mode=default   Description: this arg specifies generated dir name (any string)"
	@$(ECHO) "make ccov=off       Description: this arg specifies switch of coverage ratio (on or off)"
	@$(ECHO) "make gui=off        Description: this arg specifies switch of debug IDE (on of off)"
	@$(ECHO) "make sim_prof=off   Description: this arg specifies optimizing of simulation time (on or off)"
	@$(ECHO) "make auto_part=off  Description: this arg specifies partition complie (on or off)"
	@$(ECHO) "make xprop=off      Description: this arg specifies switch of x state check (on or off)"
	@$(ECHO) "make initreg=off    Description: this arg specifies reg's initial value (on or off)"
	@$(ECHO) "make assert=off     Description: this arg specifies assert switch (on or off)"
	@$(ECHO) "make post_sim=off   Description: this arg specifies switch of post simulation ckeck (on or off)"
	@$(ECHO) "make no_tmp=on      Description: this arg specifies switch of internediated file (on or off)"
	@$(ECHO) "make seed=0         Description: this arg specifies the seed of simulation (integer)"
	@$(ECHO) "$(echo_g)2. Variables can be overrided in wrapper makefile as follow (such variables can be checked if overried):$(echo_end)"
	@$(ECHO) "UVM_VERSION Description: it has two choices: uvm-1.1 and uvm-1.2"
	@$(ECHO) "TIMESCALE   Description: timescale about simulation"
	@$(ECHO) "SIM_PATH    Description: directory of storage simulation result"
	@$(ECHO) "TOP_OPTS    Description: the top module of all of testbench (sometimes two modules)"
	@$(ECHO) "gui_tool    Description: specifing the debug IDE (verdi or dve)"
	@$(ECHO) "cm_hier_cfg Description: specifing the configration file of coverage hier"
	@$(ECHO) "j16         Description: specifing the number of thread"
	@$(ECHO) "$(echo_g)3. Usage as follow:$(echo_end)"
	@$(ECHO) "make mrun   Description: specifing the flow of two-step method, the first step is compilation and the second step is simulation"
	@$(ECHO) "make drun   Description: specifing the number of thread"



#----system constant variables----{{{
null     =
space    = $(null) $(null)
CUR_TIME = `date "+%Y-%m-%d %H:%M:%S"`
ECHO     = echo -e
echo_r   = \033[1;31m
echo_g   = \033[1;32m
echo_y   = \033[1;33m
echo_end = \033[0m
pwd      = $(shell pwd)

#}}}


#----overried variable----{{{
UVM_VERSION    ?= uvm-1.1
TIMESCALE      ?= -timescale=1ns/1ps -unit_timescale=lns/1ps
TOP_OPTS       ?= -top hvl_top -top hdl_top
gui_tool       ?= verdi
cm_hier_cfg    ?= ./cfg/cm_hier.cfg
j16            ?= j8

URG    ?= urg
VCS    ?= vcs
VHDLAN ?= vhdlan
VLOGAN ?= vlogan
VERDI  ?= verdi
DVE    ?= dve

ifeq ($(TOP_OPTS), $(null))
    $(warning Please overried the top module name, maybe two !)
endif

#}}}


#----derived variables----{{{

HOST_NAME          := $(shell hostname)
TC                 := $(tc)
SEED               := $(seed)
TC_SEED            := $(TC)_$(SEED)
SRC_PATH           := $(pwd)
SIM_PATH           ?= $(SRC_PATH)
SIM_PATH_LINK      := "./$(shell basename $(SIM_PATH))"
SYNOPSYS_SIM_SETUP := $(SIM_PATH)/$(mode)/synopsys_sim.setup
UVM_HOME           := $(VCS_HOME)/etc/$(UVM_VERSION)
an_lib             := lib
an_dut             := dut
an_tb              := tb
AN_LIB             := $(shell echo $(an_lib) | tr a-z A-Z))
AN_DUT             := $(shell echo $(an_dut) | tr a-z A-Z))
AN_TB              := $(shell echo $(an_tb)  | tr a-z A-Z))
AN_LIBLIST         := $(AN_LIB)+$(AN_DUT)+$(AN_TB)

ifneq ($(VERIFICATION_HOME), $(null))
    export project := $(VERIFICATION_HOME)
endif

OUT_DIR    := $(SIM_PATH)/$(mode)/exec
LOG_DIR    := $(SIM_PATH)/$(mode)/log
WAVE_DIR   := $(SIM_PATH)/$(mode)/wave
CCOV_DIR   := $(SIM_PATH)/$(mode)/ccov
TC_LOG_DIR := $(SIM_PATH)/$(mode)/log/$(TC_SEED)
TC_LOG     := $(TC_LOG_DIR)/$(TC_SEED).log

export DBG_OPTS ?= -debug_access+r+f+fwn+dmptf
export UVM_OPTS := $(UVM_HOME)/uvm_pkg.sv $(OUT_DIR)/import_uvm.sv

#}}}


#----vcs option-----{{{

CMP_OPTS := $(space)
RUN_OPTS := $(space)

CMP_OPTS += -ntb_opts $(UVM_VERSION) $(TIMESCALE) -j8 -full64 \
            -sverilog +v2k -lca -kdb -nc -pcmakeprof \
            +vcs+lic+wait +fsdb+region +lint=no +warn=all +vcs+flush+all
RUN_OPTS += +TC_NAME=$(TC) +TC_SEED=$(SEED) \
            +vcs+lic+wait +vcsi+lic+wait

ifeq ($(sim_prof), on)
   CMP_OPTS += -simprofile -lca
   RUN_OPTS += -simprofile mem+time
endif

ifeq ($(assert), on)
    CMP_OPTS += +define+ASSERT_ON
endif

ifeq ($(gui), on)
    RUN_OPTS += -gui=$(gui_tool)
    DBG_OPTS := -debug_access+all
endif

CMP_OPTS += $(DBG_OPTS)
CM_START ?= 50

ifeq ($(ccov), on)
    ifneq ($(cov_mode), only_fcov)
        export CM_OPTS      += -cm line+cond+tgl+branch+fsm+assert
        export COV_CMP_OPTS += -cm_hier $(cm_hier_cfg)
        export COV_CMP_OPTS += -cm_line contassign -cm_cond std+allops -cm tgl -cm_glitch 0
    else
        export CM_OPTS := -cm assert
        export CM_OPTS += -covg_disable_cg
    endif
    export COV_RUN_OPTS += -cm_start $(CM_START)
endif

ifneq (${post_sim}, on)
    CMP_OPTS += +nospecify +notimingcheck
endif

FOR_CTL_TEST := $(shell echo $(USER_COMPILE_OPTS) | grep FOR_CTL_TEST)
ifneq ($(FOR_CTL_TEST), $(null))
    WAVE_FILE := $(shell pwd)/wave_fsdb.do
endif

CMP_OPTS += -CFLAGS -I$(VCS_HOME)/include

ifeq ($(SRC), $(null))
    ifneq ($(LIB_SRC), $(null))
        SRC += -F $(LIB_SRC)
    endif
    ifneq ($(DUT_SRC), $(null))
        SRC += -F $(DUT_SRC)
    endif
    ifneq ($(TB_SRC), $(null))
        SRC += -F $(TB_SRC)
    endif
endif

VERDI_OPT = +libext+.v+.V+.vh +verilog2001ext+.vp -2012 -sv -nologo

ifeq ($(auto_part), on)
    CM_OPTS += -partcomp=autopart_low -fastpartcomp=$(j16) -partcomp_dir=./$(mode)/exec/partitionlib
endif

ifeq ($(no_tmp), on)
    PRE_VLOGAN := \cd $(OUT_DIR)
    PRE_ELAB   := \cd $(OUT_DIR)
endif


#}}}

## INCLUDE
include $(VER_PATH)/script/HSIM/hsim2.mk

#----Analysis Elabration----{{{

AN_OPTS   += $(USER_AN_OPTS)
ELAB_OPTS += $(USER ELAB_OPTS)
AN_OPTS   := $(filter-out +nospecify, \
             $(filter-out -CFLAGS,     \
             $(filter-out -I%include,  \
             $(filter-out +notimingcheck, $(CMP_OPTS)))))
ELAB_OPTS := $(filter-out +define+*, \
             $(filter-out +libext+.v, \
             $(filter-out +v2k, \
             $(filter-out -ntb_opts $(UVM_VERSION), $(CMP_OPTS)))))

ELAB_OPTS += -$(j16) $(UVM_HOME)/dpi/uvm_dpi.cc

ifneq ($(TOPCFG), $(null))
    ifneq ($(shell grep -e "^ *partition" $(TOPCFG)), $(null))
        ELAB_OPTS += -partcomp
    endif
else
    ELAB_OPTS += $(TOP_OPTS)
endif

ifeq ($(power_wave), on)
    ELAB_OPTS += -debug_region=lib+cell
endif


SYNOPSYS_SIM += WORK      \> DEFAULT                 \\n
SYNOPSYS_SIM += DEFAULT   : $(OUT_DIR)/work_lib      \\n
SYNOPSYS_SIM += UVM       : $(OUT_DIR)/uvm_lib       \\n
SYNOPSYS_SIM += $(AN_LIB) : $(OUT_DIR)/$(an_lib)_lib \\n
SYNOPSYS_SIM += $(AN_DUT) : $(OUT_DIR)/$(an_dut)_lib \\n
SYNOPSYS_SIM += $(AN_TB)  : $(OUT_DIR)/$(an_tb)_lib

synopsys_sim_setup :
	@if [ ! -f ./synopsys_sim.setup ] ; then \
	echo  $(SYNOPSYS_SIM) > ./synopsys_sim.setup && \
	sed -i 's/\s*\\n/\n/g' ./synopsys_sim.setup && \
	sed -i 's/^\s*//g' ./synopsys_sim.setup && \
	$(ECHO) "** Synopsys_sim.setup done ! **"; fi

mkdir:
	@if [ ! -d $(OUT_DIR)    ] ; then mkdir -p $(OUT_DIR)    ; fi
	@if [ ! -d $(EXE_DIR)    ] ; then mkdir -p $(EXE_DIR)    ; fi
	@if [ ! -d $(LOG_DIR)    ] ; then mkdir -p $(LOG_DIR)    ; fi
	@if [ ! -d $(WAVE_DIR)   ] ; then mkdir -p $(WAVE_DIR)   ; fi
	@if [ ! -d $(CCOV_DIR)   ] ; then mkdir -p $(CCOV_DIR)   ; fi
	@if [ ! -d $(TC_LOG_DIR) ] ; then mkdir -p $(TC_LOG_DIR) ; fi

change_sim_path:
ifneq ($(SIM_PATH), $(SRC_PATH))
	@if [ ! -e $(SIM_PATH_LINK) ] ; then ln -fs $(SIM_PATH) $(SIM_PATH_LINK) ; fi
	@if [ ! -e $(SIM_PATH)/make ] ; then printf "cd $(SRC_PATH)\nmake $$*" > $(SIM_PATH)/make ; chmod 755 $(SIM_PATH)/make ; fi
endif


pre_an : mkdir synopsys_sim_setup change_sim_path pre_compile
	@$(ECHO) "$(echo_g)==========================================================$(echo_end)"
	@$(ECHO) "$(echo_g)Analysis of uvm start at $(CUR_TIME). (three steps method)$(echo_end)"
	@printf "import uvm pkg::*;" > $(OUT_DIR)/import_uvm.sv
	@$(PRE_VLOGAN) $(VLOGAN) -full64 $(AN_OPTS) -ntb_opts $(UVM_VERSION) -l $(LOG_DIR)/an_uvm.log -work UVM
	@$(ECHO) "$(echo_g)Analysis of uvm PASSED at $(CUR_TIME): $(LOG_DIR)/an_uvm.log$(echo_end)"
	@$(ECHO) "$(echo_g)============================================================$(echo_end)"

an_lib : pre_an_lib
	@$(ECHO) "$(echo_g)=====================================$(echo_end)"
	@$(ECHO) "$(echo_g)Analysis of library start at $(CUR_TIME). (three steps method)$(echo_end)"
	@$(PRE_VLOGAN) $(VLOGAN) $(AN_OPTS) $(UVM_OPTS) -l $(LOG_DIR)/an_$(an_lib).1og $(LIB_SRC) -work $(AN_LIB) || \
	(if [ $$? -ne 0 ]; then $(ECHO) "$(echo_r)Vlogan library FAILED : $(LOG_DIR)/an_$(an_lib).log$(echo_end)"; exit 1; fi)
	@$(ECHO) "$(echo_g)Analysis of library PASSED at $(CUR_TIME): $(LOG_DIR)/an_$(an_lib).log$(echo_end)"
	@$(ECHO) "$(echo_g)===========================================================================$(echo_end)"

an_dut : pre_an_dut
	@$(ECHO) "$(echo_g)=====================================$(echo_end)"
	@$(ECHO) "$(echo_g)Analysis of dut start at $(CUR_TIME). (three steps method)$(echo_end)"
	@$(PRE_VLOGAN) $(VLOGAN) $(AN_OPTS) $(UVM_OPTS) -l $(LOG_DIR)/an_$(an_dut).log $(DUT_SRE) -work $(AN_DUT) || \
	(if [ $$? -ne 0 ]; then $(ECHO) "$(echo_r)Vlogan dut FAILED : $(LOG_DIR)/an_$(an_dut).log$(echo_end)"; exit 1; fi)
	@$(ECHO) "$(echo_g)Analysis of dut PASSED at $(CUR_TIME): $(LOG_DIR)/an_$(an_dut).log$(echo_end)"
	@$(ECHO) "$(echo_g)=======================================================================$(echo_end)"

an_tb: pre_an_tb
	@$(ECHO) "$(echo_g)================================================================$(echo_end)"
	@$(ECHO) "$(echo_g)Analysis of testbench start at $(CUR_TIME). (three steps method)$(echo_end)"
	@$(PRE_VLOGAN) $(VLOGAN) $(AN_OPTS) $(UVM_OPTS) -l $(LOG_DIR)/an_$(an_tb).1og $(TB_SRC) $(TOPCFG) -work $(AN_TB) || \
	(if [ $$? -ne 0 ]; then $(ECHO) "$(echo_r)Vlogan testbench FAILED : $(LOG_DIR)/an_$(an_tb).log$(echo_end)"; exit 1; fi)
	@$(ECHO) "$(echo_g)Analysis of testbench PASSED at $(CUR_TIME): $(LOG_DIR)/an_$(an_tb).log$(echo_end)"
	@$(ECHO) "$(echo_g)============================================================================$(echo_end)"

elab: pre_elab
	@$(ECHO) "$(echo_g)============================================================$(echo_end)"
	@$(ECHO) "$(echo_g)Elabration of vcs start at $(CUR_TIME). (three steps method)$(echo_end)"
	@$(PRE_ELAB) $(VCS) $(ELAB_OPTS) -liblist UVM+$(AN_LIBLIST) $(SRC) -o $(SIM_EXE_FILE) -l $(LOG_DIR)/elab.log || \
	(if [ $$? -ne 0 ]; then $(ECHO) "$(echo_r)Elabration FAILED : $(LOG_DIR)/elab.log$(echo_end)"; exit 1; fi)
	@$(ECHO) "$(echo_g)Elaboration PASSED at $(CUR_TIME): $(LOG_DIR)/elab.log$(echo_end)"
	@$(ECHO) "$(echo_g)======================================================$(echo_end)"

acmp : pre_an an_lib an_dut an_tb elab
1cmp : an_lib an_dut elab
demp : an_dut elab
vemp : an_tb elab

run  : lcmp nerun
arun : acmp nerun
drun : demp nerun
vrun : vemp nerun

clean:
	@\rm -rf $(OUTPUT DIR) /*
	@\rm -rf $(LOG_DIR)/an_*.log $(LOG_DIR)/elab.log $(LOG_DIR)/uvm_test.cmp_log

clean_all:
	@rm -rf ./csre./novas*./verd*./ucli*./vc*
	@rm -rf $(wAVE DIR)/*. fsdb*
	@rm -rf ?/vhdl_objs _dir ./DVEfiles ./*regress*
	@rm -rf $(WAVE DIR)/*. vpd*
	@rm -rf $(LOG_DIR)/*
	@rm -rf $(CcoV DIR)/*
	@rm -rf $(oUTPUT DIR)/*

paopt:
	@echo $(AN_OPTS)
