"""Laboratory Work No. 1, Task 1.1 - Caesar cipher over the Romanian alphabet (n = 31)."""

from common import N, decrypt, encrypt, read_choice, read_key, read_text


def main():
    while True:
        op = read_choice("\nE - encrypt, D - decrypt: ", ["E", "D"])
        k = read_key(f"Key (1-{N - 1}): ")
        if op == "E":
            print("Ciphertext:", encrypt(read_text("Message: "), k))
        else:
            print("Message:", decrypt(read_text("Ciphertext: "), k))


if __name__ == "__main__":
    main()
