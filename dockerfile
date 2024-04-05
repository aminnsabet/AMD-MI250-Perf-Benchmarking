# Dockerfile to work with HuggingFace Optimum Benchmark

# Pull Kian's image to setup ROCm and pytorch
FROM ghcr.io/aminnsabet/llm-chat-bot/pytorch-vllm-rocm6:latest

# Update system, pip and install git
RUN apt-get update && \
    apt-get install -y git && \
    pip install --upgrade pip

# Install all the dependencies for optimum benchmark
WORKDIR /home

RUN git clone https://github.com/huggingface/optimum-benchmark.git
    
WORKDIR /home/optimum-benchmark/

RUN pip install --no-deps -e .

WORKDIR /home

RUN git clone https://github.com/ROCm/pyrsmi.git

WORKDIR /home/pyrsmi/

RUN python3 -m pip install -e .

WORKDIR /home

RUN git clone https://github.com/IlyasMoutawwakil/py-txi.git

WORKDIR /home/py-txi/

RUN pip install -e .

WORKDIR /home

RUN pip install accelerate datasets hydra-core hydra-colorlog flatten-dict pandas flatten_dict