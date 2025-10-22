FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.10, pip, and other essentials
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# --- FIXES APPLIED BELOW ---

# 1. Install the GPU-enabled version of PyTorch first.
# This ensures we don't get the CPU-only version from requirements.txt.
# This command is for PyTorch 2.3.0 with CUDA 12.1. Adjust if needed from PyTorch website.
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 2. Pre-install the build dependency that flash-attn needs.
RUN pip3 install packaging

# 3. Now, copy and install the rest of the dependencies.
#    (Ensure torch, torchvision, torchaudio are REMOVED from requirements.txt)
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the application code into the image
COPY . .

# The CMD can remain the same, it will be overridden by docker-compose anyway.
