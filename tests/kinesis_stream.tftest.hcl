# tests/kinesis_stream.tftest.hcl

variables {
  name                             = "test-kinesis-stream"
  shard_count                      = 2
  retention_period                 = 48
  shard_level_metrics              = ["IncomingRecords", "IncomingBytes", "OutgoingRecords", "OutgoingBytes"]
  encryption_type                  = "NONE"
  create_iam_policies              = true
  create_admin_policy              = true
  create_read_only_policy          = true
  create_write_only_policy         = true
  enable_cloudwatch_alarms         = true
  alarm_threshold_incoming_records = 1000
  alarm_threshold_iterator_age     = 300000
  enforce_consumer_deletion        = false
  tags = {
    Environment = "test"
    Project     = "kinesis-stream-test"
  }
}

run "kinesis_stream_test" {
  command = plan

  # Test Kinesis Stream basic properties
  assert {
    condition     = aws_kinesis_stream.kinesis_stream.name == var.name
    error_message = "Kinesis stream name does not match var.name"
  }

  assert {
    condition     = aws_kinesis_stream.kinesis_stream.shard_count == var.shard_count
    error_message = "Kinesis stream shard_count must match var.shard_count"
  }

  assert {
    condition     = aws_kinesis_stream.kinesis_stream.retention_period == var.retention_period
    error_message = "Kinesis stream retention_period must match var.retention_period"
  }

  assert {
    condition     = aws_kinesis_stream.kinesis_stream.encryption_type == var.encryption_type
    error_message = "Kinesis stream encryption_type must match var.encryption_type"
  }

  assert {
    condition     = aws_kinesis_stream.kinesis_stream.enforce_consumer_deletion == var.enforce_consumer_deletion
    error_message = "Kinesis stream enforce_consumer_deletion must match var.enforce_consumer_deletion"
  }

  # Test IAM Policies
  assert {
    condition     = length(aws_iam_policy.kinesis_admin_policy) == 1
    error_message = "Admin IAM policy should be created when create_admin_policy is true"
  }

  assert {
    condition     = length(aws_iam_policy.kinesis_read_only_policy) == 1
    error_message = "Read-only IAM policy should be created when create_read_only_policy is true"
  }

  assert {
    condition     = length(aws_iam_policy.kinesis_write_only_policy) == 1
    error_message = "Write-only IAM policy should be created when create_write_only_policy is true"
  }

  # Test CloudWatch Alarms
  assert {
    condition     = length(aws_cloudwatch_metric_alarm.incoming_records_alarm) == 1
    error_message = "Incoming records alarm should be created when enable_cloudwatch_alarms is true"
  }

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.iterator_age_alarm) == 1
    error_message = "Iterator age alarm should be created when enable_cloudwatch_alarms is true"
  }

  # Test alarm configurations
  assert {
    condition     = aws_cloudwatch_metric_alarm.incoming_records_alarm[0].threshold == var.alarm_threshold_incoming_records
    error_message = "Incoming records alarm threshold must match var.alarm_threshold_incoming_records"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.iterator_age_alarm[0].threshold == var.alarm_threshold_iterator_age
    error_message = "Iterator age alarm threshold must match var.alarm_threshold_iterator_age"
  }

  # Test tags
  assert {
    condition     = aws_kinesis_stream.kinesis_stream.tags.Environment == var.tags.Environment
    error_message = "Kinesis stream tags must include Environment tag"
  }

  assert {
    condition     = aws_kinesis_stream.kinesis_stream.tags.Project == var.tags.Project
    error_message = "Kinesis stream tags must include Project tag"
  }
}
