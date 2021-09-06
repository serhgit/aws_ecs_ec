#!/bin/bash
set -e

#Get nginx.conf from S3
[[ -n ${bucket_name} ]] && aws s3 cp s3://${bucket_name}/site_000-default.conf /etc/apache2/sites-enabled/
. /usr/local/bin/docker-php-entrypoint 
