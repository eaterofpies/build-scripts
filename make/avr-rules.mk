#AVR specific rules
#MCU and F_CPU must be set in your makefile
ifndef MCU
$(error Variable MCU eg. 'atmega168' not set)
endif

ifndef F_CPU
$(error Variable F_CPU cpu frequency eg. 8000000 not set)
endif

ifndef CCXX
CCXX=avr-g++
endif

ifndef OBJCOPY
OBJCOPY=avr-objcopy
endif

ifndef CXXFLAGS
CXXFLAGS= \
-g \
-Wall \
-Werror \
-std=c++11 \
-fpack-struct \
-fshort-enums \
-finline-functions \
-DF_CPU=$(F_CPU) \
-mmcu=$(MCU) \
-O2
endif

ifndef LDFLAGS
LDFLAGS= \
-g \
-mmcu=$(MCU)
endif

ifndef FINALTARGET
FINALTARGET=$(PROJECT).hex
endif

ifndef PROGRAMMER
PROGRAMMER=usbasp
endif

EXEEXT=.elf

all: $(PROJECT).hex

#TODO make this more overridable
burnfuse:
	avrdude -p $(MCU) -c $(PROGRAMMER) -P usb  -u -U lfuse:w:0xe4:m

program: $(PROJECT).hex
	avrdude -p $(MCU) -c $(PROGRAMMER) -P usb -u -U flash:w:$<

#create hex file from elf file
%.hex: %.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@
	

