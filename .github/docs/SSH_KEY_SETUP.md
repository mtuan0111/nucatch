# SSH Key Setup for Private Dependencies

This guide explains how to configure SSH keys for GitHub Actions to access private Git dependencies.

---

## Overview

NuCatch uses the private `ble_plat_services` package from:
```
git@github.com:mtuan0111/blue_plat_services.git
```

GitHub Actions needs an SSH key to clone this private repository during `flutter pub get`.

---

## Setup Steps

### 1. Generate SSH Key Pair

```bash
ssh-keygen -t ed25519 -C "nucatch-deploy" -f ~/.ssh/nucatch_deploy_key
```

> [!IMPORTANT]
> Leave the passphrase empty (just press Enter twice).

### 2. Add Public Key to Source Repository

The **public key** goes to the repository you want to access (`blue_plat_services`):

1. Go to: https://github.com/mtuan0111/blue_plat_services/settings/keys
2. Click **"Add deploy key"**
3. Title: `NuCatch CI/CD`
4. Key: Paste the content of:
   ```bash
   cat ~/.ssh/nucatch_deploy_key.pub
   ```
5. ☐ Keep "Allow write access" **unchecked** (read-only is sufficient)
6. Click **"Add key"**

### 3. Add Private Key to Consumer Repository

The **private key** goes to the repository that needs access (`nucatch`):

1. Go to: https://github.com/mtuan0111/nucatch/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `SSH_PRIVATE_KEY`
4. Value: Paste the **entire content** of:
   ```bash
   cat ~/.ssh/nucatch_deploy_key
   ```
   Including the `-----BEGIN` and `-----END` lines
5. Click **"Add secret"**

---

## How It Works

The workflow uses `webfactory/ssh-agent` to set up the SSH key:

```yaml
- name: Setup SSH for private dependencies
  uses: webfactory/ssh-agent@v0.9.0
  with:
    ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

- name: Get Flutter dependencies
  run: flutter pub get
```

This allows `flutter pub get` to clone private Git dependencies via SSH.

---

## Troubleshooting

### "Permission denied (publickey)"

- Verify the deploy key is added to `blue_plat_services`
- Verify the `SSH_PRIVATE_KEY` secret is set in `nucatch`
- Ensure the private key has no passphrase

### "Host key verification failed"

The `webfactory/ssh-agent` action automatically handles GitHub's host key. If issues persist, you may need to add:

```yaml
- name: Add GitHub to known hosts
  run: |
    mkdir -p ~/.ssh
    ssh-keyscan github.com >> ~/.ssh/known_hosts
```

---

## Security Best Practices

1. **Use deploy keys** (not personal SSH keys) for CI/CD
2. **Keep deploy keys read-only** unless write access is required
3. **Never commit private keys** to the repository
4. **Rotate keys periodically** for enhanced security
5. **Delete unused deploy keys** from repository settings
