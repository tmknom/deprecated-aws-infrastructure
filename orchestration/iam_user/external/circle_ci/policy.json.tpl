{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "codedeploy:Batch*",
        "codedeploy:CreateDeployment",
        "codedeploy:Get*",
        "codedeploy:List*",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:codedeploy:${region}:${aws_account_id}:*:*"
    }
  ]
}
