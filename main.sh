#!/bin/bash

banner () {
        echo "==============================================================="
        echo
        echo "    Descarga herramientas comunes para hacking "
        echo
        echo
        echo
        echo "    Gracias a todas las personas que escribieron las herramientas"
        echo
        echo "==============================================================="
}

function git_Download {
        echo
	if [ -f githubtools.lst ]; then
		if [ -f gitskip.lst ]; then
			echo "Se encontro la list ade excepciones, descarga parcial"
			for GITREPO in `cat githubtools.lst`
			do
				REPO_NAME=`sed 's|https://git.*.com/.*/||' <<< $GITREPO`
				SANITIZED=`sed 's|\.git||' <<< $REPO_NAME`
                                if grep -Fxq "$SANITIZED" $SCRIPTPATH/gitskip.lst; then
										echo
                                        echo "$SANITIZED esta en la lista, saltando..."
                                else
                                        download_Upgrade
                                fi
			done
		else
			echo "No se encontro gitskip.lst, descargando todo en la lista."
			for GITREPO in `cat githubtools.lst`
			do
				REPO_NAME=`sed 's|https://github.com/.*/||' <<< $GITREPO`
				SANITIZED=`sed 's|\.git||' <<< $REPO_NAME`
				download_Upgrade
			done
		fi
	else
		echo
		echo "No puedo encontrar la lista de descarga! No puedo hacer nada!"
		echo "Asegurate que el archivo githubtools.lst este en le mismo directorio que este script!"
	fi
}

function download_Upgrade {
        if [ -d "/opt/$SANITIZED" ]; then
                echo
                echo "Actualizando $SANITIZED ..."
                cd /opt/$SANITIZED
                git pull
        else
                echo
                echo "Descargando $SANITIZED .."
                git -C /opt/ clone $GITREPO
        fi
}

function update_Os {
        sudo apt update && sudo apt upgrade -y
}


main () {
        SCRIPTPATH=`pwd`
        banner
        echo "Revisando conexión a internet..."
        ping -c1 google.com > /dev/null 2>&1
      	if [ "$?" != 0 ]; then
      		      echo "No hay internet! Revisa tu conexión!"
      	else
      		      echo "Tienes conexión, continuando..."
                echo
                echo "Primero voy a actualizar tu sistema. Por favor espera."
                update_Os
                echo
                echo "Voy a intentar descargar las herramientas de github, estudio puede tardar un rato."
                git_Download
                echo
                echo "Feliz caza!"
      	fi
}

main
