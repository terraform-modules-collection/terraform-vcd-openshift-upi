terraform {
  backend "consul" {}

}

locals {
  mainDiskSize = "153600"
  masterNodeLabel = "master"
  bootstrapNodeLabel = "bootstrap"
  workerNodeLabel = "worker"
}