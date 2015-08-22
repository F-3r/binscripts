#!/bin/bash

case "$1" in
    list) hamachi $1
            ;;
    
    *) hamachi list | grep -i $1 # | grep -v "\[.*\]" | cut -d" " -f13
         ;;
esac
       
