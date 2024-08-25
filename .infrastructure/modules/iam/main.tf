resource "aws_iam_user" "sms_user" {
  name                 = "smsuser"
  path                 = "/"
  force_destroy        = true
  permissions_boundary = "arn:aws:iam::aws:policy/service-role/AmazonSNSRole"

  tags = {
    name = "smsuser"
  }
}

resource "aws_iam_access_key" "sms_user_key" {
  user = aws_iam_user.sms_user.name
}

resource "aws_iam_policy" "sns_user_policy" {
  name        = "sns_user"
  path        = "/"
  description = "AWS IAM Policy for SNS user role"
  policy      = file("json/policy.json")
}

resource "aws_iam_role" "sns_manager" {
  name               = "sns_manager"
  assume_role_policy = file("json/role.json")
}

resource "aws_iam_role_policy_attachment" "sns_attachment" {
  role       = aws_iam_role.sns_manager.id
  policy_arn = aws_iam_policy.sns_user_policy.arn
}

resource "aws_kms_key_policy" "key_policy" {
  key_id = aws_kms_key.sns_main.id
  policy = file("json/key_policy.json")
}

resource "aws_kms_key" "sns_main" {
  customer_master_key_spec = "RSA_2048"
  multi_region             = false
  key_usage                = "ENCRYPT_DECRYPT"
  enable_key_rotation      = false
}

resource "aws_sns_topic" "user_updates" {
  name              = "user-updates-topic"
  kms_master_key_id = aws_kms_key.sns_main.id
}