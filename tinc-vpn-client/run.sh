#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json

CLIENTNAME=$(bashio::config 'client_name')
PRIVATEKEY=$(bashio::config 'private_key')

function init_tun(){
    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
}

function generate_config_files(){
    mkdir -p /etc/tinc/vcn
    echo ${PRIVATEKEY} | base64 -d > /etc/tinc/vcn/rsa_key.priv
    chmod 600 /etc/tinc/vcn/rsa_key.priv

    cd /etc/tinc # or your tinc configuration dir
    mkdir -p vcn/hosts/
    curl -o vcn/hosts/${CLIENTNAME} https://attrezzi.esiliati.org/vcn//host/${CLIENTNAME}
    curl -o vcn/hosts/vcn1 https://attrezzi.esiliati.org/vcn//hosts/vcn1
    curl -o vcn/hosts/vcn2 https://attrezzi.esiliati.org/vcn//hosts/vcn2
    curl -o vcn/hosts/vcn3 https://attrezzi.esiliati.org/vcn//hosts/vcn3
    curl -o vcn/tinc-up https://attrezzi.esiliati.org/vcn//tinc-up/${CLIENTNAME}
    chmod +x vcn/tinc-up
    curl -o vcn/tinc.conf https://attrezzi.esiliati.org/vcn//tinc.conf/${CLIENTNAME} 
    
}

init_tun
generate_config_files

tincd -n vcn -D -d