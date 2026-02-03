# nemo-skills-harness

## preliminary
```bash
git clone https://github.com/seopbo/nemo-skills-harness.git
```

```bash
conda create nemo-skills-harness python=3.13
conda activate nemo-skills-harness
pip install --no-cache-dir uv
```

## setup
```bash
conda activate nemo-skills-harness
bash setup.sh
```

## dryrun
### serve llm
```bash
# A100으로 서빙
# vllm 환경은 따로 구축필요, setup.sh에는 vllm 포함안되어있음.
mkdir qwen3-4b-instruct-2507
hf download Qwen/Qwen3-4B-Instruct-2507 --local-dir qwen3-4b-instruct-2507

export CUDA_VISIBLE_DEVICES=0,1,2,3
vllm serve qwen3-4b-instruct-2507 \
    --data-parallel-size 4 \
    --max-model-len 32768 \
    --port 8000
```
```bash
curl http://localhost:8000/v1/models
>> {"object":"list","data":[{"id":"qwen3-4b-instruct-2507","object":"model","created":1770132962,"owned_by":"vllm","root":"qwen3-4b-instruct-2507","parent":null,"max_model_len":32768, ...}]}
```

### evaluation ifeval
```bash
# ifeval 평가
mkdir datasets
export NEMO_SKILLS_CONFIG_DIR=$(pwd)/configs
export NEMO_SKILLS_DATA_DIR=$(pwd)/datasets

ns prepare_data --cluster=local --data_dir $NEMO_SKILLS_DATA_DIR ifeval

ns eval \
	--cluster=local \
	--server_type=vllm \
	--model=qwen3-4b-instruct-2507 \
	--server_address=http://localhost:8000/v1 \
	--benchmarks=ifeval \
	--output_dir=qwen3-4b-instruct-2507 \
	++inference.temperature=0.6 \
	++inference.top_p=0.95 \
	++inference.tokens_to_generate=1024
```