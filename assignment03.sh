#!/usr/bin/env bash
#
# estrelinhas.sh - imprime várias estrelinhas no terminal
#
# Autor:      Gabriel Müler
# Manutenção: Bryant
#
# ------------------------------------------------------------------------- #
# Usabilidade
#     $ ./estrelinhas.sh
# ------------------------------------------------------------------------- #
# Histórico:
#
# v1.0 30/10/2018, Gabriel Müler:
#     - Criado o código do programa.
# v1.1 25/05/2019, Bryant:
#     - Adicionadas identação e cabeçalho.
# ------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.19
# ------------------------------------------------------------------------- #

# -------------------------- VARIÁVEIS ------------------------------------ #

comeca=0
ate=100

# -------------------------- TESTES --------------------------------------- #

# Início maior que fim?
[ $comeca -ge $ate ] && exit 1


# -------------------------- EXECUÇÃO ------------------------------------- #

for i in $(seq $comeca $ate); do
  for j in $(seq $i $ate); do
    printf "*"
  done
  printf "\n"
done

