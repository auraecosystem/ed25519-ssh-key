#!/bin/bash

# use a new and unique key name.
# it will be necessary to have both old and new keys while transitioning.
# eg: for password-store re-encryption.
key_name="rob thijssen <rthijssen@gmail.com>"

# generate ed25519 master key with no expiration
gpg --quick-generate-key ${key_name} ed25519 sign 0

key_fingerprint=$(if [[ $(gpg --list-keys ${key_name}) =~ ([A-F0-9]{40}) ]]; then echo ${BASH_REMATCH[1]}; fi)

if [ -n "${key_fingerprint}" ]; then
  # generate elyptic curve encryption sub-key with no expiration
  gpg --quick-add-key ${key_fingerprint} cv25519 encr 0

  # generate ed25519 authentication sub-key with no expiration
  gpg --quick-add-key ${key_fingerprint} ed25519 auth 0

  # generate ed25519 signing sub-key with no expiration
  gpg --quick-add-key ${key_fingerprint} ed25519 sign 0
fi