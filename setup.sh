#! /usr/bin/env bash

dependencies(){
  echo "Installing dependencies"


}


case "$1" in
  dependencies) 
    dependencies
    ;;
  editor) 
    echo "editor not implemented"
    ;;
  *) 
    echo "Hello World"
    ;;
esac 

