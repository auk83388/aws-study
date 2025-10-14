#AWSシークレットマネジャーの作成

resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "rds-mysql-secret"
  description = "RDS mysql credentials managed by terraform"
}

#暗号化の内容
resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "auk83388"
    password = "Hinata311"
  })
}

data "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
}


#JsonをTerraformで使いやすく変換する設定（ほぼ必須TerraformでJsonを使う場合単なる文字列になるので
#usernameやpasswardを取り出せないのでこの設定をいれることでJsonを使えるようにできる）
locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_version.secret_string)
}