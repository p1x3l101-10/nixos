CC       = gcc
CXX      = g++
CFLAGS   = -O2 -fPIC
CXXFLAGS = -std=c++17 $(CFLAGS)
NAME     = libminacalc

PFX = /usr/local
DEVPFX = $(PFX)

ODIR = build
SRCS = $(shell find . -name '*.cpp')

OBJS           = $(SRCS:%=$(ODIR)/%.o)
INC_FILES     := $(shell find . -name '*.h')
DEST_INC_FILES = $(patsubst %,$(DEVPFX)/include/%,$(INC_FILES))

.PHONY: build install all clean dir

all: clean build

build: dir $(ODIR)/$(NAME).so $(ODIR)/$(NAME).a

clean:
	$(RM) -r $(ODIR)

dir:
	mkdir -p $(ODIR)
	mkdir -p $(ODIR)/MinaCalc

install: $(PFX)/lib/$(NAME).so $(DEVPFX)/lib/$(NAME).a $(DEST_INC_FILES) $(DEVPFX)/lib/pkgconfig/minacalc.pc

$(ODIR)/%.cpp.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS)

$(ODIR)/$(NAME).so: $(OBJS)
	$(CC) -shared -o $@ $^ $(CFLAGS)

$(ODIR)/$(NAME).a: $(OBJS)
	$(AR) rcs $@ $^

$(PFX)/lib/%.so: $(ODIR)/%.so
	install -D -m644 $< $@

$(DEVPFX)/lib/%.a: $(ODIR)/%.a
	install -D -m644 $< $@

$(DEVPFX)/include/%.h: %.h
	install -D -m644 $< $@

$(DEVPFX)/lib/pkgconfig/%.pc: %.pc
	install -D -m644 $< $@