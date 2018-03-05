DEFAULT_SKETCH="Enni"

KALEIDOSCOPE_PATH = kaleidoscope
OUTPUT_PATH = output

BOOTSTRAPPED = $(shell git rev-parse --resolve-git-dir $(KALEIDOSCOPE_PATH)/.git &>/dev/null && echo 1 || echo 0)

all: build

bootstrap:
ifeq ($(BOOTSTRAPPED), 0)
	git clone --recursive -q -j8 https://github.com/keyboardio/Arduino-Boards $(KALEIDOSCOPE_PATH)
	git clone https://github.com/ivanjonas/Kaleidoscope-LangPack-German.git lib/Kaleidoscope-LangPack-German
endif

update: bootstrap
ifeq ($(BOOTSTRAPPED), 1)
	cd $(KALEIDOSCOPE_PATH) && git pull --recurse-submodules -q -j8
	cd lib &&  git pull --recurse-submodules -q -j8
endif

clean:
	rm -rf $(KALEIDOSCOPE_PATH) $(OUTPUT_PATH) lib

build: bootstrap
	OUTPUT_PATH=$(OUTPUT_PATH) \
	EXTRA_BUILDER_ARGS="-libraries lib" \
	$(KALEIDOSCOPE_PATH)/libraries/Kaleidoscope/bin/kaleidoscope-builder build-all

flash: bootstrap
	DEFAULT_SKETCH=$(DEFAULT_SKETCH) \
	OUTPUT_PATH=$(OUTPUT_PATH) \
	EXTRA_BUILDER_ARGS="-libraries lib" \
	$(KALEIDOSCOPE_PATH)/libraries/Kaleidoscope/bin/kaleidoscope-builder flash
