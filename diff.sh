#!/bin/bash

TEST_FILE="./test.json"

rm $TEST_FILE
./complex_mods.rb > $TEST_FILE
bcompare -ro "control_for_testing.json" "$TEST_FILE"
