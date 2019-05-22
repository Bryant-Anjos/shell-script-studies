#!/usr/bin/env bash

NOME="Bryant dos Anjos"

echo "$NOME"

NUMERO_1=23
NUMERO_2=45

TOTAL=$(($NUMERO_1+$NUMERO_2))

echo "$TOTAL"

SAIDA_CAT=$(cat /etc/passwd | grep brilliant)

echo "$SAIDA_CAT"

echo "-------------------------------------------------"

echo "Parâmetro 1: $1"
echo "Parâmetro 2: $2"

echo "Todos os parâmetros: $*"

echo "Quantos parâmetros? $#"

echo "Saída do último comando: $?"

echo "PID: $$"

echo "$0"
