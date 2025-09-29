# Data source for current AWS region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Local values
locals {
  base_name = var.name
  tags = merge(var.tags, {
    Name = var.name
  })
}

# Kinesis Data Stream
resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.name
  shard_count      = var.shard_count
  retention_period = var.retention_period

  shard_level_metrics = var.shard_level_metrics

  encryption_type = var.encryption_type
  kms_key_id      = var.kms_key_id

  enforce_consumer_deletion = var.enforce_consumer_deletion

  tags = local.tags
}

# IAM Policies for Kinesis Stream Access
resource "aws_iam_policy" "kinesis_admin_policy" {
  count = var.create_iam_policies && var.create_admin_policy ? 1 : 0
  name  = "${var.name}-kinesis-admin-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:*"
        ]
        Resource = aws_kinesis_stream.kinesis_stream.arn
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "kinesis_read_only_policy" {
  count = var.create_iam_policies && var.create_read_only_policy ? 1 : 0
  name  = "${var.name}-kinesis-read-only-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListShards",
          "kinesis:ListStreams",
          "kinesis:SubscribeToShard"
        ]
        Resource = aws_kinesis_stream.kinesis_stream.arn
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "kinesis_write_only_policy" {
  count = var.create_iam_policies && var.create_write_only_policy ? 1 : 0
  name  = "${var.name}-kinesis-write-only-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = aws_kinesis_stream.kinesis_stream.arn
      }
    ]
  })

  tags = local.tags
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "incoming_records_alarm" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.name}-incoming-records-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "IncomingRecords"
  namespace           = "AWS/Kinesis"
  period              = var.alarm_period
  statistic           = "Sum"
  threshold           = var.alarm_threshold_incoming_records
  alarm_description   = "This metric monitors incoming records to Kinesis stream"
  alarm_actions       = []

  dimensions = {
    StreamName = aws_kinesis_stream.kinesis_stream.name
  }

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "iterator_age_alarm" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.name}-iterator-age-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "IteratorAgeMilliseconds"
  namespace           = "AWS/Kinesis"
  period              = var.alarm_period
  statistic           = "Maximum"
  threshold           = var.alarm_threshold_iterator_age
  alarm_description   = "This metric monitors iterator age for Kinesis stream"
  alarm_actions       = []

  dimensions = {
    StreamName = aws_kinesis_stream.kinesis_stream.name
  }

  tags = local.tags
}
