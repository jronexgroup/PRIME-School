// Run: dart run scripts/seed_python_ch6.dart
// Seeds Python Ch 6: Conditional Expressions (2 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 6...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_6', {
    'id': 'chapter_6',
    'subjectId': 'python',
    'name': 'Conditional Expressions',
    'order': 6,
    'totalTopics': 2,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_6_1', 'chapterId': 'chapter_6', 'name': 'if/else/elif', 'order': 24},
    {'topicId': 'topic_6_2', 'chapterId': 'chapter_6', 'name': 'Relational & Logical Operators', 'order': 25},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic6_1(), topic6_2()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_6/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 6 seeded successfully.');
}

Map<String, dynamic> topic6_1() {
  return {
    'id': 'topic_6_1',
    'name': 'if/else/elif',
    'chapterId': 'chapter_6',
    'subjectId': 'python',
    'order': 24,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=11410',
    'keyPoints': [
      'if statement ek condition check karta hai — agar True hai toh andar ka code execute hota hai',
      'if ke baad colon (:) lagana zaroori hai aur next line mein indentation (4 spaces)',
      'elif doosri condition check karta hai jab pehli if false ho — aap jitne chahe elif laga sakte ho',
      'else tab execute hota hai jab saari conditions false hain — koi condition nahi dete',
      'Indentation Python mein blocks define karti hai — curly braces nahi hote',
      'if-elif-else ladder mein ek baar koi condition true hui toh baaki skip ho jaate hain',
      'Multiple independent if statements alag-alag hote hain — har ek apni condition check karta hai chahe pehla true ho ya false',
    ],
    'keyConcepts': [
      'if statement',
      'elif statement',
      'else statement',
      'Indentation (4 spaces)',
      'if-elif-else ladder',
      'Multiple independent ifs',
    ],
    'aiCoachScript': '''Chalo aaj seekhte hain conditional expressions — if, else, elif.

Ye woh cheezein hain jisse Python decide karta hai ki kya karna hai based on conditions. Jaise real life mein — agar barish ho rahi hai toh chhatri le kar chalo, nahi toh bina chhatri ke chalo.

If statement ka structure dekhte hain:

if condition:
    # code execute hoga agar condition True hai

Dhyan do — if ke baad colon aur agle line mein indentation (4 spaces). Yeh Python ka tareeka hai block define karne ka.

Else tab chalta hai jab if ki condition false ho:
if age >= 18:
    print("You can vote")
else:
    print("You cannot vote")

Elif doosri conditions check karne ke liye — elif matlab "else if":
if age < 13:
    print("Child")
elif age < 20:
    print("Teenager")
else:
    print("Adult")

Yeh if-elif-else ladder hai. Ek baar koi condition true hui toh baaki skip ho jaate hain.

Aur multiple independent if statements — yeh alag hote hain. Har ek apni condition check karta hai, chahe pehle waala true ho ya false:
if condition1:
    do_something()
if condition2:
    do_something_else()

Yeh dono alag-alag check honge. Dono true ho sakte hain ek saath.

Yaad rakho: if, elif, else — teeno ke baad colon lagana mat bhoolna! Aur indentation sahi rakho — 4 spaces ka standard hai.''',
    'codeExamples': [
      {
        'title': 'Age Consent Check',
        'code': "a = int(input(\"Enter your age: \"))\n\nif a >= 18:\n    print(\"You are eligible to vote\")\nelse:\n    print(\"You are not eligible to vote\")",
        'explanation': 'Yahan if check karta hai ki age 18 ya usse zyada hai ya nahi. Agar True hai toh eligible wala print hoga. Agar False hai toh else block execute hoga.',
        'output': 'Enter your age: 20\nYou are eligible to vote',
      },
      {
        'title': 'if-elif-else Ladder',
        'code': "marks = int(input(\"Enter marks: \"))\n\nif marks >= 90:\n    print(\"Grade A\")\nelif marks >= 75:\n    print(\"Grade B\")\nelif marks >= 60:\n    print(\"Grade C\")\nelse:\n    print(\"Grade D\")",
        'explanation': 'Ek baar koi condition true hui toh baaki elif-else skip ho jaate hain. Agar marks 85 hai toh Grade B milega — Grade C aur D check nahi honge.',
        'output': 'Enter marks: 85\nGrade B',
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo user ki age input le aur check kare ki woh vote kar sakta hai ya nahi (age >= 18).',
        'hint': 'input() se age lo, int() mein convert karo, phir if-else use karo.',
        'solution': "age = int(input(\"Enter your age: \"))\nif age >= 18:\n    print(\"Yes, you can vote!\")\nelse:\n    print(\"No, you are too young to vote.\")",
        'difficulty': 'easy',
      },
      {
        'question': '4 numbers input lo aur unmein se sabse bada number print karo using if-elif-else ladder.',
        'hint': 'Pehle do numbers compare karo, phir result ko teesre se, phir chauthi se. Nested if bhi use kar sakte ho.',
        'solution': "a = int(input())\nb = int(input())\nc = int(input())\nd = int(input())\n\nif a > b and a > c and a > d:\n    print(\"Greatest:\", a)\nelif b > c and b > d:\n    print(\"Greatest:\", b)\nelif c > d:\n    print(\"Greatest:\", c)\nelse:\n    print(\"Greatest:\", d)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo user ke marks input le. Agar marks >= 90 ho toh "Excellent", >= 75 ho toh "Good", >= 50 ho toh "Average", warna "Fail" print karo.',
        'hint': 'if-elif-else ladder use karo. Conditions descending order mein likho — pehle highest condition.',
        'solution': "marks = int(input(\"Enter marks: \"))\nif marks >= 90:\n    print(\"Excellent\")\nelif marks >= 75:\n    print(\"Good\")\nelif marks >= 50:\n    print(\"Average\")\nelse:\n    print(\"Fail\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'if condition:', 'example': 'if a > 10:', 'description': 'Condition True hone par block execute karta hai'},
      {'syntax': 'elif condition:', 'example': 'elif a > 5:', 'description': 'Extra condition check karta hai (else if)'},
      {'syntax': 'else:', 'example': 'else:', 'description': 'Koi condition true na ho toh execute hota hai'},
      {'syntax': 'if condition: if condition2:', 'example': 'if a > 0: if a % 2 == 0:', 'description': 'Nested if — andar if ke andar if'},
    ],
    'commonMistakes': [
      'Colon bhool jana if, elif, else ke baad — SyntaxError',
      'Indentation galat karna — Python block recognize nahi karega',
      'Galat comparison operator — = (assignment) ki jagah == (comparison) use karna',
      'elif ki jagah else if likh dena — Python mein elif hota hai, else if nahi',
    ],
  };
}

Map<String, dynamic> topic6_2() {
  return {
    'id': 'topic_6_2',
    'name': 'Relational & Logical Operators',
    'chapterId': 'chapter_6',
    'subjectId': 'python',
    'order': 25,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=11490',
    'keyPoints': [
      'Relational operators compare karte hain do values ko aur True/False return karte hain',
      '== (equal), != (not equal), > (greater), < (less), >= (greater equal), <= (less equal)',
      '= assignment operator hai, == comparison operator — dono alag hain, yaad rakho!',
      'Logical operators: and, or, not — teen logical operators hote hain',
      'and — dono conditions True honi chahiye tabhi True hota hai',
      'or — koi ek condition True ho toh True hota hai',
      'not — True ko False aur False ko True kar deta hai (ultaa kar deta hai)',
      'Logical operators multiple conditions ko combine karne ke liye use hote hain',
    ],
    'keyConcepts': [
      'Relational operators (==, !=, >, <, >=, <=)',
      '= vs == difference',
      'Logical operators (and, or, not)',
      'Combining conditions',
      'Boolean logic',
    ],
    'aiCoachScript': '''Ab hum baat karenge relational aur logical operators ki. Yeh woh tools hain jo conditions banane mein help karte hain.

Relational operators — yeh do values compare karte hain:
- == equal to (equals equals — yaad rakho, = assignment hai, == comparison)
- != not equal to
- > greater than
- < less than
- >= greater than or equal
- <= less than or equal

Yeh sab True ya False return karte hain — boolean values.

Ab logical operators — yeh multiple conditions ko combine karte hain:

1. AND — dono conditions True honi chahiye:
if age >= 18 and has_id == True:
    print("You can enter")

2. OR — koi ek condition True ho toh kaafi hai:
if is_weekend or is_holiday:
    print("No school today!")

3. NOT — condition ko ultaa kar deta hai:
if not is_raining:
    print("Let's go outside!")

Real life example:
if age >= 18 and age <= 60:
    print("You are working age")

Yeh condition sirf tab True hogi jab age 18 se zyada ya barabar ho aur 60 se kam ya barabar ho.

Yaad rakho: Relational operators compare karte hain, logical operators combine karte hain. Dono milkar powerful conditions banate hain!''',
    'codeExamples': [
      {
        'title': 'Relational Operators',
        'code': "a = 15\nb = 10\n\nprint(a == b)  # False\nprint(a != b)  # True\nprint(a > b)   # True\nprint(a < b)   # False\nprint(a >= 15) # True\nprint(a <= 14) # False",
        'explanation': 'Relational operators do values compare karte hain aur boolean (True/False) return karte hain. Yahan a=15 aur b=10 hai, isliye a > b True hai, a < b False hai.',
        'output': 'False\nTrue\nTrue\nFalse\nTrue\nFalse',
      },
      {
        'title': 'Logical Operators in Action',
        'code': "age = 25\nhas_license = True\n\nif age >= 18 and has_license:\n    print(\"You can drive\")\n\nis_weekend = True\nif is_weekend or age > 60:\n    print(\"You can relax\")\n\nif not has_license:\n    print(\"Get a license first\")\nelse:\n    print(\"You have a license\")",
        'explanation': 'and dono conditions check karta hai, or koi ek, not condition ko ultaa kar deta hai. Yahan age >= 18 AND has_license dono True hai, isliye "You can drive" print hoga.',
        'output': 'You can drive\nYou can relax\nYou have a license',
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo user se do numbers input le aur relational operators ke saath unhe compare kare — >, <, >=, <=, ==, != sab print karo.',
        'hint': 'input() se do numbers lo, phir har operator ka result print karo with a descriptive message.',
        'solution': "a = int(input(\"First number: \"))\nb = int(input(\"Second number: \"))\nprint(a, \">\", b, \":\", a > b)\nprint(a, \"<\", b, \":\", a < b)\nprint(a, \">=\", b, \":\", a >= b)\nprint(a, \"<=\", b, \":\", a <= b)\nprint(a, \"==\", b, \":\", a == b)\nprint(a, \"!=\", b, \":\", a != b)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jo teen numbers input le aur check kare ki kya woh sides of a triangle valid hain ya nahi (sum of any two > third). Logical operators use karo.',
        'hint': 'Triangle condition: a + b > c and a + c > b and b + c > a. Tino conditions True honi chahiye and ke saath.',
        'solution': "a = int(input(\"Side 1: \"))\nb = int(input(\"Side 2: \"))\nc = int(input(\"Side 3: \"))\n\nif a + b > c and a + c > b and b + c > a:\n    print(\"Valid triangle\")\nelse:\n    print(\"Invalid triangle\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo user se ek year input le aur check kare ki woh leap year hai ya nahi. Leap year woh hota hai jo 4 se divisible ho, lekin 100 se divisible na ho (except agar 400 se bhi divisible ho). Logical operators (and, or) use karo.',
        'hint': 'Year ko 4 se check karo AND (year 100 se divisible nahi ho OR year 400 se divisible ho). Is combination mein and aur or dono use honge.',
        'solution': "year = int(input(\"Enter a year: \"))\nif year % 4 == 0 and (year % 100 != 0 or year % 400 == 0):\n    print(year, \"is a leap year\")\nelse:\n    print(year, \"is not a leap year\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'a == b', 'example': 'if a == 10:', 'description': 'Equality check — True agar equal hain'},
      {'syntax': 'a != b', 'example': 'if a != 10:', 'description': 'Inequality check — True agar equal nahi hain'},
      {'syntax': 'condition and condition', 'example': 'if a > 0 and a < 10:', 'description': 'Dono conditions True honi chahiye'},
      {'syntax': 'condition or condition', 'example': 'if a == 0 or a == 10:', 'description': 'Koi ek condition True ho toh kaafi'},
      {'syntax': 'not condition', 'example': 'if not a:', 'description': 'Condition ko ulat deta hai (True ↔ False)'},
    ],
    'commonMistakes': [
      '= (assignment) aur == (comparison) mein confuse hona — yeh sabse common mistake hai',
      'and/or ko sahi se combine na karna — proper parentheses use karo complex conditions mein',
      'Logical operators ke saath wrong data type use karna — non-boolean values ke saath bhi kaam karta hai but unexpected results aa sakte hain',
      'Multiple conditions mein proper grouping na hona — age > 18 and < 60 galat hai, age > 18 and age < 60 sahi hai',
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
