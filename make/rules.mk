#Latest version stored at https://github.com/eaterofpies/build-scripts
#The following variable MUST be set
#PROJECT=<final executable name>
ifndef PROJECT
$(error PROJECT variable not set. This must be set to continue)
endif

#The following variables can be set
###################################
#directory to look for source in
ifndef SRCDIR
SRCDIR=src
endif

#executable file extionsion
ifndef EXEEXT
EXEEXT=
endif

#C++ file extension
ifndef CXXEXT
CXXEXT=cxx
endif

#C++ compiler
ifndef CCXX
CCXX=g++
endif

#C compiler (default to c++ compiler)
ifndef CC
CC=$(CCXX)
endif

#C++ compiler flags
ifndef CXXFLAGS
CXXFLAGS=-g -Wall -Werror -std=c++11
endif

#C compiler flags (set to C++ flags as we use that by default)
ifndef CFLAGS
CFLAGS=$(CXXFLAGS)
endif

#linker flags
ifndef LDFLAGS
LDFLAGS=
endif

#additional libraries
ifndef LIBS
LIBS=
endif

#make the end goal configurable
ifndef FINALTARGET
FINALTARGET=$(PROJECT)$(EXEEXT)
endif

# Probably shouldnt be changed
SOURCES = $(wildcard $(SRCDIR)/*.$(CXXEXT))
OBJECTS = $(SOURCES:.$(CXXEXT)=.o)
DEP = $(SOURCES:.$(CXXEXT)=.dep)

.PHONY: all clean run

all: $(FINALTARGET)

run: $(PROJECT)$(EXEEXT)
	./$(PROJECT)$(EXEEXT)


clean:
	rm -f $(SRCDIR)/*.o
	rm -f $(SRCDIR)/*.dep
	rm -f $(SRCDIR)/*.dep.new
	rm -f $(PROJECT)$(EXEEXT)

# compile our $(CXXEXT) to .o
# shell $(CCXX)... gets expanded first so will print error messages
# prepend SRCDIR to target TODO work out how to depend on the makefiles in use and depend on them
# check the deps file parses hiding make errors due to line 1 not failing if $(CCXX)... fails
# move the dep file into a place where we can use it
# compile the code
%.o: %.$(CXXEXT)
	@echo $(SRCDIR)$(shell $(CCXX) $(CXXFLAGS) -M $<) > $(basename $@).dep.new
	@$(MAKE) --silent -f $(basename $@).dep.new 2> /dev/null
	@mv $(basename $@).dep.new $(basename $@).dep
	$(CCXX) $(CXXFLAGS) -c -o $@ $<

#Link step
$(PROJECT)$(EXEEXT): $(OBJECTS)
	$(CCXX) -o $@ $^ $(LDFLAGS) $(LIBS)

#Get the actual dependencies of the .o files we are about to create
-include $(DEP)

