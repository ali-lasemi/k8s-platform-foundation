# Encrypted Secret Examples

Files ending with `.template.yaml` are plaintext templates.

Never place real credentials in template files.

Encrypted production secrets must:

- Use the `.enc.yaml` suffix
- Be encrypted with SOPS and Age
- Encrypt the `data` or `stringData` fields
- Never expose plaintext values in Git history
