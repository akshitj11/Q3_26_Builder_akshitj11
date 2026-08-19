# Form submission checklist

Form: https://forms.gle/zGPY8svmPdMQg3rG9

## Agent completed

- [x] Modified vault with registration CPI in `withdraw`
- [x] `anchor test --validator legacy` passes (4/4)
- [x] Architecture diagram: `docs/architecture.png`
- [x] README with build/test/deploy steps
- [x] Video script: `docs/VIDEO_SCRIPT.md`
- [x] Security pre-scan: no high/critical findings in `programs/pre-req-vault/src`

## User completes

- [ ] Record video from `docs/VIDEO_SCRIPT.md` (max 3 min, YouTube, captions on)
- [ ] Discord progress post
- [ ] Submit form with repo URL, diagram link, video URL

## Copy-paste fields

| Field | Value |
|---|---|
| GitHub repo | `https://github.com/akshitj11/Q3_26_Builder_akshitj11` (after push) |
| GitHub username | `akshitj11` |
| Vault program ID | `B14XYWMkDrVeQTgEM93sLLxkzfffK6dppETCEKfnM2H2` |
| Registration program | `TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM` |
| Diagram | `docs/architecture.png` in repo |

## Devnet deploy (if not done yet)

Devnet faucet was rate-limited during automated setup. After funding wallet:

```bash
solana config set --url devnet
solana airdrop 2
cd ~/Projects/turbin3-vault-prereq
CARGO_TARGET_DIR=$PWD/target anchor deploy --provider.cluster devnet
```

Wallet: `HZLaBqpSsfsMEn6kcnESmRVHGTaNgAcWgTf5yvk2PzCN`
