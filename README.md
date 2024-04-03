# genpeerid

`genpeerid` is a command-line tool designed to generate a PeerId from an ED25519 secret key,
formatted specifically for Polkadot and Substrate-based nodes. It's main purpose is to make
it easier to publish your bootnodes.

## Getting Started

These instructions will help you get a copy of `genpeerid` up and
running on your local machine for development and testing purposes.
See deployment for notes on how to deploy the project on a live system.

## Using gh workflow built binary
```bash
curl -sL $(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*?)(?=")') -o genpeerid
chmod +x genpeerid
./genpeerid ../chains/$network/network/secret_ed25519
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
python src/generate_polka_peer_id.py <path_to_your_secret_key_file>
```

The script will output a PeerId that can be used within the Polkadot network.

## Building the Binary

The GitHub Actions workflow automatically builds a binary for `genpeerid`.
To download the latest binary, visit the "Actions" tab in the GitHub repository
and select the latest successful build.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
