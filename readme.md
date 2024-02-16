mkdir -p certs && cd certs
openssl req -x509 -newkey rsa:4096 -keyout opensearch-key.pem -out opensearch-cert.pem -days 365 -nodes -subj "/CN=opensearch"
cd ..
