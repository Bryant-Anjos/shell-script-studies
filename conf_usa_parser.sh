#!/usr/bin/env bash

ARQUIVO_DE_CONFIGURACAO="configuracao.cf"
USAR_MAIUSCULAS=
USAR_CORES=
MENSAGEM="Mensagem de teste"
VERMELHO="\033[31;1m"

eval $(./parser.sh $ARQUIVO_DE_CONFIGURACAO)

[ "$(echo $CONF_USAR_MAIUSCULAS)" = "1" ] && USAR_MAIUSCULAS=1
[ "$(echo $CONF_USAR_CORES)" = "1" ] && USAR_CORES=1

[ "$USAR_MAIUSCULAS" = "1" ] && MENSAGEM="$(echo -e $MENSAGEM | tr [a-z] [A-Z])"
[ "$USAR_CORES" = "1" ] && MENSAGEM="$(echo -e ${VERMELHO}$MENSAGEM)"

echo -e "$MENSAGEM"
