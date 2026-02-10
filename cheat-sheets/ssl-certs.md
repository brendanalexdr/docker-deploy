# SSL Certificates Cheat-Sheet

### Preliminary
Be sure to update the hosts file when setting up localhost DNS
```bash
127.0.0.1  my.new.localdoman
```
### Generate CA
1. Generate RSA
```bash
openssl genrsa -aes256 -out ca.key 4096
```
2. Generate a public CA Cert
```bash
openssl req -new -x509 -sha256 -days 3650 -key ca.key -out ca.pem
```

### Optional Stage: View Certificate's Content
```bash
openssl x509 -in ca.pem -text
```

### Generate Certificate
1. Create a RSA key
```bash
openssl genrsa -out cert.key 4096
```
2. Create a Certificate Signing Request (CSR)
```bash
openssl req -new -sha256 -subj "/CN=yourcn" -key cert.key -out cert.csr
```
3. Create a `extfile` with all the alternative names
```bash
echo "subjectAltName=DNS:your-dns.record,IP:127.0.0.1" >> extfile.cnf
```
```bash
# optional
echo extendedKeyUsage = serverAuth >> extfile.cnf
```
4. Create the certificate
```bash
openssl x509 -req -sha256 -days 3650 -in cert.csr -CA ../ca/ca.pem -CAkey ../ca/ca.key -out cert.pem -extfile extfile.cnf -CAcreateserial
```

5. Convert to PFX
```bash
openssl pkcs12 -inkey cert.key -in cert.pem -export -out cert.pfx
```

## Certificate Formats

X.509 Certificates exist in Base64 Formats **PEM (.pem, .crt, .ca-bundle)**, **PKCS#7 (.p7b, p7s)** and Binary Formats **DER (.der, .cer)**, **PKCS#12 (.pfx, p12)**.

### Convert Certs

COMMAND | CONVERSION
---|---
`openssl x509 -outform der -in cert.pem -out cert.der` | PEM to DER
`openssl x509 -inform der -in cert.der -out cert.pem` | DER to PEM
`openssl pkcs12 -in cert.pfx -out cert.pem -nodes` | PFX to PEM

## Verify Certificates
`openssl verify -CAfile ca.pem -verbose cert.pem`

## Install the CA Cert as a trusted root CA

### On Windows

Assuming the path to your generated CA certificate as `C:\ca.pem`, run:
```powershell
Import-Certificate -FilePath "C:\ca.pem" -CertStoreLocation Cert:\LocalMachine\Root
```
- Set `-CertStoreLocation` to `Cert:\CurrentUser\Root` in case you want to trust certificates only for the logged in user.

OR

In Command Prompt, run:
```sh
certutil.exe -addstore root C:\ca.pem
```

- `certutil.exe` is a built-in tool (classic `System32` one) and adds a system-wide trust anchor.

## sources
- [ChristianLempa/cheat-sheets](https://github.com/ChristianLempa/cheat-sheets/blob/main/misc/ssl-certs.md)
