resource "aws_key_pair" "this" {
  key_name   = "${var.stack}.${var.env}.key"
  public_key = "${file("${path.module}/keys/${var.stack}.${var.env}.pub")}"
}
