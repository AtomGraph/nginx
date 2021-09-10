#!/bin/bash

host="$1"
out="$2"
keyout="$3"

# crude check if the host is an IP address
ip_add_match=$(echo "$host" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" || test $? = 1)

if [ -n "$ip_add_match" ]; then
    ext="subjectAltName=IP:${host}" # IP address
else
    ext="subjectAltName=DNS:${host}" # hostname
fi

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -out "$out" -keyout "$keyout" \
  -subj "/CN=${host}/OU=LinkedDataHub/O=AtomGraph/L=Copenhagen/C=DK" \
  -addext "$ext"