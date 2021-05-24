#!/usr/bin/env bash

#=============================================================#
# Autor            : Pedrovisk <pedrovisk.unix@gmail.com>
# Data de criação  : 24/05/21
# Última alteração : 24/05/21
# Descrição        :
#    Pequeno script escrito em shell bash que consulta dados
#    sobre o covid utilizando o site "worldometers" como
#    site de consulta.
#
# Dependências     :      curl
#=============================================================#

HTML_SOURCE="$(curl -s 'https://www.worldometers.info/coronavirus/')"

if (("$?" != 0))
then
	echo "Não foi possível se conectar com o servidor de consulta. Verifique a sua internet." >&2
	exit 1
fi

INFORMATIONS_ABOUT_COVID="$(echo $(sed '/^<span[^n]*>[0-9]/!d; s/<[^>]*>//g; s/,/./g' <<< "$HTML_SOURCE"))"
LAST_UPDATE="$(sed '/Last updated/!d; s/<[^>]*>//g; s/^.*: //' <<< "$HTML_SOURCE")"

echo -e "Casos de covid:\t$(cut -d ' ' -f 1 <<< "$INFORMATIONS_ABOUT_COVID")"
echo -e "Mortes:\t\t$(cut -d ' ' -f 2 <<< "$INFORMATIONS_ABOUT_COVID")"
echo -e "Recuperados:\t$(cut -d ' ' -f 3 <<< "$INFORMATIONS_ABOUT_COVID")"
echo -e "\nÚltima vez atualizado: $LAST_UPDATE"
