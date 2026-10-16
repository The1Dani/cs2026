**Laboratory Work No. 1**

**Objectives:** to understand how the Caesar cipher works, to see why its small key space makes it insecure, to strengthen it with a keyword-based permutation of the alphabet, and to implement both versions for the Romanian alphabet.

## 1.1. The Caesar Cipher

In the Caesar cipher (also spelled * Cesar* or * Cezar* ), every letter of the plaintext is replaced by the letter found a fixed number of positions further along the alphabet. The secret key * k*, which is the same for encryption and decryption, is this shift value: * * *k* * ∈\{* 1 *,* 2 *,* 3 *,...,* *n* *−* 1 *\}*, where * n* is the length of the alphabet. (The value * k* = 0 is excluded because it leaves the text unchanged.) Encryption and decryption are defined by the formulas c = ek(x) = (x+k) mod n, m = dk(y) = (y−k) mod n,

where * x* and * y* are the numeric codes (positions in the alphabet, starting from 0) of a letter of the plaintext * m* and of the ciphertext * c*, respectively. The * modulo* operation ( *a* mod * b* ) returns the remainder of dividing the integer * a* by the integer * b*. When * y* *−* *k* is negative, the result must be brought back into the range 0 *...* *n* *−* 1 by adding * n* (for example, ( 1 * −* 3 ) mod 26 = 24 ). Note that some programming languages return negative remainders, so this case must be handled explicitly.

The method is named after Julius Caesar, who is said to have used it with the key * k* = 3 to communicate with his generals (Table 1). For the English alphabet ( *n* = 26) and * k* = 3 we have, for example: $$ ek(S) = (18+3) mod 26 = 21 = V, $$ dk(V) = (21−3) mod 26 = 18 = S.

# X Y Z A B C D E F B

# A B C D E F G H I E

Figure 1. Shifting the alphabet by * k* = 3 (the last letters wrap around to the beginning)

For the plaintext * * *m* = "cifrul cezar", after converting to uppercase and removing spaces we get CIFRULCEZAR, which encrypts to * c* = "FLIUXOFHCDU". ***x***

# m

A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ***x+k***

# c

*D* *E* *F* *G* *H* *I* *J* *K* *L* *M* *N* *O* *P* *Q* *R* *S* *T* *U* *V* *W* *X* *Y* *Z* *A* *B* *C*

Table 1. * * *Caesar cipher with key k* = 3 * (English alphabet, n* = 26 *)*

The Caesar cipher is very easy to break, so it is a very weak cipher: a cryptanalyst can recover the plaintext simply by trying all 25 possible keys. It is not known how useful the cipher was in Caesar's own time, but it was probably reasonably secure, since few of his enemies could read and write, let alone had any knowledge of cryptanalysis.

**Task 1.1.** ** ** **Caesar cipher over the Romanian alphabet**

1. Implement the Caesar cipher for the ** Romanian alphabet** in a programming language of your choice. The Romanian alphabet has * n* = 31 letters:

# A ˘ A Â B C D E F G H I Î J K L M N O P Q R S S, T T, U V W X Y Z

2. Use only the letter encoding shown in Table 2 (A = 0, ˘ A = 1,..., Z = 30). Built-in character encodings of the language (e.g. ASCII or Unicode code points) must not be used to compute the shift.

3. The key must be an integer between 1 and 30 inclusive; no other values are accepted.

4. The text may contain only letters of the Romanian alphabet, uppercase (A-Z, ˘ A, Â, Î, S,, T, ) or lowercase (a-z, ˘a, â, î, s,, t, ). Spaces are allowed in the input and are removed.

5. If the user enters an invalid key or an invalid character, the program must display a clear message that states the allowed range (and, for text, which character was rejected) and ask for the value again.

6. Before encryption, the text is converted to uppercase and all spaces are removed.

7. The user chooses the operation (encryption or decryption), enters the key and the message (or ciphertext), and receives the ciphertext (or decrypted message).

# Letter

A ˘A Â B C D E F G H I Î J K L M N O P Q R S, T, U V W X Y Z

**Code** 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30

Table 2. * * *Letter encoding of the Romanian alphabet (n* = 31 *) to be used in the tasks*

*Implementation tip:* the letters S, and T, are sometimes typed with a cedilla (¸S, ¸T) instead of a comma below. It is recommended to treat these variants as the same letters, so that text typed on different keyboards is accepted.

## 1.2. The Caesar Cipher with a Permutation

The Caesar cipher has low cryptographic strength mainly because of its tiny key space: only 25 different keys for the Latin alphabet. It can therefore be broken by trying every key in turn (an * exhaustive* *search* or * brute-force attack* ). If a message was encrypted with the Caesar cipher, exactly one of the keys will produce readable text in the language of the message. For example, suppose the English message

# m = BRUTE FORCE ATTACK

is encrypted with the key * k* = 17. The resulting ciphertext is

# c = SILKVWFITVRKKRTB.

If a cryptanalyst intercepts this ciphertext and tries all keys 1 *,* 2 *,...,* 25, they obtain the following candidates:

# RHKJUVEHSUQJJQSA

EUXWHIRUFHDWWDFN QGJITUDGRTPIIPRZ DTWVGHQTEGCVVCEM PFIHSTCFQSOHHOQY CSVUFGPSDFBUUBDL OEHGRSBEPRNGGNPX BRUTEFORCEATTACK NDGFQRADOQMFFMOW AQTSDENQBDZSSZBJ MCFEPQZCNPLEELNV ZPSRCDMPACYRRYAI LBEDOPYBMOKDDKMU YORQBCLOZBXQQXZH KADCNOXALNJCCJLT XNQPABKNYAWPPWYG JZCBMNWZKMIBBIKS WMPOZAJMXZVOOVXF IYBALMVYJLHAAHJR VLONYZILWYUNNUWE HXAZKLUXIKGZZGIQ UKNMXYHKVXTMMTVD GWZYJKTWHJFYYFHP TJMLWXGJUWSLLSUC FVYXIJSVGIEXXEGO

Only the key * k* = 17 produces meaningful English text, so the plaintext corresponding to the ciphertext is

# m = BRUTEFORCEATTACK.

To increase the strength of the Caesar cipher, the alphabet can be permuted using a ** keyword** (not to be confused with the numeric key of the cipher). The keyword can be any sequence of letters of the alphabet, either a real word or a meaningless one.

Let the second key be * k* 2 = * cryptography*. We apply it to the alphabet

# A B C D E F G H I J K L M N O P Q R S T U V W X Y Z and obtain:

# C R Y P T O G A H B D E F I J K L M N Q S U V W X Z

The new order is built by writing the letters of * k* 2 first, followed by the remaining letters of the alphabet in their natural order. Each letter appears only once: if a letter occurs several times in the keyword, only its first occurrence is kept. Here CRYPTOGRAPHY contributes the 9 distinct letters C, R, Y, P, T, O, G, A, H (the second R, P and Y are dropped), shown in bold above.

The Caesar shift is then applied using this new alphabet order, i.e. the numeric code of a letter is now its position in the permuted alphabet: ***x***

# m

C R Y P T O G A H B D E F I J K L M N Q S U V W X Z ***x+k***

# c

*P* *T* *O* *G* *A* *H* *B* *D* *E* *F* *I* *J* *K* *L* *M* *N* *Q* *S* *U* *V* *W* *X* *Z* *C* *R* *Y*

Table 3. * * *Caesar cipher with keys k* 1 = 3 * and k* 2 * * *= cryptography*

For example, C has position 0 in the permuted alphabet, so it becomes the letter at position 3, which is P; I (position 13) becomes L (position 16). The plaintext CIFRULCEZAR is therefore encrypted as **PLKTXQPJYDT**, whereas the plain Caesar cipher with the same * k* gave FLIUXOFHCDU.

Since there are 26! = 403,291,461,126,605,635,584,000,000 possible orderings of the alphabet and 25 possible shifts, the number of keys ( *k* 1 *,* *k* 2 ) for this version of the algorithm is

$$ 26!\times25 = 10,082,286,528,165,140,889,600,000,000, $$

which complicates breaking the cipher by exhaustive search, but does not protect it against ** frequency analysis**: each plaintext letter is still always replaced by the same ciphertext letter, so the letter frequencies of the language remain visible in the ciphertext. (Note that different key pairs can produce the same substitution, so the number of distinct encryptions can never exceed 26!.)

**Task 1.2.** ** ** **Caesar cipher with two keys over the Romanian alphabet**

1. Implement the Caesar cipher with two keys for the ** Romanian alphabet**, keeping all the conditions of Task 1.1 (encoding from Table 2, * n* = 31).

2. Key 1 is the numeric shift (an integer from 1 to 30).

3. Key 2 is the keyword. It must contain only letters of the Romanian alphabet (including ˘ A, Â, Î, S,, T, ) and have a length of at least 7 characters; like the text, it is converted to uppercase before use.

4. The permuted alphabet is built from all 31 Romanian letters, as described above. The program must display it, so that the result can be checked by hand.

5. Invalid input for either key must produce a clear message stating the allowed values.

## Report

The report should contain the following sections:

1. ** ** **Title page:** the laboratory work number and topic, the author's name and group.

2. ** ** **Short theory:** a brief description of the Caesar cipher and of the Caesar cipher with a permutation, including the encryption and decryption formulas and the key space of each version.

3. ** ** **Implementation:** an explanation of how the tasks were solved, with the most important code fragments (for example, the letter encoding, building the permuted alphabet, encryption and decryption, and input validation), each followed by a short comment on what it does.

4. ** ** **Results:** screenshots of the running program showing encryption and decryption for both tasks, as well as the messages displayed for invalid input (wrong key, invalid characters, keyword that is too short).

5. ** ** **Conclusions:** brief conclusions about the security of the two ciphers and what was learned.

6. ** ** **Source code:** a link to the GitHub repository containing the full source code.

The final report must be uploaded to ELSE by the deadline set by the instructor. Each week of delay is penalized by one point of the final grade.