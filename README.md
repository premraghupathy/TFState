To setup remote TF state repository
===================================

1. Create S3 bucket, restrict all public access, encrypt, enable versioning
2. create dynamoDB table to store the lock while TF apply is run

3. terraform init
(creates S3 and DynamoDB)

4. add the 'backend' block to the above main.tf
provide
-> S3 bucket name
-> bucket key (objects in S3 are identied by 'key')
-> dynamoDB table name

5. terraform init (again...Initializing the backend...
<QUOTE>
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.72.1

Terraform has been successfully initialized!
</QUOTE>

6. navigate to s3\key to see the tfstate file

To see versioning in action
============================
1. delete one of the output blockin main.tf and save
2. terraformapply
<QUOTE>
aws_dynamodb_table.prem_tf_state_lock_dyna: Refreshing state... [id=prem-tf-state-lock-dyna]
aws_s3_bucket.prem_tf_state_s3: Refreshing state... [id=prem-tf-state-s3]
aws_s3_bucket_public_access_block.prem_tf_state_s3_access: Refreshing state... [id=prem-tf-state-s3]
aws_s3_bucket_server_side_encryption_configuration.prem_tf_state_s3_ssl: Refreshing state... [id=prem-tf-state-s3]
aws_s3_bucket_versioning.prem_tf_state_s3_ver: Refreshing state... [id=prem-tf-state-s3]

Changes to Outputs:
  - prem_tf_state_dynamodb_table_name = "prem-tf-state-lock-dyna" -> null

You can apply this plan to save these new output values to the Terraform state, without changing any real
infrastructure.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

prem_tf_state_s3_arn = "arn:aws:s3:::prem-tf-state-s3"

</QUOTE>

3. navigate to s3\key and slide button on show versions





