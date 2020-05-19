resource "vcd_vapp_vm" "worker-vms" {
  count = length(var.workerNodes)
  vapp_name = var.vappName
  name = var.workerNodes[count.index]["name"]
  catalog_name = var.vcdCatalogName
  template_name = var.rhcosOvaTemplate
  memory =  var.workerNodes[count.index]["ram"]
  cpus = var.workerNodes[count.index]["cpu"]
  cpu_cores = var.workerNodes[count.index]["cpu"]

  network {
    type               = var.networkType
    name               = var.networkName
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }
  guest_properties = {
    "guestinfo.coreos.config.data.encoding" = "base64"
    "guestinfo.coreos.config.data" = base64encode(data.ct_config.worker-vm-ingition[count.index].rendered)
  }
  depends_on = [
    vcd_vapp_vm.bootstrap_vm
  ]
}

data "template_file" "worker-vm-ingition-template" {
  count = length(var.workerNodes)
  template = file("${path.module}/templates/ignition.yaml")
  vars =  {
    ignUrl = local.workerIgnUrl
    ocpCoreUserPassHash = var.ocpCoreUserPassHash
    ocpSSHPubKey = var.ocpSSHPubKey
    hostname = "${var.workerNodes[count.index]["name"]}.${var.clusterName}.${var.baseDomain}"
    ipaddr = var.workerNodes[count.index]["ipaddr"]
    netMask = var.netMask
    netGateway = var.netGateway
    dns1 = var.dns1
    dns2  = var.dns2
    domain = var.baseDomain
  }
}
data "ct_config" "worker-vm-ingition" {
  count = length(var.workerNodes)
  content      = data.template_file.worker-vm-ingition-template[count.index].rendered
  pretty_print = true
}
