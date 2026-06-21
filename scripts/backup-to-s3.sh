#!/bin/bash

# ================================
# S3 Backup Script
# Nuvraverse — Richard Opaleye
# ================================
# Usage: ./backup-to-s3.sh <source-path> <bucket-name>

set -e

# Check arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source-path> <bucket-name>"
    exit 1
fi

source_path=$1
bucket_name=$2
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_name="backup_${timestamp}.tar.gz"

echo "================================"
echo "  S3 Backup Script"
echo "================================"
echo "Source: $source_path"
echo "Bucket: $bucket_name"
echo "Backup name: $backup_name"
echo ""

# Check source exists
if [ ! -e "$source_path" ]; then
    echo "ERROR: Source path does not exist: $source_path"
    exit 1
fi

# Create compressed archive
echo "Step 1: Compressing $source_path..."
tar -czf "/tmp/$backup_name" "$source_path" 2>/dev/null
echo "✅ Compression complete"

# Check bucket exists, create if not
echo ""
echo "Step 2: Checking bucket..."
if aws s3 ls "s3://$bucket_name" 2>/dev/null; then
    echo "✅ Bucket exists"
else
    echo "Bucket doesn't exist. Creating..."
    aws s3 mb "s3://$bucket_name"
    echo "✅ Bucket created"
fi

# Upload to S3
echo ""
echo "Step 3: Uploading to S3..."
aws s3 cp "/tmp/$backup_name" "s3://$bucket_name/backups/$backup_name"
echo "✅ Upload complete"

# Cleanup local temp file
rm "/tmp/$backup_name"

echo ""
echo "================================"
echo "  Backup Complete! 🎉"
echo "  Location: s3://$bucket_name/backups/$backup_name"
echo "================================"
