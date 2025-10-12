# EC2の作成

# EC2　Instance

resource "aws_instance" "aws_ec2" {
  ami                         = "ami-0c3fd0f5d33134a76" # Amazon Linux 2(ap-northeast-1)の設定
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = "auk83388"
  associate_public_ip_address = true

  tags = {
    Name = "web-server"
  }
}

#amiはAmazon　Machine　imageの略今回の場合EC2インスタンスを作成する為のOSテンプレート