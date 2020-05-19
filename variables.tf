variable "ocpPullSecret" {
  type = string
  description = "Pull secret for access OpenShift platform images, must be base64 encoded"
}

variable "ocpSSHPubKey" {
  type = string
  description = "SSH public key for ssh access to cluster nodes. ssh core@<NODE_NAME>, must be base64 encoded"
}
variable "ocpCoreUserPassHash" {
  type = string
  description = "Password hash for core user service account"
}

variable "clusterName" {
  type = string
  description = "OpenShift cluster name."
}

variable "netMask" {
  type = string
  description = "Cluster network mask."
}
variable "netGateway" {
  type = string
  description = "Cluster network gateway"
}
variable "dns1" {
  type = string
  description = "First DNS server"
}
variable "dns2" {
  type = string
  description = "Second DNS server"
}

//variable "bootstrapNodeIgnUrl" {
//  type = string
//  description = "URL to ignition file for bootstrap node."
//}
//variable "masterNodesIgnUrl" {
//  type = string
//  description = "URL to ignition file for master nodes."
//}
//variable "workerNodesIgnUrl" {
//  type = string
//  description = "URL to ignition file for worker nodes."
//}

variable "bootstrapNode" {
  type = object({
    name = string
    ipaddr = string
    ram = number
    cpu = number
  })
}
variable "workerNodes" {
  type = list(object({
    name = string
    ipaddr = string
    ram = number
    cpu = number
  }))
  description = "OpenShift worker nodes bunch."
}

variable "masterNodes" {
  type = list(object({
    name = string
    ipaddr = string
    ram = number
    cpu = number
  }))
  description = "OpenShift master nodes bunch."
}

variable "baseDomain" {
  type = string
  description = "Base organization  domain"
}

variable "networkType" {
  type = "string"
  default = "org"
  description = "Type Vcloud Director network"
}
variable "networkName" {
  type = string
  description = "Vcloud Director network name"
}
variable "vappName" {
  type = string
  description = "Vcloud Director VAPP name"
}
variable "rhcosOvaTemplate" {
  type = string
  description = "RHCOS OVA template"
}
variable "vcdCatalogName" {
  type = string
  description = "Vcloud Director catalog name"
}

variable "vcdUrl" {
  type = string
  description = "Vcloud Director API url."
}
variable "vcdUsername" {
  type = string
  description = "Vcloud Director username."
}
variable "vcdPassword" {
  type = string
  description = "Vcloud Director password."
}
variable "vcdOrganization" {
  type = string
  description = "Vcloud Director organization name"
}
variable "vcdVirtualDC" {
  type = string
  description = "Vcloud Director virtual datacenter name"
}

variable "minioServer" {
  type = string
  description = "Minio S3 server hostname without schema"
}
variable "minioAccessKey" {
  type = string
  description = "S3 access key"
}
variable "minioSecretKey" {
  type = string
  description = "S3 secret key"
}

variable "minioServerScheme" {
  type = string
  default = "http"
}
