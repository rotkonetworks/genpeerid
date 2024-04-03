import sys
import base58
from cryptography.hazmat.primitives.asymmetric import ed25519
from cryptography.hazmat.primitives import serialization


def read_secret_key_from_file(file_path):
    try:
        with open(file_path, "rb") as file:
            return file.read()
    except IOError as e:
        print(f"Error opening or reading the secret key file: {e}")
        sys.exit(1)


def generate_peer_id_from_secret_key(secret_key_bytes):
    # Load the secret key
    secret_key = ed25519.Ed25519PrivateKey.from_private_bytes(secret_key_bytes)

    # Get the public key
    public_key = secret_key.public_key()

    # Serialize the public key to bytes
    public_key_bytes = public_key.public_bytes(
        encoding=serialization.Encoding.Raw, format=serialization.PublicFormat.Raw
    )

    # Assemble the PeerId according to the Polkadot's specified format
    # src: https://spec.polkadot.network/chap-networking#id-node-identities
    peer_id_bytes = (
        bytes(
            [
                0x00,  # multihash prefix indicating no hashing
                0x24,  # length of the PeerId (36 bytes: 2 bytes for key type + 34 bytes for the public key and its length prefix)
                0x08,  # protobuf field-value pair start for key type
                0x01,  # ED25519 key type
                0x12,  # protobuf field-value pair start for the public key
                0x20,  # length of the public key (32 bytes)
            ]
        )
        + public_key_bytes
    )

    # Convert the PeerId bytes to Base58 for a more human-readable format
    return base58.b58encode(peer_id_bytes).decode()


def main(secret_key_file_path):
    secret_key_bytes = read_secret_key_from_file(secret_key_file_path)
    if len(secret_key_bytes) != 32:
        print(
            f"Error: The secret key must be exactly 32 bytes long, but got {len(secret_key_bytes)} bytes."
        )
        sys.exit(1)

    peer_id = generate_peer_id_from_secret_key(secret_key_bytes)
    print(f"{peer_id}")


def print_usage():
    print("\nUsage: genpeerid <path_to_secret_key_file>")
    print("\nThis script takes a file containing an ED25519 secret key as input,")
    print("generates the corresponding public key, and then calculates the PeerId")
    print("based on the public key following the format specified for Polkadot nodes.")
    print("\nThe expected input is a binary file with exactly 32 bytes representing")
    print(
        "the ED25519 secret key. The output is the PeerId in a Base58-encoded format,"
    )
    print("suitable for use as a unique identifier within the Polkadot network.")
    print("\nExample:")
    print("  genpeerid /path/to/your/secret_key_file")
    print("\nOutput:")
    print("  <Your_PeerId_here>\n")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print_usage()
        sys.exit(1)
    secret_key_file_path = sys.argv[1]
    main(secret_key_file_path)
