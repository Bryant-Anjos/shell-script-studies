#!/usr/bin/env bash
#
# github-extractor.sh - Verificar repositórios do GitHub pelo terminal
#
# Autor: Bryant
#
# ------------------------------------------------------------------------- #
# Aqui você deve utilizar uma descrição mais detalhada sobre o seu programa,
# explicando a forma de utilizar.
#
# Exemplos:
#     $ ./github-extractor.sh -q "Linux" -p 2
#       Pesquisa no site do GitHub o termo Linux na página 2
# ------------------------------------------------------------------------- #
# Histórico:
#
# v0.1 26/05/2019, Autor da mudança:
#     - Iniciado o programa que utiliza o Lynx como navegador via terminal,
#       fazendo pesquisas no site do github e extraindo os repositórios
# ------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.19
# ------------------------------------------------------------------------- #

# -------------------------- VARIÁVEIS ------------------------------------ #
VERSION="v0.1"
HELP="
  $(basename $0) - [OPÇÕES]
  
  -h - Menu de ajuda.
  -v - Versão.
  -q - Pesquisa um texto no Github
        Usabilidade: -q <TEXTO>
  -p - Define a página a ser pesquisada. (Padrão 1).
        usabilidade -p <NÚMERO-DA-PÁGINA>
"

SEARCH=""
PAGE="1"

VERDE="\033[32;1m"
VERMELHO="\033[33;1m"
CIANO="\033[36;1m"

# ------------------------------------------------------------------------- #

# -------------------------- TESTES --------------------------------------- #

if [ ! -x "$(which lynx)" ]; then
  while true; do
    read -p "O lynx não está instalado, gostaria de instalar? (y/n): " yn
    case $yn in
      [Yy]) sudo apt install lynx -y; break    ;;
      [Nn]) exit 0                             ;;
      *   ) echo "Por favor, responda y ou n." ;;
    esac
  done
fi
# ------------------------------------------------------------------------- #

# -------------------------- FUNÇÕES -------------------------------------- #

Extractor () {
  lynx -source "https://github.com/search?q=$SEARCH&p=$PAGE" \
                | grep "https://github.com/.*&quot;}"        \
                | sed 's/&quot;//g;s/ *<a.*href="\///;s/\">.*//'
}

CutUsers () {
  USERS=$(Extractor | cut -d "/" -f 1)
}

CutRepositories () {
  REPOSITORIES=$(Extractor | cut -d "/" -f 2)
}

PrintResult () {
  local SIZE=$(echo "$USERS" | wc -l)
  local user=($USERS)
  local repository=($REPOSITORIES)
  for ((i=0; i<$SIZE; i++)); do
    echo -e "${VERMELHO}User: ${VERDE}${user[$i]}"
    echo -e "${VERMELHO}Repository: ${VERDE}${repository[$i]}"
    echo -e "${VERMELHO}url: ${CIANO}https://github.com/${user[$i]}/${repository[$i]}"
    echo
  done
}

# ------------------------------------------------------------------------- #

# -------------------------- EXECUÇÃO ------------------------------------- #


while test -n "$1"
do
  case "$1" in
    -h) echo "$HELP"                                            ;;
    -v) echo "$VERSION"                                         ;;
    -q) SEARCH="$2"
        shift                                                   ;;
    -p) PAGE="$2"
        shift                                                   ;;
     *) echo "Opção inválida, verifique o -h para obter ajuda." ;;
  esac
  shift
done

if [ $SEARCH ]; then
  CutUsers
  CutRepositories
  PrintResult 
fi

# ------------------------------------------------------------------------- #
