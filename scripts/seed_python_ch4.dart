// Run: dart run scripts/seed_python_ch4.dart
// Seeds Python Ch 4: Lists & Tuples (4 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 4...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_4', {
    'id': 'chapter_4',
    'subjectId': 'python',
    'name': 'Lists & Tuples',
    'order': 4,
    'totalTopics': 4,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_4_1', 'chapterId': 'chapter_4', 'name': 'List Indexing', 'order': 16},
    {'topicId': 'topic_4_2', 'chapterId': 'chapter_4', 'name': 'List Methods', 'order': 17},
    {'topicId': 'topic_4_3', 'chapterId': 'chapter_4', 'name': 'Tuples', 'order': 18},
    {'topicId': 'topic_4_4', 'chapterId': 'chapter_4', 'name': 'Tuple Methods', 'order': 19},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic4_1(), topic4_2(), topic4_3(), topic4_4()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_4/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 4 seeded successfully.');
}

Map<String, dynamic> topic4_1() {
  return {
    'id': 'topic_4_1',
    'name': 'List Indexing',
    'chapterId': 'chapter_4',
    'subjectId': 'python',
    'order': 16,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=6674',
    'keyPoints': [
      'List ek container hai jisme multiple values store kar sakte hain — ek hi variable mein',
      'List square brackets [] se banayi jaati hai aur elements commas se separate hote hain',
      'List mein different data types ke elements ho sakte hain — jaise string, int, float, boolean ek saath',
      'Indexing string ki tarah 0 se start hoti hai — friends[0] first element deta hai',
      'List MUTABLE hai — aap existing list ke elements ko change kar sakte hain, string ke opposite',
      'Jaise friends[0] = "Grapes" — yeh possible hai list mein, string mein nahi tha',
      'List slicing bhi kaam karti hai — friends[1:4] se slice milega',
      'Lists are ordered — elements ka order maintain hota hai, jis order mein daale wohi order rahega',
    ],
    'keyConcepts': [
      'List data type',
      'Square brackets []',
      'Mutability',
      'Indexing and slicing',
      'Mixed data types',
    ],
    'aiCoachScript': '''Doston, Chapter 4 mein aapka swagat hai! Aaj hum padhenge Lists aur Tuples.

Sabse pehle baat karte hain List ki. List ek aisa container hai jisme aap multiple values store kar sakte ho. Jaise aapke paas friends ka list — Apple, Orange, 5, 345.06, False, Aakash, Rohan — sab ek saath!

List square brackets [] mein likhi jaati hai. Har element comma se separate hota hai. Aur best baat — aap different data types ek saath store kar sakte ho! String, integer, float, boolean — sab ek saath.

Indexing string jaisi hi hai — 0 se start hoti hai. Toh friends[0] = "Apple", friends[1] = "Orange", etc.

Lekin ek BIG difference hai — List MUTABLE hai. Matlab aap existing list ko change kar sakte ho. Jaise friends[0] = "Grapes" — yeh kaam karega! String mein yeh error deta tha, yaad hai? Immutability ka concept reverse ho gaya.

Slicing bhi kaam karti hai list ke saath. friends[1:4] se aapko index 1 se 3 tak ke elements milenge.

To yaad rakho:
- List = square brackets []
- List = mutable (change kar sakte hain)
- Indexing 0 se start
- Multiple data types ek saath

Chalo ab code likhte hain!''',
    'codeExamples': [
      {
        'title': 'List Creation and Indexing',
        'code': "friends = [\"Apple\", \"Orange\", 5, 345.06, False, \"Aakash\", \"Rohan\"]\n\nprint(friends[0])      # Apple\nfriends[0] = \"Grapes\"  # List is mutable\nprint(friends[0])      # Grapes\nprint(friends[1:4])    # ['Orange', 5, 345.06]",
        'explanation': 'List banayi with mixed types. friends[0] se "Apple" mila. friends[0] = "Grapes" ne existing element change kar diya — yeh possible hai kyunki list mutable hai. friends[1:4] ne slicing se 3 elements diye.',
        'output': 'Apple\nGrapes\n[\'Orange\', 5, 345.06]',
      },
      {
        'title': 'List with Different Data Types',
        'code': "mixed = [\"Hello\", 42, 3.14, True, None]\nprint(mixed)\nprint(type(mixed))  # <class 'list'>\nprint(len(mixed))   # 5",
        'explanation': 'List mein string, int, float, boolean, None sab chalta hai. type() se pata chalta hai ki yeh list hai. len() se total elements ka count pata karte hain.',
        'output': "['Hello', 42, 3.14, True, None]\n<class 'list'>\n5",
      },
    ],
    'challenges': [
      {
        'question': 'Ek list banao jisme 5 fruits ke naam ho. Phir pehla aur aakhri fruit print karo.',
        'hint': 'Pehla element index 0, aakhri element index -1 (negative indexing).',
        'solution': "fruits = [\"Apple\", \"Banana\", \"Mango\", \"Orange\", \"Grapes\"]\nprint(fruits[0])\nprint(fruits[-1])",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek list lo [10, 20, 30, 40, 50] aur uske elements ko swap karo — index 1 wala element index 3 wale element se. Slicing ki madad se karo bina temporary variable ke.',
        'hint': 'Aap multiple assignment use kar sakte ho: a, b = b, a. Lekin list ke liye aap friends[1], friends[3] = friends[3], friends[1] kar sakte ho.',
        'solution': 'nums = [10, 20, 30, 40, 50]\nnums[1], nums[3] = nums[3], nums[1]\nprint(nums)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek list lo [1, 2, 3, 4, 5] aur ek nayi list banao jisme original list ke har element ka square ho. List comprehension use karo.',
        'hint': 'List comprehension: [expression for item in list]. Squares ke liye x**2.',
        'solution': 'original = [1, 2, 3, 4, 5]\nsquares = [x**2 for x in original]\nprint(squares)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'list = [el1, el2, el3]', 'example': 'friends = ["A", "B", 1]', 'description': 'List creation using square brackets'},
      {'syntax': 'list[index]', 'example': 'friends[0]', 'description': 'Index par element access karta hai (0-based)'},
      {'syntax': 'list[start:end]', 'example': 'friends[1:4]', 'description': 'List slice karta hai start se end-1 tak'},
      {'syntax': 'list[index] = value', 'example': 'friends[0] = "Grapes"', 'description': 'List mutable hai — element change kar sakte hain'},
    ],
    'commonMistakes': [
      'Index out of range — list mein jitne elements hain usse zyada index access karte hain to IndexError',
      'List ko string ki tarah treat karna — list mutable hai, string immutable hai. Dono same nahi hain',
      'List slicing mein end index bhoolna ve friends[1:4] means index 1,2,3 (4 exclude) — string jaisa hi concept',
    ],
  };
}

Map<String, dynamic> topic4_2() {
  return {
    'id': 'topic_4_2',
    'name': 'List Methods',
    'chapterId': 'chapter_4',
    'subjectId': 'python',
    'order': 17,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=6780',
    'keyPoints': [
      'append() — list ke end mein naya element add karta hai',
      'sort() — list ko ascending order mein sort karta hai (numbers, strings alphabetically)',
      'reverse() — list ke elements ka order reverse kar deta hai',
      'insert(index, value) — specific index par naya element insert karta hai',
      'pop(index) — specific index ka element delete karta hai aur return karta hai',
      'List methods original list ko CHANGE karte hain kyunki list mutable hai',
      'String methods naya string return karte the, list methods original list change karte hain — yeh main difference hai',
      'remove(value) — specific value wal element ko delete karta hai (pehla occurrence)',
      'ChatGPT se aur list methods explore karo — jaise count(), index(), extend(), clear()',
    ],
    'keyConcepts': [
      'append()',
      'sort() and reverse()',
      'insert()',
      'pop()',
      'Mutability of lists',
    ],
    'aiCoachScript': '''Ab baat karte hain List Methods ki — jo list ko manipulate karne ke kaam aate hain.

First method: append() — yeh list ke end mein naya element add karta hai. Jaise friends.append("Harry") → "Harry" list mein last mein add ho jayega.

Sort() — list ko ascending order mein sort karta hai. Numbers hain to chhota se bada, strings hain to A to Z. Descending ke liye sort(reverse=True) bhi use kar sakte ho.

Reverse() — list ke elements ka order ulta kar deta hai. Last element first aa jayega.

Insert() — aap kisi specific index par element daal sakte ho. Jaise l1.insert(2, 333333) — index 2 par 333333 daal do. Baaki elements shift ho jayenge right side.

Pop() — yeh index se element delete karta hai aur deleted element ko return bhi karta hai. Jaise value = l1.pop(3) — index 3 ka element delete hoga aur value variable mein store ho jayega. Agar pop() mein kuch nahi doge to last element delete hoga.

Yaad rakho — STRING methods ki tarah yeh list methods original list nahi badalte the. But LIST methods original list KO CHANGE KARTE HAIN! Yeh bahut important difference hai. String immutable tha, isliye naya return karta tha. List mutable hai, isliye original change hoti hai.

Chalo ab challenge solve karte hain!''',
    'codeExamples': [
      {
        'title': 'Append, Sort, Reverse',
        'code': "friends = [\"Apple\", \"Orange\", 5, 345.06, False, \"Aakash\", \"Rohan\"]\nprint(friends)\nfriends.append(\"Harry\")\nprint(friends)\n\nl1 = [1, 34, 62, 2, 6, 11]\nl1.sort()\nprint(l1)  # [1, 2, 6, 11, 34, 62]\nl1.reverse()\nprint(l1)  # [62, 34, 11, 6, 2, 1]",
        'explanation': 'append("Harry") ne "Harry" ko list ke end mein add kiya. sort() ne numbers ko ascending order mein arrange kiya. reverse() ne order ulta kar diya. Dhyaan do — original list change hui hai.',
        'output': "['Apple', 'Orange', 5, 345.06, False, 'Aakash', 'Rohan']\n['Apple', 'Orange', 5, 345.06, False, 'Aakash', 'Rohan', 'Harry']\n[1, 2, 6, 11, 34, 62]\n[62, 34, 11, 6, 2, 1]",
      },
      {
        'title': 'Insert and Pop',
        'code': "l1 = [1, 34, 62, 2, 6, 11]\nl1.insert(2, 333333)  # Insert 333333 at index 2\nprint(l1)\n\nvalue = l1.pop(3)      # Pop element at index 3\nprint(value)           # 2 (pop returns the deleted value)\nprint(l1)              # [1, 34, 333333, 6, 11]",
        'explanation': 'insert(2, 333333) ne index 2 par 333333 add kar diya — baaki elements right shift ho gaye. pop(3) ne index 3 ka element delete kiya aur return kiya. Original list change ho gayi.',
        'output': '[1, 34, 333333, 62, 2, 6, 11]\n2\n[1, 34, 333333, 6, 11]',
      },
    ],
    'challenges': [
      {
        'question': 'User se 6 marks input lo, ek list mein store karo, sort karo, aur print karo.',
        'hint': 'input() se marks lo, int() mein convert karo, append() karo, sort() karo, print karo.',
        'solution': "marks = []\nfor i in range(6):\n    m = int(input(\"Enter marks: \"))\n    marks.append(m)\nmarks.sort()\nprint(marks)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek list lo [5, 2, 8, 1, 9, 3] aur use descending order mein sort karo. Built-in reverse=True use karo na ki sort + reverse alag se.',
        'hint': 'sort(reverse=True) se descending order mein sort ho jayega.',
        'solution': 'nums = [5, 2, 8, 1, 9, 3]\nnums.sort(reverse=True)\nprint(nums)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo user se 5 numbers input kare, unhe ek list mein daale, phir har ek unique number ka count bataye (kitni baar aaya). Pop ya remove ka use karo.',
        'hint': 'For each unique number, count() method use karo kitni baar aaya. Ya phir set() use karo unique nikaalne ke liye.',
        'solution': 'nums = []\nfor i in range(5):\n    nums.append(int(input(\"Enter number: \")))\n\nunique = []\nfor n in nums:\n    if n not in unique:\n        unique.append(n)\n        print(f\"{n} appears {nums.count(n)} times\")',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'list.append(value)', 'example': 'friends.append("Harry")', 'description': 'List ke end mein element add karta hai'},
      {'syntax': 'list.sort()', 'example': 'l1.sort()', 'description': 'List ko ascending order mein sort karta hai'},
      {'syntax': 'list.reverse()', 'example': 'l1.reverse()', 'description': 'List ke elements ka order reverse karta hai'},
      {'syntax': 'list.insert(index, value)', 'example': 'l1.insert(2, 333)', 'description': 'Specific index par element insert karta hai'},
      {'syntax': 'list.pop(index)', 'example': 'l1.pop(3)', 'description': 'Index par element delete karta hai aur return karta hai'},
    ],
    'commonMistakes': [
      'append() ek saath multiple elements nahi daal sakta — l1.append(4,5) error dega. extend() use karo ya append karte raho',
      'sort() mixed data types par kaam nahi karta — jaise int aur string ek saath ho to TypeError aayega',
      'pop() ka return value ignore karna — jab aap index ka element delete karte ho to woh return hota hai. Agar use nahi karna to bhi chalega, lekin pata hona chahiye',
    ],
  };
}

Map<String, dynamic> topic4_3() {
  return {
    'id': 'topic_4_3',
    'name': 'Tuples',
    'chapterId': 'chapter_4',
    'subjectId': 'python',
    'order': 18,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=7320',
    'keyPoints': [
      'Tuple ek immutable data type hai — list ki tarah collection hai lekin change nahi kar sakte',
      'Tuple round parentheses () se banaya jaata hai — a = (1, 45, 342, 3424, False, "Rohan", "Shivam")',
      'Tuples can also be created without parentheses — just comma separated values',
      'Empty tuple: a = () — empty round brackets se banta hai',
      'Single element tuple: a = (1,) — comma zaroori hai warna integer samjhega',
      'Tuple immutable hai — aap existing tuple ke elements ko change nahi kar sakte',
      'Tuple list ki tarah ordered hai aur multiple data types store kar sakta hai',
      'type() function se check kar sakte ho — class tuple print hoga',
    ],
    'keyConcepts': [
      'Tuple data type',
      'Immutable collection',
      'Tuple creation ()',
      'Single element tuple (comma)',
      'Difference between list and tuple',
    ],
    'aiCoachScript': '''Chalo ab Tuples ke baare mein samajhte hain.

Tuple kya hota hai? Tuple ek collection data type hai jo list jaisa hi hota hai — multiple values store kar sakte ho, different data types bhi. Lekin ek BIG difference hai — TUPLE IMMUTABLE HAI.

List mutable thi, yaad hai? Aap friends[0] = "Grapes" kar sakte the. Tuple mein aap elements change nahi kar sakte. Jaise string immutable thi, waise hi tuple immutable hai.

Tuple round parentheses () se banate hain:
a = (1, 45, 342, 3424, False, "Rohan", "Shivam")

Aap bina parentheses ke bhi tuple bana sakte ho — bas comma separated values likho:
a = 1, 2, 3  # Yeh bhi tuple hai

Empty tuple: a = ()

Single element tuple: a = (1,) — comma bhoolna mat! Warna (1) ko Python integer samjhega. Comma batata hai ki yeh tuple hai.

Tuple immutable kyun use karein? Kyunki kabhi kabhi aap chahte ho ki data change na ho. Jaise days of week — Monday, Tuesday etc — yeh fixed hai. Isliye tuple mein store karna safe hai.

type() se check karo — class tuple aayega.

To yaad rakho:
- List = mutable (change allowed)
- Tuple = immutable (change not allowed)
- Tuple = () round brackets
- Single element = comma zaroori''',
    'codeExamples': [
      {
        'title': 'Tuple Creation and Type',
        'code': "a = (1, 45, 342, 3424, False, \"Rohan\", \"Shivam\")\nprint(a)\nprint(type(a))  # <class 'tuple'>",
        'explanation': 'Tuple banaya with multiple data types. print(a) se saare elements dikhe. type(a) se class tuple confirm hua.',
        'output': "(1, 45, 342, 3424, False, 'Rohan', 'Shivam')\n<class 'tuple'>",
      },
      {
        'title': 'Single Element and Empty Tuple',
        'code': "a = (1)    # This is integer, not tuple\nprint(type(a))  # <class 'int'>\n\nb = (1,)   # Comma makes it a tuple\nprint(type(b))  # <class 'tuple'>\n\nc = ()     # Empty tuple\nprint(type(c))  # <class 'tuple'>",
        'explanation': '(1) integer hai, (1,) tuple hai. Comma Python ko batata hai ki yeh tuple hai. Empty tuple () se banta hai.',
        'output': "<class 'int'>\n<class 'tuple'>\n<class 'tuple'>",
      },
    ],
    'challenges': [
      {
        'question': 'Ek tuple banao jisme 5 numbers ho. Phir tuple ki length print karo.',
        'hint': 'len() function tuple ke saath bhi kaam karta hai.',
        'solution': "t = (10, 20, 30, 40, 50)\nprint(len(t))",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek tuple lo (34, 234, "Harry") aur uske element ko change karne ki koshish karo. Dekho kya error aata hai. Phir ek naya tuple banao jo dono tuples ko concatenate kare.',
        'hint': 't[0] = 100 kar ke dekho — TypeError aayega. Plus operator se tuples concatenate ho sakte hain.',
        'solution': "t1 = (34, 234, \"Harry\")\n# t1[0] = 100  # TypeError: 'tuple' object does not support item assignment\nt2 = (100, 200)\nt3 = t1 + t2\nprint(t3)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo user se 5 numbers input kare aur unhe tuple mein store kare. Phir tuple ke elements ko check karo — ki kitne elements 0 se divisible hain by 2.',
        'hint': 'Tuple immutable hai, isliye pehle list mein store karo phir tuple() se convert karo. Modulus % operator use karo even check ke liye.',
        'solution': "nums = tuple(int(input(\"Enter number: \")) for _ in range(5))\neven_count = sum(1 for n in nums if n % 2 == 0)\nprint(f\"Even numbers: {even_count}\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'tuple = (el1, el2)', 'example': 'a = (1, 2, 3)', 'description': 'Tuple creation using parentheses'},
      {'syntax': 'tuple = el1, el2', 'example': 'a = 1, 2, 3', 'description': 'Tuple without parentheses (comma-separated)'},
      {'syntax': 'tuple = (value,)', 'example': 'a = (1,)', 'description': 'Single element tuple — comma zaroori'},
      {'syntax': 'tuple = ()', 'example': 'a = ()', 'description': 'Empty tuple creation'},
    ],
    'commonMistakes': [
      '(1) ko tuple samajhna — yeh integer hai. Tuple ke liye (1,) comma chahiye',
      'Tuple ko modify karne ki koshish — tuple immutable hai, TypeError aayega',
      'Comma bhool kar single element tuple banana — yaad rakho comma mandatory hai single element tuple ke liye',
    ],
  };
}

Map<String, dynamic> topic4_4() {
  return {
    'id': 'topic_4_4',
    'name': 'Tuple Methods',
    'chapterId': 'chapter_4',
    'subjectId': 'python',
    'order': 19,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=7410',
    'keyPoints': [
      'count(value) — tuple mein diye gaye value kitni baar aata hai, count return karta hai',
      'index(value) — diye gaye value ki first occurrence ka index return karta hai',
      'len() — tuple ke total elements ki length batata hai',
      'Ye methods original tuple ko change nahi karte kyunki tuple immutable hai',
      'index() agar value nahi mili to ValueError throw karta hai — sambhal kar use karo',
      'Tuples ko concatenate (+) kiya ja sakta hai — naya tuple banta hai, existing nahi badalta',
      'Tuples ko repeat (*) kiya ja sakta hai — jaise (1,2) * 3 = (1,2,1,2,1,2)',
      '"in" keyword se membership check kar sakte ho — 45 in a returns True/False',
    ],
    'keyConcepts': [
      'count() method',
      'index() method',
      'len() function',
      'Concatenation (+)',
      'Membership operator (in)',
    ],
    'aiCoachScript': '''Chalo ab Tuple Methods ke baare mein seekhte hain.

Count() — yeh batata hai ki koi specific value tuple mein kitni baar aati hai. Jaise a = (1, 45, 342, 3424, False, 45, "Rohan"), to a.count(45) → 2. Kyunki 45 do baar aaya hai.

Index() — yeh batata hai ki koi value tuple mein kis index par hai (first occurrence). Jaise a.index(3424) → 3. Lekin agar value existing nahi hai tuple mein, to ValueError aayega — isliye pehle count() se check kar lo ya "in" operator use karo.

Len() — yeh to aap jaante hi ho, tuple ki length batata hai.

In operator — aap check kar sakte ho ki koi value tuple mein hai ya nahi:
if 45 in a: print("Hai!")

Concatenation — aap do tuples ko + se jod kar naya tuple bana sakte ho:
new = (1, 2) + (3, 4) → (1, 2, 3, 4)
Existing tuples change nahi hote — naya tuple banta hai.

Repetition — (1, 2) * 3 → (1, 2, 1, 2, 1, 2)

Yaad rakho — tuple immutable hai, isliye methods original tuple nahi badalte. Jab bhi aap tuple change karne ki koshish karte ho (jaise concatenation), to naya tuple banta hai.

ChatGPT se aur methods explore karo! Lekin count, index, len yeh teen sabse important hain. Chalo practice karte hain!''',
    'codeExamples': [
      {
        'title': 'Count, Index, and Len',
        'code': "a = (1, 45, 342, 3424, False, 45, \"Rohan\", \"Shivam\")\nprint(a)\n\nno = a.count(45)\nprint(no)  # 2\n\ni = a.index(3424)\nprint(i)  # 3\n\nprint(len(a))  # 8",
        'explanation': 'count(45) returns 2 kyunki 45 do baar hai. index(3424) returns 3 jo ki first occurrence ka index hai. len() returns 8 total elements. Sab methods read-only hain — tuple change nahi hota.',
        'output': "(1, 45, 342, 3424, False, 45, 'Rohan', 'Shivam')\n2\n3\n8",
      },
      {
        'title': 'Concatenation and Membership',
        'code': "a = (1, 2, 3)\nb = (4, 5, 6)\nc = a + b\nprint(c)  # (1, 2, 3, 4, 5, 6)\n\nprint(2 in a)   # True\nprint(10 in a)  # False\n\nprint(a * 3)  # (1, 2, 3, 1, 2, 3, 1, 2, 3)",
        'explanation': 'a + b se naya tuple bana (existing a aur b unchanged). "in" operator check karta hai ki value tuple mein hai ya nahi — True/False return karta hai. * se tuple repeat hota hai.',
        'output': '(1, 2, 3, 4, 5, 6)\nTrue\nFalse\n(1, 2, 3, 1, 2, 3, 1, 2, 3)',
      },
    ],
    'challenges': [
      {
        'question': 'Ek tuple banao (7, 0, 8, 0, 0, 9). Isme kitni baar 0 aata hai, count() se pata karo.',
        'hint': 'tuple.count(0) use karo.',
        'solution': "a = (7, 0, 8, 0, 0, 9)\nn = a.count(0)\nprint(n)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek tuple lo (10, 20, 30, 40, 50) aur user se ek number input lo. Check karo ki wo number tuple mein hai ya nahi using "in" operator. Agar hai to uska index bhi print karo.',
        'hint': 'input() se number lo, int() mein convert karo. "in" operator se check karo, index() se index pata karo.',
        'solution': "t = (10, 20, 30, 40, 50)\nnum = int(input(\"Enter number: \"))\nif num in t:\n    print(f\"Found at index {t.index(num)}\")\nelse:\n    print(\"Not found\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo do tuples ko concatenate kare, phir concatenated tuple mein se duplicates hatao (unique values nikaalo). List ya set use kar sakte ho.',
        'hint': 'Set() se unique values milti hain. Phir wapas tuple() mein convert karo.',
        'solution': "a = (1, 2, 3, 4, 2)\nb = (3, 4, 5, 6, 1)\nc = a + b\nunique = tuple(set(c))\nprint(unique)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'tuple.count(value)', 'example': 'a.count(45)', 'description': 'Value kitni baar tuple mein aati hai count karta hai'},
      {'syntax': 'tuple.index(value)', 'example': 'a.index(3424)', 'description': 'Value ki first occurrence ka index return karta hai'},
      {'syntax': 'len(tuple)', 'example': 'len(a)', 'description': 'Tuple ki length return karta hai'},
      {'syntax': 'value in tuple', 'example': '45 in a', 'description': 'Check karta hai ki value tuple mein hai ya nahi'},
      {'syntax': 'tuple1 + tuple2', 'example': 'a + b', 'description': 'Do tuples ko concatenate karta hai, naya tuple return hota hai'},
    ],
    'commonMistakes': [
      "index() mein value nahi milne par ValueError — hamesha pehle 'in' operator se check karo ya try-except use karo",
      'Tuple methods ko list methods jaisa treat karna — tuple ke paas limited methods hote hain (count, index), list jaisa append, sort etc nahi hai',
      'Concatenation ko original tuple badalne wala samajhna — a + b se naya tuple banta hai, existing a aur b wahi rehte hain',
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
