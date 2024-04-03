use anyhow::{bail, Result};
use ed25519_dalek::{SigningKey, SECRET_KEY_LENGTH};
use std::{env, fs};
use bs58;

fn read_secret_key_from_file(file_path: &str) -> Result<SigningKey> {
    let secret_key_bytes = fs::read(file_path)?;
    if secret_key_bytes.len() != SECRET_KEY_LENGTH {
        bail!(
            "Error: The secret key must be exactly {} bytes long, but got {} bytes.",
            SECRET_KEY_LENGTH,
            secret_key_bytes.len()
        );
    }
    // Assuming the check above ensures we have exactly 32 bytes, we proceed.
    let secret_key_array: [u8; 32] = secret_key_bytes
        .try_into()
        .expect("Failed to convert Vec<u8> to [u8; 32]");

    Ok(SigningKey::from_bytes(&secret_key_array))
}

fn generate_peer_id_from_signing_key(signing_key: &SigningKey) -> Result<String> {
    let public_key = signing_key.verifying_key();
    let public_key_bytes = public_key.to_bytes();

    let peer_id_bytes = vec![
        0x00, // multihash prefix indicating no hashing
        0x24, // length of the PeerId
        0x08, // protobuf field-value pair start for key type
        0x01, // ED25519 key type
        0x12, // protobuf field-value pair start for the public key
        0x20, // length of the public key (32 bytes)
    ]
    .into_iter()
    .chain(public_key_bytes.iter().cloned())
    .collect::<Vec<u8>>();

    Ok(bs58::encode(peer_id_bytes).into_string())
}

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        println!("Usage: {} <path_to_secret_key_file>", args[0]);
        bail!("Invalid number of arguments.");
    }
    let secret_key_file_path = &args[1];
    let signing_key = read_secret_key_from_file(secret_key_file_path)?;
    let peer_id = generate_peer_id_from_signing_key(&signing_key)?;
    println!("{}", peer_id);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    fn secret_key_file_path() -> PathBuf {
        PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("testfile/secret_ed25519")
    }

    #[test]
    fn test_generate_peer_id_from_secret_key() -> Result<()> {
        let file_path = secret_key_file_path();
        let file_path_str = file_path.to_str().expect("Failed to convert path to string");

        let signing_key = read_secret_key_from_file(file_path_str)?;
        let peer_id = generate_peer_id_from_signing_key(&signing_key)?;

        assert_eq!(peer_id, "12D3KooWKJWU7pUcNTehXoRmUpDTTiNPdLBCckwcXQ1Znzm6A7om");
        Ok(())
    }
}
