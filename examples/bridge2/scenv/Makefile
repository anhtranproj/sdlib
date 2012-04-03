SYSTEMC=/opt/systemc
VERILATOR_ROOT=$(HOME)/tools/share/verilator
VERIDIR=obj_dir
INCLUDES=-I$(SYSTEMC)/include -I$(VERIDIR) -I$(VERILATOR_ROOT)/include -I$(SYSTEMPERL)
LINKOPT=-L$(SYSTEMC)/lib-linux -lsystemc -lm
DEFINES=-DDEBUG
OBJFILES=env_top.o gmii_driver.o \
$(VERIDIR)/Vbridge_ex2__ALL.a \
verilated.o verilated_vcd_sc.o verilated_vcd_c.o Sp.o
OPT_FAST=-O2

CXX=g++ -g $(OPT_FAST) $(INCLUDES) $(DEFINES)

all: env_top

test: env_top
	./env_top

env_top: $(OBJFILES)
	$(CXX) $^ -o $@ $(LINKOPT)

verilated.o : $(VERILATOR_ROOT)/include/verilated.cpp
	$(CXX) -c $^

verilated_vcd_sc.o : $(VERILATOR_ROOT)/include/verilated_vcd_sc.cpp
	$(CXX) -c $^

verilated_vcd_c.o : $(VERILATOR_ROOT)/include/verilated_vcd_c.cpp
	$(CXX) -c $^

$(VERIDIR)/Vbridge_ex2__ALL.a:
	make OPT_FAST="$(OPT_FAST)" -f $(VERIDIR)/Vbridge_ex2.mk -C $(VERIDIR)
	#(cd $(VERIDIR); make -f Vtv80s.mk Vtv80s.o)

Sp.o: $(SYSTEMPERL)/Sp.cpp
	$(CXX) -I$(SYSTEMPERL) -c $^

clean:
	rm -f *.o
	rm -f ../obj_dir/*.o

