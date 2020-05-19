#!/usr/bin/env bash

mkdir -p $WORKDIR
rm -rf $WORKDIR/*

printf "Init cluster-config.yaml, in directory %s/%s\n" $WORKDIR

echo $INSTALL_CONFIG | base64 -d > $WORKDIR/install-config.yaml

openshift-install create ignition-configs --dir=$WORKDIR

printf "Configure s3 client for save installer  assests\n"
mc config host add s3  http://$MINIO_SERVER   $MINIO_ACCESS_KEY $MINIO_SECRET_KEY --api S3v4

printf "Copy ignition configuration to public bucket: %s\n", $PUBLIC_BUCKET_NAME
mc cp  $WORKDIR/*.ign  s3/$PUBLIC_BUCKET_NAME/

printf "Copy bootstrap auth configuration to  private bucket: %s\n", $PRIVATE_BUCKET_NAME
mc cp  $WORKDIR/auth/*  s3/$PRIVATE_BUCKET_NAME/

printf "Copy cluster metadata to  private bucket: %s\n", $PRIVATE_BUCKET_NAME
mc cp  $WORKDIR/metadata.json  s3/$PRIVATE_BUCKET_NAME/

