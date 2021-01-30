FROM ubuntu:20.04

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    apt install -y curl make git

ENV ARDUINO_DIRECTORIES_DATA=/arduino-cli/data
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh -s 0.13.0 \
    && arduino-cli config init \
    && arduino-cli update \
    && arduino-cli core install arduino:avr

ENV KALEIDOSCOPE_DIR=/kaleidoscope
RUN git clone -b v1.99.3 --depth=1 https://github.com/keyboardio/Kaleidoscope.git $KALEIDOSCOPE_DIR \
    && cd $KALEIDOSCOPE_DIR && make setup

