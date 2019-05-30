#!/usr/bin/env zsh

ARQUIVO_DE_BANCO_DE_DADOS="banco_de_dados.txt"
TEMP=temp.$$
SEP=:
VERDE="\033[32;1m"
VERMELHO="\033[31;1m"

[ ! -e "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não existe." && exit 1
[ ! -r "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de leitura." && exit 1
[ ! -w "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de escrita." && exit 1

MostaUsuarioNaTela () {
  
    local id="$(echo $1 | cut -d $SEP -f 1)"
    local nome="$(echo $1 | cut -d $SEP -f 2)"
    local email="$(echo $1 | cut -d $SEP -f 3)"

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

ValidaExistenciaUsuario () {
  grep -i -q "$1$SEP" "$ARQUIVO_DE_BANCO_DE_DADOS"
}

InsereUsuario () {
  local nome="$(echo $1 | cut -d $SEP -f 2)"

  if ValidaExistenciaUsuario "$nome"
  then
    echo "ERRO. Usuário já existente!"
  else
    echo "$*" >> "$ARQUIVO_DE_BANCO_DE_DADOS"
    echo "Usuário cadastrado com sucesso!"
  fi
  OrdenaLista
}

ApagaUsuario () {
  ValidaExistenciaUsuario "$1" || return

  grep -i -v "$1$SEP" "$ARQUIVO_DE_BANCO_DE_DADOS" > "$TEMP"
  mv "$TEMP" "$ARQUIVO_DE_BANCO_DE_DADOS"

  echo "Usuário removido com sucesso!"
  OrdenaLista
}

OrdenaLista () {
  sort "$ARQUIVO_DE_BANCO_DE_DADOS" > "$TEMP"
  mv "$TEMP" "$ARQUIVO_DE_BANCO_DE_DADOS"
}
