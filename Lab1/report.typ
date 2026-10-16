#import "@templates/gc:1.0.0": temp

#set document(title: [
  Report Lab 1
])

#show: temp.with(
  lab-number: "1",
  toc: false,
  year: "2026",
  checked-by: ([Zaica Maia, university assistant],),
  title: "of Cryptography"
)

// Inline code. Not using raw: the template's `show raw: set par(..)` rule
// breaks the paragraph around every inline raw element.

// FreeMono fills in Ș and Ț, which Courier New is missing, at the same width.
#let mono = ("Courier New", "FreeMono")

#let c(body) = text(font: mono, size: 10pt, body)

// Terminal output of the programs, copied from a real run.
#let term(body) = figure(
  block(fill: black, inset: 8pt, radius: 4pt, width: 100%, align(left, {
    set par(justify: false, first-line-indent: 0pt, leading: 0.6em)
    text(fill: white, font: mono, size: 9pt, body.text)
  })),
)

#set list(indent: 1.5cm, body-indent: 0.6em)

#show raw: set text(font: mono, size: 9pt)

#show raw.where(block: true): block.with(
  breakable: false,
  width: 100%,
  fill: luma(245),
  stroke: luma(200),
  inset: 10pt,
  radius: 4pt,
)

= Theory

== The Caesar Cipher

In the Caesar cipher every letter of the message is replaced by the letter found $k$ positions further in the alphabet, wrapping around at the end. The letters are numbered from $0$ to $n - 1$ and the same key $k$ is used to encrypt and decrypt:

$ c = e_k (x) = (x + k) mod n, quad m = d_k (y) = (y - k) mod n $

The key is $k in {1, 2, ..., n - 1}$, since $k = 0$ leaves the text unchanged. For the Romanian alphabet $n = 31$, so there are only *30 keys*, and the cipher is broken by simply trying all of them (brute force).

== The Caesar Cipher with a Permutation

A second key, a keyword $k_2$, is used to reorder the alphabet: first the letters of the keyword (each only once), then the rest of the letters in their normal order. The formulas stay the same, but $x$ and $y$ are now positions in the permuted alphabet.

The key space is every ordering of the alphabet times every shift:

$ 31! times 30 = 246 thin 685 thin 159 thin 625 thin 337 thin 684 thin 531 thin 766 thin 886 thin 400 thin 000 thin 000 approx 2.47 dot 10^35 $

This is too many to brute force, but every letter is still always replaced by the same letter, so the cipher can be broken with frequency analysis.

= Implementation

The lab is written in Python and split in three files:

- #c("common.py") holds the alphabet, text preparation, encryption, decryption and the input checks used by both tasks
- #c("caesar.py") is Task 1.1, the classic Caesar cipher
- #c("caesar_keyword.py") is Task 1.2, the Caesar cipher with a keyword

== Letter Encoding

```python
ALPHABET = "AĂÂBCDEFGHIÎJKLMNOPQRSȘTȚUVWXYZ"
N = len(ALPHABET)
```

The 31 letters are written in the order of Table 2, so the code of a letter is just its index in the string (#c("A") = 0, #c("Ă") = 1, ..., #c("Z") = 30). The shift never uses ASCII or Unicode values.

== Preparing the Text

```python
def prepare(text):
    text = text.replace(" ", "").upper()
    invalid = [ch for ch in text if ch not in ALPHABET]
    if invalid:
        print(f"Invalid character(s): {' '.join(invalid)}. Allowed: only letters "
              f"of the Romanian alphabet {ALPHABET}, uppercase or lowercase.")
        return None
    return text
```

The spaces are removed and the text is converted to uppercase; Python's #c("upper()") also handles the Romanian letters (#c("ă") → #c("Ă"), #c("ș") → #c("Ș")). Every character that is not in the alphabet is collected and shown in the error message, and #c("None") is returned so the input is asked again. The keyword goes through the same function.

== Encryption and Decryption

```python
def encrypt(text, k, alphabet=ALPHABET):
    n = len(alphabet)
    return "".join(alphabet[(alphabet.index(ch) + k) % n] for ch in text)


def decrypt(text, k, alphabet=ALPHABET):
    n = len(alphabet)
    return "".join(alphabet[(alphabet.index(ch) - k) % n] for ch in text)
```

Each letter is turned into its position, shifted by $k$ and turned back into a letter, which is exactly $(x + k) mod n$ and $(y - k) mod n$. Python's #c("%") always returns a value between $0$ and $n - 1$, so a negative $y - k$ wraps around without extra code. The alphabet is a parameter, so Task 1.2 uses the same two functions with the permuted alphabet.

== Building the Permuted Alphabet

```python
def permuted_alphabet(keyword, alphabet=ALPHABET):
    result = ""
    for ch in keyword + alphabet:
        if ch not in result:
            result += ch
    return result
```

The function walks over the keyword followed by the whole alphabet and keeps each letter only the first time it appears. The result always has all 31 letters, starting with the ones of the keyword.

== Input Validation

```python
def read_key(prompt):
    while True:
        raw = input(prompt).strip()
        if raw.isdecimal() and 1 <= int(raw) <= N - 1:
            return int(raw)
        print(f"Invalid key '{raw}'. The key must be an integer from 1 to {N - 1}.")


def read_keyword(prompt):
    while True:
        keyword = prepare(input(prompt))
        if keyword is None:
            continue
        if len(keyword) >= 7:
            return keyword
        print(f"Keyword too short ({len(keyword)} letters). "
              f"It must have at least 7 letters.")
```

Every input is asked again until it is valid. The key has to be a whole number from 1 to 30, and the keyword has to contain only Romanian letters and be at least 7 letters long.

== Task 1.2 Program

#block(breakable: false)[
```python
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
```
]

The program reads the operation and both keys, prints the permuted alphabet so it can be checked by hand, and then encrypts or decrypts the text. The Task 1.1 program is the same without the keyword.

= Results

== Task 1.1 — Encryption

#term(```
E - encrypt, D - decrypt: E
Key (1-30): 0
Invalid key '0'. The key must be an integer from 1 to 30.
Key (1-30): abc
Invalid key 'abc'. The key must be an integer from 1 to 30.
Key (1-30): 3
Message: cifrul cezar 2026!
Invalid character(s): 2 0 2 6 !. Allowed: only letters of the Romanian alphabet AĂÂBCDEFGHIÎJKLMNOPQRSȘTȚUVWXYZ, uppercase or lowercase.
Message: cifrul cezar
Ciphertext: FKITXOFHÂBT
```)

The wrong keys and the invalid characters are rejected and asked again. The last letter checks by hand: #c("Z") (30) + 3 = 33 mod 31 = 2, which is #c("Â").

== Task 1.1 — Decryption

#term(```
E - encrypt, D - decrypt: D
Key (1-30): 3
Ciphertext: FKITXOFHÂBT
Message: CIFRULCEZAR
```)

== Task 1.2 — Encryption

#term(```
E - encrypt, D - decrypt: E
Key 1 (1-30): 35
Invalid key '35'. The key must be an integer from 1 to 30.
Key 1 (1-30): 3
Key 2 - keyword (at least 7 letters): cripto
Keyword too short (6 letters). It must have at least 7 letters.
Key 2 - keyword (at least 7 letters): criptografie2
Invalid character(s): 2. Allowed: only letters of the Romanian alphabet AĂÂBCDEFGHIÎJKLMNOPQRSȘTȚUVWXYZ, uppercase or lowercase.
Key 2 - keyword (at least 7 letters): criptografie
Permuted alphabet: C R I P T O G A F E Ă Â B D H Î J K L M N Q S Ș Ț U V W X Y Z
Message: Știința în țară
Ciphertext: VAOOȘWĂLȘWĂTD
```)

#c("CRIPTOGRAFIE") gives the 10 distinct letters #c("C R I P T O G A F E") (the second #c("R") and #c("I") are dropped), followed by the other 21 letters in order. Checking one letter by hand: #c("Ș") is at position 23, and 23 + 3 = 26, which is #c("V").

== Task 1.2 — Decryption

#term(```
E - encrypt, D - decrypt: D
Key 1 (1-30): 3
Key 2 - keyword (at least 7 letters): criptografie
Permuted alphabet: C R I P T O G A F E Ă Â B D H Î J K L M N Q S Ș Ț U V W X Y Z
Ciphertext: vaooșwălșwătd
Message: ȘTIINȚAÎNȚARĂ
```)

= Conclusion

The classic Caesar cipher over the Romanian alphabet has only 30 keys, so it can be broken instantly by trying all of them. Adding a keyword permutation raises the key space to $31! times 30 approx 2.47 dot 10^35$, which makes brute force impossible, but the cipher is still a simple substitution: each letter always becomes the same letter, so the letter frequencies of the language stay visible and frequency analysis breaks it.

The main takeaway is that a large key space alone does not make a cipher secure. From the implementation side, the letter codes have to come from the cipher's own alphabet and not from the character encoding, the modulo has to wrap negative numbers correctly, and all user input has to be checked.

= Source Code

The full source code is available at #link("https://github.com/TODO")[#c("https://github.com/TODO")].
