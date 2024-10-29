## 
## Instancia
## 
resource "oci_core_instance" "instance1" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = local.availability_domain
  display_name        = "ubuntu-instance-1"
  shape               = "VM.Standard.E2.1.Micro"
  shape_config {
    ocpus         = 1
    memory_in_gbs = 1
  }
  source_details {
    source_type = "image"
    source_id   = local.ubuntu2204ocid
  }

  metadata = {
    ssh_authorized_keys = local.ssh_pubkey_data
  }
  preserve_boot_volume = false


  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.main_subnet.id
    nsg_ids = [
        oci_core_network_security_group.my_security_group_http.id,
        oci_core_network_security_group.my_security_group_ssh.id]
  }
}