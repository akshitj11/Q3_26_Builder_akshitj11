# Architecture

The vault stores SOL in a System-owned PDA. Metadata lives in a separate program-owned PDA seeded on the user wallet.

## Accounts

| Account | Seeds | Owner | Role |
|---|---|---|---|
| vault_state | `["state", user]` | vault program | stores vault and state bumps |
| vault | `["vault", vault_state]` | System Program | holds lamports only |
| application_account | `["prereqs", user]` on registration program | registration program | stores GitHub handle after withdraw CPI |

## Instruction flow

1. **initialize** creates `vault_state` and derives the vault address.
2. **deposit** moves lamports user to vault via System CPI.
3. **withdraw** moves lamports vault to user via PDA signer seeds, then CPIs registration `initialize` with `GITHUB_USERNAME`.
4. **close** drains the vault PDA and closes `vault_state`.

The registration CPI must run inside `withdraw` so evaluators can verify the vault program orchestrates enrollment, not the client.

Visual diagram: [architecture.png](architecture.png)
