# genpeerid

`genpeerid` is a command-line tool designed to generate a PeerId from an ED25519 secret key,
formatted specifically for Polkadot and Substrate-based nodes. It's main purpose is to make
it easier to publish your bootnodes.

## Getting Started

These instructions will help you get a copy of `genpeerid` up and
running on your local machine for development and testing purposes.
See deployment for notes on how to deploy the project on a live system.

## Installation with binary

```bash
# Script checks signatures and hashes of the binary before executing it
curl -sL https://raw.githubusercontent.com/rotkonetworks/genpeerid/master/scripts/install.sh | bash
```

## Building from source

```bash
cargo install --git https://github.com/rotkonetworks/genpeerid
cargo run --release /path/to/secret_ed25519
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
