# tf-oci-core-mod-iam

This project is maintained by ["Version 1"](https://www.version1.com). 
 
--- 
 
## Overview 
 
This project creates an IAM Role, Profile and associated Polices based on provided JSON IAM Policy Documents.
 
## Usage  

To create a new module, clone this repository and navigate to .pipeline and populdate the terraform.tfvars with module specific details and apply with tf init and apply.

Include this module in your existing terraform code: 
 
```hcl 
module "role" {
  source = ""

  enabled            = "true"
  label              = module.label.id
  policy_description = "Profile for Testing CI"
  role_description   = "Role for Testing CI"

  principals = {
    AWS = "ec2.amazonaws.com"
  }

  policy_documents = [
    "${data.aws_iam_policy_document.resource_full_access.json}",
    "${data.aws_iam_policy_document.base.json}",
  ]
}

``` 
 
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| enabled | Set to `false` to prevent the module from creating any resources | `string` | `"true"` | no |
| label | Environment Label | `any` | n/a | yes |
| max\_session\_duration | The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours | `number` | `3600` | no |
| policy\_description | The description of the IAM policy that is visible in the IAM policy manager | `string` | n/a | yes |
| policy\_document\_count | Number of policy documents (length of policy\_documents list). | `number` | `1` | no |
| policy\_documents | List of JSON IAM policy documents | `list(string)` | `[]` | no |
| principals | Map of service name as key and a list of ARNs to allow assuming the role as value. (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`))) | `map(string)` | `{}` | no |
| role\_description | The description of the IAM role that is visible in the IAM role manager | `string` | n/a | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) specifying the role |
| id | The stable and unique string identifying the role |
| name | The name of the IAM role created |
| policy | Role policy document in json format. Outputs always, independent of `enabled` variable |
| profile | The name of the IAM profile created |

## Example  
 
    * `example/complete` - contains a full working example of the module 
 
## Primary Conventions 
 
1. **Naming Convention** - Module repository names must follow the `tf-$PROVIDER-mod-$NAME` naming convention, where `$NAME` is the descriptive label for the infra provisioned, and `$PROVIDER` the primary provider provisioning the infra e.g. aws. Use hyphens (-) to separate all fields. Do not use underscores (_). 
 
The naming convention as reccomended by terraform-best-practices should be adhered to - [https://www.terraform-best-practices.com/naming](https://www.terraform-best-practices.com/naming) 
 
2. **Standard Module Structure** - The module must follow the [standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure) as included within the base AWS module, and include a example/complete. 
 
    * `main.tf` - call modules, locals and data-sources to create all resources 
    * `variables.tf` - contains declarations of variables used in `main.tf` 
    * `outputs.tf` - contains outputs from the resources created in `main.tf` 
    * `example/complete` - contains a full working example of the module 
    * `.pipeline` - contains the scaffolding for the module, pipeline definitions, repository etc.
 
3. **Use Semantic Versioning** - Every release should have a tag in the x.y.z format. Use semantic versions for tagged releases and prefixed with a v (e.g. v1.0.1 or 1.0.1) as per the guide here [https://semver.org/](https://semver.org/).
 
## When to write a module 
We do not recommend writing modules that are just thin wrappers around single other resource types.  
If you have trouble finding a name for your module that isn't the same as the main resource type inside it, that may be a sign that your module is not creating any new abstraction and so the module is adding unnecessary complexity. Just use the resource type directly in the calling module instead. 
 
--- 
 
_Copyright © 2020 [Version 1](https://www.version1.com)_ 