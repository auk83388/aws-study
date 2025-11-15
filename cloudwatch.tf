#cloudwatchの作成

#cloudwarchlogグループの作成
resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = "/ec2/web-server" #ロググループ名
  retention_in_days = 7                 #ログの保存期間の設定

  tags = {
    name = "ec2-logs-group"
  }
}

#CloudwatchLog内でEC２用専用のLogファイルの作成

resource "aws_cloudwatch_log_stream" "ec2_log_stream" {
  name           = "ec2-log-stream"
  log_group_name = aws_cloudwatch_log_group.ec2_log_group.name
}

#cloudwatchアラームの作成
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_hiph_alarm"
  comparison_operator = "GreaterThanThreshold" #どんな条件で発火するかの設定
  evaluation_periods  = 2                      #２回連続で条件に達したら
  metric_name         = "CPUUtilization"       #監視対象のメトリクス
  namespace           = "AWS/EC2"              #EC2のメトリクス領域
  period              = 60                     #評価間隔
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Trigger when EC2 CPU > 80%"
  dimensions = {
    InstanceId = aws_instance.aws_ec2.id #監視対象今回の場合EC2
  }

  actions_enabled = false #アラームが反応したときの通知アクションの設定（今回は無効）

  tags = {
    Name = "cpu-hiph-alarm"
  }
}