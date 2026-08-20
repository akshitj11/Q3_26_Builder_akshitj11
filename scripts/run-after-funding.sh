#!/usr/bin/env bash
# Run after wallet has >= 2 SOL on devnet.
# Chains deploy, on-chain proof, and prints values for SUBMISSION.md.
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="$HOME/.avm/bin:$HOME/capstone_bootcamp_5/.tmp/solana-release/bin:$HOME/.local/share/mise/installs/node/20.20.2/bin:${PATH:-}"

BALANCE=$(solana balance --url devnet | awk '{print $1}')
if awk "BEGIN {exit !($BALANCE < 2)}"; then
  echo "Wallet balance ${BALANCE} SOL. Need >= 2 SOL."
  echo "Fund HZLaBqpSsfsMEn6kcnESmRVHGTaNgAcWgTf5yvk2PzCN at https://faucet.solana.com (GitHub login recommended)."
  exit 1
fi

echo "=== Deploy ==="
./scripts/deploy-devnet.sh 2>&1 | tee /tmp/turbin3-deploy.log

echo "=== On-chain proof ==="
./scripts/devnet-proof.sh 2>&1 | tee /tmp/turbin3-proof.log

echo ""
echo "=== Copy into docs/SUBMISSION.md ==="
grep -E "^(Vault program|Wallet|Registration PDA|Initialize tx|Withdraw tx)" /tmp/turbin3-proof.log || true
solana program show 6L2tmAf5H1NpVoEizg7iQLemGeWyf6KDRpoCxkt89d6u --url devnet | head -3
