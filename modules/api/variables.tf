variable "functionDocManagementArn" {
  description = "ARN of the Doc Management Lambda function"
  type        = string
}

variable "functionDocRoutingArn" {
  description = "ARN of the Doc Routing Lambda function"
  type        = string
}

variable "functionIndepthArn" {
  description = "ARN of the Indepth Lambda function"
  type        = string
}

variable "functionLLMArn" {
  description = "ARN of the LLM Lambda function"
  type        = string
}

variable "functionPastMapperArn" {
  description = "ARN of the Past Mapper Lambda function"
  type        = string
}

variable "functionPullDocumentArn" {
  description = "ARN of the Pull Document Lambda function"
  type        = string
}

variable "functionReturnInfoArn" {
  description = "ARN of the Return Info Lambda function"
  type        = string
}

variable "data_flow" {
  description = "Data flow configuration"
  type        = string
  default     = "dataflow"
}