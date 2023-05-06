#!/bin/bash

opc=0
acceso=0
letter="a"
d=`date +%d-%m-%Y`
h=`date +%H:%M`

while [ $opc -ne 3 ] ; do

clear

echo "Bienvenido!"
echo
echo "1)Opcion 1. Ingresar Usuario y Contrasena"
echo "2)Opcion 2. Ingrese al Sistema."
echo "3)Salir del Sistema."
read -p "Seleccione una opcion: " opc

case $opc in

	1)clear
		while read -p "Desea crear un nuevo usuario? (S/N): " crearUsuario && [[ "$crearUsuario" == "S" || "$crearUsuario" == "s" ]]
		do
			echo "Ingrese nombre de usuario"
			read username
			echo "Ingrese contrasena"
			read password
			
		if [[ ! -e log.txt ]]; then
				touch log.txt
		fi

		echo $username $password $d >> log.txt
		done
		sleep 3
		;;
	2)clear	
		read -p "Ingrese usuario para ingresar al sistema " userLogin
		read -p "Ingrese contrasena " passLogin
		echo
		credencial="$userLogin $passLogin"
		lastLogin=$(grep -oP "$userLogin $passLogin \K.*" log.txt)
		existe=$(grep -o "$credencial" log.txt)
		
		if [[ $existe == "$credencial" ]]; 
		then
		acceso=1
		echo "Ingresando al sistema ..."
		sed -i "s/$lastLogin/$d/g" log.txt
		else
		echo "Usuario y/o contrasena invalidos"
		echo "Volviendo al menu principal..."
		acceso=0
		fi

		sleep 2
		clear
		
		opcSistema=0

		while [ $opcSistema -ne 6 ] && [ $acceso -gt 0 ];
		do
			echo "Bienvenido $userLogin."
			echo "Usted ingreso por ultima vez el $lastLogin"
			echo
			echo "1) Cambiar Contrasena."
			echo "2) Escoger una letra."
			echo "3) Buscar palabras en el diccionario que finalicen con la letra escogida."	
			echo "4) Contar las palabras de la Opcion 3."
			echo "5) Guardar las palabras en un archivo.txt, en conjunto con la fecha y hora de realizado el informe."
			echo "6)Volver al Menu Principal"
		read -p "Seleccione una opcion: " opcSistema
		case $opcSistema in
			1)clear
				read -p "Ingrese nueva contrasena " newpass
				sed -i "s/$passLogin/$newpass/g" log.txt
				echo "Su contrasena ha sido actualizada"
				sleep 2
				clear
				;;
			2)clear
				read -p "Ingrese una letra " letter
				echo
				echo "La letra $letter ha sido guardada"

				sleep 2
				clear
				;;
			3)clear

				grep -a "$letter$" diccionario.txt
				sleep 3
				clear
				;;
			4)clear
				cantidad=$(grep -c "$letter$" diccionario.txt)
				echo "Cantidad de palabras que finalizan con la letra $letter : $cantidad"
				sleep 4
				clear
				;;
			5)clear
				nombreFichero="informe_"$d"_"$h"_"$letter".txt"
				echo "Guardando resultado de busqueda como $nombreFichero..."
				grep -a "$letter$" diccionario.txt >> "$nombreFichero"
				sleep 4
				clear
				;;

		esac		
		done
		sleep 2
		;;
	3)clear
		echo "Cerrando sistema..."
		sleep 2
		clear
		;;
	*)clear
		echo "$opc no es una opcion valida"
		sleep 2
		clear
		;;
esac	
done
