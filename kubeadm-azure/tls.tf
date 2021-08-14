resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "priv_key" {
  content  = tls_private_key.tls_key.private_key_pem
  filename = "certs/privkey.pem"
}