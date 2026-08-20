# pre-req-vault

`withdraw` sends lamports from the vault PDA to the user, then CPIs registration `initialize` with `GITHUB_USERNAME` in the same instruction. Turbin3 checks that registration runs through your deployed vault program, not a separate client call.

| | |
|---|---|
| Vault program | `6L2tmAf5H1NpVoEizg7iQLemGeWyf6KDRpoCxkt89d6u` |
| Registration program | [`TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM`](https://explorer.solana.com/address/TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM?cluster=devnet) |
| GitHub on-chain | `akshitj11` |
| Architecture | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |

Two PDAs per wallet. `vault_state` stores bump seeds. `vault` is System-owned, lamports only, no custom data. The vault has no private key, so outbound transfers pass PDA signer seeds to the System Program. Registration fires once per wallet on the first `withdraw`.

```bash
avm install 1.1.2 && avm use 1.1.2
npm install
CARGO_TARGET_DIR=$PWD/target anchor build
```

Tests run on a local validator with the devnet registration program cloned in. Node 20 required.

```bash
export PATH="$HOME/.local/share/mise/installs/node/20.20.2/bin:$PATH"
CARGO_TARGET_DIR=$PWD/target anchor test --validator legacy
```

Four tests: initialize, deposit, withdraw with registration PDA, close.

Deploy wallet: `HZLaBqpSsfsMEn6kcnESmRVHGTaNgAcWgTf5yvk2PzCN` (`~/.config/solana/id.json`). Fund at [faucet.solana.com](https://faucet.solana.com) if CLI airdrop is rate-limited.

```bash
./scripts/run-after-funding.sh
```

Form: https://forms.gle/zGPY8svmPdMQg3rG9
