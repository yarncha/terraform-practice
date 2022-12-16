# resource "aws_iam_instance_profile" "ec2profile" {
#   name = "ec2profile"
#   role = aws_iam_role.ec2role.name
# }

# # EC2 ROLE
# resource "aws_iam_role" "ec2role" {
#   name = var.ec2_role_name

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# # Bastion EC2 Policy attachment
# resource "aws_iam_role_policy_attachment" "ec2-AmazonEC2RoleforSSM-bastion" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#   role       = aws_iam_role.ec2role.name
# }

# resource "aws_iam_role_policy_attachment" "ec2-Admin-bastion" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.ec2role.name
# }

# # WEB01 EC2 Policy attachment
# resource "aws_iam_role_policy_attachment" "ec2-AmazonEC2RoleforSSM-web01" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#   role       = aws_iam_role.ec2role.name
# }

# resource "aws_iam_role_policy_attachment" "ec2-Admin-web01" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.ec2role.name
# }

# # WEB02 EC2 Policy attachment
# resource "aws_iam_role_policy_attachment" "ec2-AmazonEC2RoleforSSM-web02" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#   role       = aws_iam_role.ec2role.name
# }

# resource "aws_iam_role_policy_attachment" "ec2-Admin-web02" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.ec2role.name
# }

# # WAS01 EC2 Policy attachment
# resource "aws_iam_role_policy_attachment" "ec2-AmazonEC2RoleforSSM-was01" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#   role       = aws_iam_role.ec2role.name
# }

# resource "aws_iam_role_policy_attachment" "ec2-Admin-was01" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.ec2role.name
# }

# # WAS02 EC2 Policy attachment
# resource "aws_iam_role_policy_attachment" "ec2-AmazonEC2RoleforSSM-was02" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#   role       = aws_iam_role.ec2role.name
# }

# resource "aws_iam_role_policy_attachment" "ec2-Admin-was02" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.ec2role.name
# }

# # DB01 EC2 Policy attachment
# resource "aws_iam_role_policy_attachment" "ec2-AmazonEC2RoleforSSM-db01" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#   role       = aws_iam_role.ec2role.name
# }

# resource "aws_iam_role_policy_attachment" "ec2-Admin-db01" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = aws_iam_role.ec2role.name
# }