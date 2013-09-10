#Latest version stored at https://github.com/eaterofpies/build-scripts
#The following variable MUST be set
#PROJECT=<final executable name>
#CC=g++

#The following variables can be set
#CFLAGS=-g -Wall -Werror -std=c++11
#CXXFLAGS=$(CFLAGS)
#LDFLAGS=
#SRCDIR=src
#LIBS=

# Probably shouldnt be changed
SOURCES = $(wildcard $(SRCDIR)/*.cxx)
OBJECTS = $(SOURCES:.cxx=.o)
DEP = $(SOURCES:.cxx=.dep)

.PHONY: all clean run

all: $(PROJECT)

run: $(PROJECT)
	./$(PROJECT)


clean:
	rm -f $(SRCDIR)/*.o
	rm -f $(SRCDIR)/*.dep
	rm -f $(SRCDIR)/*.dep.new
	rm -f $(PROJECT)

# compile our cxx to .o
# shell $(CC)... gets expanded first so will print error messages
# prepend SRCDIR to target TODO work out how to depend on the makefiles in use and depend on them
# check the deps file parses hiding make errors due to line 1 not failing if $(CC)... fails
# move the dep file into a place where we can use it
# compile the code
%.o: %.cxx
	@echo $(SRCDIR)$(shell $(CC) $(CFLAGS) -M $<) > $(basename $@).dep.new
	@$(MAKE) --silent -f $(basename $@).dep.new 2> /dev/null
	@mv $(basename $@).dep.new $(basename $@).dep
	$(CC) $(CFLAGS) -c -o $@ $<

#Link step
$(PROJECT): $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)

#Get the actual dependencies of the .o files we are about to create
-include $(DEP)

