# Terraform AWS Kinesis Firehose Module

A reusable Terraform module that provisions a Kinesis Firehose delivery stream for logging data to S3, with CloudWatch logging enabled and IAM permissions automatically managed.

## Features

- 🚀 **Easy to use**: Only requires a `name` parameter for basic usage
- 🔧 **Flexible**: Option to create new S3 bucket or use existing one
- 📊 **Observable**: Built-in CloudWatch logging for monitoring
- 🔒 **Secure**: Automatic IAM role and policy creation
- 🏷️ **Tagged**: Support for custom tags on all resources
- ⚡ **Optimized**: Sensible defaults for buffering and compression

## Usage

### Basic Usage

```hcl
module "waf_firehose" {
  source = "path/to/terraform-aws-kinesis-stream"

  name = "waf-logs"

  tags = {
    Environment = "dev"
    Project     = "waf-kinesis-s3-logging"
  }
}
```

### Advanced Usage

```hcl
module "waf_firehose" {
  source = "path/to/terraform-aws-kinesis-stream"

  name            = "waf-logs"
  create_bucket   = false
  bucket_name     = "my-existing-bucket"
  bucket_prefix   = "waf-logs/!{timestamp:yyyy/MM/dd/}"
  compression_format = "GZIP"
  buffer_size     = 10
  buffer_interval = 60
  log_retention_days = 7

  tags = {
    Environment = "prod"
    Project     = "waf-kinesis-s3-logging"
    Team        = "security"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Base name for Firehose, S3 bucket, and CloudWatch log group | `string` | n/a | yes |
| create_bucket | Whether to create a new S3 bucket or use an existing one | `bool` | `true` | no |
| bucket_name | Existing bucket name (if create_bucket=false) | `string` | `null` | no |
| bucket_prefix | Prefix for objects written to S3 | `string` | `"${var.name}/!{timestamp:yyyy/MM/dd/}"` | no |
| error_output_prefix | Prefix for failed deliveries | `string` | `"errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"` | no |
| buffer_size | Firehose buffer size (MB) | `number` | `10` | no |
| buffer_interval | Buffer interval (seconds) | `number` | `60` | no |
| compression_format | Output format (GZIP, Snappy, Parquet) | `string` | `"GZIP"` | no |
| log_retention_days | Retention period for CloudWatch logs | `number` | `1` | no |
| tags | Map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| firehose_name | Name of the Firehose delivery stream |
| firehose_arn | ARN of the Firehose delivery stream |
| bucket_arn | ARN of the S3 bucket used |
| bucket_name | Name of the S3 bucket used |
| log_group_name | Name of the CloudWatch log group |
| log_group_arn | ARN of the CloudWatch log group |
| iam_role_arn | ARN of the IAM role for Firehose delivery |
| iam_role_name | Name of the IAM role for Firehose delivery |

## Resources Created

- **S3 Bucket** (optional): With versioning and server-side encryption
- **IAM Role & Policy**: Allows Firehose to write to S3 and CloudWatch Logs
- **CloudWatch Log Group & Stream**: For Firehose diagnostic logging
- **Kinesis Firehose Delivery Stream**: Configured with buffering, prefix, compression, and error output

## Examples

See the [examples](./examples/) directory for complete working examples.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 3.0 |

## License

This module is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
Terraform module for managing AWS Kinesis streams and logging pipelines
