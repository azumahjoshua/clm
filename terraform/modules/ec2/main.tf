resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_name
  associate_public_ip_address = var.enable_public_ip
  iam_instance_profile = var.iam_instance_profile
  root_block_device {
    volume_size = var.root_block_device[0].volume_size
    volume_type = var.root_block_device[0].volume_type
    delete_on_termination = var.root_block_device[0].delete_on_termination
  }
  tags = merge(
    {
      Name = "${var.instance_name}-${count.index}"
    },
    var.tags
  )
}