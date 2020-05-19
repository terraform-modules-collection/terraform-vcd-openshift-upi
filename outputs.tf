output "workerIgnUrl" {
  value = "http://${var.minioServer}/${minio_s3_bucket.public-bucket.id}/worker.ign"
}
output "masterIgnUrl" {
  value = "http://${var.minioServer}/${minio_s3_bucket.public-bucket.id}/master.ign"
}

output "bootstrapIgnUrl" {
  value = "http://${var.minioServer}/${minio_s3_bucket.public-bucket.id}/bootstrap.ign"
}

output "publicBucketName" {
  value = local.publicBucketName
}

output "privateBucketName" {
  value = local.privateBucketName
}
