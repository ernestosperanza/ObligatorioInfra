#!/bin/bash
# Obligatorio Infraestructura

## Colores
green='\033[0;32m' 
blue='\033[0;34m'
clear='\033[0m'
red='\033[0;31m'

## SetColores
ColorGreen(){
	echo -e ${green}${1}${clear}
}
ColorBlue(){
	echo -e ${blue}${1}${clear}
}
ColorRed(){
    echo -e ${red}${1}${clear}
}

## Variables
letra=""
nombre=""
usuario=""
existe=""

function configurarVariables() {
    # Chekear si la letra esta ingresada
    if [ "$letra" = "" ]; then
        echo "Ingrese la letra"
        read letra
        ## letra no vocal error y volver
        if ! [[ $letra =~ [aeiou]{1} ]]; then
            ColorRed "Error, la letra ingresada no es una vocal \n"
            letra=""
            return
        fi
    fi

    if [ "$nombre" = "" ]; then
        echo "Ingrese el directorio"
        read nombre
        if [[ $nombre =~ [0-9A-Z] ]]; then
            ColorRed "Error, el directorio ingresado contiene letras fuera de la a-z \n"
            nombre=""
            return
        fi
    fi
        
    if [ "$usuario" = "" ]; then
        echo "Ingrese el usuario"
        read usuario
        if ! [[ $usuario =~ [a-z] ]]; then
            ColorRed "Error, el usuario ingresado no es una letra \n"
            usuario=""
            return
        else
           existe=$(cut -d: -f1 /etc/passwd | grep -w $usuario)
           if [ "$existe" = "" ]; then
            ColorRed "Error, el usuario ingresado no es valido, ingrese un usuario valido. Seleccione entre:" 
            echo $(cut -d: -f1 /etc/passwd)
            usuario=""
            return
           fi
        fi
    fi
}

function obtenerInforme() {
    if [[ $letra != "" ]] && [[ $nombre != "" ]] && [[ $usuario != "" ]]; then
        echo "--------------------------------------------------------------------------------" 
        echo "------------------------------   Informe  --------------------------------------" 
        # Contar la cantidad de palabras que comienzan con la letra seleccionada
        echo -e "${blue}Cantidad de palabras que comienzan con la letra $letra:${clear}" 
        cat ${nombre}/diccionario.txt | grep -c "^${letra}"
        #La cantidad de palabras que finalizan con la letra seleccionada.
        echo -e "${blue}Cantidad de palabras que finalizan con la letra $letra:${clear}" 
        cat ${nombre}/diccionario.txt | grep -c "${letra}$" 
        # La cantidad de palabras que contienen al menos una vez la letra seleccionada.
        echo -e "${blue}Cantidad de palabras que contienen al menos una vez la letra $letra:${clear}" 
        cat ${nombre}/diccionario.txt | grep -c "${letra}"
        echo "--------------------------------------------------------------------------------" 
        echo "--------------------------------------------------------------------------------" 
    else 
        echo "$(ColorRed '----------------------  Error  ---------------------')"
        echo "$(ColorRed 'Debe configurar todas las variables primero.')"
        echo "$(ColorRed '--------------------------------------------------')"
    fi
}

function guardarInforme() {
    if [[ $letra != "" ]] && [[ $nombre != "" ]] && [[ $usuario != "" ]]; then
        #Antes de escribir el archivo borrar si existe
        rm -f ${nombre}/solucion.txt
        # Creo el archivo de nuevo con la fecha y hora
        date >> ${nombre}/solucion.txt
        echo "--------------------------------------------------------------------------------" >> ${nombre}/solucion.txt
        echo "------------------------------   Informe  --------------------------------------" >> ${nombre}/solucion.txt
        echo "--------------------------------------------------------------------------------" >> ${nombre}/solucion.txt
        # Agrego el informe
        echo "Cantidad de palabras que comienzan con la letra $letra:" >> ${nombre}/solucion.txt
        cat ${nombre}/diccionario.txt | grep -c "^${letra}" >> ${nombre}/solucion.txt
        echo "Cantidad de palabras que finalizan con la letra $letra:" >> ${nombre}/solucion.txt
        cat ${nombre}/diccionario.txt | grep -c "${letra}$" >> ${nombre}/solucion.txt
        echo "Cantidad de palabras que contienen al menos una vez la letra $letra:" >> ${nombre}/solucion.txt
        cat ${nombre}/diccionario.txt | grep -c "${letra}" >> ${nombre}/solucion.txt
        # Agrego el listado de palabras
        echo "--------------------------------------------------------------------------------" >> ${nombre}/solucion.txt
        echo "---------------------------  Listado de palabras  ------------------------------" >> ${nombre}/solucion.txt
        echo "--------------------------------------------------------------------------------" >> ${nombre}/solucion.txt
        cat ${nombre}/diccionario.txt | grep -e "^${letra}" >> ${nombre}/solucion.txt
        echo "--------------------------------------------------------------------------------" 
        echo "------------  Se ha generado el reporte en ${nombre}/solucion.txt  -----------------"
        echo "--------------------------------------------------------------------------------" 
    else 
        echo "$(ColorRed '----------------------  Error  ---------------------')"
        echo "$(ColorRed 'Debe configurar todas las variables primero.')"
        echo "$(ColorRed '--------------------------------------------------')"
    fi

}

function cambiarPermisos() {
    if [[ $letra != "" ]] && [[ $nombre != "" ]] && [[ $usuario != "" ]]; then
        sudo chown $usuario ${nombre}/solucion.txt
        chmod ugo+rw ${nombre}
        echo "--------------------------------------------------------------------------------" 
        echo "------------  Los permisos del usuario $usuario fueron cambiados  ------------------"
        echo "--------------------------------------------------------------------------------" 
    else 
        echo "$(ColorRed '----------------------  Error  ---------------------')"
        echo "$(ColorRed 'Debe configurar todas las variables primero.')"
        echo "$(ColorRed '--------------------------------------------------')"
    fi
}

function verificarInputs() {
    if [ "$letra" = "" ]; then
        echo "$(ColorRed 'Aún no se ha escogido una letra.')"
    else 
        echo "$(ColorGreen 'Se ha escogido la letra: ')$letra"
    fi
    if [ "$nombre" = "" ]; then
        echo "$(ColorRed 'No se ha seleccionado un nombre de directorio.')"
    else
        echo "$(ColorGreen 'Se ha seleccionado el directorio: ')$nombre"
    fi
    if [ "$usuario" = "" ]; then
        echo "$(ColorRed 'No se ha seleccionado un usuario.')"
    else
        echo "$(ColorGreen 'Se ha seleccionado el usuario: ')$usuario"
    fi
}

function menu() {
    echo -e "----------------- Menu -----------------"
    verificarInputs;
    echo "
    $(ColorGreen '1)') Configurar Variables
    $(ColorGreen '2)') Obtener Informe de la letra
    $(ColorGreen '3)') Guardar Informe
    $(ColorGreen '4)') Cambiar propietarios y permiso
    $(ColorGreen '5)') Salir
    $(ColorBlue 'Ingrese su elección:') "
    read input
    case $input in
        1) configurarVariables ; menu ;;
	    2) obtenerInforme ; menu ;;
	    3) guardarInforme ; menu ;;
	    4) cambiarPermisos ; menu ;;
		5) exit 0 ;;
        *) echo -e ${red}"${input} es una opción inválida, ingrese otro numero"${clear}"\n"; menu ;;
        esac
}

menu;