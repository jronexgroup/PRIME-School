// Run: dart run scripts/seed_python_ch8.dart
// Seeds Python Ch 8: Functions & Recursion (2 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 8...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_8', {
    'id': 'chapter_8',
    'subjectId': 'python',
    'name': 'Functions & Recursion',
    'order': 8,
    'totalTopics': 2,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_8_1', 'chapterId': 'chapter_8', 'name': 'Defining Functions', 'order': 31},
    {'topicId': 'topic_8_2', 'chapterId': 'chapter_8', 'name': 'Recursion', 'order': 32},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic8_1(), topic8_2()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_8/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 8 seeded successfully.');
}

Map<String, dynamic> topic8_1() {
  return {
    'id': 'topic_8_1',
    'name': 'Defining Functions',
    'chapterId': 'chapter_8',
    'subjectId': 'python',
    'order': 31,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=17467',
    'keyPoints': [
      'Function code ka reusable block hota hai - ek baar define karo, baar-baar use karo',
      'Function define karne ke liye def keyword use hota hai, uske baad function name aur parentheses',
      'Function call tab hota hai jab aap function_name() likhte ho - tabhi andar ka code execute hota hai',
      'Parameters variables hote hain jo function definition mein likhe jaate hain',
      'Arguments actual values hote hain jo hum function call mein pass karte hain',
      'Return statement function se value wapas bhejta hai caller ke paas',
      'Default arguments allow karte hain ki agar koi value na do toh default value use ho',
      'Function ke bina same code baar-baar likhna padta hai - DRY principle violate hota hai',
      'Aap ek function ko jitni baar chahe call kar sakte ho - reuse ka yahi magic hai',
    ],
    'keyConcepts': [
      'def keyword',
      'Function definition vs function call',
      'Parameters and Arguments',
      'return statement',
      'Default arguments',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Python functions ke baare mein.

Function kya hota hai? Function ek code ka block hota hai jo ek specific kaam karta hai. Aur sabse acchi baat - aap ise ek baar define karo aur jitni baar chahe call karo.

Ab imagine karo, tumhe 3 numbers ka average nikalna hai. Bina function ke tumhe har baar wahi code likhna padega:
a = int(input())
b = int(input())
c = int(input())
average = (a + b + c) / 3
print(average)

Agar tumhe 5 jagah average chahiye, toh yeh code 5 baar copy-paste karna padega. But function se:

def avg():
    a = int(input("Enter your number: "))
    b = int(input("Enter your number: "))
    c = int(input("Enter your number: "))
    average = (a + b + c) / 3
    print(average)

Aur phir jitni baar chahe: avg(), avg(), avg() call karo. Dekho kitna simple ho gaya!

Function define karne ka syntax:
def function_name(parameters):
    # code
    return value

def keyword se function start hota hai. Uske baad name. Phir parentheses mein parameters. Colon lagao. Andar indentation ke saath code likho.

Parameters special hote hain - yeh input hote hain jo function leta hai. Jaise:
def goodDay(name, ending):
    print("Good Day, " + name)
    print(ending)

Yahan name aur ending parameters hain. Jab aap call karte ho goodDay("Harry", "Thank you"), toh "Harry" name mein jaata hai aur "Thank you" ending mein.

Aur default arguments? Agar chahte ho ki ending ka default "Thank you" ho toh:
def goodDay(name, ending="Thank you"):
- Agar aap ending do, toh woh use hoga
- Agar na do, toh "Thank you" default use hoga

Return keyword function se value wapas bhejta hai. Jaise:
def goodDay(name, ending):
    print("Good Day, " + name)
    print(ending)
    return "ok"

a = goodDay("Harry", "Thank you")
print(a)  # Yeh "ok" print karega

Yaad rakho:
- def -> function define
- name() -> function call
- Parameters -> input variables
- return -> output value
- Default arguments -> optional values

Functions se code chhota, readable aur reusable ban jaata hai. Practice karo, functions ke master ban jao!''',
    'codeExamples': [
      {
        'title': 'Basic Function - Average Calculator',
        'code': "def avg():\n"
            "    a = int(input('Enter your number: '))\n"
            "    b = int(input('Enter your number: '))\n"
            "    c = int(input('Enter your number: '))\n"
            "    average = (a + b + c) / 3\n"
            "    print(average)\n\n"
            "avg()\n"
            "print('Thank you!')\n"
            "avg()\n"
            "avg()",
        'explanation': 'Yahan humne avg() naam ka function banaya hai jo 3 numbers ka average nikalta hai. Ek baar define karne ke baad hum ise teen baar call kar rahe hain. Har call par user se naye input lete hain aur output dete hain.',
        'output': "Enter your number: 10\nEnter your number: 20\nEnter your number: 30\n20.0\nThank you!\nEnter your number: 5\nEnter your number: 6\nEnter your number: 7\n6.0",
      },
      {
        'title': 'Function with Parameters and Return',
        'code': "def goodDay(name, ending):\n"
            "    print('Good Day, ' + name)\n"
            "    print(ending)\n"
            "    return 'ok'\n\n"
            "a = goodDay('Harry', 'Thank you')\n"
            "print(a)",
        'explanation': "goodDay() function do parameters leta hai - name aur ending. Yeh ek value return karta hai ('ok') jo variable 'a' mein store hoti hai. Parameters function ko input provide karte hain aur return value output provide karti hai.",
        'output': "Good Day, Harry\nThank you\nok",
      },
      {
        'title': 'Default Arguments',
        'code': "def goodDay(name, ending='Thank you'):\n"
            "    print(f'Good Day, {name}')\n"
            "    print(ending)\n\n"
            "goodDay('Harry', 'Thanks')\n"
            "goodDay('Rohan')",
        'explanation': 'Yahan ending parameter ka default value "Thank you" hai. Pehli call mein hum "Thanks" pass kar rahe hain jo default ko override karta hai. Dusri call mein sirf name diya hai, toh ending apne default "Thank you" se kaam karta hai.',
        'output': "Good Day, Harry\nThanks\nGood Day, Rohan\nThank you",
      },
    ],
    'challenges': [
      {
        'question': 'Teen numbers ka greatest kaise nikaaloge? Ek function likho jo 3 numbers lekar unme se sabse bada number return kare.',
        'hint': 'if-elif-else use karo. Pehle check karo ki a, b se bada hai aur a, c se bada hai. Agar nahi toh b check karo. Warna c return karo.',
        'solution': "def greatest(a, b, c):\n"
            "    if(a > b and a > c):\n"
            "        return a\n"
            "    elif(b > a and b > c):\n"
            "        return b\n"
            "    else:\n"
            "        return c\n\n"
            "print(greatest(1, 23, 3))",
        'difficulty': 'easy',
      },
      {
        'question': 'Fahrenheit to Celsius converter function likho. Formula: C = 5*(F-32)/9. Output ko 2 decimal places tak round karo.',
        'hint': 'round() function use karo 2 decimal places ke liye. Jaise round(c, 2). Pehle input ko int() mein convert karo.',
        'solution': "def f_to_c(f):\n"
            "    return 5 * (f - 32) / 9\n\n"
            "f = int(input('Enter temperature in F: '))\n"
            "c = f_to_c(f)\n"
            "print(round(c, 2), 'C')",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek function likho jo inches ko centimeters mein convert kare. 1 inch = 2.54 cm. User se input lo aur result print karo.',
        'hint': 'Simple multiplication: inch * 2.54. Function ko inch parameter do aur woh return kare centimeters.',
        'solution': "def inch_to_cms(inch):\n"
            "    return inch * 2.54\n\n"
            "n = int(input('Enter value in inches: '))\n"
            "print('The corresponding value in cms is', inch_to_cms(n))",
        'difficulty': 'easy',
      },
    ],
    'importantSyntax': [
      {'syntax': 'def function_name():', 'example': 'def greet():', 'description': 'Function define karne ke liye def keyword. Colon aur indentation mandatory hai.'},
      {'syntax': 'function_name()', 'example': 'greet()', 'description': 'Function call karne ke liye name ke baad parentheses lagao.'},
      {'syntax': 'def function(param1, param2):', 'example': 'def add(a, b):', 'description': 'Function with parameters - input values jo function leta hai.'},
      {'syntax': 'return value', 'example': 'return a + b', 'description': 'Function se value wapas bhejta hai caller ko.'},
      {'syntax': 'def function(param=default):', 'example': "def greet(name=\"User\"):", 'description': 'Default argument - agar value na do toh default use hota hai.'},
    ],
    'commonMistakes': [
      'Function define karte time colon (:) bhoolna - SyntaxError aayega',
      'Indentation sahi na rakhna - Python indentation se blocks identify karta hai',
      'Function call karte time parentheses bhoolna - greet likhoge toh function object print hoga, execute nahi hoga',
      'Return value capture karna bhoolna - agar function return kar raha hai toh variable mein store karo warna output dikhega nahi',
      'Default arguments ko non-default arguments ke baad rakhna bhoolna - SyntaxError',
    ],
  };
}

Map<String, dynamic> topic8_2() {
  return {
    'id': 'topic_8_2',
    'name': 'Recursion',
    'chapterId': 'chapter_8',
    'subjectId': 'python',
    'order': 32,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=18600',
    'keyPoints': [
      'Recursion tab hoti hai jab function khud ko hi call karta hai - function ke andar wahi function',
      'Har recursive function mein ek base case hona chahiye - rukne ki condition, warna infinite loop',
      'Base case ke bina recursion kabhi nahi rukta - stack overflow error aayega',
      'Recursion complex problems ko chhoti sub-problems mein tod deta hai',
      'factorial(n) = n * factorial(n-1) - recursion ka classic example',
      'factorial(0) = 1 aur factorial(1) = 1 - yeh base cases hain',
      'Har recursive call ke saath problem ka size chhota hota jaata hai, eventually base case tak',
      'Recursion mein memory zyada lagti hai - har function call stack mein save hota hai',
      'Python mein recursion depth ki limit hoti hai (~1000) - uske baad RecursionError',
    ],
    'keyConcepts': [
      'Recursion',
      'Base case',
      'Recursive case / Recursive call',
      'Call stack',
      'Stack overflow',
    ],
    'aiCoachScript': '''Chalo doston, ab baat karte hain recursion ki - ek interesting aur powerful concept.

Recursion kya hai? Simple words mein - jab ek function khud ko hi call karta hai. Function ke andar wahi function dobara call ho jaata hai.

Lekin rukna bhi zaroori hai. Har recursive function mein do cheezein honi chahiye:
1. Base case - rukne ki condition
2. Recursive case - jahan function khud ko call karta hai

Samajhte hain factorial se:

factorial(5) = 5 * 4 * 3 * 2 * 1
Aur yeh likh sakte hain: factorial(5) = 5 * factorial(4)
factorial(4) = 4 * factorial(3)
factorial(3) = 3 * factorial(2)
factorial(2) = 2 * factorial(1)
factorial(1) = 1 - yeh humara base case hai

Code dekhte hain:
def factorial(n):
    if(n == 1 or n == 0):
        return 1
    return n * factorial(n-1)

Dekho - factorial(n) call karta hai factorial(n-1) ko. Aur aise hota-hota yeh factorial(1) tak pahunchta hai, jahan base case milta hai aur recursion ruk jaata hai.

Ab recursion kaise kaam karta hai internally? Stack ke through. Har function call stack mein push hota hai. Jab base case reach hota hai, tab stack unwinding hoti hai - ek-ek karke values return hoti hain.

factorial(5) stack:
factorial(5) -> 5 * factorial(4) -> 4 * factorial(3) -> 3 * factorial(2) -> 2 * factorial(1) -> 1
Phir wapas: 1 return -> 2*1=2 return -> 3*2=6 return -> 4*6=24 return -> 5*24=120 return

Aur final answer: 120.

Kuch problems aisi hain jo recursion se naturally solve hoti hain - jaise tree traversal, backtracking, divide-and-conquer algorithms.

Lekin yaad rakho: recursion hamesha sabse efficient nahi hota. Kabhi-kabhi loops better hote hain. But concept important hai - aage advanced data structures mein recursion bahut kaam aayega.

Base case mat bhoolna! Warna Stack Overflow - aur Python dega RecursionError. To recursion ko samjho, practice karo, aur maza lo!''',
    'codeExamples': [
      {
        'title': 'Factorial using Recursion',
        'code': "def factorial(n):\n"
            "    if(n == 1 or n == 0):\n"
            "        return 1\n"
            "    return n * factorial(n - 1)\n\n"
            "n = int(input('Enter a number: '))\n"
            "print(f'The factorial of this number is: {factorial(n)}')",
        'explanation': 'factorial(n) khud ko call karta hai n-1 ke saath. Jab n=1 hota hai, base case return 1 karta hai aur recursion ruk jaata hai. Stack unwinding hoti hai aur final result calculate hota hai.',
        'output': "Enter a number: 5\nThe factorial of this number is: 120",
      },
      {
        'title': 'Sum of n Natural Numbers using Recursion',
        'code': "def sum(n):\n"
            "    if(n == 1):\n"
            "        return 1\n"
            "    return sum(n - 1) + n\n\n"
            "print(sum(4))",
        'explanation': 'sum(n) = sum(n-1) + n. Base case: sum(1) = 1. Sum of 4 = 1+2+3+4 = 10. Har recursive call n ko ghatata hai jab tak 1 na pahunch jaaye.',
        'output': "10",
      },
      {
        'title': 'Print Pattern using Recursion',
        'code': "def pattern(n):\n"
            "    if(n == 0):\n"
            "        return\n"
            "    print('*' * n)\n"
            "    pattern(n - 1)\n\n"
            "pattern(3)",
        'explanation': 'pattern(n) pehle n stars print karta hai, phir pattern(n-1) call karta hai. Jaise-jaise n ghatta hai, stars ki count bhi ghatti hai. Jab n=0 hota hai, base case return kar deta hai.',
        'output': "***\n**\n*",
      },
    ],
    'challenges': [
      {
        'question': 'Ek recursive function likho jo first n natural numbers ka sum return kare. Jaise n=4 hai toh 1+2+3+4 = 10.',
        'hint': 'Base case: sum(1) = 1. Recursive case: sum(n) = sum(n-1) + n. Har call mein n ek kam hota hai.',
        'solution': "def sum(n):\n"
            "    if(n == 1):\n"
            "        return 1\n"
            "    return sum(n - 1) + n\n\n"
            "print(sum(4))",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek recursive function likho jo pattern print kare. Jaise n=3 hai toh output aaye: ***, **, * (har line mein ek star kam).',
        'hint': "Base case: n=0 hai toh return. Pehle n stars print karo '*', phir pattern(n-1) call karo. '*' * n se n stars ka string banta hai.",
        'solution': "def pattern(n):\n"
            "    if(n == 0):\n"
            "        return\n"
            "    print('*' * n)\n"
            "    pattern(n - 1)\n\n"
            "pattern(3)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek recursive function likho jo Fibonacci series ka nth term return kare. Fibonacci: 0, 1, 1, 2, 3, 5, 8, 13... Base cases: fib(0)=0, fib(1)=1.',
        'hint': 'Fibonacci formula: fib(n) = fib(n-1) + fib(n-2). Do base cases: n=0 return 0, n=1 return 1. Do recursive calls - ek n-1 ke liye aur ek n-2 ke liye.',
        'solution': "def fibonacci(n):\n"
            "    if(n == 0):\n"
            "        return 0\n"
            "    elif(n == 1):\n"
            "        return 1\n"
            "    return fibonacci(n - 1) + fibonacci(n - 2)\n\n"
            "print(fibonacci(7))",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'def func(n): ... func(n-1)', 'example': 'def fact(n): return n * fact(n-1)', 'description': 'Recursive function - khud ko hi call karta hai chhote input ke saath'},
      {'syntax': 'if(condition): return base_value', 'example': 'if(n==1): return 1', 'description': 'Base case - recursion ko rokne ke liye condition'},
      {'syntax': 'Recursive case', 'example': 'return n * fact(n-1)', 'description': 'Jahan function khud ko call karta hai, problem size ghatata hai'},
    ],
    'commonMistakes': [
      'Base case bhoolna - recursion kabhi nahi rukega, stack overflow hoga',
      'Base case sahi define na karna - jaise factorial mein n=1 aur n=0 dono handle karne hain',
      'Har recursive call mein problem size ghatana bhoolna - infinite recursion hoga',
      'Zyaada deep recursion (1000+) - Python RecursionError dega, loops use karo',
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
