#outputs.tf テスト用の定義出力

# VPC
output "vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}

# EC2
output "instance_type" {
  value = aws_instance.aws_ec2.instance_type
}

# RDS
output "rds_encrypted" {
  value = coalesce(aws_db_instance.mysql.storage_encrypted,false)
}

output "rds_multi_az" {
  value = aws_db_instance.mysql.multi_az
}
 
output "rds_publicly_accessible" {
  value = aws_db_instance.mysql.publicly_accessible
}
