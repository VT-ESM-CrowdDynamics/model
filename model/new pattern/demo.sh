#!/bin/sh
octave --eval demo | octave --eval 'headerlines=17;columnskip=2;frameskip=0,size=1000' ../../view/liveview.m
