"""Laboratory Work No. 3, Task 3.2 - Vigenere cipher over the Romanian alphabet."""

# A letter's code is its index (A = 0, Ă = 1, ..., Z = 30).
ALPHABET = "AĂÂBCDEFGHIÎJKLMNOPQRSȘTȚUVWXYZ"


def encrypt(text, key, alphabet=ALPHABET):
    """c_i = (m_i + k_i) mod n"""
    n = len(alphabet)
    return "".join(
        # Index of the char + the key's selected char (pos%key_len) in the map
        alphabet[(alphabet.index(m) + alphabet.index(key[i % len(key)])) % n]
        for i, m in enumerate(text)
    )


def decrypt(text, key, alphabet=ALPHABET):
    """m_i = (c_i - k_i) mod n"""
    n = len(alphabet)
    return "".join(
        # In the same manner but in reverse this time we shift back with the key
        alphabet[(alphabet.index(c) - alphabet.index(key[i % len(key)])) % n]
        for i, c in enumerate(text)
    )


def prepare(text):
    """Remove spaces and uppercase. Returns None if a character is not allowed."""
    text = text.replace(" ", "").upper()
    invalid = [ch for ch in text if ch not in ALPHABET]
    if invalid:
        print(f"Invalid character(s): {' '.join(invalid)}. Allowed: only letters "
              f"of the Romanian alphabet {ALPHABET}, uppercase or lowercase.")
        return None
    return text


def read_choice(prompt, options):
    while True:
        choice = input(prompt).strip().upper()
        if choice in options:
            return choice
        print(f"Invalid choice. Allowed: {', '.join(options)}.")


def read_text(prompt):
    while True:
        text = prepare(input(prompt))
        if text is not None:
            return text


def read_key(prompt):
    while True:
        key = read_text(prompt)
        if len(key) >= 7:
            return key
        print(f"Key too short ({len(key)} letters). It must have at least 7 letters.")


def main():
    while True:
        op = read_choice("\nE - encrypt, D - decrypt: ", ["E", "D"])
        key = read_key("Key (at least 7 letters): ")
        if op == "E":
            print("Ciphertext:", encrypt(read_text("Message: "), key))
        else:
            print("Message:", decrypt(read_text("Ciphertext: "), key))


if __name__ == "__main__":
    main()
