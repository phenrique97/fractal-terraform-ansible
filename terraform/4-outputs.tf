## 
## Saidas de dados
## 
output "vm_list" {
  value = [
    for instance in [oci_core_instance.instance1] : {
      hostname   = instance.display_name
      ip_address = instance.public_ip
      user       = "ubuntu"
      url_app    = "http://${instance.public_ip}:7860"
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