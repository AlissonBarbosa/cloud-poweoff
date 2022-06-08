#!/bin/bash

# Script para desligamento da CLOUD 5

################# ATENCAO #####################
# NÃO RODE ESSE SCRIPT A MENOS QUE VOCÊ TENHA #
# TOTAL CERTEZA DE QUE QUER DESLIGAR TODOS OS #
# SERVIÇOS E HOSTS QUE ESTÃO RODANDO NA CLOUD #
###############################################

for compute in $(openstack hypervisor list -f value | awk '{print $2 ";" $4}')
do
    compute_name=$(echo $compute | awk -F ";" '{print $1}' | sed -e 's/\.*lsd.*//')
    compute_ip=$(echo $compute | awk -F ";" '{print $2}')

    openstack server list --host $compute_name --all-projects

    echo Confirma desligar as vms do $compute_name - $compute_ip Y ou N?
    read choice
    if [[ "$choice" == Y ]]
    then
        for server in $(openstack server list --host $compute_name -f value --all-projects | awk -F " " '{ print $1 }')
        do
            if [[ $(openstack server show $server -f shell | grep status | cut -d "=" -f2) == "ACTIVE" ]]
            then
                ### Comando para Desligar
                openstack server stop $server
                while [[ $(openstack server show $server -f shell | grep status | cut -d "=" -f2) != "SHUTOFF" ]]
                do
                    echo Desligando $server
                    sleep 5
                done
            else
                echo Desligue manualmente a instancia com id $server
            fi
        done
    else
        echo Parar o desligamento? Y ou N
        read stop_choice
        if [[ "$stop_choice" == Y ]]
        then
            exit 0
        fi
    fi
done
