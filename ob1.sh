#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"


opc=0
acceso=0
letter="a"
d=`date +%d-%m-%Y`
h=`date +%H:%M`

## Prints output on green
function logger_info() {
	echo -e "${GREEN} ${1} ${NC}"
}

## Prints output on red
function logger_error() {
	echo -e "${RED} ${1} ${NC}"
}

## Prints output on red
function logger_warn() {
	echo -e "${YELLOW} ${1} ${NC}"
}

function print_welcome() {
	echo "Bienvenido $1."
	echo "Usted ingreso por ultima vez el $2"
	echo
	echo "1) Cambiar Contrasena."
	echo "2) Escoger una letra."
	echo "3) Buscar palabras en el diccionario que finalicen con la letra escogida."	
	echo "4) Contar las palabras de la Opcion 3."
	echo "5) Guardar las palabras en un archivo.txt, en conjunto con la fecha y hora de realizado el informe."
	echo "6)Volver al Menu Principal"
}

## touch no sobreescribe el archivo si ya existe previamente
touch log.txt

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
		while true
		do
			echo -e "Ingrese nombre de usuario\n"
			read username
			grep -q -E "^$username" "log.txt" >> /dev/null 2>&1
			if [[ $? -eq 0 ]] ; then
				logger_warn "Usuario ya existe"
			else 
				echo -e "Ingrese contrasena\n"
				read password
				echo $username $password $d >> log.txt

			fi
			read -p "Desea crear un nuevo usuario? (S/N): " bool
			if [[ $bool == "N" || $bool == "n" ]]; then
				break
			fi
		done
		sleep 3
		;;
	2)clear	
		read -p "Ingrese usuario para ingresar al sistema: " userLogin
		read -p "Ingrese contrasena: " passLogin
		echo

		##########
		credencial="$userLogin $passLogin"
		existe=$(grep -o "$credencial" log.txt)
		lastLogin=$(cat log.txt | grep -e "$userLogin" | awk '{print $3}')
		########## revisar esto
		
		if [[ $existe == "$credencial" ]]; 
		then
			acceso=1
			logger_info "Ingresando al sistema ..."
			sed -i -E "/^$userLogin/s/[0-9]{2}-[0-9]{2}-[0-9]{4}/$(date +%d-%m-%Y)/" log.txt
		else
			logger_error "Usuario y/o contrasena invalidos"
			echo "Volviendo al menu principal..."
		acceso=0
		fi

		sleep 2
		clear
		
		opcSistema=0

		while [ $opcSistema -ne 6 ] && [ $acceso -gt 0 ];
		do
			print_welcome $userLogin $lastLogin
		read -p "Seleccione una opcion: " opcSistema
		case $opcSistema in
			1)clear
				read -p "Ingrese nueva contrasena " newpass
				## Reemplaza la contraseña solo si coincide el usuario con la contraseña
				sed -i "/^$userLogin $passLogin/s/$passLogin/$newpass/g" log.txt
				logger_info "Su contrasena ha sido actualizada"
				sleep 2
				clear
				;;
			2)clear
				read -p "Ingrese una letra " letter
				echo
				logger_info "La letra $letter ha sido guardada"

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
				logger_info "Cantidad de palabras que finalizan con la letra $letter : $cantidad"
				sleep 4
				clear
				;;
			5)clear
				nombreFichero="informe_"$d"_"$h"_"$letter".txt"
				logger_info "Guardando resultado de busqueda como $nombreFichero..."
				grep -a "$letter$" diccionario.txt >> "$nombreFichero"
				sleep 4
				clear
				;;

		esac		
		done
		sleep 2
		;;
	3)clear
		logger_info "Cerrando sistema..."
		sleep 2
		clear
		;;
	*)clear
		logger_error "$opc no es una opcion valida"
		sleep 2
		clear
		;;
esac	
done

