# Trust Bootstrap: ICANN → Handshake
## `theclubdelta.com` → `.configfile`

**Version:** 0.3
**Scope:** Define a secure onboarding flow where an ICANN domain is used once to install Handshake DNS + trust config.
**Updated:** 2025-12-30

---

## 1. Objective

Use:

https://theclubdelta.com/install.sh

to install:

- Handshake DNS resolver
- optional internal CA trust
- optional VPN config

so that all subsequent trusted communication uses:

*.configfile

ICANN is not required after onboarding.

---

## 2. Components

| Component | Purpose |
|----------|---------|
| `theclubdelta.com` | Installer delivery endpoint |
| `.configfile` | Sovereign namespace |
| `hnsd` / `hsd` | Handshake resolver |
| System DNS settings | Route lookup to Handshake |
| Root CA (optional) | TLS termination for internal services |
| WireGuard / Tailscale (optional) | Authenticated network fabric |
| `install.sh` | Bootstrap installer |

---

## 3. Trust Model

### 3.1 Temporary trust (one-time)
- Public TLS via CA → `theclubdelta.com`
- HTTPS transport integrity

### 3.2 Permanent trust (installed)
- Handshake DNS resolver
- Optional internal CA root
- Optional VPN identity

### 3.3 Post-bootstrap
- Trusted services exist only under `.configfile`
- Public DNS and CA are no longer relied upon

---

## 4. Requirements

### 4.1 Installer delivery
- HTTPS enforced
- SHA256 checksum published
- Optional signature (GPG/Minisign)
- Script must be auditable and minimal

### 4.2 Supported clients
- macOS
- Linux

Windows optional later.

---

## 5. Onboarding Flow

### 5.1 User command

Preferred:

```bash
curl -O https://theclubdelta.com/install.sh
curl -O https://theclubdelta.com/install.sh.sha256
sha256sum -c install.sh.sha256
bash install.sh
```

(or equivalent on macOS)

---

## 6. Installer Actions (deterministic order)

1. Detect OS + architecture
2. Install Handshake resolver:
   - Option A: install hnsd locally
   - Option B: configure trusted remote HNS resolver
3. Configure DNS resolution:
   - macOS example:
     ```
     Network Service DNS → 127.0.0.1 or resolver IP
     ```
   - Linux example:
     ```
     /etc/resolv.conf or systemd-resolved override
     ```
4. Verify .configfile DNS lookup
   ```bash
   dig test.configfile
   ```
5. (Optional) install internal CA root
6. (Optional) enroll device into VPN
7. Verify HTTPS against internal service endpoint

---

## 7. DNS Architecture

### Option A — Self-Hosted Resolver (recommended) ✅ DEPLOYED

Run `hnsd` on your own server, accessed via Tailscale.

**Current deployment:**
- **Server:** Bregalad (Ubuntu 24.04 LTS)
- **Tailscale IP:** `100.88.83.124`
- **hnsd version:** 2.99.0
- **Status:** Running, chain synced

**Server setup (Ubuntu):**
```bash
# Install dependencies
sudo apt update && sudo apt install -y build-essential autoconf libtool libunbound-dev git

# Build hnsd
git clone https://github.com/handshake-org/hnsd
cd hnsd && ./autogen.sh && ./configure && make
sudo make install
sudo ldconfig

# IMPORTANT: Remove conflicting libuv (breaks dig/bind)
sudo rm /usr/local/lib/libuv.so*
sudo ldconfig

# Run as systemd service (bind to Tailscale IP only)
cat << 'EOF' | sudo tee /etc/systemd/system/hnsd.service
[Unit]
Description=Handshake Light Resolver
After=network.target tailscaled.service

[Service]
ExecStart=/usr/local/bin/hnsd -r 100.88.83.124:53
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Disable systemd-resolved if using this server for DNS
sudo systemctl disable --now systemd-resolved

sudo systemctl daemon-reload
sudo systemctl enable --now hnsd
```

**Client DNS config:**
- Point system DNS → `100.88.83.124` (Tailscale IP)
- No firewall rules needed (Tailscale handles auth)
- Only accessible from within Tailnet

**Verification:**
```bash
dig @100.88.83.124 nb NS +short
# Should return: ns1.hns.id. ns2.hns.id.
```

**Pros:** zero trust, always warm, no local RAM usage, secure via Tailscale
**Cons:** server dependency (but you own it)

### Option B — Local Resolver

- Install hnsd locally
- Run as daemon
- Point system DNS → 127.0.0.1

**Pros:** fully independent
**Cons:** ~100MB RAM, cold start delay

### Option C — Third-Party Resolver

- Configure trusted endpoint (hdns.io, NextDNS w/ HNS)
- System DNS points to resolver

**Pros:** simple, no maintenance
**Cons:** trust third party

---

## 8. Validation Steps

Installer must verify:

```bash
dig bootstrap.configfile
curl -fsSL https://ok.configfile/health
```

Failure → rollback & exit non-zero.

---

## 9. Rollback Logic

Installer must support:

- restore previous DNS
- remove resolver
- remove CA
- remove VPN config

Rollback must be idempotent.

---

## 10. Security Controls

| Control | Requirement |
|---------|-------------|
| Script integrity | checksum and/or signature |
| TLS transport | mandatory |
| Code visibility | public repo |
| Minimal permissions | no unnecessary sudo |
| Logs | local only, optional |
| Token auth (optional) | per-device onboarding |

Bootstrap domain credentials must use hardware-backed MFA.

---

## 11. Threat Model Summary

| Threat | Mitigation |
|--------|------------|
| Registrar/DNS hijack | Only relevant pre-bootstrap |
| DNS poisoning post-bootstrap | Removed via HNS |
| Rogue CA issuance | Mitigated via internal CA/pinning |
| MITM during install | TLS + checksum |
| Compromised bootstrap host | High-impact — protect domain & infra |
| Device compromise | Out of scope |

---

## 12. Directory Layout (proposed)

```
/bootstrap
  install.sh
  install.sh.sha256
  uninstall.sh
  docs/
  verifier/
```

---

## 13. Future Work

- Windows installer
- Offline bootstrap
- Fleet provisioning tokens
- Emergency trust anchor rotation process

---

## 14. Constants

| Key | Value |
|-----|-------|
| Bootstrap Domain | theclubdelta.com |
| Sovereign Root | .configfile |
| Resolver Server | Bregalad (`100.88.83.124`) |
| Resolver Software | hnsd 2.99.0 |
| VPN | Tailscale |
| CA | optional |

---

## 15. Progress & Next Steps

### Completed ✅
- [x] hnsd resolver deployed on Bregalad
- [x] Systemd service configured and running
- [x] Chain synced, resolving HNS names (verified with `nb` TLD)
- [x] Accessible via Tailscale at `100.88.83.124:53`

### Next Steps 🔜
1. **Register `.configfile` TLD on Handshake**
   - Use Namebase, Bob Wallet, or Shakedex
   - Estimated cost: ~5-50 HNS depending on auction
   - Set up DNS records after registration

2. **Configure DNS records for `.configfile`**
   - Point NS records to authoritative nameserver
   - Options: self-host with `hsd`, use hns.id, or Route53

3. **Set up `theclubdelta.com` for bootstrap**
   - Configure web server for installer delivery
   - Write `install.sh` script
   - Generate SHA256 checksums
   - Set up HTTPS

4. **Write client installer (`install.sh`)**
   - Detect OS (macOS/Linux)
   - Configure DNS to point to `100.88.83.124`
   - Verify HNS resolution works
   - Optional: Tailscale enrollment

5. **Test end-to-end bootstrap flow**
   - Fresh device → theclubdelta.com → install.sh → .configfile works

### Blocked/Waiting ⏳
- `.configfile` TLD availability (need to check/bid on Handshake)

---

End of spec.
