"""Laboratory Work No. 1 - functions shared by Task 1.1 and Task 1.2."""

# Table 2 encoding: a letter's code is its index (A = 0, Ă = 1, ..., Z = 30).
ALPHABET = "AĂÂBCDEFGHIÎJKLMNOPQRSȘTȚUVWXYZ"
N = len(ALPHABET)


def prepare(text):
    """Uppercase the text and remove spaces. Returns None if a character is not allowed."""
    text = text.replace(" ", "").upper()
    invalid = [ch for ch in text if ch not in ALPHABET]
    if invalid:
        print(f"Invalid character(s): {' '.join(invalid)}. Allowed: only letters "
              f"of the Romanian alphabet {ALPHABET}, uppercase or lowercase.")
        return None
    return text

def encrypt(text, k, alphabet=ALPHABET):
    """c = (x + k) mod n"""
    n = len(alphabet)
    return "".join(alphabet[(alphabet.index(ch) + k) % n] for ch in text)


def decrypt(text, k, alphabet=ALPHABET):
    """m = (y - k) mod n  (Python's % already returns a value in 0..n-1 for negative numbers)"""
    n = len(alphabet)
    return "".join(alphabet[(alphabet.index(ch) - k) % n] for ch in text)


# ------------------------------------------------------------------ input

def read_choice(prompt, options):
    while True:
        choice = input(prompt).strip().upper()
        if choice in options:
            return choice
        print(f"Invalid choice. Allowed: {', '.join(options)}.")


def read_key(prompt):
    while True:
        raw = input(prompt).strip()
        if raw.isdecimal() and 1 <= int(raw) <= N - 1:
            return int(raw)
        print(f"Invalid key '{raw}'. The key must be an integer from 1 to {N - 1}.")


def read_text(prompt):
    while True:
        text = prepare(input(prompt))
        if text is not None:
            return text
