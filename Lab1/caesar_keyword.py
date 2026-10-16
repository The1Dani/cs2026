"""Laboratory Work No. 1, Task 1.2 - Caesar cipher with two keys over the Romanian alphabet."""

from common import ALPHABET, N, decrypt, encrypt, prepare, read_choice, read_key, read_text


def permuted_alphabet(keyword, alphabet=ALPHABET):
    """Keyword letters first (each only once), then the remaining letters in order."""
    result = ""
    for ch in keyword + alphabet:
        if ch not in result:
            result += ch
    return result


def read_keyword(prompt):
    while True:
        keyword = prepare(input(prompt))
        if keyword is None:
            continue
        if len(keyword) >= 7:
            return keyword
        print(f"Keyword too short ({len(keyword)} letters). "
              f"It must have at least 7 letters.")


def main():
    while True:
        op = read_choice("\nE - encrypt, D - decrypt: ", ["E", "D"])
        k = read_key(f"Key 1 (1-{N - 1}): ")
        keyword = read_keyword("Key 2 - keyword (at least 7 letters): ")
        alphabet = permuted_alphabet(keyword)
        print("Permuted alphabet:", " ".join(alphabet))
        if op == "E":
            print("Ciphertext:", encrypt(read_text("Message: "), k, alphabet))
        else:
            print("Message:", decrypt(read_text("Ciphertext: "), k, alphabet))


if __name__ == "__main__":
    main()
