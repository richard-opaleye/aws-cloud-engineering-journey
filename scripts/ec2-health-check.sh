#!/bin/bash

# ================================
# EC2 Health Check Script
# Nuvraverse — Richard Opaleye
# ================================

echo "================================"
echo "  EC2 Instance Health Report"
echo "  $(date)"
echo "================================"
echo ""

# Get all instance IDs and their states
instances=$(aws ec2 describe-instances \
  --query "Reservations[].Instances[].[InstanceId,State.Name,InstanceType,Tags[?Key=='Name'].Value | [0]]" \
  --output text)

if [ -z "$instances" ]; then
    echo "No EC2 instances found."
    exit 0
fi

# Loop through each instance
echo "$instances" | while read -r id state type name; do
    echo "Instance: $name"
    echo "  ID: $id"
    echo "  Type: $type"
    echo "  State: $state"

    if [ "$state" == "running" ]; then
        echo "  Status: ✅ Healthy"
    elif [ "$state" == "stopped" ]; then
        echo "  Status: ⏸️  Stopped"
    else
        echo "  Status: ⚠️  $state"
    fi
    echo ""
done

echo "================================"
echo "  Report Complete"
echo "================================"
