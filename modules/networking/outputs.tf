output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "security_group_id" {
  value = aws_security_group.main.id
}

output "private_subnet_id" {
  description = "First private subnet ID"
  value       = length(aws_subnet.private) > 0 ? aws_subnet.private[0].id : null
}