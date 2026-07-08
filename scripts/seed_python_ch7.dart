// Run: dart run scripts/seed_python_ch7.dart
// Seeds Python Ch 7: Loops (5 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 7...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_7', {
    'id': 'chapter_7',
    'subjectId': 'python',
    'name': 'Loops',
    'order': 7,
    'totalTopics': 5,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_7_1', 'chapterId': 'chapter_7', 'name': 'while Loop', 'order': 26},
    {'topicId': 'topic_7_2', 'chapterId': 'chapter_7', 'name': 'for Loop', 'order': 27},
    {'topicId': 'topic_7_3', 'chapterId': 'chapter_7', 'name': 'range() Function', 'order': 28},
    {'topicId': 'topic_7_4', 'chapterId': 'chapter_7', 'name': 'for with else', 'order': 29},
    {'topicId': 'topic_7_5', 'chapterId': 'chapter_7', 'name': 'break, continue, pass', 'order': 30},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic7_1(), topic7_2(), topic7_3(), topic7_4(), topic7_5()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_7/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 7 seeded successfully.');
}

Map<String, dynamic> topic7_1() {
  return {
    'id': 'topic_7_1',
    'name': 'while Loop',
    'chapterId': 'chapter_7',
    'subjectId': 'python',
    'order': 26,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=14441',
    'keyPoints': [
      'while loop tab tak chalta hai jab tak condition True hai — jaise hi False hoti hai, loop stop',
      'Syntax: while condition: — colon aur indentation zaroori hai',
      'Infinite loop tab hota hai jab condition kabhi False nahi hoti — Ctrl+C se rok sakte ho',
      'Counter variable update karna bhoolna sabse common mistake hai — infinite loop aayega',
      'while loop ka use tab hota hai jab aapko nahi pata kitni baar loop chalega',
      'List ya string ke elements ko while loop se index-based access kar sakte ho',
    ],
    'keyConcepts': [
      'while loop syntax',
      'Condition',
      'Increment/decrement',
      'Infinite loop',
      'Counter variable',
      'Index-based iteration',
    ],
    'aiCoachScript': '''Chalo seekhte hain loops — specifically while loop.

While loop ka kaam hai — kisi kaam ko baar-baar karna jab tak condition True hai. Jaise — jab tak plate mein khaana hai, khaate raho. Khaana khatam hua, ruk jao.

Syntax dekho:
i = 1
while i < 51:
    print(i)
    i = i + 1

Yeh 1 se 50 tak print karega. Har baar i increase hota hai, aur jab i 51 ho jata hai, condition False ho jati hai aur loop ruk jata hai.

Important: i = i + 1 likhna mat bhoolna! Agar yeh bhool gaye toh i hamesha 1 rahega, condition kabhi False nahi hogi, aur infinite loop chal jayega. Infinite loop rokne ke liye Ctrl+C dabaao.

While loop tab use karo jab aapko nahi pata kitni baar loop chalana hai — jaise user se input lena jab tak valid data na de.

List ke elements ko while loop se access karna:
l = [1, 2, 3, 4, 5]
i = 0
while i < len(l):
    print(l[i])
    i += 1

Yaad rakho: while loop = condition-based, tab tak chalo jab tak condition True hai. Condition ka False hona loop ka stop signal hai.''',
    'codeExamples': [
      {
        'title': 'While Loop — Counting 1 to 5',
        'code': "i = 1\nwhile i <= 5:\n    print(i)\n    i += 1",
        'explanation': 'i=1 se start. Jab tak i <= 5 True hai, loop chalta hai. Har iteration mein i print hota hai aur i increment hota hai (i += 1). Jab i=6 hota hai, condition False ho jati hai aur loop stops.',
        'output': '1\n2\n3\n4\n5',
      },
      {
        'title': 'While Loop with List',
        'code': "l = [1, 2, 3, 4, 5]\ni = 0\nwhile i < len(l):\n    print(l[i])\n    i += 1",
        'explanation': 'List ke elements ko while loop se access karne ka tareeka. i ko index ki tarah use karte hain. Jab i list ki length ke barabar ho jata hai, loop ruk jata hai.',
        'output': '1\n2\n3\n4\n5',
      },
    ],
    'challenges': [
      {
        'question': 'While loop ka use karke 1 se 10 tak numbers print karo.',
        'hint': 'i = 1 se start karo, condition i <= 10, aur har baar i += 1 karo.',
        'solution': "i = 1\nwhile i <= 10:\n    print(i)\n    i += 1",
        'difficulty': 'easy',
      },
      {
        'question': 'While loop ka use karke kisi number ka multiplication table print karo. Jaise user ne 5 diya toh 5x1=5 se 5x10=50 tak.',
        'hint': 'i = 1 se start karo, i <= 10 tak loop chalao, aur har iteration mein num * i print karo.',
        'solution': "num = int(input(\"Enter a number: \"))\ni = 1\nwhile i <= 10:\n    print(num, \"x\", i, \"=\", num * i)\n    i += 1",
        'difficulty': 'medium',
      },
      {
        'question': 'While loop ka use karke user se tab tak number input lo jab tak woh positive number na de. Jaise hi positive number de, us number ka table print karo.',
        'hint': 'while loop mein condition rakh lo ki jab tak num <= 0 hai, input lete raho. Phir loop ke baad table print karo.',
        'solution': "num = int(input(\"Enter a positive number: \"))\nwhile num <= 0:\n    print(\"That's not positive!\")\n    num = int(input(\"Enter again: \"))\n\nprint(\"Table of\", num, \":\")\ni = 1\nwhile i <= 10:\n    print(num, \"x\", i, \"=\", num * i)\n    i += 1",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'while condition:', 'example': 'while i < 5:', 'description': 'While loop — condition True rahe toh chalta hai'},
      {'syntax': 'i += 1', 'example': 'i += 1', 'description': 'Increment operator — i ko 1 se badhata hai'},
      {'syntax': 'i -= 1', 'example': 'i -= 1', 'description': 'Decrement operator — i ko 1 se ghatata hai'},
    ],
    'commonMistakes': [
      'Counter variable update karna bhoolna — infinite loop ho jayega',
      'Condition galat likhna — ek extra/missing iteration ho sakti hai',
      'While loop mein list modify karna during iteration — unexpected results aate hain',
      'Colon aur indentation bhoolna — SyntaxError',
    ],
  };
}

Map<String, dynamic> topic7_2() {
  return {
    'id': 'topic_7_2',
    'name': 'for Loop',
    'chapterId': 'chapter_7',
    'subjectId': 'python',
    'order': 27,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=14942',
    'keyPoints': [
      'for loop collections (list, tuple, string, etc.) ke har element par iterate karta hai',
      'Syntax: for variable in collection: — jo variable hai woh har iteration mein next element store karta hai',
      'String pe for loop chalaoge toh har character alag milta hai',
      'Tuple pe for loop chalaoge toh har element sequentially milta hai',
      'For loop automatically terminate hota hai jab collection khatam ho jata hai — counter ki zaroorat nahi',
      'For loop while loop se clean hota hai jab aapko pata hai ki kis collection mein iterate karna hai',
    ],
    'keyConcepts': [
      'for loop syntax',
      'Iteration over sequences',
      'String iteration',
      'List iteration',
      'Tuple iteration',
      'Automatic termination',
    ],
    'aiCoachScript': '''Ab baat karte hain for loop ki.

For loop collections ke har element par iterate karta hai. Matlab — aapke paas ek list hai, for loop automatically uske har ek element ko ek-ek karke access karega.

Syntax dekho:
l = [1, 2, 3, 4, 5]
for i in l:
    print(i)

Yahan i har iteration mein list ka next element ban jata hai. Pehle i=1, phir i=2, i=3, i=4, i=5. Jab list khatam hoti hai, loop automatically terminate ho jata hai. Koi counter nahi, koi condition nahi — clean and simple.

String pe for loop:
for i in "Hello":
    print(i)

Yeh H, e, l, l, o ek-ek karke print karega.

Tuple pe for loop:
t = (1, 2, 3)
for i in t:
    print(i)

For loop tab use karo jab aapko collection ke elements par iterate karna hai. While loop tab use karo jab condition-based iteration chahiye. For loop generally cleaner aur less error-prone hota hai.

Yaad rakho: for loop = collection-based iteration. Koi counter nahi, koi condition nahi, bas collection khatam hone tak chalta hai.''',
    'codeExamples': [
      {
        'title': 'For Loop — List Iteration',
        'code': "l = [1, 2, 3, 4, 5]\nfor i in l:\n    print(i)",
        'explanation': 'For loop list l ke har element par iterate karta hai. Har iteration mein i list ka current element leta hai. Jab list khatam hoti hai, loop apne aap ruk jata hai.',
        'output': '1\n2\n3\n4\n5',
      },
      {
        'title': 'For Loop — String and Tuple',
        'code': "# String iteration\nfor char in \"Python\":\n    print(char)\n\n# Tuple iteration\nfor item in (10, 20, 30):\n    print(item)",
        'explanation': 'String par for loop har character ko alag karke deta hai. Tuple par bhi same — har element sequentially milta hai. For loop kisi bhi iterable collection ke saath kaam karta hai.',
        'output': 'P\ny\nt\nh\no\nn\n10\n20\n30',
      },
    ],
    'challenges': [
      {
        'question': 'Ek list banao jisme 5 fruits ke naam ho. For loop use karke har fruit ka naam print karo.',
        'hint': 'List banao, phir for fruit in fruits: likho aur print(fruit) karo.',
        'solution': "fruits = [\"apple\", \"banana\", \"mango\", \"orange\", \"grapes\"]\nfor fruit in fruits:\n    print(fruit)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jo user se ek string input le aur for loop use karke vowels (a, e, i, o, u) aur consonants count kare. Capital aur small dono vowels count karo.',
        'hint': 'For loop mein har character ko check karo: agar ch in "aeiouAEIOU" hai toh vowel, warna agar (ch >= "a" and ch <= "z") or (ch >= "A" and ch <= "Z") hai toh consonant.',
        'solution': "text = input(\"Enter a string: \")\nvowels = 0\nconsonants = 0\nfor ch in text:\n    if ch in 'aeiouAEIOU':\n        vowels += 1\n    elif (ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z'):\n        consonants += 1\nprint(\"Vowels:\", vowels, \"Consonants:\", consonants)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek list of lists hai — jaise [[1,2], [3,4], [5,6]]. Nested for loop use karke har inner element ko print karo.',
        'hint': 'for inner in outer_list: phir for elem in inner: print(elem). Do loop chahiye — ek outer list ke liye, ek inner list ke liye.',
        'solution': "matrix = [[1, 2], [3, 4], [5, 6]]\nfor row in matrix:\n    for elem in row:\n        print(elem, end=' ')\n    print()",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'for var in iterable:', 'example': 'for i in [1,2,3]:', 'description': 'Collection ke har element par iterate karta hai'},
      {'syntax': 'for var in string:', 'example': 'for ch in "Hi":', 'description': 'String ke har character par iterate karta hai'},
      {'syntax': 'for var in tuple:', 'example': 'for i in (1,2):', 'description': 'Tuple ke har element par iterate karta hai'},
    ],
    'commonMistakes': [
      'For loop ke andar collection modify karna — unexpected behavior',
      'Iteration variable ko loop ke bahar use karna — woh last value store karta hai',
      'For loop mein indentation bhoolna — block define nahi hoga',
      'For loop ko while loop ki tarah use karne ki koshish — har tool ka apna use case hai',
    ],
  };
}

Map<String, dynamic> topic7_3() {
  return {
    'id': 'topic_7_3',
    'name': 'range() Function',
    'chapterId': 'chapter_7',
    'subjectId': 'python',
    'order': 28,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=15000',
    'keyPoints': [
      'range() function numbers ka sequence generate karta hai — mostly for loop ke saath use hota hai',
      'range(stop): 0 se stop-1 tak numbers generate karta hai — jaise range(5) → 0,1,2,3,4',
      'range(start, stop): start se stop-1 tak — jaise range(1,6) → 1,2,3,4,5',
      'range(start, stop, step): step size bhi define kar sakte ho — jaise range(1,10,2) → 1,3,5,7,9',
      'range() memory-efficient hai — saare numbers ek saath store nahi karta, on-the-fly generate karta hai',
      'range() ka result list nahi hai — yeh ek range object hai, list() se convert kar sakte ho',
    ],
    'keyConcepts': [
      'range(stop)',
      'range(start, stop)',
      'range(start, stop, step)',
      'For loop with range',
      'Range object',
      'Memory efficiency',
    ],
    'aiCoachScript': '''Chalo range() function ke baare mein seekhte hain.

Range function numbers ka sequence generate karta hai. Yeh mostly for loop ke saath use hota hai jab aapko fixed number of iterations chahiye.

Teen tarike hain range use karne ke:

1. range(stop) — 0 se stop-1 tak:
for i in range(5):  # 0, 1, 2, 3, 4
    print(i)

2. range(start, stop) — start se stop-1 tak:
for i in range(1, 6):  # 1, 2, 3, 4, 5
    print(i)

3. range(start, stop, step) — step size ke saath:
for i in range(1, 10, 2):  # 1, 3, 5, 7, 9
    print(i)

Range ka sabse common use case hai — for loop ko specific number of times chalana. Jaise:

for i in range(4):
    print("Hello")

Yeh "Hello" 4 baar print karega.

Range memory-efficient hai — yeh saare numbers ek saath store nahi karta. Har iteration mein agla number generate karta hai.

Range object ko list mein convert kar sakte ho agar zaroorat ho:
print(list(range(5))) → [0, 1, 2, 3, 4]

Yaad rakho: range ka stop value EXCLUSIVE hota hai — stop ke numbers include nahi hote. range(5) ka matlab 0 se 4, 5 nahi!''',
    'codeExamples': [
      {
        'title': 'range() — Different Forms',
        'code': "print(list(range(5)))      # stop only\nprint(list(range(1, 6)))  # start, stop\nprint(list(range(1, 10, 2))) # start, stop, step",
        'explanation': 'range(5) → 0 se 4 (5 exclusive). range(1, 6) → 1 se 5. range(1, 10, 2) → 1 se 9 with step 2. list() se range object ko list mein convert kar ke dekhte hain.',
        'output': '[0, 1, 2, 3, 4]\n[1, 2, 3, 4, 5]\n[1, 3, 5, 7, 9]',
      },
      {
        'title': 'For Loop with range() — Print 4 Times',
        'code': "for i in range(4):\n    print(i, \"Hello\")",
        'explanation': 'range(4) 4 numbers generate karta hai — 0, 1, 2, 3. For loop har number ke liye ek baar chalta hai. i current number store karta hai. Output 4 lines hogi.',
        'output': '0 Hello\n1 Hello\n2 Hello\n3 Hello',
      },
    ],
    'challenges': [
      {
        'question': 'For loop aur range() ka use karke 1 se 10 tak numbers print karo (range with start and stop).',
        'hint': 'range(1, 11) use karo kyunki stop exclusive hota hai.',
        'solution': "for i in range(1, 11):\n    print(i)",
        'difficulty': 'easy',
      },
      {
        'question': 'For loop aur range() ka use karke 1 se 100 tak ke saare even numbers print karo.',
        'hint': 'range(2, 101, 2) use karo — start=2, stop=101, step=2.',
        'solution': "for i in range(2, 101, 2):\n    print(i)",
        'difficulty': 'medium',
      },
      {
        'question': 'User se ek number N input lo aur for loop aur range() ka use karke N ka factorial nikaalo. Jaise 5! = 5*4*3*2*1 = 120.',
        'hint': 'Factorial ke liye range(N, 0, -1) use kar sakte ho — reverse order mein multiply karo.',
        'solution': "n = int(input(\"Enter a number: \"))\nfactorial = 1\nfor i in range(n, 0, -1):\n    factorial *= i\nprint(\"Factorial of\", n, \"is\", factorial)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'range(stop)', 'example': 'range(5)', 'description': '0 se stop-1 tak numbers'},
      {'syntax': 'range(start, stop)', 'example': 'range(2, 7)', 'description': 'start se stop-1 tak numbers'},
      {'syntax': 'range(start, stop, step)', 'example': 'range(1, 10, 2)', 'description': 'Step size ke saath sequence'},
    ],
    'commonMistakes': [
      'range(stop) mein stop value include hota hai samajh lena — nahi, stop exclusive hota hai',
      'range(start, stop) mein start > stop dena — empty sequence aayega (reverse ke liye negative step chahiye)',
      'range() ko list samajh lena — range object alag hota hai, list() se convert karo agar zaroorat ho',
      'range() mein float value dena — TypeError aayega, sirf integers support karta hai',
    ],
  };
}

Map<String, dynamic> topic7_4() {
  return {
    'id': 'topic_7_4',
    'name': 'for with else',
    'chapterId': 'chapter_7',
    'subjectId': 'python',
    'order': 29,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=15257',
    'keyPoints': [
      'For loop ke saath else clause bhi lag sakta hai — unique Python feature hai yeh',
      'Else block tab execute hota hai jab loop normally complete hota hai (bina break ke)',
      'Agar loop break se terminate hota hai, toh else block execute nahi hota',
      'Yeh "search and validate" pattern ke liye useful hai — agar item mil gaya toh break, nahi mila toh else',
      'While loop ke saath bhi else kaam karta hai — same behavior',
      'Har language mein for-else nahi hota — Python ka special feature hai',
    ],
    'keyConcepts': [
      'for-else clause',
      'Normal loop completion',
      'Break exits without else',
      'Search pattern',
      'Python-specific feature',
    ],
    'aiCoachScript': '''Chalo ek interesting topic — for loop ke saath else!

Python mein aap for loop ke baad else clause laga sakte ho. Yeh unique feature hai — bahut si languages mein yeh nahi hota.

Else block tab execute hota hai jab loop normally complete hota hai — matlab bina break ke khatam hota hai. Agar loop break statement se terminate hota hai, toh else block execute nahi hota.

Example dekho:
for i in range(5):
    print(i)
else:
    print("Loop completed normally")

Yeh 0 se 4 print karega, phir "Loop completed normally" print hoga.

Ab break ke saath:
for i in range(5):
    if i == 3:
        break
    print(i)
else:
    print("Loop completed normally")

Yeh 0, 1, 2 print karega, phir break ho jayega because i == 3. Else block execute nahi hoga.

Ye pattern "search" karne ke liye useful hai. Jaise — list mein koi item dhundh rahe ho. Agar mil gaya toh break. Agar nahi mila (loop normally complete hua) toh else mein "not found" message do.

for item in list:
    if item == target:
        print("Found!")
        break
else:
    print("Not found")

Yaad rakho: else = loop bina break ke complete hua. Break lag gaya toh else nahi chalega.''',
    'codeExamples': [
      {
        'title': 'For-else — Normal Completion',
        'code': "for i in range(5):\n    print(i)\nelse:\n    print(\"Loop completed without break\")",
        'explanation': 'Loop 0 se 4 tak chalta hai, koi break nahi hai, isliye else block execute hota hai. Output dono — numbers aur else message — print hoga.',
        'output': '0\n1\n2\n3\n4\nLoop completed without break',
      },
      {
        'title': 'For-else with Break',
        'code': "for i in range(5):\n    if i == 3:\n        print(\"Breaking at 3\")\n        break\n    print(i)\nelse:\n    print(\"Loop completed without break\")",
        'explanation': 'Loop 0, 1, 2 print karta hai. Phir i=3 par break ho jata hai. Kyunki break se terminate hua, else block execute nahi hota.',
        'output': '0\n1\n2\nBreaking at 3',
      },
    ],
    'challenges': [
      {
        'question': 'Ek list mein se kisi specific number ko dhundho using for-else pattern. Agar mil jaye toh "Found" warna "Not Found".',
        'hint': 'For loop mein if item == target: break. Else mein "Not Found" print karo.',
        'solution': "numbers = [10, 20, 30, 40, 50]\ntarget = 30\n\nfor num in numbers:\n    if num == target:\n        print(\"Found!\")\n        break\nelse:\n    print(\"Not Found\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jo check kare ki koi number prime hai ya nahi using for-else pattern. Hint: agar koi divisor mil gaya (2 se n-1 tak) toh break, else mein prime declare karo.',
        'hint': 'range(2, n) mein loop chalao. Agar n % i == 0 hai toh break. Else mein "Prime" print karo.',
        'solution': "n = int(input(\"Enter a number: \"))\nfor i in range(2, n):\n    if n % i == 0:\n        print(n, \"is not prime\")\n        break\nelse:\n    print(n, \"is prime\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek list of numbers lo. User se ek number input lo. For-else use karke check karo ki number list mein hai ya nahi. Agar hai toh uski index (counter variable se) bhi batao.',
        'hint': 'Ek counter variable index = 0 lo. For loop mein agar num == target ho toh index print karo aur break. Har iteration mein index += 1 karo.',
        'solution': "numbers = [10, 20, 30, 40, 50]\ntarget = int(input(\"Enter a number to search: \"))\n\nindex = 0\nfor num in numbers:\n    if num == target:\n        print(\"Found at index\", index)\n        break\n    index += 1\nelse:\n    print(\"Not found\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'for var in iterable: ... else: ...', 'example': 'for i in range(5): print(i) else: print("Done")', 'description': 'Else tab execute hota hai jab loop bina break ke complete ho'},
    ],
    'commonMistakes': [
      'For-else ko if-else samajh lena — else loop ka part hai, if ka nahi',
      'Else block ke indentation ka dhyaan na dena — else for ke same level par hona chahiye',
      'Break ke baad bhi else execute hone ki expect karna — aisa nahi hota, break else ko skip kar deta hai',
      'Else ko unnecessary jagah use karna — simple flag variable se bhi kaam chal sakta hai',
    ],
  };
}

Map<String, dynamic> topic7_5() {
  return {
    'id': 'topic_7_5',
    'name': 'break, continue, pass',
    'chapterId': 'chapter_7',
    'subjectId': 'python',
    'order': 30,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=15360',
    'keyPoints': [
      'break — loop ko turant terminate kar deta hai, loop ke bahar aa jata hai',
      'continue — current iteration skip karta hai aur agla iteration start karta hai',
      'pass — kuch nahi karta, placeholder ki tarah use hota hai. Syntax error nahi aane deta',
      'break ka use tab hota hai jab aapko condition milne par loop rokna hai',
      'continue ka use tab hota hai jab aap current iteration skip karke next par jana chahte ho',
      'pass ka use tab hota hai jab aap syntax ke liye empty block chhodna chahte ho (future implementation)',
      'break aur continue sirf loops mein kaam karte hain. Pass kahi bhi use kar sakte ho',
    ],
    'keyConcepts': [
      'break statement',
      'continue statement',
      'pass statement',
      'Loop control',
      'Placeholder',
      'Early exit',
    ],
    'aiCoachScript': '''Aakhri topic — break, continue, aur pass. Yeh teen statements hain jo loops ke flow ko control karte hain.

BREAK:
Break loop ko immediately terminate kar deta hai. Jaise hi Python break statement tak pahunchta hai, loop turant stop ho jata hai.

for i in range(10):
    if i == 5:
        break
    print(i)
# Output: 0, 1, 2, 3, 4 (5 par loop ruk gaya)

CONTINUE:
Continue current iteration ko skip karta hai aur next iteration par chala jata hai. Matlab — continue ke baad ki lines us iteration mein execute nahi hoti.

for i in range(10):
    if i == 5:
        continue
    print(i)
# Output: 0, 1, 2, 3, 4, 6, 7, 8, 9 (5 skip ho gaya)

PASS:
Pass kuch nahi karta. Yeh ek placeholder hai. Jab aap code future mein likhne wale ho lekin abhi empty block nahi chhod sakte (syntax error aayega), toh pass use karo.

for i in range(5):
    pass  # Baad mein implement karenge

Yaad rakho:
- break = poori loop ko rok do
- continue = current iteration skip karo, next par chalo
- pass = kuch mat karo (placeholder)
- break aur continue loops mein hi kaam karte hain. Pass kahi bhi — if, else, function — sab jagah.''',
    'codeExamples': [
      {
        'title': 'Break at 34',
        'code': "for i in range(100):\n    if i == 34:\n        break\n    print(i)",
        'explanation': 'Range 0 se 99 tak hai. Jab i 34 hota hai, break execute ho jata hai aur loop terminate ho jata hai. 0 se 33 tak print hoga, phir loop ruk jayega.',
        'output': '0\n1\n2\n...\n33',
      },
      {
        'title': 'Continue at 34',
        'code': "for i in range(40):\n    if i == 34:\n        continue\n    print(i)",
        'explanation': 'Range 0 se 39 tak. Jab i 34 hota hai, continue execute hota hai — woh iteration skip ho jati hai. 34 print nahi hoga, lekin 35, 36, 37, 38, 39 sab print honge.',
        'output': '0\n1\n2\n...\n33\n35\n36\n37\n38\n39',
      },
      {
        'title': 'Pass — Placeholder',
        'code': "for i in range(645):\n    pass  # Will implement later",
        'explanation': 'Pass kuch nahi karta. Sirf placeholder hai. Agar pass na likho toh for loop ke baad body nahi hogi — SyntaxError aayega. Pass se Python ko pata hai ki intentionally kuch nahi karna.',
        'output': '(No output — pass does nothing)',
      },
    ],
    'challenges': [
      {
        'question': 'For loop aur break ka use karke 1 se 100 tak numbers print karo, lekin jaise hi 50 aaye loop rok do.',
        'hint': 'range(1, 101) mein loop chalao, if i == 50: break.',
        'solution': "for i in range(1, 101):\n    if i == 50:\n        break\n    print(i)",
        'difficulty': 'easy',
      },
      {
        'question': 'For loop aur continue ka use karke 1 se 20 tak numbers print karo lekin multiples of 3 skip kar do.',
        'hint': 'i % 3 == 0 check karo, agar True hai toh continue karo.',
        'solution': "for i in range(1, 21):\n    if i % 3 == 0:\n        continue\n    print(i)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo prime numbers 1 se 50 tak find kare. Break ka use karo — jaise hi koi divisor mil jaye, break karo aur next number check karo. Continue nahi, break use karna hai!',
        'hint': 'Har number ke liye 2 se n-1 tak loop chalao. Agar n % i == 0 hai toh break (prime nahi). Agar loop normally complete ho (for-else) toh prime print karo.',
        'solution': "for num in range(2, 51):\n    for i in range(2, num):\n        if num % i == 0:\n            break\n    else:\n        print(num, \"is prime\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'break', 'example': 'if i == 5: break', 'description': 'Loop ko turant terminate karta hai'},
      {'syntax': 'continue', 'example': 'if i == 5: continue', 'description': 'Current iteration skip karta hai'},
      {'syntax': 'pass', 'example': 'if i == 5: pass', 'description': 'Kuch nahi karta — placeholder statement'},
    ],
    'commonMistakes': [
      'break and continue ko loops ke bahar use karna — SyntaxError aayega',
      'continue ke baad loop ka kuch code reh jana — woh skip ho jayega, dhyan rakho',
      'Pass ki jagah kuch nahi likhna — empty block allowed nahi, SyntaxError aayega',
      'Break aur continue ko else ke saath galat combine karna — else tabhi chalega jab loop bina break ke complete ho',
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
