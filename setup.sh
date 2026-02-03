#/usr/bin/env bash

uv pip install --system https://github.com/seopbo/nemo-skills-patch.git
uv pip install --system --no-cache-dir langdetect absl-py immutabledict nltk
mkdir /opt/benchmarks
# https://github.com/seopbo/nemo-skills-patch/blob/main/dockerfiles/Dockerfile.nemo-skills
git clone https://github.com/google-research/google-research.git /opt/benchmarks/google-research --depth=1
