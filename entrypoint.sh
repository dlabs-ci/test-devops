#!/bin/bash
eval $(cat .env | xargs echo export)

exec /usr/local/bin/testserver -address 0.0.0.0 -ca-file /crt/ca.pem -cert-file /crt/testserver.pem -key-file /crt/testserver-key.pem
