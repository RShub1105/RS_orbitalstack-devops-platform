resource "aws_sqs_queue" "telemetry" {
  name = "orbital-telemetry"
  tags = var.tags
}

resource "aws_iot_policy" "device_policy" {
  name = "orbital-device-cert-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect   = "Allow"
        Action   = ["iot:Connect", "iot:Publish", "iot:Subscribe", "iot:Receive"]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iot_topic_rule" "telemetry_forward" {
  name        = "orbitalTelemetryForward"
  enabled     = true
  sql         = "SELECT * FROM 'devices/+/telemetry'"
  sql_version = "2016-03-23"
  sqs {
    role_arn   = "arn:aws:iam::123456789012:role/orbital-iot-rule-role"
    queue_url  = aws_sqs_queue.telemetry.id
    use_base64 = false
  }
}
