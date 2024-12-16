# # Define the models
# resource "aws_sagemaker_model" "llama_3_2_3b_instruct" {
#   name               = "llama-3-2-3b-instruct"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMaker-ExecutionRole-20231011T100538"

#   primary_container {
#     image = "482718065396.dkr.ecr.us-east-2.amazonaws.com/llama3binstruct:latest"
#     model_data_url = "s3://llama-32-3b-instruct/llama-3_2-3b-instruct.tar.gz"
#   }
# }

# resource "aws_sagemaker_model" "meta_llama_3_1_8b_instruct" {
#   name               = "meta-llama-3-1-8b-instruct-151106"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMaker-ExecutionRole-20231011T100538"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/djl-inference:0.29.0-lmi11.0.0-cu124"

#     model_data_source {
#       s3_data_source {
#         s3_uri = "s3://jumpstart-private-cache-prod-us-east-2/meta-textgeneration/meta-textgeneration-llama-3-1-8b-instruct/artifacts/inference-prepack/v2.0.0/"
#         s3_data_type = "S3Prefix"
#         compression_type = "None"
#       }
#     }

#     environment = {
#       ENDPOINT_SERVER_TIMEOUT = "3600"
#       HF_MODEL_ID = "/opt/ml/model"
#       MODEL_CACHE_ROOT = "/opt/ml/model"
#       OPTION_ENABLE_CHUNKED_PREFILL = "true"
#       SAGEMAKER_ENV = "1"
#       SAGEMAKER_MODEL_SERVER_WORKERS = "1"
#       SAGEMAKER_PROGRAM = "inference.py"
#     }
#   }
# }

# resource "aws_sagemaker_model" "meta_llama_3_2_3b_instruct_neuron" {
#   name               = "meta-llama-3-2-3b-instruct-neuron-014541"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMaker-ExecutionRole-20231011T100538"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/djl-inference:0.29.0-neuronx-sdk2.19.1"

#     model_data_source {
#       s3_data_source {
#         s3_uri = "s3://jumpstart-private-cache-prod-us-east-2/meta-textgenerationneuron/meta-textgenerationneuron-llama-3-2-3b-instruct/artifacts/inference-prepack/v1.0.0/"
#         s3_data_type = "S3Prefix"
#         compression_type = "None"
#       }
#     }

#     environment = {
#       ENDPOINT_SERVER_TIMEOUT = "3600"
#       OPTION_DTYPE = "bf16"
#       OPTION_ENTRYPOINT = "inference.py"
#       OPTION_LOAD_SPLIT_MODEL = "False"
#       OPTION_MAX_ROLLING_BATCH_SIZE = "8"
#       OPTION_MODEL_LOADING_TIMEOUT = "6000"
#       OPTION_NEURON_OPTIMIZE_LEVEL = "2"
#       OPTION_N_POSITIONS = "8192"
#       OPTION_ROLLING_BATCH = "auto"
#       OPTION_TENSOR_PARALLEL_DEGREE = "2"
#       OPTION_TRUST_REMOTE_CODE = "true"
#       SAGEMAKER_MODEL_SERVER_WORKERS = "1"
#       SAGEMAKER_PROGRAM = "inference.py"
#       SERVING_LOAD_MODELS = "test::Python=/opt/ml/model"
#     }
#   }
# }

# resource "aws_sagemaker_model" "meta_llama_3_2_1b_instruct" {
#   name               = "meta-llama-3-2-1b-instruct-185751"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMaker-ExecutionRole-20231011T100538"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/djl-inference:0.29.0-lmi11.0.0-cu124"

#     model_data_source {
#       s3_data_source {
#         s3_uri = "s3://jumpstart-private-cache-prod-us-east-2/meta-textgeneration/meta-textgeneration-llama-3-2-1b-instruct/artifacts/inference-prepack/v1.0.0/"
#         s3_data_type = "S3Prefix"
#         compression_type = "None"
#       }
#     }

#     environment = {
#       ENDPOINT_SERVER_TIMEOUT = "3600"
#       HF_MODEL_ID = "/opt/ml/model"
#       MODEL_CACHE_ROOT = "/opt/ml/model"
#       OPTION_ENABLE_CHUNKED_PREFILL = "true"
#       SAGEMAKER_ENV = "1"
#       SAGEMAKER_MODEL_SERVER_WORKERS = "1"
#       SAGEMAKER_PROGRAM = "inference.py"
#     }
#   }
# }

# resource "aws_sagemaker_model" "pytorch_inference" {
#   name               = "pytorch-inference-2024-09-23-01-43-01-385"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMaker-ExecutionRole-20231011T100538"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/pytorch-inference:1.10.0-gpu-py38"
#     model_data_url = "s3://sagemaker-us-east-2-482718065396/pytorch-inference-2024-09-23-00-12-32-724/model.tar.gz"

#     environment = {
#       SAGEMAKER_CONTAINER_LOG_LEVEL = "20"
#       SAGEMAKER_PROGRAM = "inference.py"
#       SAGEMAKER_REGION = "us-east-2"
#       SAGEMAKER_SUBMIT_DIRECTORY = "/opt/ml/model/code"
#     }
#   }
# }

# resource "aws_sagemaker_model" "meta_llama_3_1_8b_instruct_182345" {
#   name               = "meta-llama-3-1-8b-instruct-182345"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMaker-ExecutionRole-20231011T100538"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/djl-inference:0.29.0-lmi11.0.0-cu124"

#     model_data_source {
#       s3_data_source {
#         s3_uri = "s3://jumpstart-private-cache-prod-us-east-2/meta-textgeneration/meta-textgeneration-llama-3-1-8b-instruct/artifacts/inference-prepack/v2.0.0/"
#         s3_data_type = "S3Prefix"
#         compression_type = "None"
#       }
#     }

#     environment = {
#       ENDPOINT_SERVER_TIMEOUT = "3600"
#       HF_MODEL_ID = "/opt/ml/model"
#       MODEL_CACHE_ROOT = "/opt/ml/model"
#       OPTION_ENABLE_CHUNKED_PREFILL = "true"
#       SAGEMAKER_ENV = "1"
#       SAGEMAKER_MODEL_SERVER_WORKERS = "1"
#       SAGEMAKER_PROGRAM = "inference.py"
#     }
#   }
# }

# resource "aws_sagemaker_model" "huggingface_llm_mistral" {
#   name               = "huggingface-llm-mistral-7b-instruct-v3-20240801-175218"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMaker-ExecutionRole-20231011T100538"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/huggingface-pytorch-tgi-inference:2.3.0-tgi2.0.3-gpu-py310-cu121-ubuntu22.04"

#     model_data_source {
#       s3_data_source {
#         s3_uri = "s3://jumpstart-cache-prod-us-east-2/huggingface-llm/huggingface-llm-mistral-7b-instruct-v3/artifacts/inference-prepack/v1.0.0/"
#         s3_data_type = "S3Prefix"
#         compression_type = "None"
#       }
#     }

#     environment = {
#       ENDPOINT_SERVER_TIMEOUT = "3600"
#       HF_MODEL_ID = "/opt/ml/model"
#       MAX_BATCH_PREFILL_TOKENS = "8191"
#       MAX_INPUT_LENGTH = "8191"
#       MAX_TOTAL_TOKENS = "8192"
#       MODEL_CACHE_ROOT = "/opt/ml/model"
#       SAGEMAKER_ENV = "1"
#       SAGEMAKER_MODEL_SERVER_WORKERS = "1"
#       SAGEMAKER_PROGRAM = "inference.py"
#     }
#   }
# }

# resource "aws_sagemaker_model" "huggingface_pytorch_inference" {
#   name               = "huggingface-pytorch-inference-2023-10-12-04-03-29-976"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMakerServiceCatalogProductsUseRole"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/huggingface-pytorch-inference:1.13.1-transformers4.26.0-cpu-py39-ubuntu20.04"

#     environment = {
#       HF_MODEL_ID = "distilbert-base-cased-distilled-squad"
#       HF_TASK = "question-answering"
#       SAGEMAKER_CONTAINER_LOG_LEVEL = "20"
#       SAGEMAKER_REGION = "us-east-2"
#     }
#   }
# }

# resource "aws_sagemaker_model" "huggingface_pytorch_tgi_inference_1" {
#   name               = "huggingface-pytorch-tgi-inference-2023-10-12-03-53-10-022"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMakerServiceCatalogProductsUseRole"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/huggingface-pytorch-tgi-inference:2.0.1-tgi1.1.0-gpu-py39-cu118-ubuntu20.04"

#     environment = {
#       HF_MODEL_ID = "databricks/dolly-v2-7b"
#       SAGEMAKER_CONTAINER_LOG_LEVEL = "20"
#       SAGEMAKER_REGION = "us-east-2"
#       SM_NUM_GPUS = "1"
#     }
#   }
# }

# resource "aws_sagemaker_model" "huggingface_pytorch_tgi_inference_2" {
#   name               = "huggingface-pytorch-tgi-inference-2023-10-12-02-35-02-129"
#   execution_role_arn = "arn:aws:iam::482718065396:role/service-role/AmazonSageMakerServiceCatalogProductsUseRole"

#   primary_container {
#     image = "763104351884.dkr.ecr.us-east-2.amazonaws.com/huggingface-pytorch-tgi-inference:2.0.0-tgi0.8.2-gpu-py39-cu118-ubuntu20.04"

#     environment = {
#       HF_MODEL_ID = "databricks/dolly-v2-7b"
#       SAGEMAKER_CONTAINER_LOG_LEVEL = "20"
#       SAGEMAKER_REGION = "us-east-2"
#       SM_NUM_GPUS = "1"
#     }
#   }
# }


# ############################################################
# ### Define the endpoints
# ############################################################    







# # Endpoint Configuration for llama-3-2-3b-instruct
# resource "aws_sagemaker_endpoint_configuration" "llama_3_2_3b_instruct_config" {
#   name = "llama-3-2-3b-instruct-3"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.llama_3_2_3b_instruct.name
#     initial_instance_count = 1
#     instance_type         = "ml.g4dn.2xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "llama_3_2_3b_instruct" {
#   name                 = "llama-3-2-3b-instruct"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.llama_3_2_3b_instruct_config.name
# }

# # Endpoint Configuration for meta-llama-3-1-8b-instruct-151106
# resource "aws_sagemaker_endpoint_configuration" "meta_llama_3_1_8b_instruct_config" {
#   name = "meta-llama-3-1-8b-instruct-151106-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.meta_llama_3_1_8b_instruct.name
#     initial_instance_count = 1
#     instance_type         = "ml.c5.large"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "meta_llama_3_1_8b_instruct" {
#   name                 = "meta-llama-3-1-8b-instruct-151106"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.meta_llama_3_1_8b_instruct_config.name
# }

# # Endpoint Configuration for meta-llama-3-2-3b-instruct-neuron-014541
# resource "aws_sagemaker_endpoint_configuration" "meta_llama_3_2_3b_instruct_neuron_config" {
#   name = "meta-llama-3-2-3b-instruct-neuron-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.meta_llama_3_2_3b_instruct_neuron.name
#     initial_instance_count = 1
#     instance_type         = "ml.g4dn.xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "meta_llama_3_2_3b_instruct_neuron" {
#   name                 = "meta-llama-3-2-3b-instruct-neuron-014541"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.meta_llama_3_2_3b_instruct_neuron_config.name
# }

# # Endpoint Configuration for meta-llama-3-2-1b-instruct-185751
# resource "aws_sagemaker_endpoint_configuration" "meta_llama_3_2_1b_instruct_config" {
#   name = "meta-llama-3-2-1b-instruct-185751-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.meta_llama_3_2_1b_instruct.name
#     initial_instance_count = 1
#     instance_type         = "ml.c6i.xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "meta_llama_3_2_1b_instruct" {
#   name                 = "meta-llama-3-2-1b-instruct-185751"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.meta_llama_3_2_1b_instruct_config.name
# }

# # Endpoint Configuration for pytorch-inference-2024-09-23-01-43-01-385
# resource "aws_sagemaker_endpoint_configuration" "pytorch_inference_config" {
#   name = "pytorch-inference-2024-09-23-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.pytorch_inference.name
#     initial_instance_count = 1
#     instance_type         = "ml.c5.2xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "pytorch_inference" {
#   name                 = "pytorch-inference-2024-09-23-01-43-01-385"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.pytorch_inference_config.name
# }

# # Endpoint Configuration for meta-llama-3-1-8b-instruct-182345
# resource "aws_sagemaker_endpoint_configuration" "meta_llama_3_1_8b_instruct_182345_config" {
#   name = "meta-llama-3-1-8b-instruct-182345-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.meta_llama_3_1_8b_instruct_182345.name
#     initial_instance_count = 1
#     instance_type         = "ml.g4dn.2xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "meta_llama_3_1_8b_instruct_182345" {
#   name                 = "meta-llama-3-1-8b-instruct-182345"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.meta_llama_3_1_8b_instruct_182345_config.name
# }

# # Endpoint Configuration for huggingface-llm-mistral-7b-instruct-v3-20240801-175218
# resource "aws_sagemaker_endpoint_configuration" "huggingface_llm_mistral_config" {
#   name = "huggingface-llm-mistral-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.huggingface_llm_mistral.name
#     initial_instance_count = 1
#     instance_type         = "ml.g4dn.xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "huggingface_llm_mistral" {
#   name                 = "huggingface-llm-mistral-7b-instruct-v3-20240801-175218"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.huggingface_llm_mistral_config.name
# }

# # Endpoint Configuration for huggingface-pytorch-inference-2023-10-12-04-03-29-976
# resource "aws_sagemaker_endpoint_configuration" "huggingface_pytorch_inference_config" {
#   name = "huggingface-pytorch-inference-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.huggingface_pytorch_inference.name
#     initial_instance_count = 1
#     instance_type         = "ml.c5.large"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "huggingface_pytorch_inference" {
#   name                 = "huggingface-pytorch-inference-2023-10-12-04-03-29-976"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.huggingface_pytorch_inference_config.name
# }

# # Endpoint Configuration for huggingface-pytorch-tgi-inference-2023-10-12-03-53-10-022
# resource "aws_sagemaker_endpoint_configuration" "huggingface_pytorch_tgi_inference_1_config" {
#   name = "huggingface-pytorch-tgi-inference-1-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.huggingface_pytorch_tgi_inference_1.name
#     initial_instance_count = 1
#     instance_type         = "ml.g4dn.xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "huggingface_pytorch_tgi_inference_1" {
#   name                 = "huggingface-pytorch-tgi-inference-2023-10-12-03-53-10-022"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.huggingface_pytorch_tgi_inference_1_config.name
# }

# # Endpoint Configuration for huggingface-pytorch-tgi-inference-2023-10-12-02-35-02-129
# resource "aws_sagemaker_endpoint_configuration" "huggingface_pytorch_tgi_inference_2_config" {
#   name = "huggingface-pytorch-tgi-inference-2-config"

#   production_variants {
#     variant_name          = "AllTraffic"
#     model_name            = aws_sagemaker_model.huggingface_pytorch_tgi_inference_2.name
#     initial_instance_count = 1
#     instance_type         = "ml.g4dn.xlarge"  # Choose an appropriate instance type
#   }
# }

# resource "aws_sagemaker_endpoint" "huggingface_pytorch_tgi_inference_2" {
#   name                 = "huggingface-pytorch-tgi-inference-2023-10-12-02-35-02-129"
#   endpoint_config_name = aws_sagemaker_endpoint_configuration.huggingface_pytorch_tgi_inference_2_config.name
# }

