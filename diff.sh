#!/bin/bash

TEST_FILE="./test.json"

./complex_mods.rb > $TEST_FILE
bcomp original_complex_mods.json $TEST_FILE
rm $TEST_FILE
