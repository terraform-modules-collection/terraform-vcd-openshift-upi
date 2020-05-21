resource "vcd_vapp_vm" "bootstrap-vm" {
  for_each = var.bootstrapNode
  vapp_name = var.vappName
  name = each.key
  catalog_name = var.vcdCatalogName
  template_name = var.rhcosOvaTemplate
  memory =  each.value["ram"]
  cpus = each.value["cpu"]
  cpu_cores = each.value["cpu"]

  override_template_disk {
    bus_type         = "paravirtual"
    size_in_mb       = local.mainDiskSize
    bus_number       = 0
    unit_number      = 0
    iops             = 0
    storage_profile  = var.storageProfile
  }
  network {
    type               = var.networkType
    name               = var.networkName
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }
  metadata = {
    role    = local.bootstrapNodeLabel
    cluster_name    = var.clusterName
  }
  guest_properties = {
    "guestinfo.coreos.config.data.encoding" = "base64"
    "guestinfo.coreos.config.data" = base64encode(data.ct_config.bootstrap-vm-ingition[each.key].rendered)
  }

  lifecycle {
    ignore_changes = [template_name, override_template_disk]
    prevent_destroy = false
  }
}

data "template_file" "bootstrap-vm-ingition-template" {
  for_each = var.bootstrapNode
  template = file("${path.module}/templates/ignition.yaml")
  vars =  {
    ignUrl = local.bootstrapIgnUrl
    ocpCoreUserPassHash =  base64decode(var.ocpCoreUserPassHash)
    ocpSSHPubKey =  base64decode(var.ocpSSHPubKey)
    hostname = "${each.key}.${var.clusterName}.${var.baseDomain}"
    ipaddr = each.value["ipaddr"]
    netMaskPrefix = var.netMaskPrefix
    netGateway = var.netGateway
    dns1 = var.dns1
    dns2  = var.dns2
    domain = var.baseDomain
  }
}
data "ct_config" "bootstrap-vm-ingition" {
  for_each = var.bootstrapNode
  content      = data.template_file.bootstrap-vm-ingition-template[each.key].rendered
  pretty_print = true
}