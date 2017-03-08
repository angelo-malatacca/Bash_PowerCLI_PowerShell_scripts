#!/bin/bash

sleep 3
echo ""
echo ""
echo "##########################"
echo "# Verifica aggiornamenti #"
echo "##########################"
echo ""
sleep 3
sudo apt-get update
echo ""
echo ""
sleep 3
echo "###############################"
echo "# Installazione aggiornamenti #"
echo "###############################"
echo ""
sleep 3
sudo apt-get upgrade -y
echo ""
echo ""
sleep 3
echo "#########################"
echo "# Aggiornamento sistema #"
echo "#########################"
echo ""
sleep 3
sudo apt-get dist-upgrade -y
sleep 3
echo "##############################"
echo "# Pulizia file non necessari #"
echo "##############################"
echo ""
sleep 3
sudo apt-get autoremove -y
echo ""
echo ""
sleep 3

exit
