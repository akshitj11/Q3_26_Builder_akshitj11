# Video script (~2:45)

Record screen showing `docs/architecture.svg`. Speak to camera or voice-over. Enable YouTube captions after upload.

---

**0:00–0:15**

This vault is a per-wallet SOL storage program on Solana. Only the owner who initialized it can deposit, withdraw, or close.

---

**0:15–1:00**

Two PDAs per user. `vault_state` stores the bump seeds. `vault` is a System-owned account that only holds lamports, no custom data. That split is why withdrawals need PDA signer seeds: the vault has no private key, so the program passes seeds to the System Program transfer CPI.

---

**1:00–1:45**

Happy path: initialize creates the state account and derives the vault address. Deposit is a user-signed transfer into the vault PDA. Withdraw reverses that with `CpiContext::new_with_signer`, using bumps cached at init.

---

**1:45–2:30**

The extension: after SOL leaves the vault, the same `withdraw` instruction CPIs the Turbin3 registration program's `initialize`. It writes my GitHub handle `akshitj11` into an application PDA seeded on my wallet. Evaluators check that this CPI happens through my deployed vault program, not via a direct client call.

---

**2:30–2:45**

Close drains remaining lamports and closes `vault_state`, returning rent to the user. That is the full lifecycle.

---

**Caption keywords:** PDA, CPI, Anchor, devnet, registration, vault, System Program, Turbin3
