# Trust Bootstrap: ICANN → Handshake
## `theclubdelta.com` → `.configfile`

**Version:** 0.2
**Scope:** Define a secure onboarding flow where an ICANN domain is used once to install Handshake DNS + trust config.

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

### Option A — Local Resolver (recommended)

- Install hnsd
- Run as daemon
- Point system DNS → 127.0.0.1

**Pros:** independent
**Cons:** update/maintenance required

### Option B — Remote Resolver

- Configure trusted endpoint (DoT/DoH preferred)
- System DNS points to resolver

**Pros:** simple
**Cons:** central dependency

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
| Resolver | TBD |
| VPN | optional |
| CA | optional |

---

End of spec.
