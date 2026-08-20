# Architecture

SOL lives in a System-owned vault PDA. Bump metadata lives in a separate program-owned `vault_state` PDA seeded on the user wallet. The vault holds lamports only, no account data, so every outbound transfer needs PDA signer seeds passed to the System Program.

Registration runs inside `withdraw`, not as a client-side call. After lamports move vault to user, the instruction CPIs `initialize` on program `TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM` and writes `akshitj11` into the `prereqs` PDA for that wallet. One registration per wallet.

## Accounts

| Account | Seeds | Owner | Role |
|---|---|---|---|
| vault_state | `["state", user]` | vault program | bump seeds |
| vault | `["vault", vault_state]` | System Program | lamport balance |
| application_account | `["prereqs", user]` | registration program | GitHub handle after withdraw CPI |

## Flow

**initialize** creates `vault_state`, derives the vault address, stores bumps.  
**deposit** user-signed System transfer into the vault PDA.  
**withdraw** PDA-signed transfer out, then registration `initialize` CPI with `GITHUB_USERNAME`.  
**close** drains the vault PDA and closes `vault_state`, rent back to user.

Diagram: [architecture.png](architecture.png)
