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
#     - Criado a função de Salvar strings em HASH em arquivo
# v0.2 25/05/2019, Bryant:
#     - Adicionado a validação de textos em HASH
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

  -h - Menu de ajuda.
  -v - Versão.
  -c - Criptografa uma string e salva em um arquivo.
          Usabilidade: -c <TEXTO> <NOME DO ARQUIVO>
  -d - Verifica se a String está salva em um determinado arquivo
          Usabilidade: -d <TEXTO> <ARQUIVO>
  -a - Define o usuário como anônimo. Colocar antes de -c.
"
VERSAO="v0.2"
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

Valida () {
  local STRING_VERIFICA=$(echo -n $1 | sha256sum | cut -d " " -f 1)
  local HASH_LIST=$(cat $2 | cut -d ";" -f 1)
  for HASH_VERIFICA in $HASH_LIST; do
    [ "$STRING_VERIFICA" = "$HASH_VERIFICA" ] && echo "Verdadeiro" && exit 0
  done
  echo "Falso"
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
    -d) Valida $2 $3                                               ;;
#    *) echo "Comando inválido. Veja as opções disponíveis com -h" ;;
  esac
  shift
done

# ------------------------------------------------------------------------- #

