# Simple Kinesis Stream Example
# This example shows how to use the Kinesis stream module

terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

# Local values
locals {
  stream_name      = "example-kinesis-stream"
  shard_count      = 2
  retention_period = 48
  encryption_type  = "NONE"
  environment      = "dev"
  project_name     = "kinesis-example"
}

# Kinesis Stream
module "kinesis_stream" {
  source = "../../"

  name             = local.stream_name
  shard_count      = local.shard_count
  retention_period = local.retention_period
  encryption_type  = local.encryption_type

  # Enable IAM policies
  create_iam_policies = true

  # Enable monitoring
  enable_cloudwatch_alarms = true

  tags = {
    Environment = local.environment
    Project     = local.project_name
  }
}

# Outputs
output "stream_name" {
  description = "Name of the Kinesis stream"
  value       = module.kinesis_stream.stream_name
}

output "stream_arn" {
  description = "ARN of the Kinesis stream"
  value       = module.kinesis_stream.stream_arn
}

output "shard_count" {
  description = "Number of shards in the stream"
  value       = module.kinesis_stream.shard_count
}
