output "ssh-center" {
  value = "ssh ubuntu@${aws_instance.center.public_ip}"
}

output "url-tidb-dashboard" {
  value = "http://${aws_instance.pd.public_ip}:2379/dashboard"
}

output "url-grafana" {
  value = "http://${aws_instance.pd.public_ip}:3000"
}

output "private-ip-tidb" {
  value = aws_instance.tidb.*.private_ip
}

output "private-ip-tikv" {
  value = aws_instance.tikv.*.private_ip
}

output "private-ip-tiflash-write" {
  value = aws_instance.tiflash_write.*.private_ip
}

output "private-ip-tiflash-compute" {
  value = aws_instance.tiflash_compute.*.private_ip
}

output "private-ip-pd" {
  value = aws_instance.pd.*.private_ip
}

output "s3-bucket" {
  value = aws_s3_bucket.main.bucket
}
