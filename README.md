# pre-req-vault — Turbin3 Builders Prerequisite

Anchor SOL vault extended so `withdraw` CPI-calls the Turbin3 registration program and records a GitHub handle on-chain.

| | |
|---|---|
| **Vault program ID** | `B14XYWMkDrVeQTgEM93sLLxkzfffK6dppETCEKfnM2H2` |
| **Registration program** | [`TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM`](https://explorer.solana.com/address/TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM?cluster=devnet) |
| **Registered GitHub** | `akshitj11` |
| **Architecture** | [docs/architecture.svg](docs/architecture.svg) · [docs/architecture.png](docs/architecture.png) |

## What it does

Each wallet gets two PDAs: `vault_state` (metadata + bumps) and `vault` (lamport balance). Deposit moves SOL from the user into the vault PDA. Withdraw moves SOL back, then CPIs `initialize` on the registration program with `GITHUB_USERNAME`. Close drains the vault and reclaims rent.

The registration CPI runs inside the vault program, not as a separate client call. That is what the challenge verifies.

## Build

Requires Rust stable, Solana CLI, Anchor 1.1.2, Node 20.

```bash
avm install 1.1.2 && avm use 1.1.2
npm install
CARGO_TARGET_DIR=$PWD/target anchor build
```

## Test (local validator + cloned registration program)

Uses legacy validator with the devnet registration program cloned into localnet.

```bash
export PATH="$HOME/.local/share/mise/installs/node/20.20.2/bin:$PATH"
CARGO_TARGET_DIR=$PWD/target anchor test --validator legacy
```

All four tests pass: initialize, deposit, withdraw (with CPI), close.

## Deploy to devnet

Fund the wallet first, then:

```bash
./scripts/deploy-devnet.sh
```

Or manually:

```bash
solana config set --url devnet
solana airdrop 2
CARGO_TARGET_DIR=$PWD/target anchor deploy --provider.cluster devnet
```

Then run tests against devnet by setting `skip_local_validator = true` and `cluster = "devnet"` in `Anchor.toml`.

## Submission form

https://forms.gle/zGPY8svmPdMQg3rG9

- Repo: this repository
- Diagram: `docs/architecture.svg`
- Video: record from `docs/VIDEO_SCRIPT.md`
