output "alb_id" {
  description = "ID of the ALB"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.main.zone_id
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value       = aws_lb_target_group.service[*].arn
}

output "target_group_names" {
  description = "Names of the target groups"
  value       = aws_lb_target_group.service[*].name
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}
