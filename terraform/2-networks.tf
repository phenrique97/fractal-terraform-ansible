####
## MAIN ROUTING
####
resource "oci_core_vcn" "main_vcn" {
  cidr_blocks = [
    "10.0.0.0/16",
  ]
  compartment_id = local.availability_domain
  display_name   = "Main VCN"
  dns_label      = "mainvcn"
  freeform_tags = {
  }
  ipv6private_cidr_blocks = [
  ]
}

resource "oci_core_internet_gateway" "main_vcn_internet_gateway" {
  compartment_id = local.availability_domain
  display_name   = "Internet Gateway Main VCN"
  enabled        = "true"
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.main_vcn.id
}

resource "oci_core_subnet" "main_subnet" {
  vcn_id         = oci_core_vcn.main_vcn.id
  compartment_id = local.availability_domain
  cidr_block     = "10.0.0.0/24"
  #dhcp_options_id = oci_core_vcn.main_vcns.default_dhcp_options_id
  display_name = "Main SubNet"
  dns_label    = "mainsubnet"
  freeform_tags = {
  }

  prohibit_internet_ingress  = "false"
  prohibit_public_ip_on_vnic = "false"

  # we are interested in this, allows SSH default
  security_list_ids = [
    oci_core_vcn.main_vcn.default_security_list_id,
    #oci_core_security_list.https_security_list.id
  ]
}

resource "oci_core_default_route_table" "Default-Route-Table-for-main-vcn" {
  compartment_id = local.availability_domain
  display_name   = "Default Route Table for Main VCN"
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.main_vcn.default_route_table_id
  route_rules {
    #description = <<Optional value not found in discovery>>
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main_vcn_internet_gateway.id
  }
}

## 
## SECURITY GROUPS
## 
resource "oci_core_network_security_group" "my_security_group_http" {
  compartment_id = local.availability_domain
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "my-security-group-http"
}

resource "oci_core_network_security_group" "my_security_group_ssh" {
  compartment_id = local.availability_domain
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "my-security-group-ssh"
}

## 
## NSG Rules
## 
resource "oci_core_network_security_group_security_rule" "https_security_rule" {
  network_security_group_id = oci_core_network_security_group.my_security_group_http.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 7860
      max = 7860
    }
  }
}

resource "oci_core_network_security_group_security_rule" "ssh_security_group_rule" {
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.my_security_group_ssh.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "22"
      min = "22"
    }
  }
}

####
## SECURITY LISTS
####
resource "oci_core_default_security_list" "default-seclist" {
  compartment_id = local.availability_domain
  display_name   = "Default Security List for Main VCN"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  freeform_tags = {
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
    }
  }
  ingress_security_rules {
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }
  ingress_security_rules {
    icmp_options {
      code = "-1"
      type = "3"
    }
    protocol    = "1"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }
  manage_default_resource_id = oci_core_vcn.main_vcn.default_security_list_id
  lifecycle {
    create_before_destroy = true
  }
}