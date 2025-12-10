#!/usr/bin/env bash
brew deps --installed | awk -f "$(dirname "$0")/filter.awk"
