# pre-req-vault

Withdraw moves SOL out of the vault PDA, then CPIs the Turbin3 registration program's `initialize` in the same instruction. Evaluators verify enrollment runs through your deployed vault program, not a separate client call.

| | |
|---|---|
| Vault program | `6L2tmAf5H1NpVoEizg7iQLemGeWyf6KDRpoCxkt89d6u` |
| Registration program | [`TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM`](https://explorer.solana.com/address/TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM?cluster=devnet) |
| GitHub on-chain | `akshitj11` |
| Architecture | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |

Each wallet gets two PDAs: `vault_state` holds bump seeds, `vault` is a System-owned lamport account with no custom data. Withdrawals use `CpiContext::new_with_signer` because the vault PDA has no private key. After the System transfer, `withdraw` CPIs registration `initialize` with `GITHUB_USERNAME`. One registration per wallet.

## Build

Rust stable, Solana CLI, Anchor 1.1.2, Node 20.

```bash
avm install 1.1.2 && avm use 1.1.2
npm install
CARGO_TARGET_DIR=$PWD/target anchor build
```

## Test

Local validator clones the devnet registration program.

```bash
export PATH="$HOME/.local/share/mise/installs/node/20.20.2/bin:$PATH"
CARGO_TARGET_DIR=$PWD/target anchor test --validator legacy
```

4/4: initialize, deposit, withdraw with registration PDA, close.

## Deploy

Wallet: `HZLaBqpSsfsMEn6kcnESmRVHGTaNgAcWgTf5yvk2PzCN` (`~/.config/solana/id.json`).

Fund at [faucet.solana.com](https://faucet.solana.com) if CLI airdrop is rate-limited, then:

```bash
./scripts/run-after-funding.sh
```

Submission form: https://forms.gle/zGPY8svmPdMQg3rG9
