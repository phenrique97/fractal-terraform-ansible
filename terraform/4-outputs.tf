# # The "name" of the availability domain to be used for the compute instance.
# output "name-of-first-availability-domain" {
#   value = data.oci_identity_availability_domains.ads.availability_domains[0]
# }
# output "objectstorage-namesace" {
#   value = data.oci_objectstorage_namespace.state_namespace
# }

# output "vcn_id" {
#  value = data.oci_core_vcns.main_vcns
# }

output "vm_list" {
  value = [
    for instance in [oci_core_instance.instance1] : {
      hostname   = instance.display_name
      ip_address = instance.public_ip
      user       = "ubuntu"
    }
  ]
}


resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory"
  content  = <<-EOT
    [oracl-inst]
    ${oci_core_instance.instance1.display_name} ansible_host=${oci_core_instance.instance1.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${local.ssh_private_key_path}
  EOT
}