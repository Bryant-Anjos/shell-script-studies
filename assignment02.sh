#!/usr/bin/env bash

for numero in $(seq 0 10); do
    [[ $(($numero % 2)) -eq 0 ]] && echo "$numero é par" || echo "$numero é ímpar"
done
