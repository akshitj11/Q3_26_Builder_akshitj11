# Video script (~2:45)

Screen: `docs/architecture.svg`. Enable YouTube captions after upload.

---

**0:00–0:15**

Per-wallet SOL vault on Solana. Only the wallet that initialized it can deposit, withdraw, or close.

---

**0:15–1:00**

Two PDAs per user. `vault_state` stores bump seeds. `vault` is System-owned, lamports only, no custom data. Outbound transfers need PDA signer seeds because the vault has no private key.

---

**1:00–1:45**

Initialize creates `vault_state` and derives the vault address. Deposit is a user-signed transfer into the vault PDA. Withdraw uses `CpiContext::new_with_signer` with bumps cached at init.

---

**1:45–2:30**

After SOL leaves the vault, the same `withdraw` instruction CPIs registration `initialize`. It writes `akshitj11` into a `prereqs` PDA on my wallet. Evaluators check this CPI runs through my deployed vault program, not a direct client call.

---

**2:30–2:45**

Close drains the vault and reclaims `vault_state` rent. That is the full lifecycle.

---

Caption keywords: PDA, CPI, Anchor, devnet, registration, vault, System Program, Turbin3
