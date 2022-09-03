.PHONY : cmp pre_compile compile nerun batch_run mkdir post_mkdir ucli mrun cov
.DEFAULT_GOAL = mrun


#----arguments after make----{{{

FULL64_SWITCH ?= on

#}}}


#----overried variable----{{{

PRE_RUN_CMD       :=
POST_RUN_CMD      :=
COV_CMP_OPTS      :=
COV_RUN_OPTS      :=
USER_COMPILE_OPTS :=
USER_RUN_OPTS     :=
WAVE_DUMP_OTPS    := +fsdb+aotuflush +fsdb+dump_log=off

#}}}


#----derived variable----{{{

TC   := $(tc)
SEED := $(seed)
ifeq ($(seed), rand)
    SEED := $(shell perl -e 'print int (rand(10000000000))')
endif


CMP_OPTS += +vcs+lic+wait
CMP_OPTS += $(USER_COMPILE_OPTS) $(udc)
RUN_OPTS += $(USER_RUN_OPTS) +TC_LOG_DIR=$(TC_LOG_DIR) +TC_NAME=$(TC) +TC_SEED=$(TC_SEED)

ifneq ($(FULL64_SWITCH), off)
    FULL64 := -full64
endif
CMP_OPTS += $(FULL64)

ifneq ($(pl), $(null))
    RUN_OPTS += +UVM_VERBOSITY=$(pl)
endif

ifeq ($(wave), fsdb)
    WAVE_FILE  ?= ../cfg/wave_fsdb.do
    TC_DO_FILE ?= ../cfg/$(TC_SEED)_fsdb.do
    RUN_OPTS   += $(WAVE_DUMP_OTPS) +fsdbfile+$(WAVE_DIR)/$(TC_SEED).fsdb -ucli -do $(OUT_DIR)/pre_wave_$(TC_SEED).do
endif

ifeq ($(wave), vpd)
    WAVE_FILE  ?= ../cfg/wave_vdb.do
    TC_DO_FILE ?= ../cfg/$(TC_SEED)_vdb.do
    RUN_OPTS   += $(WAVE_DUMP_OTPS) +vpdfile+$(WAVE_DIR)/$(TC_SEED).vpd -ucli -do $(OUT_DIR)/pre_wave_$(TC_SEED).do
endif

ifneq ($(xprop), off)
    initreg := off
    ifeq ($(xprop), xmerge)
        CMP_OPTS += -xprop=xmerge
    else
        CMP_OPTS += -xprop=tmerge
    endif
    RUN_OPTS += +drv_mode=x
endif

SEED_MOD = $(shell expr $(SEED) % 4)
ifneq ($(initreg), off)
    CMP_OPTS += +vcs+initreg+random
    ifeq ($(initreg), on)
        ifeq ($(SEED_MOD), 0)
            RUN_OPTS += +vcs+initreg+0
        endif
        ifeq ($(SEED_MOD), 1)
            RUN_OPTS += +vcs+initreg+1
        endif
        ifeq ($(SEED_MOD), 2)
            RUN_OPTS += +vcs+initreg+x
        endif
        ifeq ($(SEED_MOD), 3)
            RUN_OPTS += +vcs+initreg+$(SEED)
        endif
    else ifeq ($(initreg), rand)
        RUN_OPTS += +vcs+initreg+$(SEED)
    else
        RUN_OPTS += +vcs+initreg+$(initreg)
    endif
endif

ifeq ($(ccov), on)
    CM_DIR   := $(CCOV_DIR)/simv.vdb
    CM_OPTS  += -cm line+tgl+cond+branch+fsm+assert -cm_dir $(CM_DIR)
    CMP_OPTS += $(CM_OPTS) $(COV_CMP_OPTS)
    RUN_OPTS += $(CM_OPTS) $(COV_RUN_OPTS) -cm_name $(TC_SEED) -cm_log $(LOG_DIR)/coverage.log
endif

EXE_SIMV := $(OUT_DIR)/simv
CMP_OPTS += -Mupdate
CMP_OPTS += -Mdir=$(OUT_DIR)/csrc
CMP_OPTS += +notimingcheck +nospecify
CMP_OPTS += -o $(EXE_SIMV)

RUN_OPTS += +UVM_TESTNAME=$(TC)
RUN_OPTS += -l $(TC_LOG)
RUN_OPTS += +ntb_random_seed=$(SEED)
RUN_OPTS += $(DEF_OPTS)
RUN_OPTS += $(ARGS_OPTS)
RUN_OPTS += -k $(TC_LOG_DIR)/ucli.key


#}}}


#----Compilation RUN----{{{{

ucli:
	@rm -rf $(OUT_DIR)/pre_wave_$(TC_SEED).do
	@if [ -r $(TC_DO_FILE) ]; then \
	    printf "source $(SRC_PATH)/$(TC_DO_FILE)" >> $(OUT_DIR)/pre_wave_$(TC_SEED).do ; \
	else \
	    printf "source $(SRC_PATH)/$(WAVE_FILE)" >> $(OUT_DIR)/pre_wave_$(TC_SEED).do ; \
	fi

cmp : compile
compile : mkdir post_mkdir pre_compile
	@$(ECHO) "$(echo_g)===================================================================$(echo_end)"
	@$(ECHO) "$(echo_g)HSIM: Compilation of vcs start at $(CUR_TIME). (two steps method)$(echo_end)"
	@$(VCS) $(CMP_OPTS) $(TOP_OPTS) $(DBG_OPTS) $(SRC) -o $(EXE_SIMV) -l $(LOG_DIR)/compile.log   && \
	$(ECHO) "$(echo_g)HSIM: Compilation PASSED at $(CUR_TIME). $(LOG_DIR)/compile.log$(echo_end)" || \
	$(ECHO) "$(echo_r)HSIM: Compilation FAILED at $(CUR_TIME). $(LOG_DIR)/compile.log$(echo_end)"
	@$(ECHO) "$(echo_g)===================================================================$(echo_end)"

nerun : batch_run
batch_run : mkdir post_mkdir ucli $(EXE_SIMV)
	@$(ECHO) "$(echo_g)===================================================================$(echo_end)"
	@$(ECHO) "$(echo_g)HSIM: Simulation of vcs start at $(CUR_TIME). (all steps method)$(echo_end)"
	@cd $(TC_LOG_DIR) $(PRE_RUN_CMD)
	@cd $(TC_LOG_DIR) && $(EXE_SIMV) $(RUN_OPTS) && \
	$(ECHO) "$(echo_g)HSIM: Simulation PASSED at $(CUR_TIME). $(TC_LOG)$(echo_end)" || \
	$(ECHO) "$(echo_g)HSIM: Simulation FAILED at $(CUR_TIME). $(TC_LOG)$(echo_end)"
	@cd $(TC_LOG_DIR) $(POST_RUN_CMD)
	@$(ECHO) "$(echo_g)===================================================================$(echo_end)"

mrun: compile batch_run

#}}}


verdi:
	$(VERDI) -sv $(CMP_OPTS) $(VERDI_TOP_OPTS) $(SRC) $(VERDI_OPT) &

$(EXE_SIMV):
	@cd $(TC_LOG_DIR); $(EXE_SIMV) tc=$(TC) mode=$(mode)

cov:
	$(VERDI) $(FULL64) -cov -covdir $(CM DIR) &

sanity: compile_sanity $(SANITY_LIST)

compile_sanity:
	$(MAKE) compile tc=$(TC) wave=$(wave) ccov=on mode=$(mode) ude="$(ude)" udl=$(udl);

URG_DIR := $(CM_DIR)
ifneq ($(dir), $(null))
    URG_DIR += $(dir)
endif

urg:
	@\ed $(SIM PATH)/$(mode)/ECOV ; $(URG) $(FULL64) -dbname merge.vdb -dir "$(URG_DIR)" -parallel -flex merge reference

urg_cov:
	@led $(SIM PATH) /$(mode)/CCoV ; $(VERDI) $(FULL64) -cov -covdir merge.vdb &

pcopt:
	@echo $(CMP_OPTS)

propt:
	@echo $(RUN_OPTS)

