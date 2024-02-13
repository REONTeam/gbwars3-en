#!/bin/sh
rgbasm -o main.o main.asm
rgblink -O baserom.gbc -o GBWARS3.gbc main.o
