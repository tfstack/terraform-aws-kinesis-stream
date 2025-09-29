variable "name" {
  description = "Name of the Kinesis stream"
  type        = string
}

variable "shard_count" {
  description = "Number of shards for the Kinesis stream"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream (in hours)"
  type        = number
  default     = 24
  validation {
    condition     = var.retention_period >= 24 && var.retention_period <= 8760
    error_message = "Retention period must be between 24 and 8760 hours."
  }
}

variable "shard_level_metrics" {
  description = "List of shard-level CloudWatch metrics to enable"
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([
      for metric in var.shard_level_metrics : contains([
        "IncomingRecords", "IncomingBytes", "OutgoingRecords", "OutgoingBytes",
        "WriteProvisionedThroughputExceeded", "ReadProvisionedThroughputExceeded",
        "IteratorAgeMilliseconds", "ALL"
      ], metric)
    ])
    error_message = "Shard level metrics must be valid Kinesis metrics."
  }
}

variable "encryption_type" {
  description = "Encryption type for the Kinesis stream"
  type        = string
  default     = "NONE"
  validation {
    condition     = contains(["NONE", "KMS"], var.encryption_type)
    error_message = "Encryption type must be either NONE or KMS."
  }
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (required when encryption_type is KMS)"
  type        = string
  default     = null
}

variable "enforce_consumer_deletion" {
  description = "Whether to enforce consumer deletion when the stream is deleted"
  type        = bool
  default     = false
}

variable "create_iam_policies" {
  description = "Whether to create IAM policies for the Kinesis stream"
  type        = bool
  default     = true
}

variable "create_admin_policy" {
  description = "Whether to create an admin IAM policy"
  type        = bool
  default     = true
}

variable "create_read_only_policy" {
  description = "Whether to create a read-only IAM policy"
  type        = bool
  default     = true
}

variable "create_write_only_policy" {
  description = "Whether to create a write-only IAM policy"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_alarms" {
  description = "Whether to create CloudWatch alarms for monitoring"
  type        = bool
  default     = false
}

variable "alarm_threshold_incoming_records" {
  description = "Threshold for incoming records alarm"
  type        = number
  default     = 1000
}

variable "alarm_threshold_iterator_age" {
  description = "Threshold for iterator age alarm (in milliseconds)"
  type        = number
  default     = 300000 # 5 minutes
}

variable "alarm_evaluation_periods" {
  description = "Number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 2
}

variable "alarm_period" {
  description = "Period in seconds over which the specified statistic is applied"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
