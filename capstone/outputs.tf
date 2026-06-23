output "alb_dns_name" {
  description = "NuvraPay API endpoint"
  value       = module.ecs.alb_dns_name
}

output "sqs_queue_url" {
  description = "Payment processing queue URL"
  value       = module.sqs.queue_url
}

output "cloudwatch_dashboard" {
  description = "Monitoring dashboard name"
  value       = module.monitoring.dashboard_name
}
