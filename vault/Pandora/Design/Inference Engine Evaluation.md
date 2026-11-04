# Inference Engine Evaluation

Quick notes on engines relevant to the DEE/BOX local runtime and Jade-style distributed setups. #project #the-lab

## Strata

- **Repo:** https://github.com/niko1221/strata
- **Focus:** Qwen3.8-Flash-Next on consumer NVIDIA hardware (Windows/Linux).
- **API:** OpenAI/Anthropic-compatible localhost server.
- **Extras:** Optional image input, one-click install.
- **Status:** 1,752 GitHub stars, C++ engine, active issue tracker.
- **Relevance:** Good candidate if the local runtime settles on Qwen3.8-Flash-Next as a fast default. The OpenAI-compatible API makes it easy to slot into `jade-py` / sidecar without custom client code.
- **Risk:** Single-model focus means less flexibility if we want to swap models by config.

## PolyStrata

- **Repo:** https://github.com/VecSzn/PolyStrata
- **Focus:** Multi-model server built on Strata: Qwen3.8-Flash-Next, GLM 5.3 Flash, DeepSeek V4 Flash, LFM2.5, Qwen3.6, Ornith 1.5, Gemma 4, Tiel Coder, MiniCPM-V.
- **API:** OpenAI/Anthropic-compatible localhost server.
- **Memory model:** VRAM + RAM + CPU "kitchen counter/pantry" approach so big MoE models fit on 12–24 GB cards.
- **Install:** One-click for Windows/Linux.
- **Relevance:** Better fit for a general-purpose sidecar where model choice should be config-driven. The hot-swap capability (change models while running) is useful for a multi-agent box.
- **Risk:** More moving parts; newer project; model support depends on upstream conversions.

## Recommendation

For the first `pandora-dee` → `jade-py` sidecar, start with **PolyStrata** if the host has an NVIDIA GPU with 12 GB+ VRAM and we want model flexibility. Use **Strata** directly if we want a single known-good fast path around Qwen3.8-Flash-Next. Both expose the same API shape, so switching later is low cost.

## Dward cluster fit

- Primary: Ryzen 5 5600 + RTX 2060 12 GB + 64 GB RAM — either engine works; PolyStrata’s pantry model helps offload MoE experts to RAM.
- Overflow: Intel i5-7500 + 32 GB RAM CPU-only — could run a second PolyStrata/Strata worker if the protocol supports distributed load, but that is not yet confirmed.

## Next step

Try a local install of PolyStrata on Mrrowr-murrr’s Windows 10 Firefox hardware and benchmark Qwen3.8-Flash-Next against the existing llama.cpp setup.
