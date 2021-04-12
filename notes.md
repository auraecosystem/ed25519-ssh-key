

update `~/.gitconfig`

```
[user]
  ...
  signingkey = <signing key from `gpg --list-secret-keys --keyid-format LONG` goes here)
  ...
```

update password-store (re-encrypt everything)

```
cd ~/.password-store
pass init $new_key_fingerprint $old_key_fingerprint
```