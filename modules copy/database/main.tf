resource "aws_db_instance" "default" {
  identifier         = "${var.env}-postgres-db"
  engine             = "postgres"
  engine_version     = "16.3"  # Specify the version you want
  instance_class     = var.db_instance_class
  allocated_storage  = var.db_allocated_storage
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
  skip_final_snapshot = true  # Set to false if you want to take a final snapshot before deletion

  tags = {
    Name = "${var.env}-postgres-db"
  }
}