#!/bin/bash
g++ polycont/cpp/examples/test_io.cpp          clipper/clipper.cpp -std=c++11 -I. -Ipolycont -o polycont/cpp/examples/test_io.$OSTYPE
g++ polycont/cpp/examples/example_polycont.cpp clipper/clipper.cpp -std=c++11 -I. -Ipolycont -o polycont/cpp/examples/example_polycont.$OSTYPE
#-DNDEBUG