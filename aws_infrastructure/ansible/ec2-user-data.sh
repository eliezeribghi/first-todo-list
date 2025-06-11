#!/bin/bash

# Mettre à jour le système
sudo apt update -y
sudo apt upgrade -y

# Installer nginx
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

# Installer Python 3 et pip
sudo apt install python3 -y
sudo apt install python3-pip -y

# Vérifier les installations
nginx -v
python3 --version

# Créer un fichier de log pour vérifier l'exécution
echo "Installation terminée : $(date)" > /home/ubuntu/install.log
