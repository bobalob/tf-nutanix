# tf-nutanix

Basic AD domain joined windows machine template for Nutanix AHV

[Check the blog post here](https://blog.superautomation.co.uk/2023/04/terraform-nutanix-ahv-and-windows.html)

This post assumes you already have a Windows image for your desired Server OS. The Autounattend.xml included here should work fine on Server 2016 through 2022 and will need some tweaks for a client OS.

I build my AHV images using Packer and have one for each OS type. The Terraform template assumes your image is using UEFI boot, but could easily be modified for BIOS boot. You will need to modify main.tf to add your image name to the map, or copy your template and name it the same as mine - efi-rf2-2022-packer - for instance.

```
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
```

The image name in Nutanix for my 2022 server template is efi-rf2-2022-packer so if you just want to quickly test, replace the image you already have in the map, e.g… "2022" = "myServerTemplate"

The os variable in terraform.tfvars maps into the table above (and also the product key map.)
