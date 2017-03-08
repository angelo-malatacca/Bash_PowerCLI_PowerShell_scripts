#!/bin/bash

clear
echo "##########################"
echo "# Verifica aggiornamenti #"
echo "##########################"
echo ""
sleep 3
sudo apt-get update
echo ""
echo ""
sleep 3
clear
echo "###############################"
echo "# Installazione aggiornamenti #"
echo "###############################"
echo ""
sleep 3
sudo apt-get upgrade -y
echo ""
echo ""
sleep 3
clear
echo "#########################"
echo "# Aggiornamento sistema #"
echo "#########################"
echo ""
sleep 3
sudo apt-get dist-upgrade -y
echo ""
echo ""
sleep 3
clear
echo "##############################"
echo "# Pulizia file non necessari #"
echo "##############################"
echo ""
sleep 3
sudo apt-get clean -y
sudo apt-get autoclean -y
sudo apt-get autoremove -y
echo ""
echo ""
sleep 3

exit
