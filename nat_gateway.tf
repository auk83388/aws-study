#Nat_gatewayの作成

#EIPの作成
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "Nat-eip"
  }
}

#Nat Gatewayの作成
resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  depends_on = [aws_internet_gateway.main_igw] #※１

  tags = {
    Name = "main_nat"
  }
}

#※１depends_onを設定することでmain_igwより後に作られるように設定を行っているこれを行わない場合main_igwより先に作られる
#そのためmain_igw→NATgatewayの関係が成立せづコンソール上でエラーが出る 

#プライベートルートテーブルにNATの追加
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_nat.id
}

#プライベートルートテーブルにdestination_cidr_block = "0.0.0.0/0"を設定るすることによってインターネット上で外から中は
#できないけど中から外には行けるようになっているそのためにプライベートルートテーブルで設定を行っている