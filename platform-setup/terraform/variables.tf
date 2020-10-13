variable "map_users" {
  description = "Additional IAM users to be added to aws-auth"
  default = [
    { 
      "groups": [ "system:masters" ],
      "userarn": "arn:aws:iam::318839763251:user/ephemeral-gha-user", 
      "username": "ephemeral-gha-user" 
    },
  ]
}

variable "ephemeral_hostedzone_arn" {
  description = "ARN for route53 hosted zone for ephemeral environment"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  default     = {}
}

variable "region" {
  description = "AWS region"
}