
## path prefix
PREFIX ?= /usr/local

## application binary name
BIN ?= suri

## clang arguments
CXX ?= clang
CXXFLAGS += -fobjc-arc
CXXFLAGS += -framework Cocoa
CXXFLAGS += -framework Foundation
CXXFLAGS += -framework ApplicationServices

.PHONY: $(BIN)
$(BIN):
	$(CXX) $(CXXFLAGS) suri.m -o $(BIN)

install:
	install $(BIN) $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

clean:
	rm -f $(BIN)
