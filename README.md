# Universal Shell DEC 5.0 (Stable)

This is a simple program designed to decrypt shell scripts using various methods.

## Supported Decryption:

- SHC
- Base64
- Eval
- Base64 + Base64
- Eval + Base64
- Base64 + Eval + Base64
- Eval + Base64 + Eval
- Random eval
- Random Base64

## Usage:

1. Update and upgrade Termux packages:
   
   ```sh
   apt update -y && apt upgrade -y
   ```

2. Install curl:
   
   ```sh
   apt install curl -y
   ```
3. Online script execution:
   
   ```sh
   curl https://raw.githubusercontent.com/RiProG-id/Universal-Shell-Dec/main/run.sh > run.sh; bash run.sh; rm run.sh
   ```