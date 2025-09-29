# Kinesis Stream Example

This example demonstrates how to use the `terraform-aws-kinesis-stream` module to create a Kinesis Data Stream.

## What This Example Creates

- **Kinesis Data Stream**: With configurable shard count and retention period
- **IAM Policies**: Admin, read-only, and write-only policies for stream access
- **CloudWatch Alarms**: Monitoring for incoming records and iterator age
- **Tags**: Environment and project tagging for resource management

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Review the plan**:

   ```bash
   terraform plan
   ```

3. **Apply the configuration**:

   ```bash
   terraform apply
   ```

## Configuration

The example uses these values defined in `locals`:

- **Stream Name**: `example-kinesis-stream`
- **AWS Region**: `us-west-2`
- **Shard Count**: 2
- **Retention Period**: 48 hours
- **Encryption**: None
- **Environment**: dev
- **Project**: kinesis-example

To customize the configuration, simply edit the values in the `locals` block in `main.tf`.

## Outputs

After applying, you'll get:

- Kinesis stream name and ARN
- Number of shards in the stream

## Clean Up

To destroy the resources:

```bash
terraform destroy
```
