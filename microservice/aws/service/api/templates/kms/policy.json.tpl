{
    "Sid": "Enable IAM Role Permissions",
    "Effect": "Allow",
    "Principal": {
        "AWS": "${role}"
    },
    "Action": "kms:*",
    "Resource": "*"
}