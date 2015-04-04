#!/bin/sh
octave --eval demo | octave --eval 'headerlines=17;columnskip=2' ../view/liveview.m
