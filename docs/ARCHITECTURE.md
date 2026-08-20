# Architecture

Programs on Solana are stateless. This vault splits state across two PDAs: `vault_state` holds bump seeds, `vault` holds lamports under the System Program with no data field. That split is why `withdraw` needs `CpiContext::new_with_signer`. The vault PDA signs the outbound transfer, then CPIs registration `initialize` before the instruction returns.

Registration lives at `TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM`. The CPI writes `akshitj11` into a `prereqs` PDA seeded on the user wallet. A second `withdraw` on the same wallet would fail once that PDA exists.

```mermaid
flowchart TB
    subgraph accounts [Accounts per wallet]
        user[User wallet]
        vaultState["vault_state PDA\nseeds: state + user"]
        vaultPDA["vault PDA\nseeds: vault + vault_state"]
        regPDA["prereqs PDA\nseeds: prereqs + user"]
    end

    subgraph programs [Programs]
        vaultProg["Vault program\n6L2tmAf5H1NpVoEizg7iQLemGeWyf6KDRpoCxkt89d6u"]
        systemProg[System Program]
        regProg["Registration program\nTRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM"]
    end

    user -->|"initialize"| vaultProg
    vaultProg --> vaultState
    vaultProg --> vaultPDA

    user -->|"deposit"| vaultProg
    vaultProg -->|"CPI transfer"| systemProg
    systemProg --> vaultPDA

    user -->|"withdraw"| vaultProg
    vaultProg -->|"PDA signer transfer"| systemProg
    systemProg --> user
    vaultProg -->|"CPI initialize"| regProg
    regProg --> regPDA

    user -->|"close"| vaultProg
    vaultProg -->|"drain and close"| vaultPDA
    vaultProg --> vaultState
```

```mermaid
sequenceDiagram
    participant User
    participant Vault as VaultProgram
    participant VaultPDA as vaultPDA
    participant System as SystemProgram
    participant Reg as RegistrationProgram
    participant RegPDA as prereqsPDA

    User->>Vault: initialize
    Vault->>Vault: create vault_state, derive vault

    User->>Vault: deposit amount
    Vault->>System: transfer User to VaultPDA

    User->>Vault: withdraw amount
    Vault->>System: transfer VaultPDA to User via PDA seeds
    Vault->>Reg: CPI initialize github=akshitj11
    Reg->>RegPDA: create account

    User->>Vault: close
    Vault->>System: drain VaultPDA
    Vault->>Vault: close vault_state
```

| Account | Seeds | Owner |
|---|---|---|
| vault_state | `["state", user]` | vault program |
| vault | `["vault", vault_state]` | System Program |
| prereqs | `["prereqs", user]` | registration program |
