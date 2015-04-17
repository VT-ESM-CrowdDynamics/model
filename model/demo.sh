#!/bin/sh
octave --eval demo | tee log | octave --eval 'headerlines=17;columnskip=2;frameskip=0;config' ../../view/liveview.m
