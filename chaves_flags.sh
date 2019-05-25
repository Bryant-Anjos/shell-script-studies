#!/usr/bin/env bash

USUARIOS="$(cat /etc/passwd | cut -d : -f 1)"
MENSAGEM_USO="
  $(basename $0) - [OPÇÕES]

  -h - Menu de ajuda
  -v - Versão
  -s - Ordenar a saída
  -m - Coloca em maiúsculo
"
VERSAO="v1.0"
CHAVE_ORDENA=0
CHAVE_MAISCULO=0

while test -n "$1"
do
  case "$1" in
    -h) echo "$MENSAGEM_USO" && exit 0                            ;;
    -v) echo "$VERSAO" && exit 0                                  ;;
    -s) CHAVE_ORDENA=1                                            ;;
    -m) CHAVE_MAISCULO=1                                          ;;
     *) echo "Opção inválida, obtenh ajuda usando o -h" && exit 1 ;;
  esac
  shift
done

[ $CHAVE_ORDENA -eq 1 ]   && USUARIOS=$(echo "$USUARIOS" | sort)
[ $CHAVE_MAISCULO -eq 1 ] && USUARIOS=$(echo "$USUARIOS" | tr [a-z] [A-Z])

echo "$USUARIOS"
