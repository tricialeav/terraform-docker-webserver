####################################################################
# ECS Service
####################################################################

resource "aws_iam_role" "ecs_service_role" {
  name = "ecs_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "ecs.amazonaws.com", 
            "ecs-tasks.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_service_policy" {
  name = "ecs_service_policy"
  role = aws_iam_role.ecs_service_role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "ec2:AttachNetworkInterface",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteNetworkInterfacePermission",
            "ec2:Describe*",
            "ec2:DetachNetworkInterface",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets",
            "iam:PassRole",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:DescribeLogStreams",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "*",
        "Condition": {"StringLike": {"iam:ResourceTag/name": "tf-docker"}}
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "ecs_task_policy"
  role = aws_iam_role.ecs_task_role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "*",
        "Condition": {"StringLike": {"iam:ResourceTag/name": "tf-docker"}}
        }, 
        {
        "Action": [
            "dynamodb:Scan",
            "dynamodb:Query",
            "dynamodb:UpdateItem",
            "dynamodb:GetItem"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}*"
        }
    ]
}
  EOF
}