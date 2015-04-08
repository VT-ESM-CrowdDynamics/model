#!/bin/sh
octave --eval demo | octave --eval 'headerlines=17;columnskip=2;frameskip=0;config' ../../view/liveview.m
