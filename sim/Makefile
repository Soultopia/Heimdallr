#------------------------------------
#
# author : soultopia
# e-mail : yuhng.zhu@gmail.com
#
#------------------------------------

#--test case name--
TC           := xxx

#--seed--
SEED         := 2

#--uvm top module--
UVM_TOP      := zeus

#--switch--
FULL64_SWITCH := on
tc            := sanity
wave          := fsdb
ccov          := on
mode          := two_step
gui           := on
printl        := UVM_LOW
null          :=
space         := ${null} ${null}

ifeq (${mode}, ${null})
    $(error Please setup the mode of vcs !!!)
endif

ifeq (${TC}, ${null})
    $(warning Please setup the uvm_testname !!!)
endif

ifeq (${FULL64_SWITCH}, on)
    NOVAS_LIB_B := LINUX64
else
    NOVAS_LIB_B := LINUX
endif

#--out dir--
UVM_OUT      := $(UVM_TOP)

#--c code dir--
C_HOME       := ./model

#--rtl filelist--
dutlist      := ./cfg/dut.f

#--env filelist--
envlist      := ./cfg/env.f

#--uvm lib dir--
UVM_LIB      := $(VCS_HONE)/etc/uvm-1.1

#--intermediate dir--
OUT_DIR      := ./$(UVM_OUT)
EXE_DIR      := ./$(UVM_OUT)/exec
COV_DIR      := ./$(UVM_OUT)/ccov/$(TC)
LOG_DIR      := ./$(UVM_OUT)/logs/$(TC)
WAVE_DIR     := ./$(UVM_OUT)/wave/$(TC)
EXE          := ${EXE_DIR}/simv

#--common options--
COM_OPTS     := -sverilog -ntb_opts uvm-1.1 -nc -kdb +v2k  \
                -timescale=1ns/1ps -unit_timescale=1ns/1ps \
                +vcs+lic+wait +lint=all +error=all +warn=all 

DEF_OPTS     := +define+XXX=xxx

ARGS_OPTS    := +pluargs_save +TC=$(TC)

DEBUG_OPTS   := +debug_access

DPI          := -CFLAGS "-std=gnu99"             \
                -CFLAGS "-Wall"                  \
                -CFLAGS "-fPIC"                  \
                -CFLAGS "shared"                 \
                -CFLAGS "-I ${VCS_HOME}/include" \
                $(C_HOME)/*.c

#--specify options--
CMP_OPTS     := ${COM_OPTS} $(ARGS_OPTS) $(DEF_OPTS) \
                -ntb_opts uvm-1.2  \
                -P $(NOVAS)/share/PLI/VCS/$(NOVAS_LIB_B)/novas.tab \
                   $(NOVAS)/share/PLI/VCS/$(NOVAS_LIB_B)/pli.a

CMP_OPTS     += -Mupdate
CMP_OPTS     += -top ${UVM_TOP}
CMP_OPTS     += -Mdir=${EXE_DIR}/csrc

RUN_OPTS     += +UVM_TESTNAME=${TC}
RUN_OPTS     += -l ${LOG_DIR}/${TC}_${SEED}.log
RUN_OPTS     += +ntb_random_seed=${SEED}
RUN_OPTS     += ${DEF_OPTS}
RUN_OPTS     += ${ARGS_OPTS}



ifeq ($(wave), fsdb)
    WAVE_FILE  := wave_fsdb.do
    TC_DO_FILE := ${TC}_fsdb.do
    RUN_OPTS   += ${WAVE_DUMP_OPTS} +fsdbfile+${WAVE_DIR}/${TC}_${SEED}.fsdb -ucli ${TC_DO_FILE}
else
  ifeq (${wave}, vpd)
    WAVE_FILE  := wave_vpd.do
    TC_DO_FILE := ${TC}_vpd.do
    RUN_OPTS   += ${WAVE_DUMP_OPTS} +vpdfile+${WAVE_DIR}/${TC}_${SEED}.vpd -ucli ${TC_DO_FILE}
  endif
endif


ifeq ($(ccov), on)
    CMP_OPTS += -cm line+tgl+cond+branch+fsm+assert
    RUN_OPTS += -cm line+tgl+cond+branch+fsm+assert -cm_dir ${COV_DIR}/simv.vdb \
                -cm_name ${TC}_${SEED}
endif


ifeq ($(printl), $(null))
    RUN_OPTS += +UVM_VERBOSITY=${printl}
endif


ifeq (${gui}, on)
    RUN_OPTS += -gui
endif

ifeq (${dutlist}, ${null})
    SRC      += -F ${dutlist}
endif

ifeq (${envlist}, ${null})
    SRC      += -F ${envlist}
endif


# ---------------------------------------------------------------------
# generating the synopsys_sim.setup file and middle file storage folder
# ---------------------------------------------------------------------

SYNOPSYS_SIM += WORK    \> DEFAULT        \\n
SYNOPSYS_SIM += DEFAULT : $(OUT_DIR)      \\n
SYNOPSYS_SIM += DUT     : $(EXE_DIR)/dut  \\n
SYNOPSYS_SIM += ENV     : $(EXE_DIR)/env                                     

.PHONY : mkdir
mkdir :
	@if [ ! -d ${OUT_DIR}  ] ; then mkdir -p ${OUT_DIR}  ; fi
	@if [ ! -d ${EXE_DIR}  ] ; then mkdir -p ${EXE_DIR}  ; fi
	@if [ ! -d ${COV_DIR}  ] ; then mkdir -p ${COV_DIR}  ; fi
	@if [ ! -d ${LOG_DIR}  ] ; then mkdir -p ${LOG_DIR}  ; fi
	@if [ ! -d ${WAVE_DIR} ] ; then mkdir -p ${WAVE_DIR} ; fi


.PHONY : setup
setup :
	@-rm -rf ./synopsys_sim.setup
	@-touch  ./synopsys_sim.setup
	@-echo  $(SYNOPSYS_SIM) >> ./synopsys_sim.setup
	@-sed -i 's/\s*\\n/\n/g' ./synopsys_sim.setup
	@-echo  "** Setup done ! **"


# -------------------------
# vcs three step simulation
# -------------------------

.PHONY : dutan
dutan :
	vlogan $(COM_OPTS) \
	-f $(dutlist) -l $(LOG_DIR)/dutan.log -work DUT


.PHONY : envan
envan :
	vlogan $(COM_OPTS) \
	-f $(envlist) -l $(LOG_DIR)/envan.log -work ENV


.PHONY : elab
elab :
	vcs -top $(UVM_TOP) $(CMP_OPTS) \
	-l $(LOG_DIR)/elab.log


.PHONY : comp
comp :
	vcs -top $(UVM_TOP) $(CMP_OPTS) \
	-l $(LOG_DIR)/comp.log -o $(EXE)


.PHONY : sim
sim :
	./$(EXE) $(RUN_OPTS) -l $(LOG_DIR)/sim.log


# -----------------------
# vcs step two simulation
# -----------------------

compile : mkdir
	vcs ${CMP_OPTS} ${SRC} -l $(LOG_DIR)/comp.log


batch_run : ${EXE}
	${EXE} ${RUN_OPTS} -l $(LOG_DIR)/${TC}_${SEED}.log

run : compile batch_run

# -----------------------
# detect the wave of zeus
# -----------------------


.PHONY : verdi
verdi :
	verdi -sv -f $(envlist) -top $(UVM_TOP) \
	-ssf $(WAVE_DIR)/$(TC).fsdb &


.PHONY : clean
clean :
	@-rm -rf $(OUT_DIR)
	@-rm -rf synopsys_sim.setup
	@-echo "** Clean done ! **"


