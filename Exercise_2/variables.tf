# TODO: Define the variable for aws_region
variable "aws_region" {
  default = "us-east-1"
}

variable "access_key" {
  default = "AKIAVWQKGVM23A336LHL"
}

variable "secret_key" {
  default = "btbziyMwINBWahM9VjDoSi2/Vb/1R26PrH87Vyiu"
}

variable "lambda_name" {
  default = "greet_lambda"
}

variable "lambda_file" {
  default = "greet_lambda.zip"
}

variable "lambda_handler_name" {
  default = "lambda_handler"
}

variable "lambda_runtime" {
  default = "python3.9"
}

variable "hello_world" {
  default = "Hello world"
}