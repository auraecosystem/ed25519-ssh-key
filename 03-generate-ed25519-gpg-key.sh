#!/bin/bash

# references:
# - https://blog.josefsson.org/tag/ed25519/
# - https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Key-Management.html

# use a new and unique key name.
# it will be necessary to have both old and new keys while transitioning.
# eg: for password-store re-encryption.
old_key_name="Rob Thijssen (https://grenade.github.io) <rthijssen@gmail.com>"
new_key_name="rob thijssen <rthijssen@gmail.com>"

# generate ed25519 master key with no expiration
gpg --quick-generate-key ${new_key_name} ed25519 sign 0

old_key_fingerprint=$(if [[ $(gpg --list-keys ${old_key_name}) =~ ([A-F0-9]{40}) ]]; then echo ${BASH_REMATCH[1]}; fi)
new_key_fingerprint=$(if [[ $(gpg --list-keys ${new_key_name}) =~ ([A-F0-9]{40}) ]]; then echo ${BASH_REMATCH[1]}; fi)

if [ -n "${new_key_fingerprint}" ]; then
  # generate elyptic curve encryption sub-key with no expiration
  gpg --quick-add-key ${new_key_fingerprint} cv25519 encr 0

  # generate ed25519 authentication sub-key with no expiration
  gpg --quick-add-key ${new_key_fingerprint} ed25519 auth 0

  # generate ed25519 signing sub-key with no expiration
  gpg --quick-add-key ${new_key_fingerprint} ed25519 sign 0
  
  # sign the new key with the old key
  gpg --default-key ${old_key_fingerprint} --sign-key ${new_key_fingerprint}
  # optionally sign the old key with the new key
  # gpg --default-key ${new_key_fingerprint} --sign-key ${old_key_fingerprint}
  
  # wip. don't use this.
  # touch transition-statement.md
  # gpg --digest-algo SHA512 --default-key ${new_key_fingerprint} --clearsign transition-statement.md
  
  # tell git about signing key
  # https://docs.github.com/en/github/authenticating-to-github/telling-git-about-your-signing-key
  new_signing_key_id=$(if [[ $(gpg --list-secret-keys --keyid-format LONG ${new_key_fingerprint}) =~ ed25519/([A-F0-9]{16})[[:space:]]202[1-9]-[01][0-9]-[0-3][0-9][[:space:]]\[S\] ]]; then echo ${BASH_REMATCH[1]}; fi)
  git config --global user.signingkey ${new_signing_key_id}
fi