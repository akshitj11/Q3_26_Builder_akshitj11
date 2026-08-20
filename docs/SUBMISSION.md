# Submission

Form: https://forms.gle/zGPY8svmPdMQg3rG9

## Done

- [x] Registration CPI in `withdraw` (`programs/pre-req-vault/src/instructions/withdraw.rs`)
- [x] `anchor test --validator legacy` — 4/4 passing
- [x] Architecture diagram — `docs/architecture.png`
- [x] Repo — https://github.com/akshitj11/Q3_26_Builder_akshitj11
- [x] Video script — `docs/VIDEO_SCRIPT.md`

## Pending devnet (fund wallet first)

Devnet faucet rate-limited at last attempt. After funding `HZLaBqpSsfsMEn6kcnESmRVHGTaNgAcWgTf5yvk2PzCN`:

```bash
cd ~/Projects/turbin3-vault-prereq
./scripts/deploy-devnet.sh
./scripts/devnet-proof.sh
```

Paste deploy and withdraw tx signatures below after running.

- [ ] Program deployed on devnet
- [ ] Withdraw tx creates registration PDA with `akshitj11`

## You

- [ ] Record video from `docs/VIDEO_SCRIPT.md` (≤3 min, YouTube, captions)
- [ ] Discord progress post
- [ ] Submit form

## Form fields

| Field | Value |
|---|---|
| GitHub repo | https://github.com/akshitj11/Q3_26_Builder_akshitj11 |
| GitHub username | `akshitj11` |
| Vault program ID | `6L2tmAf5H1NpVoEizg7iQLemGeWyf6KDRpoCxkt89d6u` |
| Registration program | `TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM` |
| Diagram | `docs/architecture.png` in repo |
| Deploy tx | _(run deploy script)_ |
| Withdraw tx | _(run devnet-proof script)_ |
| Registration PDA | _(printed by devnet-proof script)_ |
