output "stream_name" {
  description = "Name of the Kinesis stream"
  value       = aws_kinesis_stream.kinesis_stream.name
}

output "stream_arn" {
  description = "ARN of the Kinesis stream"
  value       = aws_kinesis_stream.kinesis_stream.arn
}

output "stream_id" {
  description = "ID of the Kinesis stream"
  value       = aws_kinesis_stream.kinesis_stream.id
}

output "shard_count" {
  description = "Number of shards in the Kinesis stream"
  value       = aws_kinesis_stream.kinesis_stream.shard_count
}

output "retention_period" {
  description = "Retention period of the Kinesis stream (in hours)"
  value       = aws_kinesis_stream.kinesis_stream.retention_period
}

output "encryption_type" {
  description = "Encryption type of the Kinesis stream"
  value       = aws_kinesis_stream.kinesis_stream.encryption_type
}

output "kms_key_id" {
  description = "KMS key ID used for encryption"
  value       = aws_kinesis_stream.kinesis_stream.kms_key_id
}

output "admin_policy_arn" {
  description = "ARN of the admin IAM policy"
  value       = var.create_iam_policies && var.create_admin_policy ? aws_iam_policy.kinesis_admin_policy[0].arn : null
}

output "read_only_policy_arn" {
  description = "ARN of the read-only IAM policy"
  value       = var.create_iam_policies && var.create_read_only_policy ? aws_iam_policy.kinesis_read_only_policy[0].arn : null
}

output "write_only_policy_arn" {
  description = "ARN of the write-only IAM policy"
  value       = var.create_iam_policies && var.create_write_only_policy ? aws_iam_policy.kinesis_write_only_policy[0].arn : null
}

output "incoming_records_alarm_arn" {
  description = "ARN of the incoming records CloudWatch alarm"
  value       = var.enable_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.incoming_records_alarm[0].arn : null
}

output "iterator_age_alarm_arn" {
  description = "ARN of the iterator age CloudWatch alarm"
  value       = var.enable_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.iterator_age_alarm[0].arn : null
}
