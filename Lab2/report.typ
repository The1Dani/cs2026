#import "@templates/gc:1.0.0": temp

#set document(title: [
  Report Lab 2
])

#show: temp.with(
  lab-number: "2",
  toc: false,
  year: "2026",
  checked-by: ([Zaica Maia, university assistant],),
  title: "of Cryptography"
)

// Inline code. Not using raw: the template's `show raw: set par(..)` rule
// breaks the paragraph around every inline raw element.

// FreeMono fills in glyphs that Courier New is missing (e.g. Ș, Ț), at the same width.
#let mono = ("Courier New", "FreeMono")

#let c(body) = text(font: mono, size: 10pt, body)

// Ciphertext and partly decrypted text. Breakable, since the full texts are long.
#let txt(body) = block(
  fill: luma(245), stroke: luma(200), inset: 10pt, radius: 4pt, width: 100%,
  align(left, {
    set par(justify: false, first-line-indent: 0pt, leading: 0.6em)
    text(font: mono, size: 9pt, body.text)
  }),
)

#set list(indent: 1.5cm, body-indent: 0.6em)

// Letter counts in the cryptogram (2708 letters), from the online tool.
#let total = 2708
#let counts = (
  V: 402, W: 318, T: 193, I: 186, Q: 183, X: 176, N: 167, P: 162, G: 160,
  S: 113, O: 97, U: 88, H: 75, F: 57, D: 53, C: 49, R: 47, Z: 46, A: 37,
  J: 33, K: 23, L: 23, Y: 15, B: 2, M: 2, E: 1,
)

// English letter frequencies in percent (handout, Table 2.2), most frequent first.
#let english = (
  E: 12.7, T: 9.06, A: 8.17, O: 7.51, I: 6.97, N: 6.75, S: 6.33, H: 6.09,
  R: 5.99, D: 4.25, L: 4.03, C: 2.78, U: 2.76, M: 2.41, W: 2.36, F: 2.23,
  G: 2.01, Y: 1.97, P: 1.93, B: 1.49, V: 0.98, K: 0.77, J: 0.15, X: 0.15,
  Q: 0.09, Z: 0.07,
)

#let pct(n) = {
  let p = calc.round(n / total * 1000)
  str(int(p / 10)) + "." + str(calc.rem(p, 10))
}

#let freq-table(letters) = table(
  columns: (auto,) + (1fr,) * 13,
  align: center,
  inset: 5pt,
  ..for half in (letters.slice(0, 13), letters.slice(13)) {
    ([*Letter*], ..half)
    ([*Count*], ..half.map(l => str(counts.at(l))))
    ([*%*], ..half.map(l => pct(counts.at(l))))
  },
)

#let bars(data, color) = grid(
  columns: data.len(),
  column-gutter: 1.5pt,
  row-gutter: 3pt,
  align: center + bottom,
  ..data.pairs().map(((l, v)) => rect(
    width: 100%, height: v / 15 * 40mm, fill: color, stroke: none,
  )),
  ..data.keys().map(l => text(size: 7pt, l)),
)

#show raw: set text(font: mono, size: 9pt)

= Theory

== Monoalphabetic Substitution

A monoalphabetic cipher replaces every letter of the message with another letter of the alphabet, always the same one. The key is a permutation $pi$ of the alphabet:

$ c_i = pi(m_i), quad m_i = pi^(-1)(c_i) $

For the 26 letters of the English alphabet there are

$ 26! = 403 thin 291 thin 461 thin 126 thin 605 thin 635 thin 584 thin 000 thin 000 approx 4.03 dot 10^26 $

keys, so trying all of them is impossible. In this lab only the letters were encrypted, so spaces, digits and punctuation stay in place, which also keeps the word lengths visible.

== Frequency Analysis

Since each letter always becomes the same letter, the cipher keeps the letter frequencies of the language. In a long enough English text #c("e") is the most common letter (about 12.7%), followed by #c("t"), #c("a"), #c("o"), #c("i"), #c("n"). So the most frequent ciphertext letters are probably the images of these letters.

The frequencies alone are not exact, letters with close values can swap places. That is why the guesses are checked on words: the most common short words (#c("the"), #c("and"), #c("of"), #c("to"), #c("in"), #c("a")) and the one-letter words #c("a") and #c("I"). Every new substitution makes more of the text readable, and the half-decrypted words suggest the next letters.

= Breaking the Cipher

== The Intercepted Cryptogram

The cryptogram of variant 10, written in uppercase so that the letters still encrypted are easy to tell apart from the decrypted ones (lowercase) in the next steps:

#txt(```
KXJVGVIV RTP ANIG XG WQV KXSSTJV NC PTXGW-UNDIHTXG, TANDW QTSCRTFAVWRVVG UTIXP TGO
ZTIPVXSSVP, NG TUIXS 5, 1523. TW 24, QV VGWVIVO WQVPVIKXHV NC WQV ODLV NC GVKVIP, WN
RQNPV QNDPV QV IVZTXGVO TWWTHQVO WQVIVPW NC QXP SXCV, VYHVUW CNI UVIXNOP TW HNDIW TGO
TP T OXUSNZTW. XG 1549, TW26, QV RVGW WN INZV NG T WRN-FVTI OXUSNZTWXH ZXPPXNG.XW RTP
QVIV WQTW QV RTP CXIPW WQINRG XGWN HNGWTHW RXWQ HIFUWNSNJF, TGOQV PVVZP WN QTKV
PWVVUVO QXZPVSC XG XW. QV IVTO WQV ANNLP NC WIXWQVZXDP,AVSTPN, TGO NWQVI RIXWVIP, TGO
WQV DGUDASXPQVO ZTGDPHIXUW NC TSAVIWX. QVVKXOVGWSF HNGKVIPVO RXWQ WQV VYUVIWP NC WQV
UTUTS HDIXT, CNI QV WVSSPTGVHONWVP WQTW QV HNDSO QTKV QVTIO NGSF XG WQV PQNUWTSL NC
WQVPVHIFUWNSNJXPWP. TW 47, KXJVGVIV BDXW WQV HNDIW, WDIGVO NKVI QXP TGGDXWF NC1,000
SXKIVP T FVTI WN WQV UNNI NC UTIXP, ZTIIXVO WQV ZDHQ FNDGJVI ZTIXVKTIV, TGO OVKNWVO
QXZPVSC WN QXP RIXWXGJ. QXP WITXHWV OVP HQXCCIVP, RQXHQRTP RIXWWVG XG 1585 OVPUXWV WQV
OXPWITHWXNG NC T FVTI-NSO ATAF OTDJQWVI,TUUVTIVO, VSVJTGWSF IDAIXHTWVO, XG 1586, TGO
RTP IVUIXGWVO WQV CNSSNRXGJFVTI. QXP TDWNLVF PFPWVZ DPVO WQV USTXGWVYW TP WQV LVF. XW
UINKXOVO TUIXZXGJ LVF. WQXP HNGPXPWVO NC T PXGJSV SVWWVI, LGNRG WN ANWQ VGHXUQVIVITGO
OVHXUQVIVI, RXWQ RQXHQ WQV OVHXUQVIVI HNDSO OVHXUQVI WQV CXIPWHIFUWNJITZ SVWWVI TGO PN
JVW T PWTIW NG QXP, RNIL. RXWQ WQXP, QV RNDSO JVWWQV CXIPW USTXGWVYW SVWWVI, WQVG DPV
WQXP TP WQV LVF WN OVHXUQVI WQV PVHNGOHIFUWNJITZ SVWWVI, DPV WQTW USTXGWVYW TP WQV LVF
WN OVHXUQVI WQV WQXIOHIFUWNJITZ SVWWVI, TGO PN NG.WQV PFPWVZ RNILP RVSS TGO TCCNIOP
CTXI JDTITGWVVP NC PVHDIXWF; XW QTPAVVG VZANOXVO XG T GDZAVI NC ZNOVIG HXUQVI
ZTHQXGVP.XG PUXWV NC KXJVGVIV'P HSVTI VYUNPXWXNG NC QXP WVHQGXBDV, XW RTP
VGWXIVSFCNIJNWWVG TGO NGSF VGWVIVO WQV PWIVTZ NC HIFUWNSNJF STWV XG WQV 19WQHVGWDIF
TCWVI XW QTO AVVG IVXGKVGWVO. RIXWVIP NG HIFUWNSNJF WQVG TOOVOXGPDSW WN XGEDIF AF
OVJITOXGJ KXJVGVIV'P PFPWVZ XGWN NGV ZDHQ ZNIVVSVZVGWTIF.WQV HXUQVI GNR DGXKVIPTSSF
HTSSVO WQV KXJVGVIV VZUSNFP NGSF PWTGOTIO TSUQTAVWP TGO T PQNIW IVUVTWXGJ LVFRNIO—T
PFPWVZ CTIZNIV PDPHVUWXASV WN PNSDWXNG WQTG KXJVGVIV'P TDWNLVF. XWP WTASVTDHNGPXPWP NC
T ZNOVIG WTADST IVHWT: 26 PWTGOTIO QNIXMNGWTS TSUQTAVWP,VTHQ PSXO NGV PUTHV WN WQV
SVCW NC WQV NGV TANKV. WQVPV TIV WQV HXUQVITSUQTAVWP. T GNIZTS TSUQTAVW CNI WQV
USTXGWVYW PWTGOP TW WQV WNU. TGNWQVIGNIZTS TSUQTAVW, RQXHQ ZVIVSF IVUVTWP WQV XGXWXTS
SVWWVIP NC WQV QNIXMNGWTSHXUQVIWVYW TSUQTAVWP, IDGP ONRG WQV SVCW PXOV. WQXP XP WQV
LVF TSUQTAVW.ANWQ HNIIVPUNGOVGWP ZDPW LGNR WQV LVFRNIO. WQV VGHXUQVIVI IVUVTWPWQXP
TANKV WQV USTXGWVYW SVWWVIP DGWXS VTHQ NGV QTP T LVFSVWWVI. QV PVVLPWQV USTXGWVYW
SVWWVI XG WQV WNU TSUQTAVW TGO WQV LVFSVWWVI XG WQV PXOV. WQVGQV WITHVP ONRG CINZ WQV
WNU TGO XG CINZ WQV PXOV. WQV HXUQVIWVYW SVWWVIPWTGOP TW WQV XGWVIPVHWXNG NC WQV
HNSDZG TGO WQV INR. WQV VGHXUQVIVIIVUVTWP WQXP UINHVPP RXWQ TSS WQV SVWWVIP NC WQV
USTXGWVYW. WN OVHXUQVI, WQVHSVIL AVJXGP RXWQ WQV LVFSVWWVI, IDGP XG TSNGJ WQV
HXUQVIWVYW TSUQTAVWDGWXS QV PWIXLVP WQV HXUQVI SVWWVI, WQVG CNSSNRP WQV HNSDZG NC
SVWWVIPDURTIO DGWXS QV VZVIJVP TW WQV USTXGWVYW SVWWVI TW WQV WNU.UNSFTSUQTAVWXH
HXUQVIP RVIV, RQVG DPVO RXWQ ZXYVO TSUQTAVWP TGORXWQNDW RNIO OXKXPXNGP, DGAIVTLTASV WN
WQV HIFUWTGTSFPWP NC WQVIVGTXPPTGHV. RQF, WQVG, OXO WQV GNZVGHSTWNI IVXJG PDUIVZV CNI
300FVTIP? RQF OXO HIFUWNJITUQVIP GNW DPV WQV UNSFTSUQTAVWXH PFPWVZXGPWVTO?
```)

== Letter Frequencies

The first step is to count every letter of the cryptogram, done with the online tool #link("https://crypto.interactive-maths.com/frequency-analysis-breaking-the-code.html")[Interactive Maths]. The text has 2708 letters. Table 2.1 shows them in alphabetical order and Table 2.2 sorted by frequency.

#figure(
  freq-table(counts.keys().sorted()),
  caption: [Letter frequencies in the cryptogram],
)

#figure(
  freq-table(counts.keys()),
  caption: [Letter frequencies in the cryptogram, sorted],
)

Figure 2.1 compares the English frequencies (left) with the cryptogram's (right), both sorted and on the same scale.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 8mm,
    bars(english, rgb("#4a7ebb")),
    bars(counts.pairs().map(((l, v)) => (l, v / total * 100)).to-dict(),
      rgb("#be4b48")),
  ),
  caption: [Letter frequencies (%) of English (left) and of the cryptogram (right)],
)

== Step 1: e and t

The most frequent letter is #c("V") with 14.8%, far ahead of the rest, followed by #c("W") with 11.7%. In English these are #c("e") and #c("t"), so we replace #c("V") with #c("e") and #c("W") with #c("t"):

#txt(```
KXJeGeIe RTP ANIG XG tQe KXSSTJe NC PTXGt-UNDIHTXG, TANDt QTSCRTFAetReeG UTIXP TGO
ZTIPeXSSeP, NG TUIXS 5, 1523. Tt 24, Qe eGteIeO tQePeIKXHe NC tQe ODLe NC GeKeIP, tN
RQNPe QNDPe Qe IeZTXGeO TttTHQeO tQeIePt NC QXP SXCe, eYHeUt CNI UeIXNOP Tt HNDIt TGO
TP T OXUSNZTt. XG 1549, Tt26, Qe ReGt tN INZe NG T tRN-FeTI OXUSNZTtXH ZXPPXNG.Xt RTP
QeIe tQTt Qe RTP CXIPt tQINRG XGtN HNGtTHt RXtQ HIFUtNSNJF, TGOQe PeeZP tN QTKe
PteeUeO ...
```)

== Step 2: h

The word #c("tQe") appears all over the text. The most common three-letter word in English is #c("the"), which fits what we already have, so #c("Q") is #c("h"). The frequencies agree: 6.8% for #c("Q") and 6.09% for #c("h").

#txt(```
KXJeGeIe RTP ANIG XG the KXSSTJe NC PTXGt-UNDIHTXG, TANDt hTSCRTFAetReeG UTIXP TGO
ZTIPeXSSeP, NG TUIXS 5, 1523. Tt 24, he eGteIeO thePeIKXHe NC the ODLe NC GeKeIP, tN
RhNPe hNDPe he IeZTXGeO TttTHheO theIePt NC hXP SXCe, eYHeUt CNI UeIXNOP Tt HNDIt TGO
TP T OXUSNZTt. XG 1549, Tt26, he ReGt tN INZe NG T tRN-FeTI OXUSNZTtXH ZXPPXNG.Xt RTP
heIe thTt he RTP CXIPt thINRG XGtN HNGtTHt RXth HIFUtNSNJF, TGOhe PeeZP tN hTKe
PteeUeO ...
```)

== Step 3: a

The next most frequent letter is #c("T") (7.1%), so it is probably #c("a"), #c("o") or #c("i"). #c("T") stands alone as a word (#c("TP T OXUSNZTt"), #c("NG T tRN-FeTI")), and the only one-letter words in English are #c("a") and #c("I"), so #c("T") is #c("a"). It also turns #c("Tt 24") into #c("at 24").

#txt(```
KXJeGeIe RaP ANIG XG the KXSSaJe NC PaXGt-UNDIHaXG, aANDt haSCRaFAetReeG UaIXP aGO
ZaIPeXSSeP, NG aUIXS 5, 1523. at 24, he eGteIeO thePeIKXHe NC the ODLe NC GeKeIP, tN
RhNPe hNDPe he IeZaXGeO attaHheO theIePt NC hXP SXCe, eYHeUt CNI UeIXNOP at HNDIt aGO
aP a OXUSNZat. XG 1549, at26, he ReGt tN INZe NG a tRN-FeaI OXUSNZatXH ZXPPXNG.Xt RaP
heIe that he RaP CXIPt thINRG XGtN HNGtaHt RXth HIFUtNSNJF, aGOhe PeeZP tN haKe
PteeUeO ...
```)

== Step 4: n and d

Now the three-letter word #c("aGO") is very common. The most likely word is #c("and"), so #c("G") is #c("n") and #c("O") is #c("d"), and both are close in frequency (5.9% and 6.75%, 3.6% and 4.25%).

#txt(```
KXJeneIe RaP ANIn Xn the KXSSaJe NC PaXnt-UNDIHaXn, aANDt haSCRaFAetReen UaIXP and
ZaIPeXSSeP, Nn aUIXS 5, 1523. at 24, he enteIed thePeIKXHe NC the dDLe NC neKeIP, tN
RhNPe hNDPe he IeZaXned attaHhed theIePt NC hXP SXCe, eYHeUt CNI UeIXNdP at HNDIt and
aP a dXUSNZat. Xn 1549, at26, he Rent tN INZe Nn a tRN-FeaI dXUSNZatXH ZXPPXNn.Xt RaP
heIe that he RaP CXIPt thINRn XntN HNntaHt RXth HIFUtNSNJF, andhe PeeZP tN haKe
PteeUed ...
```)

== Step 5: i, w and s

#c("XG 1549") became #c("Xn 1549"), and #c("Xn the") is also frequent, so #c("X") is #c("i"). The word #c("RaP") appears many times, for example in #c("Xt RaP heIe"), which reads as #c("it was here"), so #c("R") is #c("w") and #c("P") is #c("s").

#txt(```
KiJeneIe was ANIn in the KiSSaJe NC saint-UNDIHain, aANDt haSCwaFAetween UaIis and
ZaIseiSSes, Nn aUIiS 5, 1523. at 24, he enteIed theseIKiHe NC the dDLe NC neKeIs, tN
whNse hNDse he IeZained attaHhed theIest NC his SiCe, eYHeUt CNI UeIiNds at HNDIt and
as a diUSNZat. in 1549, at26, he went tN INZe Nn a twN-FeaI diUSNZatiH ZissiNn.it was
heIe that he was CiIst thINwn intN HNntaHt with HIFUtNSNJF, andhe seeZs tN haKe
steeUed ...
```)

== Step 6: o and f

Two frequent two-letter words are still unknown, #c("tN") and #c("NC"). #c("tN") can only be #c("to"), and #c("NC the") then becomes #c("oC the"), which is #c("of the"). So #c("N") is #c("o") and #c("C") is #c("f").

#txt(```
KiJeneIe was AoIn in the KiSSaJe of saint-UoDIHain, aAoDt haSfwaFAetween UaIis and
ZaIseiSSes, on aUIiS 5, 1523. at 24, he enteIed theseIKiHe of the dDLe of neKeIs, to
whose hoDse he IeZained attaHhed theIest of his Sife, eYHeUt foI UeIiods at HoDIt and
as a diUSoZat. in 1549, at26, he went to IoZe on a two-FeaI diUSoZatiH Zission.it was
heIe that he was fiIst thIown into HontaHt with HIFUtoSoJF, andhe seeZs to haKe
steeUed ...
```)

== Step 7: r and b

The words #c("heIe"), #c("otheI") and #c("wIiteIs") are clearly #c("here"), #c("other") and #c("writers"), so #c("I") is #c("r"). After that, #c("was AoIn in") reads as #c("was born in"), so #c("A") is #c("b").

#txt(```
KiJenere was born in the KiSSaJe of saint-UoDrHain, aboDt haSfwaFbetween Uaris and
ZarseiSSes, on aUriS 5, 1523. at 24, he entered theserKiHe of the dDLe of neKers, to
whose hoDse he reZained attaHhed therest of his Sife, eYHeUt for Ueriods at HoDrt and
as a diUSoZat. in 1549, at26, he went to roZe on a two-Fear diUSoZatiH Zission.it was
here that he was first thrown into HontaHt with HrFUtoSoJF, andhe seeZs to haKe
steeUed ...
```)

== Step 8: l, g and v

The text starts with #c("KiJeneIe was born in the KiSSaJe of"). #c("KiSSaJe") fits only #c("village"), which gives #c("K") → #c("v"), #c("S") → #c("l") and #c("J") → #c("g"). The first word then becomes #c("vigenere"), the name of the cryptographer the text is about.

#txt(```
vigenere was born in the village of saint-UoDrHain, aboDt halfwaFbetween Uaris and
Zarseilles, on aUril 5, 1523. at 24, he entered theserviHe of the dDLe of nevers, to
whose hoDse he reZained attaHhed therest of his life, eYHeUt for Ueriods at HoDrt and
as a diUloZat. in 1549, at26, he went to roZe on a two-Fear diUloZatiH Zission.it was
here that he was first thrown into HontaHt with HrFUtologF, andhe seeZs to have
steeUed ...
```)

== Step 9: p, u and c

#c("Uaris"), #c("aboDt") and #c("HontaHt") are #c("paris"), #c("about") and #c("contact"), so #c("U") is #c("p"), #c("D") is #c("u") and #c("H") is #c("c"). This also gives #c("saint-pourcain"), #c("house") and #c("periods").

#txt(```
vigenere was born in the village of saint-pourcain, about halfwaFbetween paris and
Zarseilles, on april 5, 1523. at 24, he entered theservice of the duLe of nevers, to
whose house he reZained attached therest of his life, eYcept for periods at court and
as a diploZat. in 1549, at26, he went to roZe on a two-Fear diploZatic Zission.it was
here that he was first thrown into contact with crFptologF, andhe seeZs to have
steeped ...
```)

== Step 10: y

#c("two-Fear") and #c("crFptologF") can only be #c("two-year") and #c("cryptology"), so #c("F") is #c("y").

#txt(```
vigenere was born in the village of saint-pourcain, about halfwaybetween paris and
Zarseilles, on april 5, 1523. at 24, he entered theservice of the duLe of nevers, to
whose house he reZained attached therest of his life, eYcept for periods at court and
as a diploZat. in 1549, at26, he went to roZe on a two-year diploZatic Zission.it was
here that he was first thrown into contact with cryptology, andhe seeZs to have
steeped ...
```)

== Step 11: m, k, x, q, z and j

Only a few rare letters are left, and the words around them are easy to read: #c("Zarseilles") and #c("roZe") give #c("Z") → #c("m"), #c("duLe") and #c("booLs") give #c("L") → #c("k"), and #c("eYcept") and #c("eYperts") give #c("Y") → #c("x"). The last three letters appear only once or twice in the whole text: #c("vigenere Buit the court") gives #c("B") → #c("q"), #c("horiMontal") gives #c("M") → #c("z"), and #c("insult to inEury") gives #c("E") → #c("j").

== The Decrypted Message

With all 26 letters replaced we get the message. Some words are joined together because the spaces are already missing in the cryptogram of the handout.

#txt(```
vigenere was born in the village of saint-pourcain, about halfwaybetween paris and
marseilles, on april 5, 1523. at 24, he entered theservice of the duke of nevers, to
whose house he remained attached therest of his life, except for periods at court and
as a diplomat. in 1549, at26, he went to rome on a two-year diplomatic mission.it was
here that he was first thrown into contact with cryptology, andhe seems to have
steeped himself in it. he read the books of trithemius,belaso, and other writers, and
the unpublished manuscript of alberti. heevidently conversed with the experts of the
papal curia, for he tellsanecdotes that he could have heard only in the shoptalk of
thesecryptologists. at 47, vigenere quit the court, turned over his annuity of1,000
livres a year to the poor of paris, married the much younger marievare, and devoted
himself to his writing. his traicte des chiffres, whichwas written in 1585 despite the
distraction of a year-old baby daughter,appeared, elegantly rubricated, in 1586, and
was reprinted the followingyear. his autokey system used the plaintext as the key. it
provided apriming key. this consisted of a single letter, known to both enciphererand
decipherer, with which the decipherer could decipher the firstcryptogram letter and so
get a start on his, work. with this, he would getthe first plaintext letter, then use
this as the key to decipher the secondcryptogram letter, use that plaintext as the key
to decipher the thirdcryptogram letter, and so on.the system works well and affords
fair guarantees of security; it hasbeen embodied in a number of modern cipher
machines.in spite of vigenere's clear exposition of his technique, it was
entirelyforgotten and only entered the stream of cryptology late in the 19thcentury
after it had been reinvented. writers on cryptology then addedinsult to injury by
degrading vigenere's system into one much moreelementary.the cipher now universally
called the vigenere employs only standard alphabets and a short repeating keyword—a
system farmore susceptible to solution than vigenere's autokey. its tableauconsists of
a modern tabula recta: 26 standard horizontal alphabets,each slid one space to the
left of the one above. these are the cipheralphabets. a normal alphabet for the
plaintext stands at the top. anothernormal alphabet, which merely repeats the initial
letters of the horizontalciphertext alphabets, runs down the left side. this is the
key alphabet.both correspondents must know the keyword. the encipherer repeatsthis
above the plaintext letters until each one has a keyletter. he seeksthe plaintext
letter in the top alphabet and the keyletter in the side. thenhe traces down from the
top and in from the side. the ciphertext letterstands at the intersection of the
column and the row. the enciphererrepeats this process with all the letters of the
plaintext. to decipher, theclerk begins with the keyletter, runs in along the
ciphertext alphabetuntil he strikes the cipher letter, then follows the column of
lettersupward until he emerges at the plaintext letter at the top.polyalphabetic
ciphers were, when used with mixed alphabets andwithout word divisions, unbreakable to
the cryptanalysts of therenaissance. why, then, did the nomenclator reign supreme for
300years? why did cryptographers not use the polyalphabetic systeminstead?
```)

The text is about Blaise de Vigenère: his life, his autokey cipher, and how the simpler repeating-key cipher came to be called the Vigenère cipher.

== The Recovered Key

Putting the plaintext alphabet next to the ciphertext letters gives the key used for the encryption (Table 2.3). It would decrypt any other message encrypted with the same key right away.

#figure(
  table(
    columns: (auto,) + (1fr,) * 26,
    align: center,
    inset: (x: 2pt, y: 5pt),
    [*Plain*], ..("abcdefghijklmnopqrstuvwxyz".clusters()),
    [*Cipher*], ..("TAHOVCJQXELSZGNUBIPWDKRYFM".clusters()),
  ),
  caption: [The recovered key],
)

Figure 2.2 shows the final state of the online tool, with every ciphertext letter (sorted by frequency) and the plaintext letter it was replaced with.

#figure(
  image("static/frequency_tool.png", width: 100%),
  caption: [The frequency table and the substitution in the online tool],
)

= Conclusion

The cipher was broken in eleven steps. Matching letters only by frequency would have worked for the first two (#c("V") → #c("e"), #c("W") → #c("t")), but after that the ranks no longer match: the third most frequent letter is #c("a") as expected, but the next ones are #c("r") and #c("h"), not #c("o") and #c("i"). Short frequent words like #c("the"), #c("and"), #c("a") and #c("to") fixed these, and from the middle of the process on, half-decrypted words like #c("KiSSaJe") gave the remaining letters almost by themselves.

The main takeaway is that a key space of $26! approx 4 dot 10^26$ does not protect a monoalphabetic cipher at all. The text keeps the letter statistics and the word structure of the language, and a few thousand letters were more than enough to recover the whole key by hand.
