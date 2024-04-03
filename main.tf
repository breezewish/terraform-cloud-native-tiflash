terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.53.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = local.region
  default_tags {
    tags = {
      Usage = local.namespace
    }
  }
}

resource "random_id" "id" {
  byte_length = 4
}

resource "aws_key_pair" "master_key" {
  public_key = file(local.master_ssh_public)
}

resource "aws_instance" "tidb" {
  count = local.n_tidb

  ami                         = local.image
  instance_type               = local.tidb_instance
  key_name                    = aws_key_pair.master_key.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  private_ip                  = "172.31.7.${count.index + 1}"

  root_block_device {
    volume_size           = 100
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
  }

  tags = {
    Name = "${local.namespace}-tidb-${count.index}"
  }

  user_data_base64 = data.cloudinit_config.common_server.rendered
}

resource "aws_instance" "pd" {
  ami                         = local.image
  instance_type               = local.pd_instance
  key_name                    = aws_key_pair.master_key.id
  vpc_security_group_ids      = [aws_security_group.ssh.id, aws_security_group.etcd.id, aws_security_group.grafana.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  private_ip                  = "172.31.8.1"

  root_block_device {
    volume_size           = 100
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
  }

  tags = {
    Name = "${local.namespace}-pd-1"
  }

  user_data_base64 = data.cloudinit_config.common_server.rendered
}

resource "aws_instance" "tikv" {
  count = local.n_tikv

  ami                         = local.image
  instance_type               = local.tikv_instance
  key_name                    = aws_key_pair.master_key.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  private_ip                  = "172.31.6.${count.index + 1}"

  root_block_device {
    volume_size           = 400
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 4000
    throughput            = 288
  }

  tags = {
    Name = "${local.namespace}-tikv-${count.index}"
  }

  user_data_base64 = data.cloudinit_config.common_server.rendered
}

resource "aws_instance" "tiflash_write" {
  count = local.n_tiflash_write

  ami                         = local.image
  instance_type               = local.tiflash_instance
  key_name                    = aws_key_pair.master_key.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  private_ip                  = "172.31.9.${count.index + 1}"

  root_block_device {
    volume_size           = 400
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 4000
    throughput            = 288
  }

  tags = {
    Name = "${local.namespace}-tiflash-write-${count.index}"
  }

  user_data_base64 = data.cloudinit_config.common_server.rendered
}

resource "aws_instance" "tiflash_compute" {
  count = local.n_tiflash_compute

  ami                         = local.image
  instance_type               = local.tiflash_instance
  key_name                    = aws_key_pair.master_key.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  private_ip                  = "172.31.10.${count.index + 1}"

  root_block_device {
    volume_size           = 400
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 4000
    throughput            = 288
  }

  tags = {
    Name = "${local.namespace}-tiflash-compute-${count.index}"
  }

  user_data_base64 = data.cloudinit_config.common_server.rendered
}

resource "aws_instance" "center" {
  ami                         = local.image
  instance_type               = local.center_instance
  key_name                    = aws_key_pair.master_key.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  private_ip                  = "172.31.1.1"

  root_block_device {
    volume_size           = 200
    delete_on_termination = true
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
  }

  tags = {
    Name = "${local.namespace}-center"
  }

  user_data_base64 = data.cloudinit_config.center_server.rendered
}
