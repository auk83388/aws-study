#セキュリティグループの作成（EC2、ELC、RDS）

#ELBセキュリティグループ
resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "allow HTTP access from internet"
  vpc_id      = aws_vpc.main_vpc.id

  #descriptionは必須のものではないがコンソール上に作成したときに表示される何をしているかをわかるようにするメモの役割があるので管理がしやすい


  #ingressは外部から入ってくる通信をどう扱うかを決定するためのコマンド
  #egressは内部から外に出る通信をどう扱うかを決定するためのコマンド

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elb_sg"
  }
}

#EC2セキュリティグループ

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "allow HTTP from ELB andSSH from admin"
  vpc_id      = aws_vpc.main_vpc.id


  #　ELBからHTTP通信の許可設定
  ingress {
    description     = "allow HTTP from ELB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  # PCからのSSHを通信許可設定
  ingress {
    description = "allow SSH from admin PC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip}/32"]
  }

  # EC2から外部への通信をすべて許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

#RDSセキュリティグループ
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "allow MySQL communication from EC2"
  vpc_id      = aws_vpc.main_vpc.id


  #　EC2からSQLへの通信のみを許可する
  ingress {
    description     = "Allow MySQL access from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  # RDSから外部への通信を許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_security_group.ec2_sg] # ec2のセキュリティグループを作成後に作成されるように設定

  tags = {
    Name = "rds-sg"
  }
}