locals {
  availability_domain  = "<tenancy-ocid>"
  ubuntu2204ocid       = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaasab5yshycv5lxwio273qe4zw3yqbu6znsvu7rzuskb3zp7kr7pna"
  user_ocid            = "<user-ocid>"
  fingerprint          = "<your-fingerprint>"
  private_api_key_path = pathexpand("/path/your/oci-api-key.pem")
  region               = "<your-region>"
  ssh_pubkey_path      = pathexpand("/path/your/public-key")
  ssh_pubkey_data      = file(pathexpand("/path/your/public-key"))
  ssh_private_key_path = pathexpand("/path/your/private-key")
  private_key_path     = "/path/your/oci-api-key.pem"
}