#!/bin/bash

# Functions
# TODO Take version from image label
shortVersion() {
  echo $1 | grep -oE '[0-9]+\.[0-9]+'
}
