# SSL certificate problem

## Error sample

```bash
curl https://my-page.my-domain.com
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```

## Steps

1. Fetch the issuer

```bash
$ openssl s_client -connect my-page.my-domain.com:443 -showcerts | grep issuer
...
issuer=C = US, O = Let's Encrypt, CN = R3
```

2. Download the chain of trust, for example [Let's encrypt ones](https://letsencrypt.org/certificates/)

```bash
# Root Cert
wget "https://letsencrypt.org/certs/isrgrootx1.pem" --output-document=isrgrootx1.crt
# Intermediate Cert - depending on the above one
wget "https://letsencrypt.org/certs/lets-encrypt-r3.pem" --output-document=lets-encrypt-r3.crt

3. Install

```bash
# Move files to the proper path
# Ubuntu = /usr/local/share/ca-certificates
sudo mv isrgrootx1.crt lets-encrypt-r3.crt  /usr/local/share/ca-certificates
# Update CA certificates
sudo update-ca-certificates
```

4. Try curl again	