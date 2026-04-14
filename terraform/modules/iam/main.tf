locals {
  oidc_subject_base = "${replace(var.telemetry_oidc_url, "https://", "")}:sub"
}

resource "aws_iam_role" "telemetry_ingestor" {
  name = "orbital-telemetry-ingestor-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = { Federated = var.telemetry_oidc_arn }
      Condition = {
        StringEquals = {
          (local.oidc_subject_base) = "system:serviceaccount:orbital-production:telemetry-ingestor"
        }
      }
    }]
  })
  tags = var.tags
}

resource "aws_iam_role" "ota_controller" {
  name               = "orbital-ota-controller-role"
  assume_role_policy = aws_iam_role.telemetry_ingestor.assume_role_policy
  tags               = var.tags
}

resource "aws_iam_role" "device_api" {
  name               = "orbital-device-api-role"
  assume_role_policy = aws_iam_role.telemetry_ingestor.assume_role_policy
  tags               = var.tags
}

