#!/usr/bin/env bash

ARQUIVO_DE_BANCO_DE_DADOS="banco_de_dados.txt"
TEMP=temp.$$
SEP=:
VERDE="\033[32;1m"
VERMELHO="\033[31;1m"

[ ! -e "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não existe." && exit 1
[ ! -r "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de leitura." && exit 1
[ ! -w "$ARQUIVO_DE_BANCO_DE_DADOS" ] && echo "ERRO. Arquivo não tem permissão de escrita." && exit 1
[ ! -x "$(which dialog)" ] && sudo apt install dialog 1> /dev/null 2>&1

ListaUsuarios () {
  egrep -v "^#|^$" "$ARQUIVO_DE_BANCO_DE_DADOS" | tr : ' ' > "$TEMP"
  dialog --title "Lista de Usuários" --textbox "$TEMP" 20 40
  rm -f "$TEMP"
}

ValidaExistenciaUsuario () {
  grep -i -q "$1$SEP" "$ARQUIVO_DE_BANCO_DE_DADOS"
}

InsereUsuario () {
  local ultimo_id="$(egrep -v "^#|^$" $ARQUIVO_DE_BANCO_DE_DADOS | sort | tail -n 1 | cut -d $SEP -f 1)"
  local proximo_id=$((ultimo_id+1))

  local nome=$(dialog --title "Cadastro de Usuários" --stdout --inputbox "Digite o seu nome" 0 0)
  echo $nome
  ValidaExistenciaUsuario "$nome" && {
    dialog --title "ERRO FATAL!" --msgbox "Usuário já cadastrado no sistema!" 6 40
    exit 1
  }

  local email=$(dialog --title "Cadastro de Usuários" --stdout --inputbox "Digite o seu E-mail" 0 0)

  echo "$proximo_id$SEP$nome$SEP$email" >> "$ARQUIVO_DE_BANCO_DE_DADOS"
  dialog --title "SUCESSO" --msgbox "Usuário cadastrado com sucesso!" 6 40

  ListaUsuarios
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
