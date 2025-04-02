# resource "google_compute_security_policy" "policy" {
#   name        = "waf-policy-${var.common.prefix}-${var.common.env}"
#   description = "DDoS攻撃防御とOWASP Top 10対策のためのセキュリティポリシー"
# }

# resource "google_compute_security_policy_rule" "rate_limit_throttle" {
#   security_policy  = google_compute_security_policy.policy.name
#   preview          = true
#   priority         = 1000
#   action           = "throttle"
#   description      = "各クライアントからのリクエストを1分あたり100件に制限する"
#   match {
#     versioned_expr = "SRC_IPS_V1"
#   }
#   rate_limit_options {
#     rate_limit_threshold {
#       count = 100
#       interval_sec = 60
#     }
#   }
# }

# resource "google_compute_security_policy_rule" "block_country" {
#   security_policy  = google_compute_security_policy.policy.name
#   preview          = true
#   priority         = 5000
#   action           = "deny(403)"
#   description      = "中国からのトラフィックをブロックする"
#   match {
#     expr {
#       expression = "origin.region_code == 'CN'"
#     }
#   }
# }

# resource "google_compute_security_policy_rule" "sqli_protection" {
#   security_policy  = google_compute_security_policy.policy.name
#   preview          = true
#   priority         = 7000
#   action           = "deny(403)"
#   description      = "SQLインジェクション攻撃から保護する（感度レベル2）"
#   match {
#     expr {
#       expression = "evaluatePreconfiguredWaf('sqli-v33-stable', {'sensitivity': 2})"
#     }
#   }
# }

# resource "google_compute_security_policy_rule" "xss_protection" {
#   security_policy  = google_compute_security_policy.policy.name
#   priority         = 8000
#   action           = "deny(403)"
#   description      = "クロスサイトスクリプティング攻撃から保護する（感度レベル2）"
#   match {
#     expr {
#       expression = "evaluatePreconfiguredWaf('xss-v33-stable', {'sensitivity': 2})"
#     }
#   }
# }
