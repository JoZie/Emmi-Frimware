DEFAULT_SKETCH="Enni"

KALEIDOSCOPE_PATH = kaleidoscope
OUTPUT_PATH = output

BOOTSTRAPPED = $(shell git rev-parse --resolve-git-dir $(KALEIDOSCOPE_PATH)/.git &>/dev/null && echo 1 || echo 0)

all: build

bootstrap:
ifeq ($(BOOTSTRAPPED), 0)
	git clone --recursive -q -j8 https://github.com/keyboardio/Arduino-Boards $(KALEIDOSCOPE_PATH)
endif

update:
ifeq ($(BOOTSTRAPPED), 1)
	cd $(KALEIDOSCOPE_PATH) && git pull --recurse-submodules -q -j8
endif

clean:
	rm -rf $(KALEIDOSCOPE_PATH) $(OUTPUT_PATH)

build: bootstrap
	OUTPUT_PATH=$(OUTPUT_PATH) \
	$(KALEIDOSCOPE_PATH)/libraries/Kaleidoscope/bin/kaleidoscope-builder build-all

flash: bootstrap
	DEFAULT_SKETCH=$(DEFAULT_SKETCH) \
	OUTPUT_PATH=$(OUTPUT_PATH) \
	$(KALEIDOSCOPE_PATH)/libraries/Kaleidoscope/bin/kaleidoscope-builder flash
