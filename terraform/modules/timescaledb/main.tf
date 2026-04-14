resource "aws_db_subnet_group" "this" {
  name       = "orbital-timescaledb"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "db" {
  name   = "orbital-timescaledb"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_db_parameter_group" "this" {
  name   = "orbital-timescaledb-params"
  family = "postgres15"
  parameter {
    name  = "shared_preload_libraries"
    value = "timescaledb"
  }
  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier              = "orbital-timescaledb"
  engine                  = "postgres"
  engine_version          = "15.7"
  instance_class          = "db.r6g.large"
  allocated_storage       = 200
  storage_type            = "gp3"
  storage_encrypted       = true
  multi_az                = true
  backup_retention_period = 14
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = aws_db_parameter_group.this.name
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  skip_final_snapshot     = true
  tags                    = var.tags
}

