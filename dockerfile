
ARG ROCM_VERSION=rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2
ARG TGI_VERSION=1.4.5

#FROM ghcr.io/aminnsabet/llm-ot/pytorch-vllm-rocm6:latest
FROM rocm/pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2

WORKDIR /home/
### TODO clean the documentation ###
# Install the pyrsmi library.
# Update important packages such as pip, install git, install amd-smi-lib
# Installing all the python packages needed with no cache to reduce image size.
# install TGI wrapper py-txi
# Small fix to force previous and compatible version of TGI and install the TGI wrapper. 
# Clone the config files and the automation script
# Install optimum benchmark without it's dependencies to avoid errors. 
# Add here the commands to run the experiments and get the results back. 
# Cloning all the necessary repository for benchmarking. 1: pyrsmi provide additional features to ROCm smi. 2: Benchmarking tool. 3: Nscale repo for configs and scripts. 4: py-txi is a TGI wrapper for optimum benchmark. 
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get install -y amd-smi-lib && \
    pip install --upgrade pip && \
    pip install --no-cache-dir accelerate datasets hydra-core hydra-colorlog flatten-dict pandas flatten_dict transformers docker seaborn && \
    pip install -U "huggingface_hub[cli]" && \
    git clone https://github.com/ROCm/pyrsmi.git && \ 
    git clone https://github.com/huggingface/optimum-benchmark.git && \
    git clone https://github.com/aminnsabet/AMD-MI250-Perf-Benchmarking.git && \
    git clone -b v0.5.1 https://github.com/IlyasMoutawwakil/py-txi.git && \ 
    cd optimum-benchmark/ && \
    git checkout 379b5ad && \
    pip install --no-deps -e . && \
    cd .. && \  
    cp -r /home/AMD-MI250-Perf-Benchmarking/configs/ /home/optimum-benchmark/ && \
    cp /home/AMD-MI250-Perf-Benchmarking/run_all.sh /home/optimum-benchmark/ && \
    cp /home/AMD-MI250-Perf-Benchmarking/plot_pipeline.py /home/optimum-benchmark/ && \
    cd /home/pyrsmi/ && \
    python3 -m pip install -e . && \
    cd /home/py-txi/ && \
    sed -i 's/text-generation-inference:latest/text-generation-inference:1.4.5-rocm/g' py_txi/text_generation_inference.py && \
    pip install --no-deps -e . && \
    cd /opt/rocm/share/amd_smi && \
    python3 -m pip install --upgrade pip \
    && python3 -m pip install --user . && \
    cd /home/optimum-benchmark/ && \
    mkdir results

WORKDIR /home/optimum-benchmark/
CMD ["./run_all.sh", "configs/NousResearchLlama7B/", "Nrl_", "/results"]