# Create a self-signed certificate with SAN

The following creates a self-signed certificate which can be used as wildcard for one ore more subdomains, assuming `mysub.mydomain.com` as the main level, and then `*.mysub.mydomain.com` as potential FQDNs.

```bash
# Create request config
cat <<EOF >>/tmp/tls.csr
[req]
    distinguished_name = req_distinguished_name
    req_extensions = v3_req
    prompt = no
    [req_distinguished_name]
    C = AR
    ST = Buenos Aires
    L = Bahia Blanca
    O = Company
    OU = SelfSignedCertificate
    CN = *.mysub.mydomain.com
    [v3_req]
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    extendedKeyUsage = serverAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = *.mysub.mydomain.com
EOF
# Create certificates
openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -config /tmp/tls.csr -extensions 'v3_req'
# Check the certificate output
openssl x509 -in /tmp/tls.crt -text -noout
```

Notes:

- `keyUsage` is set to avoid some known issues with `ERR_SSL_KEY_USAGE_INCOMPATIBLE`
- `alt_names` is set to avoid ingress-nginx issue with `x509: certificate relies on legacy Common Name field, use SANs instead`

## If you want to use this for Kubernetes

```bash
# Create secret
kubectl create secret tls tls-secret \
    --namespace my-namespace \
    --key /tmp/tls.key \
    --cert /tmp/tls.crt \
    -o yaml --dry-run=server > /tmp/tls.yaml
# Apply
kubectl apply -f /tmp/tls.yaml
```