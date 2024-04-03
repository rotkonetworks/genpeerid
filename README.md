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
curl -sL https://raw.githubusercontent.com/rotkonetworks/genpeerid/master/scripts/install.sh | bash
```

## Building from source

### Prerequisites

- Python 3.8 or newer
- Pip for Python3

### Installing

To set up a local development environment:

1. Clone the repository:

```bash
git clone https://github.com/yourusername/genpeerid.git
```

2. Navigate to the cloned directory:

```bash
cd genpeerid
```

3. Install the required Python packages:

```bash
pip install -r requirements.txt
```

## Usage

To generate a PeerId, run:

```bash
python src/genpeerid.py <path_to_your_secret_key_file>
```

The script will output a PeerId that can be used within the Polkadot network.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
