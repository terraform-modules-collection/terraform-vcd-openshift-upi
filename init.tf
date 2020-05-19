provider "minio" {
  minio_server = var.minioServer
  minio_access_key = var.minioAccessKey
  minio_secret_key = var.minioSecretKey
}

data "template_file" "install-config" {
  template = file("${path.module}/templates/install-config.yaml")
  vars = {
    clusterName = var.clusterName
    pullSecret =  base64decode(var.ocpPullSecret)
    sshPubKey = base64decode(var.ocpSSHPubKey)
    baseDomain = var.baseDomain
  }
}
locals {
  publicBucketName = "ocp-cluster-${var.clusterName}-public"
  privateBucketName = "ocp-cluster-${var.clusterName}-private"

  workerIgnUrl  = "${var.minioServerScheme}://${var.minioServer}/${minio_s3_bucket.public-bucket.id}/worker.ign"
  masterIgnUrl = "${var.minioServerScheme}://${var.minioServer}/${minio_s3_bucket.public-bucket.id}/master.ign"
  bootstrapIgnUrl = "${var.minioServerScheme}://${var.minioServer}/${minio_s3_bucket.public-bucket.id}/bootstrap.ign"
}

resource "minio_s3_bucket" "public-bucket" {
  bucket = local.publicBucketName
  acl    = "public"
}

resource "minio_s3_bucket" "private-bucket" {
  bucket = local.privateBucketName
  acl    = "private"
}

resource "null_resource" "init-cluster" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/init-cluster.sh"
    environment = {
      WORKDIR = "${path.module}/init-cluster/${var.clusterName}"
      PUBLIC_BUCKET_NAME = minio_s3_bucket.public-bucket.id
      PRIVATE_BUCKET_NAME = minio_s3_bucket.private-bucket.id
      MINIO_SERVER = var.minioServer
      MINIO_ACCESS_KEY = var.minioAccessKey
      MINIO_SECRET_KEY = var.minioSecretKey
      INSTALL_CONFIG =  base64encode(data.template_file.install-config.rendered)
    }
  }
}

