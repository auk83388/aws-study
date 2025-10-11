#ELBの作成

resource "aws_lb" "web_elb" {
  name               = "web-elb"
  internal           = false #インターネットからアクセスできるかどうかを指定する設定
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]

  enable_deletion_protection = false #削除保護機能（今回は失敗して作り直せるように一旦オフ）
  tags = {
    name = "web-elb"
  }
}

#ターゲットグループの作成（先ほど作ったELBをどこに振り分けるかの設定）

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  #ヘルスチェックの設定で動いているのかの確認先のプロトコルの指定や正常、異常の判断の設定
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    name = "web-tg"
  }
}

#ELBリスナーの設定　ELBが受けた通信をどこに転送するかの設定（今回の場合は８０番ポートでHTTPを受け取ったら先ほど作ったweb-tgに転送する）

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_elb.arn
  port              = 80
  protocol          = "HTTP"
  #default_actionはリスナーが受け取った場所をどこに転送するかの定義
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

#EC2インスタンスをELBのターゲットに紐づけ

resource "aws_lb_target_group_attachment" "web_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.aws_ec2.id
  port             = 80
}