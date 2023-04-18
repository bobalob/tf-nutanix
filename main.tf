terraform {
  required_providers {
    nutanix = {
      source = "nutanix/nutanix"
    }
  }
}

# Connection Variables
provider "nutanix" {
  endpoint     = var.nutanix_endpoint
  port         = var.nutanix_port
  insecure     = var.nutanix_insecure
  wait_timeout = var.nutanix_wait_timeout
}

# Get Cluster uuid
data "nutanix_clusters" "clusters" {
}
locals {
  cluster1 = data.nutanix_clusters.clusters.entities[0].metadata.uuid
}

# Select the correct image and product key
variable "images" {
  type = map(any)
  default = {
    "2016"      = "efi-rf2-2016-packer"
    "2016-core" = "efi-rf2-2016-core-packer"
    "2019"      = "efi-rf2-2019-packer"
    "2019-core" = "efi-rf2-2019-core-packer"
    "2022"      = "efi-rf2-2022-packer"
    "2022-core" = "efi-rf2-2022-core-packer"
  }
}

# These are KMS keys available from Microsoft at:
# https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys
variable "product_keys" {
  type = map(any)
  default = {
    "2016"      = "CB7KF-BWN84-R7R2Y-793K2-8XDDG"
    "2016-core" = "CB7KF-BWN84-R7R2Y-793K2-8XDDG"
    "2019"      = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
    "2019-core" = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
    "2022"      = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"
    "2022-core" = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"
  }
}


data "nutanix_image" "disk_image" {
  image_name = var.images[var.os]
}
#pull desired subnet data
data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}
# Unattend.xml template
data "template_file" "autounattend" {
  template = file("${path.module}/Autounattend.xml")
  vars = {
    ADMIN_PASSWORD       = textencodebase64(join("", [var.admin_password, "AdministratorPassword"]), "UTF-16LE")
    AUTOLOGON_PASSWORD   = textencodebase64(join("", [var.admin_password, "Password"]), "UTF-16LE")
    ORG_NAME             = "Terraform Org"
    OWNER_NAME           = "Terraform Owner"
    TIMEZONE             = var.timezone
    PRODUCT_KEY          = var.product_keys[var.os]
    VM_NAME              = var.vm_name
    AD_DOMAIN_SHORT      = var.domain_shortname
    AD_DOMAIN            = var.domain
    AD_DOMAIN_USER       = var.domain_user
    AD_DOMAIN_PASSWORD   = var.domain_pw
    AD_DOMAIN_OU_PATH    = var.ou_path
    FIRST_RUN_SCRIPT_URI = var.first_run_script_uri
  }
}

# Virtual machine resource
resource "nutanix_virtual_machine" "virtual_machine_1" {
  # General Information
  name                 = var.vm_name
  description          = "Terraform Test VM"
  num_vcpus_per_socket = 4
  num_sockets          = 1
  memory_size_mib      = 8192
  boot_type            = "UEFI"

  guest_customization_sysprep = {
    install_type = "PREPARED"
    unattend_xml = base64encode(data.template_file.autounattend.rendered)
  }

  # VM Cluster
  cluster_uuid = local.cluster1

  # What networks will this be attached to?
  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }

  # What disk/cdrom configuration will this have?
  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.disk_image.id
    }
  }

  disk_list {
    # defining an additional entry in the disk_list array will create another.
    disk_size_mib   = 10240
  }
}

# Show IP address
output "ip_address" {
  value = nutanix_virtual_machine.virtual_machine_1.nic_list_status[0].ip_endpoint_list[0].ip
}