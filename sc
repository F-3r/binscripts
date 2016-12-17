#!/bin/bash

jackd -dalsa -dhw:1,0 &
scsynth -u 57110 &
scide
