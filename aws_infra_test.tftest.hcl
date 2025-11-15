#インフラ自動テスト

#planが通るかの確認

run "plan_check" {
    command = plan
}

# VPC

run "check_vpc_cidr" {
    command = plan
    assert {
      condition = output.vpc_cidr_block == "10.0.0.0/16"
      error_message = "VPC CIDRが設計と異なる"
    }
}

# EC2

run "check_ec2_type" {
    command = plan
    assert {
      condition = output.instance_type == "t2.micro"
      error_message = "EC2のインスタンスタイプが設計と異なります"
    }
}

#　RDS
run "check_rds_encryption" {
  command = plan
  assert {
    condition = coalesce(output.rds_encrypted) == false
    error_message = "RDSの暗号化が無効"
  }
}

run "check_rds_multi_az" {
  command = plan
  assert {
    condition     = output.rds_multi_az == false
    error_message = "RDSのMulti-AZが想定外です"
  }
}

run "check_rds_public" {
  command = plan
  assert {
    condition     = output.rds_publicly_accessible == false
    error_message = "RDSがパブリックアクセス可能になっています"
  }
}

