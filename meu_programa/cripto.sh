#!/usr/bin/env bash
#
# cripto.sh - Criptografa strings com o sha256
#
# Autor: Bryant 
#
# ------------------------------------------------------------------------- #
# Aqui você deve utilizar uma descrição mais detalhada sobre o seu programa,
# explicando a forma de utilizar.
#
# Exemplos:
#     $ ./nomeDoScript.sh -d 1
#     Neste exemplo o script será executado no modo debug nível 1.
# ------------------------------------------------------------------------- #
# Histórico:
#
# v0.1 25/05/2019, Bryant:
#     - O que mudou?
# ------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.19
# ------------------------------------------------------------------------- #
# Agradecimentos:
#
#   Mateus Müler - Por ensinar os conhecimentos aplicados nesse programa.
# ------------------------------------------------------------------------- #

# -------------------------- VARIÁVEIS ------------------------------------ #
HELP="
  $(basename $0) - [OPÇÔES]

  -h - Menu de ajuda
  -v - Versão
  -a - Define o usuário como anônimo
"
VERSAO="v0.1"
HASH=""
USER="$(whoami)"
# ------------------------------------------------------------------------- #

# -------------------------- TESTES --------------------------------------- #

# ------------------------------------------------------------------------- #

# -------------------------- FUNÇÕES -------------------------------------- #

Data () {
  date +%d/%m/%y";"%T
}

Criptografa () {
  if [ ! $1 ] && [ ! $2 ]; then
    echo "Um ou mais argumentos faltando. Veja -h para obter ajuda" && exit 0
  fi

  HASH="$(echo -n $1 | sha256sum | cut -d " " -f 1);$(Data);$USER"
  echo "$HASH" >> $2
}

# ------------------------------------------------------------------------- #

# -------------------------- EXECUÇÃO ------------------------------------- #

while test -n "$1"
do
  case "$1" in
    -h) echo "$HELP" && exit 0                                     ;;
    -v) echo "$VERSAO" && exit 0                                   ;;
    -c) Criptografa $2 $3                                          ;;
    -a) USER="anonymous"                                           ;;
#    *) echo "Comando inválido. Veja as opções disponíveis com -h" ;;
  esac
  shift
done

# ------------------------------------------------------------------------- #

