#code copied from aws_eip data source example in the terraform docs
# data "aws_eip" "by_allocation_id" {
#   id = "eipalloc-078f47c7dc2ceaa06"
# }

#data.aws_eip.by_allocation_id.id



# Pull existing data source from the console using the key id." 
# This is used if the resource is already existed in console.
# Another option is to create a new one using the resource block.
data "aws_kms_key" "rds_kms" {
  key_id = "alias/${var.environment}-kms"
}

#to use the aws_kms_key copy below
#data.aws_kms_key.rds_kms.arn




# iF i want the region
data "aws_region" "current" {}
#data.aws_region.current.name

# If I want the account ID
data "aws_caller_identity" "current" {}
#data.aws_caller_identity.current.account_id