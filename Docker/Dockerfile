FROM ghcr.io/aminnsabet/llm-chat-bot/pytorch-vllm-rocm6:latest
#FROM rocm/pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2
RUN apt-get update && \
    apt-get install -y git && \
    pip install --upgrade pip


WORKDIR /home/
RUN git clone https://github.com/ROCm/pyrsmi.git
RUN git clone https://github.com/huggingface/optimum-benchmark.git
RUN git clone https://github.com/aminnsabet/AMD-MI250-Perf-Benchmarking.git
RUN git clone -b https://github.com/IlyasMoutawwakil/py-txi.git v0.5.1

RUN pip install accelerate datasets hydra-core hydra-colorlog flatten-dict pandas flatten_dict transformers docker && \
    pip install -U "huggingface_hub[cli]"


WORKDIR /home/optimum-benchmark/
RUN pip install --no-deps -e .

WORKDIR /home/pyrsmi/
RUN python3 -m pip install -e .

WORKDIR /home
############## FIX this for TGI 1.4.5
WORKDIR /home/py-txi/
RUN sed -i 's/text-generation-inference:latest-rocm/text-generation-inference:1.4.5-rocm/g' py_txi/text_generation_inference.py && \
    pip install --no-deps -e .

WORKDIR /home/optimum-benchmark/

# Install amd-smi-lib
RUN apt-get update && apt-get install -y amd-smi-lib

# All installs to run optimum benchmark are done
# Clone the config files and the automation script
WORKDIR /home

RUN mkdir /results

WORKDIR /home/AMD-MI250-Perf-Benchmarking/ 
RUN cp -r configs/ /home/optimum-benchmark/ && \
    cp run_all.sh /home/optimum-benchmark/ && \
    cp plot_pipeline.py /home/optimum-benchmark/ && \
    chmod +x /home/optimum-benchmark/run_all.sh

# Add here the commands to run the experiments and get the results back. 
WORKDIR /home/optimum-benchmark/
RUN ls

CMD ["./run_all.sh", "/configs/NousResearchLlama7B/", "Nrl_", "/results"]

