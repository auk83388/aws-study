# RDSの作成

#RDSのサブネットグループ

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-goup"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

#RDSのパラメーターグループの作成
resource "aws_db_parameter_group" "mysql_native" {
  name        = "mysql-native"
  family      = "mysql8.0" #このパラメーターグループは8.0専用という宣言　familyはどのデータベースエンジンに設定項目をベースするか
  description = "MySQL8.0 with native password authentication"
}

#RDSインスタンスの作成
resource "aws_db_instance" "mysql" {
  identifier             = "rds-mysql"
  engine                 = "mysql" #RDSのエンジンの指定
  engine_version         = "8.0"   #エンジンのverison指定
  instance_class         = "db.t3.micro"
  allocated_storage      = 20    #容量の指定
  storage_type           = "gp2" #RDSのストレージの種類の指定gp2の場合は汎用SSDという設定
  username               = "auk83388"
  password               = "Hinata311"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.mysql_native.name
  multi_az               = false #マルチアベイラビリティゾーンの設定（今回は東京１だけなのでfalse)
  publicly_accessible    = false #外部からのアクセスをfalseで拒否
  skip_final_snapshot    = true  #削除時のスナップショット無効
  deletion_protection    = false #削除保護オフ


  tags = {
    Name = "rds-mysql"
  }
}