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

RemoverUsuario () {
  local usuarios=$(egrep "^#|^$" -v "$ARQUIVO_DE_BANCO_DE_DADOS" | sort -h | cut -d $SEP -f 1,2 | sed 's/:/ "/;s/$/"/')
  local id_usuario=$(eval dialog --stdout --menu \"Escolha um usuário:\" 0 0 0 $usuarios)

  grep -i -v "^$id_usuario$SEP" "$ARQUIVO_DE_BANCO_DE_DADOS" > $TEMP
  mv "$TEMP" "$ARQUIVO_DE_BANCO_DE_DADOS"

  dialog --msgbox "Usuário removido com sucesso!"
  ListaUsuarios
}

OrdenaLista () {
  sort "$ARQUIVO_DE_BANCO_DE_DADOS" > "$TEMP"
  mv "$TEMP" "$ARQUIVO_DE_BANCO_DE_DADOS"
}

while :
do
  acao=$(dialog --title   "Gerenciamento de Usuários 2.0"         \
                --stdout                                          \
                --menu    "Escolha uma das opções abaixo:"        \
                0 0 0                                             \
                listar    "Listar todos os usuários do sistema"   \
                remover   "Remover um usuário do sistema"         \
                inserir   "Inserir um novo usuário no sistema")
  [ $? -ne 0 ] && exit

  case $acao in
    listar) ListaUsuarios   ;;
    inserir) InsereUsuario  ;;
    remover) RemoverUsuario ;;
  esac
done
