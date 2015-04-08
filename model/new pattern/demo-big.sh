#!/bin/sh
octave --eval demo_big | octave --eval 'headerlines=17;columnskip=2;frameskip=0' ../../view/liveview.m
