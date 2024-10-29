locals {
  availability_domain  = "<tenancy-ocid>"
  ubuntu2204ocid       = "<image-ocid>"
  user_ocid            = "<user-ocid>"
  fingerprint          = "<your-fingerprint>"
  private_api_key_path = pathexpand("/path/your/oci-api-key.pem")
  region               = "<your-region>"
  ssh_pubkey_path      = pathexpand("/path/your/public-key")
  ssh_pubkey_data      = file(pathexpand("/path/your/public-key"))
  ssh_private_key_path = pathexpand("/path/your/private-key")
  private_key_path     = "/path/your/oci-api-key.pem"
}