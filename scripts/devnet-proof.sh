#!/usr/bin/env bash
# Run after deploy-devnet.sh succeeds. Initializes vault, deposits 1 SOL, withdraws 0.5 SOL
# to trigger registration CPI. Prints tx signatures and registration PDA for SUBMISSION.md.
set -euo pipefail
export PATH="$HOME/.avm/bin:$HOME/capstone_bootcamp_5/.tmp/solana-release/bin:$HOME/.local/share/mise/installs/node/20.20.2/bin:${PATH:-}"

cd "$(dirname "$0")/.."
solana config set --url devnet

export ANCHOR_PROVIDER_URL=https://api.devnet.solana.com
export ANCHOR_WALLET="$HOME/.config/solana/id.json"

node <<'EOF'
const anchor = require("@anchor-lang/core");
const { PublicKey, SystemProgram, LAMPORTS_PER_SOL } = require("@solana/web3.js");
const { BN } = require("bn.js");

(async () => {
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);
  const program = anchor.workspace.preReqVault;
  const user = provider.wallet.publicKey;

  const [vaultStatePda] = PublicKey.findProgramAddressSync(
    [Buffer.from("state"), user.toBuffer()],
    program.programId,
  );
  const [vaultPda] = PublicKey.findProgramAddressSync(
    [Buffer.from("vault"), vaultStatePda.toBuffer()],
    program.programId,
  );

  const regProgram = new PublicKey("TRBZyQHB3m68FGeVsqTK39Wm4xejadjVhP5MAZaKWDM");
  const [applicationAccount] = PublicKey.findProgramAddressSync(
    [Buffer.from("prereqs"), user.toBuffer()],
    regProgram,
  );

  console.log("Vault program:", program.programId.toBase58());
  console.log("Wallet:", user.toBase58());
  console.log("Registration PDA:", applicationAccount.toBase58());

  const initSig = await program.methods.initialize().accountsStrict({
    user,
    vaultState: vaultStatePda,
    vault: vaultPda,
    systemProgram: SystemProgram.programId,
  }).rpc();
  console.log("Initialize tx:", initSig);

  const depSig = await program.methods.deposit(new BN(LAMPORTS_PER_SOL)).accountsStrict({
    user,
    vaultState: vaultStatePda,
    vault: vaultPda,
    systemProgram: SystemProgram.programId,
  }).rpc();
  console.log("Deposit tx:", depSig);

  const wdSig = await program.methods.withdraw(new BN(0.5 * LAMPORTS_PER_SOL)).accountsStrict({
    user,
    vaultState: vaultStatePda,
    vault: vaultPda,
    systemProgram: SystemProgram.programId,
    applicationAccount,
    applicationProgram: regProgram,
  }).rpc();
  console.log("Withdraw tx (registration CPI):", wdSig);

  const acct = await provider.connection.getAccountInfo(applicationAccount);
  if (!acct) throw new Error("Registration account missing after withdraw");
  const off = 8 + 32 + 1 + 1 + 1;
  const len = acct.data.readUInt32LE(off);
  const github = acct.data.slice(off + 4, off + 4 + len).toString();
  console.log("Registered GitHub:", github);
  if (github !== "akshitj11") throw new Error(`Expected akshitj11, got ${github}`);
})();
EOF
