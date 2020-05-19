resource "vcd_vapp_vm" "masters-vms" {
  count = length(var.masterNodes)
  vapp_name = var.vappName
  name = var.masterNodes[count.index]["name"]
  catalog_name = var.vcdCatalogName
  template_name = var.rhcosOvaTemplate
  memory =  var.masterNodes[count.index]["ram"]
  cpus = var.masterNodes[count.index]["cpu"]
  cpu_cores = var.masterNodes[count.index]["cpu"]

  network {
    type               = var.networkType
    name               = var.networkName
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }
  guest_properties = {
    "guestinfo.coreos.config.data.encoding" = "base64"
    "guestinfo.coreos.config.data" = base64encode(data.ct_config.master-vm-ingition[count.index].rendered)
  }
  depends_on = [
    vcd_vapp_vm.bootstrap_vm
  ]
}

data "template_file" "master-vm-ingition-template" {
  count = length(var.masterNodes)
  template = file("${path.module}/templates/ignition.yaml")
  vars =  {
    ignUrl = local.masterIgnUrl
    ocpCoreUserPassHash = var.ocpCoreUserPassHash
    ocpSSHPubKey = var.ocpSSHPubKey
    hostname = "${var.masterNodes[count.index]["name"]}.${var.clusterName}.${var.baseDomain}"
    ipaddr = var.masterNodes[count.index]["ipaddr"]
    netMask = var.netMask
    netGateway = var.netGateway
    dns1 = var.dns1
    dns2  = var.dns2
    domain = var.baseDomain
  }
}
data "ct_config" "master-vm-ingition" {
  count = length(var.masterNodes)
  content      = data.template_file.master-vm-ingition-template[count.index].rendered
  pretty_print = true
}