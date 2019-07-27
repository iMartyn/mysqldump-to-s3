# mysqldump-to-s3

Hard forked from ianneub/mysqldump-to-s3 because I wanted :

* s3 compatible storage not just actual s3
* smaller image size (alpine vs ubuntu)
* automated builds

This docker container will backup a MySQL database using mysqldump, stream it to gzip, and stream that to a file on S3.

You must set the following environment variables, or use an IAM Role:
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

These are also necessary :
* `AWS_BUCKET`
* `PREFIX` (subfolder in your bucket)
* `MYSQL_HOST`
* `MYSQL_USER`
* `MYSQL_PASS`

You may also set these :
* `DATE_FORMAT` variable to change the date used in the output filename. Be default this is `%Y/%m/%d`.
* `AWS_ENDPOINT` for s3 compatible storage (adds `--endpoint $AWS_ENDPOINT` to the s3 command)
* `MYSQL_PORT` for non-standard installs

## To build

    make
