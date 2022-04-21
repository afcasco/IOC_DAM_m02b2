#!/bin/bash
#aquesta versio esta feta amb un array associatiu
#version using associative array
DIR_DOCS="matricula/docs"
DIR_M="matricula"

if [ -d $DIR_M ]; then
   read -p "El directori matricula existeix. Eliminar i seguir (S/N) " -n 1 -r && echo
   if [[ ! $REPLY =~ ^[Ss]$ ]]; then exit 0; else rm -rf $DIR_M; fi
fi

FILE=$1; i=0; declare -A ardades

while IFS=, read -r -a line; do
   for ((j = 0; j < ${#line[@]}; ++j)); do
        ardades[$i,$j]=${line[$j]} 
   done
   mkdir -p $DIR_DOCS && touch "$DIR_DOCS/${ardades[$i,2]}"
   if [[ ! -d $DIR_M/${ardades[$i,2]} ]]
      then
         mkdir -p "$DIR_M/${ardades[$i,2]}" && echo "Directori ${ardades[$i,2]} creat"
   fi
   mkdir -p "$DIR_M/${ardades[$i,2]}/${ardades[$i,0]}"
   echo "Directori de ${ardades[$i,0]} en modul ${ardades[$i,2]} creat"
   echo "${ardades[$i,0]}: ${ardades[$i,1]}" >> "$DIR_DOCS/${ardades[$i,2]}"
   ((i++))
done < $FILE
