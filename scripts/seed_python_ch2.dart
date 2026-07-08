// Run: dart run scripts/seed_python_ch2.dart
// Seeds Python Ch 2: Variables & Data Types (6 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 2...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_2', {
    'id': 'chapter_2',
    'subjectId': 'python',
    'name': 'Variables & Data Types',
    'order': 2,
    'totalTopics': 6,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_2_1', 'chapterId': 'chapter_2', 'name': 'Variables', 'order': 6},
    {'topicId': 'topic_2_2', 'chapterId': 'chapter_2', 'name': 'Data Types', 'order': 7},
    {'topicId': 'topic_2_3', 'chapterId': 'chapter_2', 'name': 'Identifiers & Rules', 'order': 8},
    {'topicId': 'topic_2_4', 'chapterId': 'chapter_2', 'name': 'Operators', 'order': 9},
    {'topicId': 'topic_2_5', 'chapterId': 'chapter_2', 'name': 'type() & Typecasting', 'order': 10},
    {'topicId': 'topic_2_6', 'chapterId': 'chapter_2', 'name': 'input() Function', 'order': 11},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic2_1(), topic2_2(), topic2_3(), topic2_4(), topic2_5(), topic2_6()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_2/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 2 seeded successfully.');
}

Map<String, dynamic> topic2_1() {
  return {
    'id': 'topic_2_1',
    'name': 'Variables',
    'chapterId': 'chapter_2',
    'subjectId': 'python',
    'order': 6,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=2095',
    'keyPoints': [
      'Variable ek container hai jisme hum data store karte hain — jaise kitchen mein box mein cheezein rakhte hain',
      'a = 1 ka matlab: "a" naam ke box mein value 1 store kar do',
      'Variable ka naam left side, value right side — assignment operator (=) dono ko jodta hai',
      'Variables ki values change ho sakti hain — isiliye variable (vary + able) kehte hain',
      'Python mein variable declare karne ke liye data type nahi batana padta — dynamic typing hai',
      'Multiple variables ek saath bana sakte hain: a = 1, b = 2, c = 7',
      'Variables ko print kar sakte hain aur unke saath operations bhi kar sakte hain: print(a + b)',
      'Variable names descriptive rakhne chahiye taake code readable ho',
    ],
    'keyConcepts': [
      'Variable (container for data)',
      'Assignment operator (=)',
      'Dynamic typing',
      'Variable naming',
      'Variable operations',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Python mein variables ke baare mein.

Variable ek container hai — ek box jisme hum apna data store karte hain. Jaise aap kitchen mein rakhte hain box mein masale, waise hi variable mein data store hota hai.

Jab hum likhte hain a = 1, toh iska matlab: "a" naam ke box mein value 1 daal do. Simple hai na?

a naam hai box ka, 1 hai value, aur = hai assignment operator jo box mein value daalta hai.

Aap ek se zyada variables bana sakte ho:
a = 1
b = 2
c = 7
name = "harry"

Ab agar hum likhein print(a + b), toh Python box a aur box b ki values nikaalega, 1 + 2 = 3 calculate karega, aur 3 print karega.

Variable ka matlab hai — vary + able. Yani jisme change aa sakta hai. Aap baad mein a = 5 bhi likh sakte ho — ab a ki value 5 ho jayegi.

Python ki speciality hai — aapko variable ka type nahi batana padta. Jaise C ya Java mein likhna padta hai "int a = 5", lekin Python mein bas "a = 5". Python khud samajh leta hai ki ye integer hai.

Is feature ko kehte hain dynamic typing. Python automatically detect karta hai ki aapne kaunsa data type store kiya.

Aur ek important baat — aap variables ke saath calculations bhi kar sakte ho. Jaise a + b, a * b, etc.

Yaad rakho: variable = box, = box mein value daalna, print = box ki value dikhana.

Bahut easy hai! Chalo ab data types dekhte hain.''',
    'codeExamples': [
      {
        'title': 'Basic Variable Assignment',
        'code': 'a = 1\nb = 2\nc = 7\nname = "harry"\nprint(a + b)',
        'explanation': 'Yahan humne 4 variables banaye: a (1), b (2), c (7), aur name ("harry"). print(a+b) ne 1+2 ka result 3 output kiya. Variable names left side, values right side.',
        'output': '3',
      },
      {
        'title': 'Variable Reassignment',
        'code': 'a = 1\nprint(a)\na = 5\nprint(a)',
        'explanation': 'Pehle a mein 1 store kiya, print kiya. Phir a ki value change karke 5 kar di, print kiya. Isiliye variable kehte hain — value change ho sakti hai.',
        'output': '1\n5',
      },
    ],
    'challenges': [
      {
        'question': 'Do variables banao: x = 10 aur y = 20. Phir unka sum, difference, aur product print karo.',
        'hint': 'x + y, x - y, x * y use karo. Har result ko alag print statement mein dikhao.',
        'solution': 'x = 10\ny = 20\nprint("Sum:", x + y)\nprint("Difference:", x - y)\nprint("Product:", x * y)',
        'difficulty': 'easy',
      },
      {
        'question': 'Do variables banao: a = 100 aur b = 70. Phir: (1) a aur b ka sum print karo, (2) a mein se b ghata kar print karo, (3) a ko 3 se multiply kar naye variable c mein store karo aur print karo, (4) a ki value mein 50 jod kar wapas a mein store karo aur print karo.',
        'hint': 'Pehle a = 100, b = 70. Phir print(a + b), print(a - b), c = a * 3, a = a + 50, print(c), print(a). Har operation ke baad print karte jaao.',
        'solution': 'a = 100\nb = 70\nprint(a + b)\nprint(a - b)\nc = a * 3\nprint(c)\na = a + 50\nprint(a)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jisme a = 5 ho. Phir step by step: (1) a mein 10 jod kar wapas a mein store karo, (2) a ko 3 se multiply karo, (3) a mein se 20 ghatao, (4) a ko 4 se divide karo. Har step ke baad a ki value print karo aur dekho final value kya aati hai.',
        'hint': 'a = 5 se shuru. Phir a = a + 10, print(a), a = a * 3, print(a), a = a - 20, print(a), a = a / 4, print(a).',
        'solution': 'a = 5\nprint(a)\na = a + 10\nprint(a)\na = a * 3\nprint(a)\na = a - 20\nprint(a)\na = a / 4\nprint(a)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'variable_name = value', 'example': 'a = 1', 'description': 'Variable mein value assign karta hai'},
      {'syntax': 'print(variable)', 'example': 'print(a)', 'description': 'Variable ki value console par display karta hai'},
      {'syntax': 'var1 = val1, var2 = val2', 'example': 'a = 1; b = 2', 'description': 'Multiple variables alag-alag assign karna'},
    ],
    'commonMistakes': [
      'Variable name left side aur value right side likhna bhoolna — "1 = a" galat hai, "a = 1" sahi',
      'Variable use karne se pehle define karna bhool jana — NameError aayega',
      'Variable name aur string mein confuse hona — a = 1 (number) vs a = "1" (string)',
    ],
  };
}

Map<String, dynamic> topic2_2() {
  return {
    'id': 'topic_2_2',
    'name': 'Data Types',
    'chapterId': 'chapter_2',
    'subjectId': 'python',
    'order': 7,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=2350',
    'keyPoints': [
      'Data type batata hai ki value kis tarah ki hai — number, text, True/False, ya kuch aur',
      'int: integer numbers — jaise 1, 2, 100, -5 (decimal ke bina)',
      'float: floating point numbers — jaise 5.22, 3.14, -0.5 (decimal ke saath)',
      'str: string — text ya characters double ya single quotes mein, jaise "Harry", "Hello"',
      'bool: boolean — sirf do values: True ya False (capital T aur F)',
      'None: khaali value — mtlb kuch nahi, null ki tarah',
      'Python automatically data type detect karta hai — aapko batane ki zaroorat nahi',
      'type() function se variable ka data type check kar sakte hain',
    ],
    'keyConcepts': [
      'int (integer numbers)',
      'float (decimal numbers)',
      'str (string / text)',
      'bool (True / False)',
      'None (empty value)',
    ],
    'aiCoachScript': '''Chalo ab data types ke baare mein samajhte hain.

Data type basically batata hai ki value kis tarah ki hai. Python main data types kuch is tarah hain:

INTEGER (int) — Pura number, jaise 1, 2, 100, -5. Decimal point nahi hota. Jaise a = 1 — ye int hai.

FLOAT (float) — Decimal wala number, jaise 5.22, 3.14. b = 5.22 — ye float hai.

STRING (str) — Text ya characters, double quotes ya single quotes mein. c = "Harry" — ye string hai. Quotes zaroori hain.

BOOLEAN (bool) — Sirf do values: True ya False. d = False — ye boolean hai. Note: Capital T aur F — Python case-sensitive hai, true likhoge toh error aayega.

NONE — Khaali value. Matlab kuch nahi. e = None — None ek special type hai. Null ki tarah.

Sabse important baat — Python automatically detect karta hai aapne kaunsa data type use kiya. Aapko batane ki zaroorat nahi. Iskehte hain dynamic typing.

Lekin aap type() function use karke check kar sakte ho ki variable kaunsa data type hai:
type(a) → <class 'int'>
type(b) → <class 'float'>

Har data type ke saath alag operations kaam karte hain. Jaise string ko + se concatenate kar sakte ho, numbers ko add kar sakte ho.

Yaad rakho: int = numbers, float = decimals, str = text, bool = True/False, None = kuch nahi.

Simple hai na? Chalo ab dekhte hain identifiers aur rules ke baare mein!''',
    'codeExamples': [
      {
        'title': 'All Five Data Types',
        'code': 'a = 1       # int\nb = 5.22    # float\nc = "Harry" # str\nd = False   # bool\ne = None    # None\n\nprint(a, b, c, d, e)',
        'explanation': 'Yahan humne Python ke 5 basic data types demonstrate kiye hain. Har variable mein alag type ki value store ki. Python ne automatically type detect kiya. Print sab kuch ek saath dikhata hai.',
        'output': '1 5.22 Harry False None',
      },
      {
        'title': 'Checking Types with type()',
        'code': 'a = 1\nb = 5.22\nc = "Harry"\n\nprint(type(a))\nprint(type(b))\nprint(type(c))',
        'explanation': 'type() function variable ka exact data type return karta hai. <class \'int\'> ka matlab ye integer hai. <class \'float\'> matlab float. <class \'str\'> matlab string.',
        'output': "<class 'int'>\n<class 'float'>\n<class 'str'>",
      },
    ],
    'challenges': [
      {
        'question': 'Har data type (int, float, str, bool, None) ka ek variable banao aur sabko ek saath print karo.',
        'hint': '5 variables banao: a = 10 (int), b = 2.5 (float), c = "Py" (str), d = True (bool), e = None. Phir print(a, b, c, d, e) se sab ek line mein print karo.',
        'solution': 'a = 10\nb = 2.5\nc = "Python"\nd = True\ne = None\nprint(a, b, c, d, e)',
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jo alag-alag types ke variables ko aapas mein combine kare — jaise int + float, str + str, int + str (dekho error aata hai ya nahi). Har case ka output batayo.',
        'hint': 'int + float = float (implicit conversion). str + str = concatenation. int + str = TypeError. Try karo aur dekho.',
        'solution': 'a = 5\nb = 2.5\nc = "Hello"\nd = " World"\nprint(a + b)    # 7.5\nprint(c + d)    # Hello World\n# print(a + c)  # TypeError',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jisme aap kisi variable ka type multiple times change karo (int → float → string → bool). Har change ke baad variable ki value print karo.',
        'hint': 'Variable ek baar mein ek type rakhta hai. Aap use dobara assign kar sakte ho nayi type ki value. Jaise x = 10 → x = 10.5 → x = "text" → x = True',
        'solution': 'x = 10\nprint(x)\nx = 10.5\nprint(x)\nx = "Hello"\nprint(x)\nx = True\nprint(x)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'variable = value', 'example': 'a = 1', 'description': 'Variable declare karta hai — type automatically detect hota hai'},
      {'syntax': 'type(variable)', 'example': 'type(a)', 'description': 'Variable ka data type return karta hai'},
      {'syntax': '"text" or \'text\'', 'example': 'name = "Harry"', 'description': 'String double ya single quotes mein likhi jaati hai'},
      {'syntax': 'True / False', 'example': 'is_ready = True', 'description': 'Boolean values — capital T aur F ke saath'},
    ],
    'commonMistakes': [
      'Boolean mein true/false small letters mein likhna — Python error dega, capital T/F zaroori hai',
      'String mein quotes bhoolna — Python variable samajh leta hai aur NameError aata hai',
      'None ko "None" string ki tarah likhna — None bina quotes ke, "None" quotes ke saath string hai',
    ],
  };
}

Map<String, dynamic> topic2_3() {
  return {
    'id': 'topic_2_3',
    'name': 'Identifiers & Rules',
    'chapterId': 'chapter_2',
    'subjectId': 'python',
    'order': 8,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=2483',
    'keyPoints': [
      'Identifier variable ya function ka naam hota hai — jaise a, aaa, harry, sameer sab identifiers hain',
      'Identifier mein alphabets (a-z, A-Z), digits (0-9), aur underscore (_) allow hai',
      'Identifier digit se start nahi ho sakta — "1variable" invalid hai',
      'Identifier letter ya underscore se start ho sakta hai — "_samerr" valid hai',
      'Identifier mein spaces nahi ho sakte — "my var" invalid hai',
      r'Special characters (@, #, $, %, etc.) allowed nahi hain — "@sameer" invalid hai',
      'Python keywords (like if, else, for, while) ko identifier ke roop mein use nahi kar sakte',
      'Case-sensitive hai — "Harry" aur "harry" alag-alag identifiers hain',
    ],
    'keyConcepts': [
      'Identifier naming rules',
      'Allowed characters (letters, digits, underscore)',
      'Cannot start with digit',
      'No special characters or spaces',
      'Case sensitivity',
    ],
    'aiCoachScript': '''Ab baat karte hain identifiers aur unke rules ki.

Identifier kya hai? Variable ka naam. Jaise a, aaa, harry, sameer — ye sab identifiers hain.

Python mein identifiers ke kuch rules hain. Agar aap rules follow nahi karoge toh error aayega. Chalo dekhte hain:

RULE 1: Alphabets, digits aur underscore allowed hain.
a = 23 — valid
aaa = 435 — valid
harry = 34 — valid
_samerr = 34 — valid (underscore se start ho sakta hai)

RULE 2: Digit se start nahi ho sakta.
1variable = 10 — INVALID. Python error dega.
Variable1 = 10 — VALID. Digit last mein aa sakta hai.

RULE 3: Spaces nahi ho sakte.
my var = 10 — INVALID. Space nahi daal sakte.
my_var = 10 — VALID. Underscore use karo.

RULE 4: Special characters allowed nahi hain.
@sameer = 56 — INVALID. @ symbol allowed nahi.
sameer\$ = 56 — INVALID. \$ bhi allowed nahi.

RULE 5: Keywords reserved hain.
if, else, for, while, import, etc. — ye Python ke keywords hain. Inhe variable name nahi bana sakte.

RULE 6: Case-sensitive.
Harry aur harry — dono alag hain. Capital H vs small h.

Toh yaad rakho: Letters, digits, underscore — bas yahi teen cheezein allowed hain. Aur digit se start nahi karna. Simple rules hain — follow karo aur error se bacho!''',
    'codeExamples': [
      {
        'title': 'Valid Variable Names',
        'code': 'a = 23\naaa = 435\nharry = 34\nsameer = 45\n_samerr = 34\nprint(a, aaa, harry, sameer, _samerr)',
        'explanation': 'Yeh saare valid identifiers hain. a, aaa, harry, sameer letters se start hote hain. _samerr underscore se start hota hai — ye bhi valid hai. Python ne sab print kar diya.',
        'output': '23 435 34 45 34',
      },
      {
        'title': 'Invalid Variable Names (commented out)',
        'code': '# @sameer = 56  # Invalid - @ symbol not allowed\n# s@meer = 45   # Invalid - @ symbol not allowed\n# 1var = 10     # Invalid - starts with digit\n# my var = 20   # Invalid - space not allowed',
        'explanation': 'Yeh saari lines commented hain kyunki ye error denge. @ symbol allowed nahi, digit se start allowed nahi, space allowed nahi. Agar inhe comment na karein toh SyntaxError aayega.',
        'output': '(Error if uncommented)',
      },
    ],
    'challenges': [
      {
        'question': '5 valid variable names banao jo alag-alag rules follow karein — ek underscore se shuru ho, ek letter se, ek number end mein ho, ek camelCase ho, ek snake_case ho.',
        'hint': 'Examples: _temp = 10, name = 20, var1 = 30, myName = 40, my_name = 50',
        'solution': '_temp = 10\nname2 = 20\nvar1 = 30\nmyName = "Harry"\nmy_name = "Sameer"\nprint(_temp, name2, var1, myName, my_name)',
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jisme intentionally 3 invalid variable names use karo, unhe comment mein likho, aur har ek ke saath likho ki woh kyun invalid hai.',
        'hint': '@ se shuru, digit se shuru, space ke saath — ye teen common invalid cases hain. Har ek ko # Invalid karena reason ke saath comment karo.',
        'solution': '# @data = 10  # Invalid: @ special character allowed nahi\n# 2nd_name = "John"  # Invalid: digit se shuru nahi ho sakta\n# my age = 25  # Invalid: space allowed nahi\n\n# Valid variables:\n_data = 10\nsecond_name = "John"\nmy_age = 25\nprint(_data, second_name, my_age)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo case sensitivity aur underscore ke role ko demonstrate kare. 6 variables banao: name = 1, Name = 2, NAME = 3, _name = 4, name_ = 5, _name_ = 6. Sabko print karo aur dekho ki ye sab alag identifiers hain.',
        'hint': 'Python case-sensitive hai — "name", "Name", "NAME" teeno alag hain. _name aur name_ bhi alag hain. Total 6 different variables.',
        'solution': 'name = 1\nName = 2\nNAME = 3\n_name = 4\nname_ = 5\n_name_ = 6\nprint(name, Name, NAME, _name, name_, _name_)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'valid_identifier = value', 'example': '_myVar1 = 10', 'description': 'Identifier letter ya underscore se start, usme letters/digits/underscore ho sakte hain'},
      {'syntax': 'Keywords are reserved', 'example': '# if = 10  # Invalid', 'description': 'Python keywords (if, else, for, etc.) ko variable name nahi bana sakte'},
      {'syntax': 'Case-sensitive', 'example': 'Name = "Harry"; name = "harry"', 'description': 'Name aur name alag identifiers hain — case matters'},
    ],
    'commonMistakes': [
      'Variable name digit se shuru karna — "1var" likhna aur error aana',
      'Variable name mein space ya special character daalna — "my var" ya "@data"',
      'Python keyword (jaise if, else, for) ko variable name banana',
    ],
  };
}

Map<String, dynamic> topic2_4() {
  return {
    'id': 'topic_2_4',
    'name': 'Operators',
    'chapterId': 'chapter_2',
    'subjectId': 'python',
    'order': 9,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=2610',
    'keyPoints': [
      'Operators woh symbols hain jo values ke saath operations perform karte hain — jaise +, -, *, /',
      'Arithmetic operators: + (addition), - (subtraction), * (multiplication), / (division), // (floor division), % (modulus), ** (exponent)',
      'Assignment operators: = (assign), += (add then assign), -= (subtract then assign) — jaise b += 3 matlab b = b + 3',
      'Comparison operators: == (equal to), != (not equal), < (less than), > (greater than) — result True ya False',
      'Logical operators: and (dono True toh True), or (ek bhi True toh True), not (ulta kar deta hai)',
      'and: True and False → False, True and True → True',
      'or: True or False → True, False or False → False',
      'not: not(True) → False, not(False) → True',
    ],
    'keyConcepts': [
      'Arithmetic operators (+, -, *, /, //, %, **)',
      'Assignment operators (=, +=, -=)',
      'Comparison operators (==, !=, <, >)',
      'Logical operators (and, or, not)',
      'Truth tables',
    ],
    'aiCoachScript': '''Chalo ab operators ke baare mein samajhte hain. Operators woh symbols hain jo values ke saath kaam karte hain.

ARITHMETIC OPERATORS — Maths waale operators:
+ (addition) — 7 + 4 = 11
- (subtraction) — 7 - 4 = 3
* (multiplication) — 7 * 4 = 28
/ (division) — 7 / 4 = 1.75
// (floor division) — 7 // 4 = 1 (decimal ignore karo)
% (modulus) — 7 % 4 = 3 (remainder)
** (exponent) — 2 ** 3 = 8 (2^3)

ASSIGNMENT OPERATORS:
= — a = 7 (a mein 7 daalo)
+= — b += 3 matlab b = b + 3 (purani value mein 3 jodo)
-= — b -= 3 matlab b = b - 3 (purani value mein se 3 ghatao)

COMPARISON OPERATORS — True ya False return karte hain:
== — equal to? 5 == 5 → True
!= — not equal? 5 != 3 → True
< — less than? 3 < 5 → True
> — greater than? 5 > 3 → True

LOGICAL OPERATORS — Multiple conditions combine karne ke liye:
and — dono True tabhi True. True and False = False.
or — ek bhi True toh True. True or False = True.
not — True ko False, False ko True. not(True) = False.

Truth table yaad rakho:
and: T+T=T, T+F=F, F+T=F, F+F=F
or: T+T=T, T+F=T, F+T=T, F+F=F
not: not T = F, not F = T

Bahut saare types hain operators ke, but itna basics enough hai abhi ke liye. Aage chalke aur dekhenge!''',
    'codeExamples': [
      {
        'title': 'Arithmetic & Assignment Operators',
        'code': 'a = 7\nb = 4\nc = a + b\nprint(c)\n\na = 4 - 2\nprint(a)\n\nb = 6\nb -= 3\nprint(b)',
        'explanation': 'Pehle a=7, b=4, c = a + b = 11. Phir a = 4-2 = 2. Phir b=6, b -= 3 (b = 6 - 3) = 3. Assignment operators value ko modify karte hain.',
        'output': '11\n2\n3',
      },
      {
        'title': 'Logical Operators Truth Table',
        'code': 'print("True or False is", True or False)\nprint("True or True is", True or True)\nprint("True and False is", True and False)\nprint("True and True is", True and True)\nprint(not(True))',
        'explanation': 'Logical operators ke truth tables dikhaye hain. or: ek True toh True. and: dono True toh True. not: True ko False karta hai.',
        'output': 'True or False is True\nTrue or True is True\nTrue and False is False\nTrue and True is True\nFalse',
      },
    ],
    'challenges': [
      {
        'question': 'Do numbers lo (jaise 15 aur 4) aur unke saath saare arithmetic operators (+, -, *, /, //, %, **) try karo. Har result print karo.',
        'hint': 'a=15, b=4. Har operator ke liye alag print statement. Dekho // aur % ka difference.',
        'solution': 'a = 15\nb = 4\nprint("a + b =", a + b)\nprint("a - b =", a - b)\nprint("a * b =", a * b)\nprint("a / b =", a / b)\nprint("a // b =", a // b)\nprint("a % b =", a % b)\nprint("a ** b =", a ** b)',
        'difficulty': 'easy',
      },
      {
        'question': 'Do numbers lo: a = 27 aur b = 5. Inke saath (1) a // b (floor division), (2) a % b (modulus), (3) a ** b (exponent), (4) a > b (comparison), (5) (a > 10) and (b < 10) (logical) check karo. Har result print karo.',
        'hint': 'Saare operators ke results alag variables mein store karo ya direct print karo. Dekho // aur % ka difference, ** ka matlab power, comparison True/False return karta hai.',
        'solution': 'a = 27\nb = 5\nprint("a // b =", a // b)\nprint("a % b =", a % b)\nprint("a ** b =", a ** b)\nprint("a > b =", a > b)\nprint("(a > 10) and (b < 10) =", (a > 10) and (b < 10))',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo teen numbers a = 15, b = 8, c = 22 ke saath multiple operators ko combine kare. Evaluate karo: (1) a + b * c, (2) (a + b) * c, (3) a > b and a < c or b < c, (4) a ** 2 > b * c, (5) a % b + c // a. Har expression ka result print karo.',
        'hint': 'Operator precedence yaad rakho: ** pehle, phir *, /, //, %, phir +, -, phir comparison, phir logical. (a + b) * c mein parentheses pehle evaluate hoga.',
        'solution': 'a = 15\nb = 8\nc = 22\nprint("a + b * c =", a + b * c)\nprint("(a + b) * c =", (a + b) * c)\nprint("a > b and a < c or b < c =", a > b and a < c or b < c)\nprint("a ** 2 > b * c =", a ** 2 > b * c)\nprint("a % b + c // a =", a % b + c // a)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'arithmetic: +, -, *, /, //, %, **', 'example': '7 % 4 = 3', 'description': 'Arithmetic operations — // floor division, % remainder, ** exponent'},
      {'syntax': 'assignment: =, +=, -=', 'example': 'b += 3', 'description': 'Shortcut assignment — b += 3 means b = b + 3'},
      {'syntax': 'comparison: ==, !=, <, >', 'example': '5 == 5', 'description': 'Comparison — result hamesha True ya False'},
      {'syntax': 'logical: and, or, not', 'example': 'True or False', 'description': 'Logical operators — conditions combine karne ke liye'},
    ],
    'commonMistakes': [
      'Assignment (=) aur comparison (==) mein confuse hona — = assign karta hai, == compare karta hai',
      'Logical operators ke saath truth table bhoolna — and mein dono True chahiye, or mein ek bhi kaafi',
      'Floor division // aur normal division / ka difference na samajhna — / decimal deta hai, // integer deta hai',
    ],
  };
}

Map<String, dynamic> topic2_5() {
  return {
    'id': 'topic_2_5',
    'name': 'type() & Typecasting',
    'chapterId': 'chapter_2',
    'subjectId': 'python',
    'order': 10,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=2830',
    'keyPoints': [
      'type() function variable ya value ka data type batata hai — jaise type(5) → <class \'int\'>',
      'Typecasting means ek data type se dusre data type mein convert karna',
      'int() se string ya float ko integer mein convert kar sakte hain — int("31") → 31',
      'float() se string ya integer ko float mein convert kar sakte hain — float("31.2") → 31.2',
      'str() se number ya kisi bhi value ko string mein convert kar sakte hain — str(123) → "123"',
      'bool() se values ko True/False mein convert kar sakte hain',
      'Incorrect typecasting se error aata hai — jaise int("hello") → ValueError',
      'Implicit conversion bhi hoti hai — Python khud kar leta hai, jaise int + float = float',
    ],
    'keyConcepts': [
      'type() function',
      'Typecasting (type conversion)',
      'int() conversion',
      'float() conversion',
      'str() conversion',
    ],
    'aiCoachScript': '''Chalo ab seekhte hain type() function aur typecasting ke baare mein.

Kabhi aapne socha ki kaise pata karein ki variable mein kaunsa data type hai? Iske liye use karte hain type() function.

a = "31.2"
print(type(a)) → <class 'str'> — Matlab ye string hai.

Ab maan lo hume is string ko float mein convert karna hai. Kyonki "31.2" ko hum mathematics mein use nahi kar sakte. Iske liye typecasting use karte hain.

b = float(a)
print(type(b)) → <class 'float'> — Ab ye float ban gaya!

Typecasting ka matlab hai ek type se dusre type mein jaana.

Common type conversions:
int() — kisiko integer banao. int("5") → 5. int(5.7) → 5 (decimal cut ho jata hai)
float() — kisiko float banao. float("31.2") → 31.2. float(5) → 5.0
str() — kisiko string banao. str(123) → "123". str(True) → "True"

Important: Sab conversion possible nahi hai. Agar aap likhoge int("hello"), toh Python error dega — ValueError. Kyonki "hello" number mein convert nahi ho sakta.

Implicit conversion bhi hoti hai — Python automatically. Jaise agar aap int + float karte ho, toh Python int ko float mein convert karke result float deta hai.

Typecasting bahut useful hai especially jab user se input lete ho — kyonki input() hamesha string return karta hai.

Yaad rakho: type() → pucho, int/float/str → badlo, aur careful raho ki galat conversion na karne do!''',
    'codeExamples': [
      {
        'title': 'type() Function & Typecasting',
        'code': 'a = "31.2"\nb = float(a)\nt = type(b)\nprint(t)',
        'explanation': 'a ek string hai "31.2". float() se humne use float mein convert kiya — b = 31.2. Phir type(b) se check kiya — <class \'float\'>. t variable mein type store kar ke print kiya.',
        'output': "<class 'float'>",
      },
      {
        'title': 'Multiple Type Conversions',
        'code': 'a = "31.2"\nb = float(a)\nc = int(b)\nd = str(c)\nprint(a, type(a))\nprint(b, type(b))\nprint(c, type(c))\nprint(d, type(d))',
        'explanation': 'String "31.2" → float 31.2 → int 31 (decimal hat gaya) → string "31". Har step par type change hota hai. int(31.2) ne decimal part 0.2 ko discard kar diya.',
        'output': "31.2 <class 'str'>\n31.2 <class 'float'>\n31 <class 'int'>\n31 <class 'str'>",
      },
    ],
    'challenges': [
      {
        'question': 'Ek variable banao x = "100" (string). Isse pehle integer mein convert karo, phir float mein, phir wapas string mein. Har step par type print karo.',
        'hint': 'x = "100". Phir y = int(x), z = float(y), w = str(z). Har conversion ke baad print(type(variable)) karo.',
        'solution': 'x = "100"\nprint(x, type(x))\ny = int(x)\nprint(y, type(y))\nz = float(y)\nprint(z, type(z))\nw = str(z)\nprint(w, type(w))',
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jisme a = "123.45" (string) ho. Isse pehle float mein convert karo, phir integer mein, phir wapas string mein. Har step par type() se check karo aur print karo. Note karo ki decimal part kya hota hai jab float se int karte hain.',
        'hint': 'a = "123.45". Phir b = float(a), c = int(b), d = str(c). Har step par print(variable) aur print(type(variable)) karo. float se int karte waqt decimal part lose hota hai.',
        'solution': 'a = "123.45"\nprint(a, type(a))\nb = float(a)\nprint(b, type(b))\nc = int(b)\nprint(c, type(c))\nd = str(c)\nprint(d, type(d))',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo demonstrate kare ki kaunsa conversion possible hai aur kaunsa nahi. 4 conversions karo: str(123), float("45.5"), int(3.99), aur int("hello") (error dega — isko comment mein likho). Successful conversions ke results aur types print karo.',
        'hint': 'int("hello") se ValueError aayega kyunki "hello" number nahi hai. Isko comment kar do (#). Baaki sab successful hain — har conversion ke baad print(value) aur print(type(value)) karo.',
        'solution': 'a = str(123)\nprint(a, type(a))\nb = float("45.5")\nprint(b, type(b))\nc = int(3.99)\nprint(c, type(c))\n# d = int("hello")  # ValueError - "hello" integer nahi hai',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'type(value)', 'example': 'type(5)', 'description': 'Value ka data type return karta hai'},
      {'syntax': 'int(value)', 'example': 'int("31")', 'description': 'Value ko integer mein convert karta hai'},
      {'syntax': 'float(value)', 'example': 'float("31.2")', 'description': 'Value ko float mein convert karta hai'},
      {'syntax': 'str(value)', 'example': 'str(123)', 'description': 'Value ko string mein convert karta hai'},
    ],
    'commonMistakes': [
      'String ko int mein convert karna jo number nahi hai — int("hello") se ValueError aayega',
      'float ko int mein convert karte waqt decimal part lose hona — int(5.9) → 5, 0.9 khatam',
      'input() ka result hamesha string hota hai — bhool kar usse direct number ki tarah use karna',
    ],
  };
}

Map<String, dynamic> topic2_6() {
  return {
    'id': 'topic_2_6',
    'name': 'input() Function',
    'chapterId': 'chapter_2',
    'subjectId': 'python',
    'order': 11,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=3000',
    'keyPoints': [
      'input() function user se input lene ke liye use hota hai — program ko interactive banata hai',
      'input() hamesha string return karta hai — chahe user number type kare ya kuch aur',
      'input() ke andar ek optional prompt message de sakte hain jo user ko dikhega',
      'Numbers ke saath kaam karne ke liye typecasting zaroori hai — int(input()) ya float(input())',
      'input() tab tak wait karta hai jab tak user kuch type karke Enter na press kare',
      'Multiple inputs le sakte hain — jaise do numbers ka sum nikalne ke liye do baar input() call karo',
      'input() ka result directly print bhi kar sakte ho: print(input("Kuch likho: "))',
      'Python 3 mein input() — Python 2 mein raw_input() hota tha, par hum Python 3 use kar rahe hain',
    ],
    'keyConcepts': [
      'input() function',
      'Prompt message',
      'User input as string',
      'Typecasting input',
      'Interactive programs',
    ],
    'aiCoachScript': '''Chalo ab dekhte hain input() function ko — yeh user se input leta hai.

Jab tak aap input() use nahi karte, aapka program hamesha wahi output deta hai jo aapne code mein likha. Lekin input() use karke aap program ko interactive bana sakte ho — user kuch type karega, program uske according respond karega.

Example:
a = input("Enter number 1: ")
Jab ye line run hogi, screen par dikhega "Enter number 1: " aur program wait karega. User type karega, Enter dabayega, aur jo type kiya woh a variable mein store ho jayega.

Lekin yaad rakho — input() hamesha STRING return karta hai. Chahe user "5" type kare, woh string "5" hogi, number 5 nahi.

Isliye agar aap numbers ke saath kaam karna chahte ho, toh typecasting karna padega:
a = int(input("Enter number 1: "))
b = int(input("Enter number 2: "))
print(a + b)

Ab agar user 5 aur 6 dalega, toh 11 print hoga. Kyunki humne int() se string ko number mein badal diya.

Yeh Python 3 ka input() hai. Python 2 mein raw_input() hota tha — but hum Python 3 use kar rahe hain toh bas input() yaad rakho.

Input lena seekh gaye? Bahut accha! Ab aap interactive programs likh sakte ho. User se pucho, answer lo, uske according kaam karo.

Yaad rakho: input() = user se baat karo, int()/float() = number mein badlo, print() = jawab do!''',
    'codeExamples': [
      {
        'title': 'Simple Input & Sum',
        'code': 'a = int(input("Enter number 1: "))\nb = int(input("Enter number 2: "))\nprint("Number a is:", a)\nprint("Number b is:", b)\nprint("Sum is:", a + b)',
        'explanation': 'input() user se prompt dikhata hai aur input leta hai. int() us string ko number mein convert karta hai. Phir a aur b add karke sum print kiya. Agar int() na lagate toh string concatenation hoti ("5" + "6" = "56").',
        'output': 'Enter number 1: 5\nEnter number 2: 6\nNumber a is: 5\nNumber b is: 6\nSum is: 11',
      },
      {
        'title': 'Input Without Typecasting',
        'code': 'a = input("Enter number: ")\nprint(type(a))',
        'explanation': 'Bina int() ke input() ka result hamesha string hota hai. Type check karne par <class \'str\'> milega. Agar aap a + 5 karte toh TypeError aata kyunki string aur number add nahi ho sakte.',
        'output': "Enter number: 10\n<class 'str'>",
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo user se do numbers input le aur unka sum print kare.',
        'hint': 'int(input()) use karo dono numbers ke liye. Phir a + b print karo.',
        'solution': 'a = int(input("Enter number 1: "))\nb = int(input("Enter number 2: "))\nprint("Sum is", a + b)',
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jo user se 3 numbers input le aur unka average print kare. Typecasting ka dhyaan rakho.',
        'hint': 'Teeno numbers int(input()) se lo. Average = (a + b + c) / 3. Output float aayega.',
        'solution': 'a = int(input("Enter number 1: "))\nb = int(input("Enter number 2: "))\nc = int(input("Enter number 3: "))\navg = (a + b + c) / 3\nprint("Average is", avg)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo user se ek number input le aur uska square do alag tarike se nikaale: a**2 aur a*a. Dono results print karo. Note karo ki a^2 kaam kyun nahi karta.',
        'hint': 'a**2 exponent operator hai. a*a multiplication hai. a^2 bitwise XOR operator hai — ye square nahi deta.',
        'solution': 'a = int(input("Enter your number: "))\nprint("Square using **:", a**2)\nprint("Square using a*a:", a*a)\n# print("Square using a^2:", a^2)  # Incorrect! ^ is XOR, not power',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'input(prompt)', 'example': 'input("Enter name: ")', 'description': 'User se input leta hai — hamesha string return karta hai'},
      {'syntax': 'int(input())', 'example': 'int(input("Enter age: "))', 'description': 'Input ko directly integer mein convert karta hai'},
      {'syntax': 'float(input())', 'example': 'float(input("Enter price: "))', 'description': 'Input ko directly float mein convert karta hai'},
    ],
    'commonMistakes': [
      'input() ka result number hai assume karna — jabki woh string hota hai, typecasting bhoolna',
      'int(input()) mein agar user number ke alawa kuch type kare toh ValueError aayega',
      'Prompt message dena bhoolna — user confuse ho jata hai ki kya type kare',
    ],
  };
}

Future<void> patchDoc(String path, Map<String, dynamic> data) async {
  final url = '$baseUrl/$path?key=$apiKey';
  final fields = <String, dynamic>{};
  data.forEach((k, v) => fields[k] = _encode(v));
  final body = jsonEncode({'fields': fields});
  try {
    final client = HttpClient();
    final req = await client.patchUrl(Uri.parse(url));
    req.headers.contentType = ContentType.json;
    req.write(body);
    final resp = await req.close();
    await resp.transform(utf8.decoder).join();
    print('  OK: $path');
  } catch (e) {
    print('  ERR: $path: $e');
  }
}

dynamic _encode(dynamic v) {
  if (v is String) return {'stringValue': v};
  if (v is int) return {'integerValue': v.toString()};
  if (v is bool) return {'booleanValue': v};
  if (v is List) return {'arrayValue': {'values': v.map(_encode).toList()}};
  if (v is Map) {
    return {
      'mapValue': {
        'fields': v.map((k, v) => MapEntry(k.toString(), _encode(v)))
      }
    };
  }
  return {'nullValue': null};
}
