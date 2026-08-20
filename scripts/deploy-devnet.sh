#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.avm/bin:$HOME/capstone_bootcamp_5/.tmp/solana-release/bin:${PATH:-}"
export PATH="$HOME/.local/share/mise/installs/node/20.20.2/bin:${PATH}"

solana config set --url devnet
BALANCE=$(solana balance | awk '{print $1}')
if awk "BEGIN {exit !($BALANCE < 2)}"; then
  echo "Balance ${BALANCE} SOL, requesting airdrop..."
  solana airdrop 2
fi
BALANCE=$(solana balance | awk '{print $1}')
if awk "BEGIN {exit !($BALANCE < 2)}"; then
  echo "Devnet wallet still underfunded (${BALANCE} SOL)."
  echo "Fund ~/.config/solana/id.json via https://faucet.solana.com or devnet-pow, then rerun."
  exit 1
fi

CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-$(pwd)/target}" anchor deploy --provider.cluster devnet
echo "Deploy complete. Run ./scripts/devnet-proof.sh for on-chain registration proof."
