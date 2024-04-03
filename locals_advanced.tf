# Changes to these locals are easy to break something. Ensure you know what you are doing (see each comment).

locals {
  # image is region-local. If you changed region, please also change image.
  # AMIs of each region (Ubuntu 20.04 + OMZ + KernelTunes):
  # us-east-1	ami-0454a7af38c718b80
  # us-east-2	ami-052a8e83f950981e6
  # us-west-1	ami-0bf9994041badd206
  # us-west-2	ami-045b4649ab79b58da
  region = "us-west-2"
  image  = "ami-045b4649ab79b58da"

  # If you want to change instance type, ensure that GP3 EBS is available in the instance type.
  tidb_instance    = "c5.2xlarge"
  tikv_instance    = "c5.2xlarge"
  pd_instance      = "c5.2xlarge"
  tiflash_instance = "r5.2xlarge"
  center_instance  = "c5.2xlarge"

  master_ssh_key         = "./master_key"
  master_ssh_public      = "./master_key.pub"
  alternative_ssh_public = "~/.ssh/id_rsa.pub"
}
