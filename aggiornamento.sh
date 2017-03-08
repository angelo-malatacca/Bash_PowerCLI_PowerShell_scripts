#!/bin/bash

sleep 2
echo "##########################"
echo "# Verifica aggiornamenti #"
echo "##########################"
sudo apt-get update
echo ""
echo ""
sleep 2

echo "###############################"
echo "# Installazione aggiornamenti #"
echo "###############################"
sudo apt-get upgrade -y
echo ""
echo ""
sleep 2

echo "#########################"
echo "# Aggiornamento sistema #"
echo "#########################"
sudo apt-get dist-upgrade -y

sleep 2

echo "##############################"
echo "# Pulizia file non necessari #"
echo "##############################"
sudo apt-get autoremove -y
echo ""
echo ""
sleep 2

exit
