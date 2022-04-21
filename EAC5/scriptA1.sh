#!/bin/bash 
#Aquesta versio esta feta sense arrays
DIR="matricula"
DIR_DOC="matricula/docs"

if [ -d $DIR ]; then
	read -p "El directori matricula existeix. Eliminar i seguir (S/N) " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Ss]$ ]]; then exit 0; else rm -rf $DIR; fi
fi

FILE=$1
while IFS="," read -r i j k; do
	if [[ ! -d $DIR/${k} ]]
		then
			mkdir -p "$DIR/${k}" && echo "Directori ${k} creat"
	fi
	mkdir -p "$DIR/${k}/${i}" && echo "Directori de ${i} en modul ${k} creat"
	mkdir -p "$DIR_DOC" && touch "$DIR_DOC/${k}"
	echo "${i}: ${j}" >> "$DIR_DOC/${k}"
done < $FILE
