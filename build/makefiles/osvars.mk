# gratis https://stackoverflow.com/questions/714100/os-detecting-makefile
ifeq ($(OS),Windows_NT)
    ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
	OS_PLATFORM := win64
    else
        ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
	    OS_PLATFORM := win64
        endif
        ifeq ($(PROCESSOR_ARCHITECTURE),x86)
	    OS_PLATFORM := win32
        endif
    endif
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        UNAME_P := $(shell uname -p)
	ifeq ($(UNAME_P),x86_64)
	    OS_PLATFORM := linux-x86_64
	endif
        ifneq ($(filter %86,$(UNAME_P)),)
	    OS_PLATFORM := linux-x86_32
        endif
    endif
    ifeq ($(UNAME_S),Darwin)
        UNAME_P := $(findstring X86_64,$(shell uname -v))
        ifeq ($(UNAME_P),X86_64)
	    OS_PLATFORM := osx-x86_64
        endif
    endif
endif

ifndef OS_PLATFORM
    $(error unsupported platform $(UNAME_S):$(UNAME_P))
endif

