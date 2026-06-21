#!/bin/bash

# ================================
# AWS Account Audit Script
# Nuvraverse — Richard Opaleye
# ================================

echo "================================"
echo "  AWS Account Audit Report"
echo "  $(date)"
echo "================================"
echo ""

# Account identity
echo "--- Account Identity ---"
aws sts get-caller-identity --query "{Account:Account,User:Arn}" --output table
echo ""

# EC2 Summary
echo "--- EC2 Instances ---"
total_instances=$(aws ec2 describe-instances --query "length(Reservations[].Instances[])")
running_instances=$(aws ec2 describe-instances --query "length(Reservations[].Instances[?State.Name=='running'][])")
echo "Total instances: $total_instances"
echo "Running instances: $running_instances"
echo ""

# S3 Buckets
echo "--- S3 Buckets ---"
bucket_count=$(aws s3api list-buckets --query "length(Buckets)")
echo "Total buckets: $bucket_count"
aws s3api list-buckets --query "Buckets[].{Name:Name,Created:CreationDate}" --output table
echo ""

# Security Groups
echo "--- Security Groups with Open SSH (0.0.0.0/0) ---"
aws ec2 describe-security-groups --query "SecurityGroups[?IpPermissions[?ToPort==\`22\` && contains(IpRanges[].CidrIp, '0.0.0.0/0')]].{Name:GroupName,ID:GroupId}" --output table
echo ""

# IAM Users
echo "--- IAM Users ---"
aws iam list-users --query "Users[].{Name:UserName,Created:CreateDate}" --output table
echo ""

echo "================================"
echo "  Audit Complete"
echo "================================"
