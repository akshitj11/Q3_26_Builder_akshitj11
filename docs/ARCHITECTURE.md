# Architecture

Withdraw moves SOL out of the vault PDA, then CPIs registration `initialize` in the same instruction. Evaluators check that enrollment runs through your deployed vault program, not a direct client call.

Each wallet owns two PDAs. `vault_state` stores bump seeds. `vault` is System-owned and holds lamports only, no custom data. Outbound transfers need PDA signer seeds because the vault has no private key. After the System transfer in `withdraw`, the vault program CPIs `TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM` and writes `akshitj11` into the `prereqs` PDA. One registration per wallet.

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
    vaultProg -->|"drain + close"| vaultPDA
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
