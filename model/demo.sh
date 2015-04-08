#!/bin/sh
octave --eval demo | octave --eval 'headerlines=17;columnskip=2;global configuration;configuration.wallPoints = [[-4,-20];[-4,0];[4,-20];[4,0];[-4,0];[-14,0];[4,0];[14,0];[-14,8];[14,8]]*300;' ../view/liveview.m
