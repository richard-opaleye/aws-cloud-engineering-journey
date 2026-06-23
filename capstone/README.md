# NuvraPay Cloud Platform

A production-grade payment API infrastructure built on AWS, demonstrating end-to-end cloud engineering skills across infrastructure, containers, CI/CD, security, and monitoring.

## Architecture Overview
## Infrastructure Components

| Component | Service | Purpose |
|-----------|---------|---------|
| Networking | VPC + Subnets | Isolated network, public/private tiers |
| Compute | ECS Fargate | Serverless containers, zero server management |
| Load Balancing | ALB | Traffic distribution across 2 AZs |
| Async Processing | SQS + DLQ | Decoupled payment processing |
| Monitoring | CloudWatch | Alarms, dashboard, log aggregation |
| IaC | Terraform | All infrastructure as code |

## Architecture Decisions

### Why ECS Fargate over Lambda for the API?
Lambda's cold starts and 15-minute execution limit are unsuitable for a latency-sensitive payment API. Fargate provides consistent performance, persistent database connections without connection pool thrashing, and native zero-downtime rolling deployments.

### Why SQS for payment processing?
Payment processing takes 3-5 seconds. The API returns 202 Accepted immediately after dropping a message on the queue. Processing happens asynchronously — no customer waits, no payment is lost even if the processor is temporarily down.

### Why PostgreSQL over DynamoDB?
Financial transactions require ACID compliance — atomicity, consistency, isolation, durability. PostgreSQL's row-level locking prevents race conditions when multiple processes update the same transaction record.

### Zero Downtime Deployments
ECS rolling deployment with minimum_healthy_percent=100, maximum_percent=200. New tasks must pass ALB health checks before old tasks are terminated. GitHub Actions pipeline waits for service stability before reporting success.

### Security Model
- ecsTaskExecutionRole: pulls ECR images + writes CloudWatch logs
- ecsTaskRole: sends messages to SQS only (least privilege)
- Secrets Manager: database credentials, never in code or logs
- Security groups chained: internet → ALB → ECS → RDS

## Monitoring

Three production-grade alarms:
1. **SQS Queue Depth > 500** — payment backlog, scale out immediately
2. **ALB 5XX Rate > 10/minute** — backend errors, real money failing
3. **RDS Connections > 80%** — connection pool exhaustion risk

## Infrastructure as Code

```bash
# Deploy entire platform
terraform init
terraform plan
terraform apply

# Destroy everything
terraform destroy
```

## Module Structure
## Skills Demonstrated

- AWS VPC, ECS Fargate, ALB, SQS, CloudWatch
- Terraform modules with remote state
- GitHub Actions CI/CD pipeline
- IAM least-privilege security model
- Production monitoring and alerting
- Architecture decision-making

## Built By

Richard Opaleye — Nuvraverse — Lagos, Nigeria
30-Day AWS Cloud Engineering Bootcamp
github.com/richard-opaleye/aws-cloud-engineering-journey
