{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM Role Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${role}"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}