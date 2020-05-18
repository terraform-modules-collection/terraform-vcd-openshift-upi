resource "vcd_vapp_vm" "bootstrap_vm" {
  vapp_name = var.vappName
  name = var.bootstrapNode.name
  catalog_name = var.catalogName
  template_name = var.rhcosOvaTemplate
  memory =  var.bootstrapNode.ram
  cpus = var.bootstrapNode.cpu
  cpu_cores = var.bootstrapNode.cpu

  network {
    type               = var.networkType
    name               = var.networkName
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }
  guest_properties = {
    "guestinfo.coreos.config.data.encoding" = "base64"
    "guestinfo.coreos.config.data" = base64encode(data.ct_config.bootstrap-vm-ingition.rendered)
  }
}

data "template_file" "bootstrap-vm-ingition-template" {
  template = file("${path.module}/templates/ignition.yaml")
  vars =  {
    ignUrl = var.bootstrapNodeIgnUrl
    ocpCoreUserPassHash = var.ocpCoreUserPassHash
    ocpSSHPubKey = var.ocpSSHPubKey
    hostname = "${var.bootstrapNode.name}.${var.clusterName}.${var.baseDomain}"
    ipaddr = var.bootstrapNode.ipaddr
    netMask = var.netMask
    netGateway = var.netGateway
    dns1 = var.dns1
    dns2  = var.dns2
    domain = var.baseDomain
  }
}
data "ct_config" "bootstrap-vm-ingition" {
  content      = data.template_file.bootstrap-vm-ingition-template.rendered
  pretty_print = true
}