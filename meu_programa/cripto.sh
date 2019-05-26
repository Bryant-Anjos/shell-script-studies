#!/usr/bin/env bash
#
# cripto.sh - Criptografa strings com o sha256
#
# Autor: Bryant 
#
# ------------------------------------------------------------------------- #
# Programa para guardar textos no formato de Hash em um arquivo, armazenando
# também a data, o usuário e um comentário caso desejar.
# Depois de armazenado é possível validar textos com o valores salvos.
# (Não utilizar para gurardar informações confidenciais como, por exemplo,
# senhas)
#
# Exemplos:
#     $ ./cripto.sh -c "seu texto aqui" "exemplo" 
#       Neste exemplo o texto "seu texto aqui" será armazenado na forma do
#       sha256 no arquivo exemplo.
#
#     $ ./cripto.sh -v "seu texto aqui" "exemplo"
#       Neste exemplo o programa irá verificar se o texto "seu texto aqui"
#       está dentro do arquivo exemplo.
# ------------------------------------------------------------------------- #
# Histórico:
#
# v0.1 25/05/2019, Bryant:
#     - Criado a função de Salvar strings em HASH em arquivo
# v0.2 25/05/2019, Bryant:
#     - Adicionado a validação de textos em HASH
# v0.3 26/05/2019, Bryant:
#     - Adicionado a possibilidade de adicionar comentários e algumas outras
#       modificações na estrutura do programa.
# v0.4 26/05/2019, Bryant:
#     - Agora quando é encontrada uma correspondência na validação, a saída
#       retorna o usuário, data, hora e comentário caso houver.
# ------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.19
# ------------------------------------------------------------------------- #
# Agradecimentos:
#
#   Mateus Müler - Por ensinar os conhecimentos aplicados nesse programa.
# ------------------------------------------------------------------------- #
# TODO
#
#   Adicionar opção de verificar o usuário caso a validação retorne True.
#   Adicionar opção de verificar a data caso a validação retorne True.
#   Adicionar opção de verificar o horário caso a validação retorne True.
#   Adicionar opção de verificar o comentário caso a validação retorne True.
#   Adicionar opção de remover um registro caso a validação retorne True.
#   Adicionar possibilidade dde criptografar com Salt.
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
  -a - Define o usuário como anônimo.
  -m - Adiciona um comentário.
          Usabilidade: -m <COMENTARIO>
"
VERSAO="v0.4"
HASH=""
USER="$(whoami)"
CHAVE_CRIPTOGRAFA=0
CHAVE_VALIDA=0
COMENTARIO=""

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

  HASH="$(echo -n $1 | sha256sum | cut -d " " -f 1);$(Data);$USER$COMENTARIO"
  echo "$HASH" >> $2
}

Valida () {
  local STRING_VERIFICA=$(echo -n $1 | sha256sum | cut -d " " -f 1)
  local HASH_LIST=$(cat $2 | cut -d ";" -f 1)
  for HASH_VERIFICA in $HASH_LIST; do
    if [ "$STRING_VERIFICA" = "$HASH_VERIFICA" ]; then
      echo "Usuário: $(grep -m 1 "$STRING_VERIFICA" $2 | cut -d ";" -f 4)"
      echo "Data: $(grep -m 1 "$STRING_VERIFICA" $2 | cut -d ";" -f 2)"
      echo "Hora: $(grep -m 1 "$STRING_VERIFICA" $2 | cut -d ";" -f 3)"
      COMENTARIO=$(grep -m 1 "$STRING_VERIFICA" $2 | cut -d ";" -f 5)
      [ $COMENTARIO ] && echo "Comentário: $COMENTARIO"
      exit 0
    fi
  done
  echo "Nenhuma correspondência encontrada."
}

# ------------------------------------------------------------------------- #

# -------------------------- EXECUÇÃO ------------------------------------- #

while test -n "$1"
do
  case "$1" in
    -h) echo "$HELP" && exit 0                                     ;;
    -v) echo "$VERSAO" && exit 0                                   ;;
    -c) CHAVE_CRIPTOGRAFA=1
        TEXTO="$2"
        shift
        NOME_ARQUIVO="$2"
        shift                                                      ;;
    -a) USER="anonymous"                                           ;;
    -d) CHAVE_VALIDA=1
        TEXTO="$2"
        shift
        NOME_ARQUIVO="$2"
        shift                                                      ;;
    -m) [ $2 ] && COMENTARIO=";$2" && shift                        ;;
     *) echo "Comando inválido. Veja as opções disponíveis com -h" ;;
  esac
  shift
done

[ $CHAVE_CRIPTOGRAFA -eq 1 ] && Criptografa $TEXTO $NOME_ARQUIVO
[ $CHAVE_VALIDA -eq 1 ] && Valida $TEXTO $NOME_ARQUIVO

# ------------------------------------------------------------------------- #

