# Devnet funding

Wallet: `HZLaBqpSsfsMEn6kcnESmRVHGTaNgAcWgTf5yvk2PzCN`  
Keypair: `~/.config/solana/id.json`  
Need: **>= 2 SOL** for deploy + proof transactions.

CLI airdrop is rate-limited on this machine. Use one of these:

1. **https://faucet.solana.com** — paste wallet address, select devnet, connect GitHub for higher limit
2. **https://faucet.quicknode.com/solana/devnet** — web form, no CLI
3. Transfer from another devnet wallet you control

Verify balance:

```bash
solana balance HZLaBqpSsfsMEn6kcnESmRVHGTaNgAcWgTf5yvk2PzCN --url devnet
```

Then run everything:

```bash
cd ~/Projects/turbin3-vault-prereq
chmod +x scripts/run-after-funding.sh
./scripts/run-after-funding.sh
```

Paste the printed tx signatures into `docs/SUBMISSION.md`.
