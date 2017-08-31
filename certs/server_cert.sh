#!/bin/bash

# server key and certificate
openssl req -nodes -new -extensions server \
  -keyout server.key -out server.csr
openssl ca -extensions server \
  -out server.crt -in server.csr

