resource "aws_iam_role" "instancerole" {
  name = "GoadInstanceRole"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "goadserverinstancerole"
  role = aws_iam_role.instancerole.name
}
