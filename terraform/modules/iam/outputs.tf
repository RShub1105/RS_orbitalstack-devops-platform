output "telemetry_ingestor_role_arn" {
  value = aws_iam_role.telemetry_ingestor.arn
}

output "ota_controller_role_arn" {
  value = aws_iam_role.ota_controller.arn
}

output "device_api_role_arn" {
  value = aws_iam_role.device_api.arn
}

