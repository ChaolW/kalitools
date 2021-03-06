#!/bin/bash

banner () {
        echo "==============================================================="
        echo
        echo "    Descarga herramientas comunes para hacking "
        echo
        echo
        echo
        echo "    Gracias a todas las personas que crearon las herramientas"
        echo
        echo "==============================================================="
}

function descarga_Git {
        echo
	if [ -f githubtools.lst ]; then
		echo "Se encontro la list descargas, comenzando..."
		for GITREPO in $(grep -v "^#" githubtools.lst);
		do
			NOMBRE_REPO=$(sed 's|https://git.*.com/.*/||' <<< "$GITREPO")
			SANITIZADO=$(sed 's|\.git||' <<< "$NOMBRE_REPO")
            descarga_Actualiza
		done
	else
		echo
		echo "No puedo encontrar la lista de descarga! No puedo hacer nada!"
		echo "Asegurate que el archivo githubtools.lst este en le mismo directorio que este script!: $DIRACTUAL"
	fi
}

function descarga_Actualiza {
        if [ -d "/opt/$SANITIZADO" ]; then
                echo
                echo "Actualizando $SANITIZADO ..."
                cd /opt/"$SANITIZADO"
                git pull
        else
                echo
                echo "Descargando $SANITIZADO .."
                sudo git -C /opt/ clone "$GITREPO"
        fi
}

function actualizar_SO {
        sudo apt update && sudo apt upgrade -y
}

main () {
        USUARIO=$(whoami)
        DIRACTUAL=$(pwd)
        banner
        if [ "$(id -u)" -eq 0 ]; then
            echo "NO me executes como root, te lo pedire cuando lo necesite..."
            exit
        else
            echo "Revisando conexión a internet..."
      	    if ! ping -c1 google.com > /dev/null 2>&1; then
      		         echo "No hay internet! Revisa tu conexión!"
      	    else
      		         echo "Tienes conexión, continuando..."
                     echo
                     echo "Primero voy a actualizar tu sistema. Por favor espera."
                     actualizar_SO
                     echo
                     echo "Voy a intentar descargar las herramientas de github, esto puede tardar un rato."
                     descarga_Git
                     sudo chown -R "$USUARIO":"$USUARIO" /opt/*
                     echo
                     echo "Termine! Feliz caza!"
      	    fi
        fi
}

main
