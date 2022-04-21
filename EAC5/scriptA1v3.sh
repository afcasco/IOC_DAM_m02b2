#!/bin/bash
#aquesta versio esta feta amb un array amb index numerics, saltant de 3 en 3 per buscar el camp correcte
#this version uses a normal 'index' array with a 3 step 
dir_m="matricula"
dir_doc="matricula/docs"

if [ -d $dir_m ]; then
	read -p "El directori matricula existeix. Eliminar i seguir (S/N) " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Ss]$ ]]; then exit 0; else rm -rf $dir_m; fi
fi

file=$(sed 'H;1h;$!d;x;y/\n/,/' $1) 
mkdir -p $dir_doc
IFS=',' read -a dades <<< $file
for ((i = 2 ; i < "${#dades[@]}" ; ((i+=3))))
do
	if [[ ! -d $dir_m/${dades[i]} ]]; then mkdir -p "$dir_m/${dades[i]}" && echo "Directori ${dades[i]} creat"; fi
	mkdir -p "$dir_m/${dades[i]}/${dades[((i-2))]}" && echo "Directori de ${dades[((i-2))]} en ${dades[i]} creat"
	touch "$dir_doc/${dades[i]}" && echo "${dades[((i-2))]}: ${dades[((i-1))]}" >> "$dir_doc/${dades[i]}"
done

