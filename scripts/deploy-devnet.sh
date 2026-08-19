#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/share/mise/installs/node/20.20.2/bin:${PATH:-}"
solana config set --url devnet
solana airdrop 2 || true
CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-$(pwd)/target}" anchor deploy --provider.cluster devnet
