#!/bin/bash

case $# in
 1 ) mode=$1 ;;
 *) echo "chiamare il programma sudo sh settings modalità (wan or lan)"; exit;;
esac

case $mode in
 "lan" ) ./lan.sh ;;
 "wan" ) ./wan.sh ;;
 *) echo "chiamare il programma sudo sh settings modalità (wan or lan)"; exit;;
esac
