import ecdsa
import sha3 # Nécessite la bibliothèque pysha3

def generer_adresse_ethereum():
    # 1. Génération de la clé privée (Private Key)
    cle_privee = ecdsa.SigningKey.generate(curve=ecdsa.SECP256k1)
    
    # 2. Dérivation EC SECP256K1 -> Clé publique (Public Key)
    # On récupère la clé publique brute non compressée
    cle_publique = cle_privee.get_verifying_key().to_string()
    
    # 3. Application du hachage Keccak-256
    keccak = sha3.keccak_256()
    keccak.update(cle_publique)
    hash_cle_publique = keccak.digest()
    
    # 4. Obtention de l'adresse Ethereum
    # On prend les 20 derniers octets du hachage et on ajoute "0x"
    adresse_eth = "0x" + hash_cle_publique[-20:].hex()
    
    return adresse_eth

print(f"Nouvelle adresse générée : {generer_adresse_ethereum()}")