#!/usr/bin/env bash
#
# Controle_de_Estoque.sh - Controle dos matérias que uso no meu trabalho.
#
# Site:           https://seusite.com.br
# Autor           Hector
# Manuntenção:    Hector
#
# ----------------------------------------------------------------------
#   O programa é um protótipo de um projeto que estou fazendo para a
#   empresa que eu trabalho, ele gerencia o estoque de matérias
#   da produção, podendo adicionar, remover, listar.
#
# Exemplos:
#     $ ./Controle_de_Estoque.sh -v
#       Ele mostra a versão do programa.
#     $ ./Controle_de_Estoque.sh -h
#       Mostra o menu de Ajuda
#     $ ./Controle_de_Estoque.sh -a
#       Entra na opção de adicionar item exemplo de uso:
#         $ ./Controle_de_Estoque.sh -a tinta:ciano:solvente
#     $ ./Controle_de_Estoque.sh -r
#       Entra na função de remover produtos, aqui você não vai passar nada
#       apenas entra nessa função e responder as perguntas sobre o produto.
#     $ ./Controle_de_Estoque.sh -l
#       Vai listar todos os itens que tem no estoque.
# ----------------------------------------------------------------------
# Histórico:
#
#     v1 15/04/2025/, Hector Lazzari:
#           - Construção do sistema e adição das funcionalidades.
# ----------------------------------------------------------------------
# Testado em (bash --version):
#     bash 5.2.37
# ----------------------------------------------------------------------
# ----------------------------Variáveis---------------------------------
estoque="Estoque.txt"
sep=":"
aux=temp.$$
verde="\033[32;1m"
vermelho="\033[31;1m"

versao="v1"

menu="
  $0
  [Opções]
  -h = menu de ajuda
  -v = versão
  -a = adicionar produto
  -r = remover produto
  -l = listar produtos
"
# ----------------------------Testes------------------------------------
[ ! -r "$estoque" ] && echo "ERRO: arquivo não pode ser lido."
[ ! -w "$estoque" ] && echo "ERRO: arquivo não pode ser escrito."
[ ! -e "$estoque" ] && echo "ERRO: arquivo não existe."
[ ! -x "$0" ] && echo "ERRO: não tem permissão de execução"
# ----------------------------Função------------------------------------
function ListarProdutos() {
  while read -r linha
  do
    [ "$(echo $linha | cut -c1)" = "#" ] && continue
    [ ! "$linha" ] && continue
    MostrarProdutos "$linha"
  done < "$estoque"
}

function MostrarProdutos() {
  local produto="$(echo "$1" | cut -d $sep -f 1)"
  local tipo="$(echo "$1" | cut -d $sep -f 2)"
  local tamanho_diluente="$(echo "$1" | cut -d $sep -f 3)"

  echo -e "${verde}PRODUTO: ${vermelho}$produto"
  echo -e "${verde}TIPO: ${vermelho}$tipo"
  echo -e "${verde}TAMANHO OU DILUENTE: ${vermelho}$tamanho_diluente\n"
}

function ValidarProduto() {
  grep -i "$1$sep$2" "$estoque"
}

function AdicionarProduto() {
  echo $1 >> "$estoque"
  echo -e "${verde}Inserido com sucesso!"
  OrdenarLista

}

function OrdenarLista() {
  sort "$estoque" > "$aux"
  mv "$aux" "$estoque"
}

function RemoverProduto() {
  echo -e "${vermelho}Informe o item que você deseja remover"
  echo "Informe o tipo do produto."
  read tipo
  echo "Informe o tamanho ou diluente do produto."
  read tamanho_diluente

  if ! ValidarProduto "$tipo" "$tamanho_diluente"
  then
    echo -e "${vermelho}Produto não encontrado no estoque"
    return
  fi

  grep -i -v "$tipo$sep$tamanho_diluente" "$estoque" > "$aux"
  mv "$aux" "$estoque"

  echo -e "${verde}Produto removido com sucesso!"
}

# ----------------------------Execução----------------------------------
while test -n "$1"
do
  case $1 in
     -h) echo "$menu"                                ;;
     -v) echo "$versao" && exit 0                    ;;
     -a) shift
         produto="$1"
         if [ -z "$produto"]; then
          echo "ERRO: nenhum produto informado"
         else
          AdicionarProduto "$1"
         fi                                          ;;
     -r) RemoverProduto                              ;;
     -l) ListarProdutos                              ;;
      *) echo "Opção inválida $1"                    ;;
  esac
  shift
done