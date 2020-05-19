provider "vcd" {
  user                 = var.vcdUsername
  password             = var.vcdPassword
  org                  = var.vcdOrganization
  url                  = var.vcdUrl
  vdc                  = var.vcdVirtualDC
  allow_unverified_ssl = true
}