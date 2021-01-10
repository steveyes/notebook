#!/usr/bin/env bash

grep -rnwP --color  '\t' * | grep -v 'Binary file'
