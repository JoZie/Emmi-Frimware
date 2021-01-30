all: build

kbd/keyboardio:
	@echo "Building Docker countainter '$@'"
	@docker build -q -t $@  .
	@echo ""

run-docker: kbd/keyboardio
	@docker run --rm -it -v $(shell pwd):/Enni -v /dev:/dev --privileged --workdir /Enni $<

build: kbd/keyboardio
	@docker run --rm -v $(shell pwd):/Enni --workdir /Enni $< ./firmware -j$(shell nproc) compile

flash: kbd/keyboardio
	@echo "Start Flashing"
	@echo ""
	@echo " ################################################################# "
	@echo "#                                                                 #"
	@echo "#  Hold the PROG button until it lights up then also press ENTER  #"
	@echo "#                                                                 #"
	@echo " ################################################################# "
	@echo " ... any key to continue ..."
	@read -p "" -n1 -s
	@docker run --rm -v $(shell pwd):/Enni -v /dev:/dev --privileged --workdir /Enni $< ./firmware -j$(shell nproc) flash

