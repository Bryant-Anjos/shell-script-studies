#!/usr/bin/env zsh

ARQUIVO_DE_BANCO_DE_DADOS="banco_de_dados.txt"

VERDE="\033[32;1m"
VERMELHO="\033[31;1m"

[ ! -e "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não existe." && exit 1
[ ! -r "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de leitura." && exit 1
[ ! -w "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de escrita." && exit 1

MostaUsuarioNaTela () {
  
    local id="$(echo $1 | cut -d : -f 1)"
    local nome="$(echo $1 | cut -d : -f 2)"
    local email="$(echo $1 | cut -d : -f 3)"

    echo -e "${VERDE}ID: ${VERMELHO}$id"
    echo -e "${VERDE}Nome: ${VERMELHO}$nome"
    echo -e "${VERDE}E-mail: ${VERMELHO}$email"
}

ListaUsuarios () {
  while read -r linha
  do
    [ "$(echo $linha | cut -c1)" = "#" ] && continue
    [ ! "$linha" ] && continue

    MostaUsuarioNaTela "$linha"
  done < "$ARQUIVO_DE_BANCO_DE_DADOS"
}
