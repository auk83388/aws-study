#AWSWAFの設定（ALBを攻撃からの保護）

#Web ACL（WAF本体）の作成

resource "aws_wafv2_web_acl" "web_acl" { #WAF本体にあたりどのルールを使って攻撃を検収ブロックするか定義するリソース
  name        = "web-acl"
  description = "Protect ALB from common attacks"
  scope       = "REGIONAL"


  #デフォルトの動作の設定
  default_action {
    allow {}
  }


  #　AWSが提供する共通攻撃対策ルールを有効化
  rule {
    name     = "AWSManagedRulesCommonRuleSet" #AWSが提供しているSQLインジェクション、XSSなどの共通防御ルールを自動で適用してくれる
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-common"
      sampled_requests_enabled   = true
    }
  }
  #不正なリクエストを検出するための設定
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-web-acl"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "web-acl"
  }
}

#WAFをELBとの関連付け
resource "aws_wafv2_web_acl_association" "web_acl_assoc" {
  resource_arn = aws_lb.web_elb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}