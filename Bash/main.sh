#!/bin/bash
# Obligatorio Infraestructura

## Colores
green='\033[0;32m' 
blue='\033[0;34m'
clear='\033[0m'
red='\033[0;31m'

## SetColores
ColorGreen(){
	echo ${green}${1}${clear}
}
ColorBlue(){
	echo ${blue}${1}${clear}
}
ColorRed(){
    echo ${red}${1}${clear}
}

## Variables
letra=""
nombre=""
usuario=""
comienzanCon = 0

# TODO
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
        
    ### TODO:: El usuario debe ser un usuario previamente creado por el alumno.
    if [ "$usuario" = "" ]; then
        echo "Ingrese el usuario"
        read usuario
        if [[usuario =~ [a-z]]]; then
            ColorRed "Error, el usuario ingresado no es una letra \n"
            usuario=""
            return
        fi
    fi
}


function obtenerInforme() {
    # Contar la cantidad de palabras que comienzan con la letra seleccionada
    echo "Cantidad de palabras que comienzan con la letra $letra:" 
    cat ${nombre}/diccionario.txt | grep -c "^${letra}"
    
    #La cantidad de palabras que finalizan con la letra seleccionada.
    echo "Cantidad de palabras que finalizan con la letra $letra:" 
    cat ${nombre}/diccionario.txt | grep -c "${letra}$" 
    
    # La cantidad de palabras que contienen al menos una vez la letra seleccionada.
    echo "Cantidad de palabras que contienen al menos una vez la letra $letra:" 
    cat ${nombre}/diccionario.txt | grep -c "${letra}"
}

function guardarInforme() {
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
}

function cambiarPermisos() {
    echo "Usted eligió  $REPLY o sea la $opt"
    echo "Prueba for de 1 al 10..."
    for numero in {1..10};
        do
            echo Este es el número: $numero
            sleep 1
        done
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
    echo "/------------- Menu -------------/"
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
        *) echo ${red}"${input} es una opción inválida, ingrese otro numero"${clear}"\n"; menu ;;
        esac
}

menu;



