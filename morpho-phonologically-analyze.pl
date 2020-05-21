
%%Defined a finite state automaton
initial(q0).
final(q1).
final(q2).
final(q3).
final(q4).
final(q5).
final(q6).
final(q7).

t(q0,verb,q1).
t(q1,negation,q5).
t(q1,defpast,q3).
t(q1,future,q2).
t(q1,progressive,q2).
t(q1,aorist,q2).
t(q1,narrative,q4).
t(q5,defpast,q3).
t(q5,future,q2).
t(q5,progressive,q2).
t(q5,aorist,q2).
t(q5,narrative,q4).
t(q5,person,q6).
t(q3,person,q6).
t(q2,defpast,q3).
t(q2,narrative,q4).
t(q2,person,q6).
t(q4,person,q6).
t(q4,defpast,q3).
t(q4,additional ,q7).
t(q2,additional ,q7).
t(q6,additional ,q7).


%%Verbs

allomorph(konuş,verb).
allomorph(çek,verb).
allomorph(çevir,verb).
allomorph(yakala,verb).
allomorph(tut,verb).


%%Tenses
allomorph(dı,defpast).
allomorph(di,defpast).
allomorph(du,defpast).
allomorph(dü,defpast).
allomorph(tı,defpast).
allomorph(ti,defpast).
allomorph(tu,defpast).
allomorph(tü,defpast).

allomorph(ecek,future).
allomorph(yecek,future).
allomorph(acak,future).
allomorph(yacak,future).

allomorph(r,aorist).
allomorph(ar,aorist).
allomorph(er,aorist).
allomorph(ur,aorist).
allomorph(ir,aorist).
allomorph(ır,aorist).
allomorph(ür,aorist).
allomorph(z,aorist).


allomorph(mış,narrative).
allomorph(miş,narrative).
allomorph(muş,narrative).
allomorph(müş,narrative).

allomorph(yor,progressive).
allomorph(ıyor,progressive).
allomorph(iyor,progressive).
allomorph(uyor,progressive).
allomorph(üyor,progressive).

allomorph(me,negation).
allomorph(ma,negation).
allomorph(mı,negation).
allomorph(mi,negation).
allomorph(mu,negation).
allomorph(mü,negation).

allomorph(dır,additional).
allomorph(dir,additional).
allomorph(tır,additional).
allomorph(tir,additional).

%%Person's allomorphs
allomorph(m,person).
allomorph(n,person).
allomorph(im,person).
allomorph(um,person).
allomorph(ım,person).
allomorph(sun,person).
allomorph(sin,person).
allomorph(k,person).
allomorph(iz,person).
allomorph(uz,person).
allomorph(siniz,person).
allomorph(sunuz,person).
allomorph(niz,person).
allomorph(ler,person).
allomorph(lar,person).

vowel(a).
vowel(ı).
vowel(o).
vowel(u).
vowel(e).
vowel(i).
vowel(ö).
vowel(ü).

consonant(b).
consonant(c).
consonant(ç).
consonant(d).
consonant(f).
consonant(g).
consonant(ğ).
consonant(h).
consonant(j).
consonant(k).
consonant(l).
consonant(m).
consonant(n).
consonant(p).
consonant(r).
consonant(s).
consonant(ş).
consonant(t).
consonant(v).
consonant(y).
consonant(z).

analyze(String, List_of_Morphemes):-
   initial(State),
   analyze(String, State, List_of_Morphemes, []).

analyze('', State, [], _):- final(State).

analyze(String, CurrentState, [Morpheme|Morphemes], Prev_Allomorph):-
   concat(Prefix, Suffix, String),
   allomorph(Prefix, Morpheme),
   t(CurrentState, Morpheme, NextState),
   append(Prev_Allomorph, [Prefix], Allomorphs),
   harmonize(Allomorphs),
   analyze(Suffix, NextState, Morphemes, [Prefix]).


harmonize([_]).

harmonize([Allomorph1, Allomorph2]):-
   string_to_list(Allomorph1, LCodes),
   string_to_list(Allomorph2, RCodes),
   vowel_vowel_harmony(LCodes, RCodes),
  consonant_consonant_harmony(LCodes, RCodes),
   vowel_consonant_harmony(LCodes, RCodes),
   consonant_vowel_harmony(LCodes, RCodes).

vowel_vowel_harmony(LCodes, [RCode1, RCode2|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   char_code(RChar2, RCode2),
   vowel(LChar1),
   consonant(RChar1),
   vowel(RChar2),
  (((LChar1 = a; LChar1 = ı), (RChar2 = a; RChar2 = ı));
   ((LChar1 = o; LChar1 = u), (RChar2 = a; RChar2 = u));
   ((LChar1 = e; LChar1 = i), (RChar2 = e; RChar2 = i));
   ((LChar1 = ö; LChar1 = ü), (RChar2 = e; RChar2 = ü))
   ).
 
vowel_vowel_harmony(LCodes, [RCode1, RCode2|_]):-
   reverse(LCodes, [LCode1, LCode2|_]),
   char_code(LChar1, LCode1),
   char_code(LChar2, LCode2),
   char_code(RChar1, RCode1),
   char_code(RChar2, RCode2),
   consonant(LChar1),
   vowel(LChar2),
   consonant(RChar1),
   vowel(RChar2),
  (((LChar2 = a; LChar2 = ı), (RChar2 = a; RChar2 = ı));
   ((LChar2 = o; LChar2 = u), (RChar2 = a; RChar2 = u));
   ((LChar2 = e; LChar2 = i), (RChar2 = e; RChar2 = i));
   ((LChar2 = ö; LChar2 = ü), (RChar2 = e; RChar2 = ü))
   ).
  
vowel_vowel_harmony(LCodes, [RCode1, RCode2|_]):-
   reverse(LCodes, [LCode1, LCode2, LCode3|_]),
   char_code(LChar1, LCode1),
   char_code(LChar2, LCode2),
   char_code(LChar3, LCode3),
   char_code(RChar1, RCode1),
   char_code(RChar2, RCode2),
   consonant(LChar1),
   consonant(LChar2),
   vowel(LChar3),
   consonant(RChar1),
   vowel(RChar2),
  (((LChar3 = a; LChar3 = ı), (RChar2 = a; RChar2 = ı));
   ((LChar3 = o; LChar3 = u), (RChar2 = a; RChar2 = u));
   ((LChar3 = e; LChar3 = i), (RChar2 = e; RChar2 = i));
   ((LChar3 = ö; LChar3 = ü), (RChar2 = e; RChar2 = ü))
   ).
   
vowel_vowel_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1, LCode2|_]),
   char_code(LChar1, LCode1),
   char_code(LChar2, LCode2),
   char_code(RChar1, RCode1),
   consonant(LChar1),
   vowel(LChar2),
   vowel(RChar1),
  (((LChar2 = a; LChar2 = ı), (RChar1 = a; RChar1 = ı));
   ((LChar2 = o; LChar2 = u), (RChar1 = a; RChar1 = u));
   ((LChar2 = e; LChar2 = i), (RChar1 = e; RChar1 = i));
   ((LChar2 = ö; LChar2 = ü), (RChar1 = e; RChar1 = ü))
   ).

consonant_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   ((not(consonant(LChar1)),!); not(consonant(RChar1))).
   
consonant_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   consonant(LChar1),
   consonant(RChar1),
  ((consonant_type1(LChar1), consonant_type1(RChar1));
   (consonant_type1(LChar1), consonant_type2(RChar1));
   (consonant_type2(LChar1), consonant_type3(RChar1));
   (consonant_type2(LChar1), consonant_type2(RChar1));
   (consonant_type3(LChar1), consonant_type2(RChar1));
   (consonant_type3(LChar1), consonant_type3(RChar1))
   ).
   
vowel_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   ((not(vowel(LChar1)),!); not(consonant(RChar1))).
   
vowel_consonant_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   vowel(LChar1),
   consonant(RChar1),
   not(RChar1 = t).
   
consonant_vowel_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   ((not(consonant(LChar1)),!); not(vowel(RChar1))).
   
consonant_vowel_harmony(LCodes, [RCode1|_]):-
   reverse(LCodes, [LCode1|_]),
   char_code(LChar1, LCode1),
   char_code(RChar1, RCode1),
   consonant(LChar1),
   vowel(RChar1),
   not(LChar1 = p),
   not(LChar1 = ç),
   not(LChar1 = t),
   not(LChar1 = k).


consonant_type1(ç).
consonant_type1(f).
consonant_type1(h).
consonant_type1(k).
consonant_type1(p).
consonant_type1(s).
consonant_type1(ş).
consonant_type1(t).

consonant_type2(l).
consonant_type2(m).
consonant_type2(n).
consonant_type2(r).
consonant_type2(y).

consonant_type3(b).
consonant_type3(c).
consonant_type3(d).
consonant_type3(g).
consonant_type3(ğ).
consonant_type3(j).
consonant_type3(v).
consonant_type3(z).
   

