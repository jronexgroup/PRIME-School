// Run: dart run scripts/seed_python_ch10.dart
// Seeds Python Ch 10: OOP (2 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 10...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_10', {
    'id': 'chapter_10',
    'subjectId': 'python',
    'name': 'Object Oriented Programming',
    'order': 10,
    'totalTopics': 2,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_10_1', 'chapterId': 'chapter_10', 'name': 'Classes & Objects', 'order': 36},
    {'topicId': 'topic_10_2', 'chapterId': 'chapter_10', 'name': 'Methods, __init__ & Attributes', 'order': 37},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic10_1(), topic10_2()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_10/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 10 seeded successfully.');
}

Map<String, dynamic> topic10_1() {
  return {
    'id': 'topic_10_1',
    'name': 'Classes & Objects',
    'chapterId': 'chapter_10',
    'subjectId': 'python',
    'order': 36,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=24147',
    'keyPoints': [
      'Class ek blueprint hota hai - jaise ghar ka blueprint, us blueprint se kitne bhi ghar bana sakte ho',
      'Object class ka ek real entity hai - jaise us blueprint se bana hua asli ghar',
      'class keyword se class define karte hain: class Employee:',
      'Class attributes directly class ke andar likhe jaate hain - saare objects share karte hain',
      'Instance attributes object ke specific hote hain - har object ka apna hota hai',
      'Dot notation (.) use karte hain object ke attributes access karne ke liye: harry.name',
      'Class attribute sab objects mein same rehta hai jab tak instance attribute override na kare',
      'Har object ka apna memory location hota hai - independent hote hain ek dusre se',
    ],
    'keyConcepts': [
      'Class (blueprint)',
      'Object (instance)',
      'Class attribute',
      'Instance attribute',
      'Dot notation',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Python mein Object Oriented Programming - yaani OOP.

Sabse pehle samajhte hain class aur object kya hota hai. Maan lo aapko ek ghar banana hai. Toh aap pehle ek blueprint banayenge - jisme likha hoga ki ghar mein kitne kamre hain, kitne darwaaze hain, kaisa design hai. Yeh blueprint hai CLASS.

Ab us blueprint se aap kitne bhi ghar bana sakte ho - ek ghar Red Fort style ka, ek ghar modern style ka. Har ghar ek OBJECT hai. Sab ghar usi blueprint se bane hain, lekin har ghar ka apna colour, apna furniture ho sakta hai.

Code mein dekhte hain:

class Employee:
    language = "Py"
    salary = 1200000

Yahan Employee ek class hai. language aur salary class attributes hain - yeh blueprint ka part hain.

Ab object banate hain:
harry = Employee()
harry.name = "Harry"

harry ek object hai Employee class ka. name = "Harry" ek instance attribute hai - sirf harry ke liye.

Aur rohan = Employee() se ek aur object bana. rohan.name = "Rohan Roro Robinson" - iska apna naam hai.

Toh dono objects mein language aur salary to same hai (class attributes), lekin name alag hai (instance attribute).

Ek important baat: jab aap likhte ho harry.language = "JavaScript", toh aap ek naya instance attribute bana rahe ho jo class attribute ko override karta hai. Lekin original class attribute waisa ka waisa rehta hai.

Class attribute = sabke liye same by default
Instance attribute = har object ka apna

Bahut simple hai na? Chalo ab agle topic mein methods aur constructor dekhenge!''',
    'codeExamples': [
      {
        'title': 'Basic Class with Objects',
        'code': "class Employee:\n    language = \"Py\"\n    salary = 1200000\n\nharry = Employee()\nharry.name = \"Harry\"\nprint(harry.name, harry.language, harry.salary)\n\nrohan = Employee()\nrohan.name = \"Rohan Roro Robinson\"\nprint(rohan.name, rohan.salary, rohan.language)",
        'explanation': 'Employee class mein language aur salary class attributes hain - saare objects mein same hain. name har object ka instance attribute hai jo alag-alag set kiya gaya hai. Dot notation se attributes access hote hain.',
        'output': 'Harry Py 1200000\nRohan Roro Robinson 1200000 Py',
      },
      {
        'title': 'Instance vs Class Attribute',
        'code': "class Employee:\n    language = \"Python\"\n    salary = 1200000\n\nharry = Employee()\nharry.language = \"JavaScript\"\nprint(harry.language, harry.salary)",
        'explanation': 'Jab harry.language = "JavaScript" likha, toh ek naya instance attribute bana jo class attribute "Python" ko override kar raha hai. Sirf harry object ke liye language ab JavaScript hai - class ka attribute nahi badla.',
        'output': 'JavaScript 1200000',
      },
    ],
    'challenges': [
      {
        'question': 'Ek Programmer class banao jiska company attribute "Microsoft" ho. Constructor mein name, salary aur pin initialize karo. Do objects banao - Harry aur Rohan - aur unki details print karo.',
        'hint': 'class Programmer: company = "Microsoft" likho. __init__ mein self.name, self.salary, self.pin set karo. p = Programmer("Harry", 1200000, 245001) se object banao.',
        'solution': "class Programmer:\n    company = \"Microsoft\"\n    def __init__(self, name, salary, pin):\n        self.name = name\n        self.salary = salary\n        self.pin = pin\n\np = Programmer(\"Harry\", 1200000, 245001)\nprint(p.name, p.salary, p.pin, p.company)\nr = Programmer(\"Rohan\", 1200000, 245001)\nprint(r.name, r.salary, r.pin, r.company)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek class Demo banao jisme class attribute a = 4 ho. Ek object o banao. Pehle o.a print karo (class attribute aayega). Phir o.a = 0 set karo aur phir se o.a print karo (instance attribute aayega). Phir Demo.a print karo (class attribute aayega). Samjhao kya ho raha hai.',
        'hint': 'Jab tak instance attribute nahi hota, Python class attribute use karta hai. Jaise hi aap o.a = value set karte ho, naya instance attribute ban jaata hai jo class attribute ko hide kar deta hai.',
        'solution': "class Demo:\n    a = 4\n\no = Demo()\nprint(o.a)  # Prints class attribute (4)\no.a = 0     # Instance attribute set\nprint(o.a)  # Prints instance attribute (0)\nprint(Demo.a)  # Prints class attribute (4)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek Library class banao jisme class attribute totalBooks = 0 ho. Har baar jab koi naya object bane, totalBooks increment ho. Har object ka apna bookName aur author ho. Do objects banao aur totalBooks print karo.',
        'hint': 'totalBooks ko class attribute rakho. __init__ mein Library.totalBooks += 1 karo. Har object mein self.bookName aur self.author set karo.',
        'solution': "class Library:\n    totalBooks = 0\n    def __init__(self, bookName, author):\n        self.bookName = bookName\n        self.author = author\n        Library.totalBooks += 1\n\nb1 = Library(\"Python Basics\", \"Harry\")\nb2 = Library(\"OOP Guide\", \"Rohan\")\nprint(b1.bookName, b1.author)\nprint(b2.bookName, b2.author)\nprint(\"Total books:\", Library.totalBooks)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'class ClassName:', 'example': 'class Employee:', 'description': 'Naya class define karta hai - class ka naam Capital letter se shuru karte hain'},
      {'syntax': 'object = ClassName()', 'example': 'harry = Employee()', 'description': 'Class se naya object (instance) create karta hai'},
      {'syntax': 'object.attribute', 'example': 'harry.name', 'description': 'Object ke attribute ko access ya assign karta hai (dot notation)'},
      {'syntax': 'class ClassName:\n    attribute = value', 'example': 'class Employee:\n    language = "Py"', 'description': 'Class attribute - saare objects share karte hain'},
    ],
    'commonMistakes': [
      'class keyword likhna bhoolna aur direct Employee(): likh dena - syntax error aayega',
      'Object banate time parentheses bhoolna: harry = Employee (wrong) vs harry = Employee() (correct)',
      'Class attribute ko instance attribute samajh kar change karna aur confuse ho jaana - dono alag hain',
    ],
  };
}

Map<String, dynamic> topic10_2() {
  return {
    'id': 'topic_10_2',
    'name': 'Methods, __init__ & Attributes',
    'chapterId': 'chapter_10',
    'subjectId': 'python',
    'order': 37,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=24480',
    'keyPoints': [
      'Method class ke andar ka function hota hai jo object ke saath associated hota hai',
      'self parameter method ka first parameter hota hai - object khud ko refer karta hai',
      'self ki jagah koi bhi naam de sakte ho (jaise slf, harry) - but convention self hi hai',
      '__init__ ek special method hai jo object banate hi automatically call hota hai',
      '__init__ ko constructor kehte hain - object ki initial setup karta hai',
      '@staticmethod decorator se aisa method banate hain jo self nahi leta',
      'Static methods class ya object ke data ko access nahi karte - independent hote hain',
      'Constructor ke parameters se object creation time par hi values pass kar sakte hain',
    ],
    'keyConcepts': [
      'Method (class function)',
      'self parameter',
      '__init__ constructor',
      '@staticmethod decorator',
      'Instance vs Class attributes',
    ],
    'aiCoachScript': '''Chalo ab baat karte hain methods aur __init__ constructor ki.

Method kya hota hai? Method ek function hai jo class ke andar likha jaata hai aur object ke saath associated hota hai. Jaise humare Employee class mein agar hume employee ki info print karni hai, toh hum ek method bana sakte hain.

Dekho code:

class Employee:
    language = "Python"
    salary = 1200000

    def getInfo(self):
        print(f"The language is {self.language}. The salary is {self.salary}")

    @staticmethod
    def greet():
        print("Good morning")

Yahan getInfo ek method hai. Isme self parameter hai - self ka matlab woh object jis par method call ho raha hai. Jaise harry.getInfo() call karenge, toh self = harry ho jaayega.

self ki jagah aap koi bhi naam de sakte ho. Maine dekha hai kuch log slf use karte hain, kuch apna naam use karte hain. Lekin convention hai self use karna - isse code readable rehta hai.

Ab aate hain __init__ par. Yeh ek special method hai jise constructor kehte hain. Jab bhi aap naya object banate ho, __init__ automatically call ho jaata hai.

def __init__(self, name, salary, language):
    self.name = name
    self.salary = salary
    self.language = language
    print("I am creating an object")

Ab object banate waqt aap values pass kar sakte ho:
harry = Employee("Harry", 1300000, "JavaScript")

Aur __init__ automatically un values ko set kar dega. No need to manually harry.name = "Harry" likhne ki.

@staticmethod dekho - yeh ek decorator hai. Iska matlab yeh method class ya object ke kisi bhi attribute ko access nahi karta. Bilkul independent hai. Jaise greet() method - bas "Good morning" print karta hai. Isme self nahi aata.

Toh recap:
- Method = class ke andar function
- self = object khud
- __init__ = constructor, automatically call hota hai
- @staticmethod = method jo self nahi leta''',
    'codeExamples': [
      {
        'title': 'Methods and @staticmethod',
        'code': "class Employee:\n    language = \"Python\"\n    salary = 1200000\n\n    def getInfo(self):\n        print(f\"The language is {self.language}. The salary is {self.salary}\")\n\n    @staticmethod\n    def greet():\n        print(\"Good morning\")\n\nharry = Employee()\nharry.greet()\nharry.getInfo()",
        'explanation': 'getInfo ek regular method hai jisme self parameter hai - yeh object ke attributes access karta hai. greet ek static method hai - isme self nahi hai aur yeh sirf ek independent message print karta hai. @staticmethod decorator se mark karte hain.',
        'output': 'Good morning\nThe language is Python. The salary is 1200000',
      },
      {
        'title': '__init__ Constructor',
        'code': "class Employee:\n    language = \"Python\"\n    salary = 1200000\n\n    def __init__(self, name, salary, language):\n        self.name = name\n        self.salary = salary\n        self.language = language\n        print(\"I am creating an object\")\n\n    def getInfo(self):\n        print(f\"The language is {self.language}. The salary is {self.salary}\")\n\nharry = Employee(\"Harry\", 1300000, \"JavaScript\")\nprint(harry.name, harry.salary, harry.language)",
        'explanation': '__init__ constructor object create hote hi call ho jaata hai. Isme hum name, salary aur language parameters pass karte hain. self.name = name se instance attributes set hote hain. Constructor ne class attributes ko override kar diya harry ke liye.',
        'output': 'I am creating an object\nHarry 1300000 JavaScript',
      },
    ],
    'challenges': [
      {
        'question': 'Ek Calculator class banao jo n number le. Usme square, cube aur squareroot methods ho. Ek @staticmethod hello() bhi ho jo "Hello there!" print kare. n = 4 ke liye sab methods call karo.',
        'hint': '__init__(self, n) mein self.n = n karo. square() mein self.n*self.n, cube() mein self.n*self.n*self.n, squareroot() mein self.n**1/2. @staticmethod se hello() define karo.',
        'solution': "class Calculator:\n    def __init__(self, n):\n        self.n = n\n    def square(self):\n        print(f\"The square is {self.n*self.n}\")\n    def cube(self):\n        print(f\"The cube is {self.n*self.n*self.n}\")\n    def squareroot(self):\n        print(f\"The squareroot is {self.n**1/2}\")\n    @staticmethod\n    def hello():\n        print(\"Hello there!\")\n\na = Calculator(4)\na.hello()\na.square()\na.cube()\na.squareroot()",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek Train class banao jisme trainNo ho. Usme book(fro, to), getStatus() aur getFare(fro, to) methods ho. getFare random fare generate kare 222 se 5555 ke beech mein. Train 12399 ke liye Rampur se Delhi tak book karo aur fare dekho.',
        'hint': 'from random import randint import karo. __init__ mein trainNo store karo. getFare mein randint(222, 5555) use karo. t = Train(12399) se object banao.',
        'solution': "from random import randint\n\nclass Train:\n    def __init__(self, trainNo):\n        self.trainNo = trainNo\n    def book(self, fro, to):\n        print(f\"Ticket is booked in train no: {self.trainNo} from {fro} to {to}\")\n    def getStatus(self):\n        print(f\"Train no: {self.trainNo} is running on time\")\n    def getFare(self, fro, to):\n        print(f\"Ticket fare in train no: {self.trainNo} from {fro} to {to} is {randint(222, 5555)}\")\n\nt = Train(12399)\nt.book(\"Rampur\", \"Delhi\")\nt.getStatus()\nt.getFare(\"Rampur\", \"Delhi\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Same Train class lo, lekin iss baar self ki jagah har ek method mein alag-alag parameter naam do - __init__ mein slf, book mein harry, getStatus mein self, getFare mein khud. Kya yeh kaam karega? Code likh kar test karo.',
        'hint': 'Python mein first parameter ka naam kuch bhi ho sakta hai - convention sirf self hai. Lekin agar aap slf ya harry ya kuch aur likhenge, tab bhi kaam karega. Jaise: def __init__(slf, trainNo): slf.trainNo = trainNo',
        'solution': "from random import randint\n\nclass Train:\n    def __init__(slf, trainNo):\n        slf.trainNo = trainNo\n    def book(harry, fro, to):\n        print(f\"Ticket is booked in train no: {harry.trainNo} from {fro} to {to}\")\n    def getStatus(self):\n        print(f\"Train no: {self.trainNo} is running on time\")\n    def getFare(self, fro, to):\n        print(f\"Ticket fare in train no: {self.trainNo} from {fro} to {to} is {randint(222, 5555)}\")\n\nt = Train(12399)\nt.book(\"Rampur\", \"Delhi\")\nt.getStatus()\nt.getFare(\"Rampur\", \"Delhi\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'def method_name(self):', 'example': 'def getInfo(self):', 'description': 'Method definition - self first parameter hota hai jo object ko refer karta hai'},
      {'syntax': 'def __init__(self, ...):', 'example': 'def __init__(self, name):', 'description': 'Constructor - object create hote hi automatically call hota hai'},
      {'syntax': '@staticmethod', 'example': '@staticmethod\ndef greet():', 'description': 'Decorator - static method banata hai jo self nahi leta'},
      {'syntax': 'object.method()', 'example': 'harry.getInfo()', 'description': 'Method call - dot notation se method call karte hain'},
    ],
    'commonMistakes': [
      'Method define karte time self parameter dena bhoolna - tab method call karte time extra argument error aata hai',
      '__init__ ko constructor ki jagah normal method ki tarah call karna - yeh automatically call hota hai',
      '@staticmethod bhool kar method mein self rakhna jab zaroorat nahi hai - isse confusion hoti hai',
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
