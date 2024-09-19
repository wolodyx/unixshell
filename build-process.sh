#!/bin/bash

while inotifywait -r -e modify .; do
  jupyter-book build --builder html .
done

