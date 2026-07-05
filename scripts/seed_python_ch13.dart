// Run: dart run scripts/seed_python_ch13.dart
// Seeds Python Ch 13: Advanced Python 2 (4 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 13...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_13', {
    'id': 'chapter_13',
    'subjectId': 'python',
    'name': 'Advanced Python 2',
    'order': 13,
    'totalTopics': 4,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_13_1', 'chapterId': 'chapter_13', 'name': 'Virtual Environments', 'order': 46},
    {'topicId': 'topic_13_2', 'chapterId': 'chapter_13', 'name': 'Lambda Functions', 'order': 47},
    {'topicId': 'topic_13_3', 'chapterId': 'chapter_13', 'name': 'String Methods', 'order': 48},
    {'topicId': 'topic_13_4', 'chapterId': 'chapter_13', 'name': 'map, filter, reduce', 'order': 49},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic13_1(), topic13_2(), topic13_3(), topic13_4()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_13/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 13 seeded successfully.');
}

Map<String, dynamic> topic13_1() {
  return {
    'id': 'topic_13_1',
    'name': 'Virtual Environments',
    'chapterId': 'chapter_13',
    'subjectId': 'python',
    'order': 46,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=32288',
    'keyPoints': [
      'Virtual environment ek isolated space hai jahan aap apne project ke dependencies install karte ho',
      'Har project ka apna virtual environment hota hai - doosre project se interfere nahi hota',
      'Virtual environment banane ke liye: python -m venv myenv',
      'Activate karne ke liye: Windows mein myenv\\Scripts\\activate, Mac/Linux mein source myenv/bin/activate',
      'Deactivate ke liye bas: deactivate command',
      'Virtual environment mein pip install karte ho toh woh sirf us environment mein install hota hai',
      'requirements.txt file saari dependencies ki list hoti hai - pip freeze > requirements.txt',
      'Kisi aur ke project mein jaake pip install -r requirements.txt se saare modules install ho jaate hain',
    ],
    'keyConcepts': [
      'Virtual environment (venv)',
      'Activation and deactivation',
      'requirements.txt',
      'pip freeze',
      'Dependency isolation',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Virtual Environments - jo professional Python development ka ek important part hai.

Dekho, maan lo aap do projects par kaam kar rahe ho. Ek project mein Django 3.2 use hota hai, aur doosre mein Django 4.0. Agar aap globally Django install karoge, toh conflict hoga.

Is problem ka solution hai Virtual Environment. Ye ek isolated space banata hai jahan aap apne project ke specific dependencies install kar sakte ho. Har project ka apna environment.

Virtual environment banane ka tarika:

1. Pehle folder mein jao jahan project hai
2. Command run karo: python -m venv myenv
3. Activate karo:
   - Windows: myenv\\Scripts\\activate
   - Mac/Linux: source myenv/bin/activate
4. Ab jo bhi pip install karoge, woh sirf is environment mein install hoga

Dekho prompt mein (myenv) dikhega - iska matlab environment active hai.

Jab environment active ho, tab:
pip install django

Yeh sirf is environment mein install hoga.

Saari dependencies ki list banao:
pip freeze > requirements.txt

Yeh file bhejo kisi aur ko. Woh:
pip install -r requirements.txt

Se saari dependencies ek saath install kar lega.

Environment band karne ke liye:
deactivate

Virtual environment use karo har project ke liye. Yeh best practice hai professional Python development mein.

Yaad rakho: (myenv) prompt mein dikhe toh environment active hai. Agar nahi dikhta toh activate karo pehle!''',
    'codeExamples': [
      {
        'title': 'Creating and Activating a Virtual Environment',
        'code': "# Create virtual environment\n# python -m venv myenv\n\n# Activate on Mac/Linux:\n# source myenv/bin/activate\n\n# Activate on Windows:\n# myenv\\Scripts\\activate\n\n# Now install packages\n# pip install requests\n\n# Check installed packages\n# pip list\n\n# Deactivate when done\n# deactivate",
        'explanation': 'python -m venv myenv ek folder banata hai jisme Python executable aur pip hota hai. Activate karne ke baad, aapka shell us folder ke Python aur pip ko use karta hai. Deactivate se aap wapas global environment mein aa jaate ho.',
        'output': '(myenv) user@computer:~/project\$ pip list\nPackage    Version\n---------- -------\npip        23.0.1\nsetuptools 67.6.0\n\n(myenv) user@computer:~/project\$ deactivate\nuser@computer:~/project\$',
      },
      {
        'title': 'Using requirements.txt',
        'code': "# After installing packages, save them:\n# pip freeze > requirements.txt\n\n# Contents of requirements.txt:\n# requests==2.31.0\n# django==4.2.0\n# numpy==1.24.3\n\n# Another developer installs all:\n# pip install -r requirements.txt\n\n# Python mein use karo:\nimport requests\n\nresponse = requests.get(\"https://api.github.com\")\nprint(response.status_code)",
        'explanation': 'pip freeze > requirements.txt se saare installed packages ki list file mein save ho jaati hai. pip install -r requirements.txt se ek baar mein saare packages install ho jaate hain. Yeh project share karne ke liye essential hai.',
        'output': '200',
      },
    ],
    'challenges': [
      {
        'question': 'Ek naya virtual environment banao "test_env" naam se, use activate karo, usme requests module install karo, aur phir pip freeze karke dikhao ki requests installed hai.',
        'hint': 'python -m venv test_env, source test_env/bin/activate (ya Windows ka command), pip install requests, pip freeze.',
        'solution': "# Terminal commands:\n# python -m venv test_env\n# source test_env/bin/activate\n# pip install requests\n# pip freeze\n# Output: requests==2.31.0\n\n# Verify in Python:\nimport requests\nprint(requests.__version__)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek project folder banao jisme do virtual environments ho - ek "dev" aur ek "test". Dev environment mein django install karo, test environment mein pytest. Dono ke pip freeze alag-alag hote hain ya same?',
        'hint': 'Do alag folders mein do environments banao. Ek mein django, doosre mein pytest install karo. Dono ke pip freeze karo - alag-alag packages dikhenge.',
        'solution': "# Terminal:\n# python -m venv dev_env\n# source dev_env/bin/activate\n# pip install django\n# pip freeze > dev_requirements.txt\n# deactivate\n\n# python -m venv test_env\n# source test_env/bin/activate\n# pip install pytest\n# pip freeze > test_requirements.txt\n# deactivate\n\n# dev_requirements.txt mein django hoga\n# test_requirements.txt mein pytest hoga",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek project do alag-alag computers par chal raha hai. Pehle computer par aapne requests aur numpy install kiye. requirements.txt banao, doosre computer par use karo. Ek script likho jo check kare ki saari dependencies installed hain ya nahi.',
        'hint': 'requirements.txt mein packages likho. Doosre computer par pip install -r requirements.txt. Check karne ke liye try-except se import karo.',
        'solution': "# requirements.txt:\n# requests\n# numpy\n\n# Check script:\nimport sys\n\nrequired = [\"requests\", \"numpy\"]\nmissing = []\n\nfor package in required:\n    try:\n        __import__(package)\n        print(f\"{package}: OK\")\n    except ImportError:\n        missing.append(package)\n        print(f\"{package}: MISSING\")\n\nif missing:\n    print(f\"\\nInstall missing packages: pip install {' '.join(missing)}\")\nelse:\n    print(\"\\nAll dependencies satisfied!\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'python -m venv env_name', 'example': 'python -m venv myenv', 'description': 'Naya virtual environment create karta hai'},
      {'syntax': 'source env/bin/activate', 'example': 'source myenv/bin/activate', 'description': 'Virtual environment activate karta hai (Mac/Linux)'},
      {'syntax': 'env\\Scripts\\activate', 'example': 'myenv\\Scripts\\activate', 'description': 'Virtual environment activate karta hai (Windows)'},
      {'syntax': 'pip freeze > requirements.txt', 'example': 'pip freeze > requirements.txt', 'description': 'Installed packages ki list file mein save karta hai'},
      {'syntax': 'pip install -r requirements.txt', 'example': 'pip install -r requirements.txt', 'description': 'File se saare packages install karta hai'},
    ],
    'commonMistakes': [
      'Virtual environment activate kiye bina packages install karna - global environment mein install ho jayenge',
      'requirements.txt ko manually edit karke versions galat likh dena - pip freeze use karo',
      'Virtual environment ko git mein commit kar dena - nahi karna chahiye, sirf requirements.txt commit karo',
    ],
  };
}

Map<String, dynamic> topic13_2() {
  return {
    'id': 'topic_13_2',
    'name': 'Lambda Functions',
    'chapterId': 'chapter_13',
    'subjectId': 'python',
    'order': 47,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=31320',
    'keyPoints': [
      'Lambda function ek anonymous function hai - jiska koi naam nahi hota',
      'Normal function def se banta hai, lambda function lambda keyword se',
      'Syntax: lambda arguments: expression - ek line mein function',
      'Lambda sirf ek expression leta hai, multiple statements nahi',
      'Lambda mostly short operations ke liye use hota hai',
      'Common use: sorting, filtering, map, reduce ke saath',
      'Lambda ko variable mein assign kar sakte ho - jaise add = lambda x, y: x + y',
      'Lambda expression ka result automatically return hota hai - return keyword ki zaroorat nahi',
    ],
    'keyConcepts': [
      'Lambda (anonymous function)',
      'lambda arguments: expression',
      'Inline function definition',
      'First-class functions',
      'Higher-order functions',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Lambda Functions - jinhe anonymous functions bhi kehte hain.

Lambda ek aisa function hai jiska koi naam nahi hota. Aap ise ek line mein define karte ho aur use karte ho. Chhoti chhoti operations ke liye perfect hai.

Normal function:
def add(x, y):
    return x + y

Lambda function:
lambda x, y: x + y

Dekha? Ek hi line mein kaam ho gaya. Lambda ka syntax hai:
lambda arguments: expression

Yahan expression ka result automatically return ho jata hai. Aap return keyword nahi likhte.

Lambda ko variable mein bhi assign kar sakte ho:
add = lambda x, y: x + y
print(add(5, 3))  # 8 print hoga

Lambda mostly tab use hota hai jab aapko kisi doosre function ko ek chhota sa function pass karna ho. Jaise sorted() mein:

students = [("Alice", 85), ("Bob", 92), ("Charlie", 78)]
sorted_by_marks = sorted(students, key=lambda x: x[1])

Yahan lambda function har student ka marks nikaalta hai jiske hisaab se sorted sort karega.

Lambda ka istemal karo jab:
1. Function bahut chhota ho (ek line mein aata ho)
2. Function sirf ek jagah use ho raha ho
3. Aap kisi higher-order function ko function pass kar rahe ho

Lekin agar function 2-3 lines ka hai, toh def use karo. Lambda complex code ke liye nahi hai.

Chalo ab examples dekhte hain!''',
    'codeExamples': [
      {
        'title': 'Lambda Basics',
        'code': "# Normal function\n\ndef square(x):\n    return x ** 2\n\n# Lambda function\nsquare_lambda = lambda x: x ** 2\n\nprint(\"Normal:\", square(5))\nprint(\"Lambda:\", square_lambda(5))\n\n# Lambda with multiple arguments\nadd = lambda a, b: a + b\nprint(\"Add:\", add(10, 20))\n\n# Lambda in one line (no variable)\nprint(\"Direct:\", (lambda x, y: x * y)(6, 7))",
        'explanation': 'Lambda function normal function ki tarah hi kaam karta hai lekin iska koi naam nahi hai. lambda x: x ** 2 ka matlab hai - x input lo aur x ** 2 return karo. Multiple arguments comma se separate hote hain. Lambda ko direct bhi call kar sakte ho bina variable assign kiye.',
        'output': 'Normal: 25\nLambda: 25\nAdd: 30\nDirect: 42',
      },
      {
        'title': 'Lambda with sorted()',
        'code': "students = [\n    {\"name\": \"Alice\", \"grade\": 85},\n    {\"name\": \"Bob\", \"grade\": 92},\n    {\"name\": \"Charlie\", \"grade\": 78},\n    {\"name\": \"Diana\", \"grade\": 95}\n]\n\n# Sort by grade ascending\nsorted_by_grade = sorted(students, key=lambda s: s[\"grade\"])\nprint(\"By grade (asc):\")\nfor s in sorted_by_grade:\n    print(f\"  {s['name']}: {s['grade']}\")\n\n# Sort by name descending\nsorted_by_name = sorted(students, key=lambda s: s[\"name\"], reverse=True)\nprint(\"By name (desc):\")\nfor s in sorted_by_name:\n    print(f\"  {s['name']}: {s['grade']}\")",
        'explanation': 'sorted() function ek key parameter leta hai jo sorting ka criteria define karta hai. Yahan lambda s: s["grade"] har student dictionary mein se grade nikaalta hai jiske hisaab se sorting hoti hai. reverse=True descending order ke liye. Lambda ek perfect use case hai yahan - chhota, ek line, sirf yahan use ho raha hai.',
        'output': "By grade (asc):\n  Charlie: 78\n  Alice: 85\n  Bob: 92\n  Diana: 95\nBy name (desc):\n  Diana: 95\n  Charlie: 78\n  Bob: 92\n  Alice: 85",
      },
    ],
    'challenges': [
      {
        'question': 'Ek lambda function likho jo do strings ko concatenate kare aur result return kare. Phir use "Hello" aur "World" ke saath call karke print karo.',
        'hint': 'concat = lambda a, b: a + " " + b. Phir concat("Hello", "World") call karo.',
        'solution': "concat = lambda a, b: a + \" \" + b\nresult = concat(\"Hello\", \"World\")\nprint(result)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek list of tuples hai: prices = [("Laptop", 800), ("Phone", 600), ("Tablet", 300), ("Monitor", 400)]. Lambda use karke sorted() se price ke hisaab se ascending order mein sort karo.',
        'hint': 'sorted(prices, key=lambda item: item[1]). item[1] price ko represent karta hai.',
        'solution': "prices = [(\"Laptop\", 800), (\"Phone\", 600), (\"Tablet\", 300), (\"Monitor\", 400)]\nsorted_prices = sorted(prices, key=lambda item: item[1])\nprint(sorted_prices)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek list of dictionaries hai: employees = [{"name": "Alice", "salary": 50000}, {"name": "Bob", "salary": 75000}, {"name": "Charlie", "salary": 60000}]. Lambda ka use karke max() se highest salary wala employee dhundho aur min() se lowest salary wala.',
        'hint': 'max(employees, key=lambda e: e["salary"]). min bhi same pattern hai.',
        'solution': "employees = [\n    {\"name\": \"Alice\", \"salary\": 50000},\n    {\"name\": \"Bob\", \"salary\": 75000},\n    {\"name\": \"Charlie\", \"salary\": 60000}\n]\n\nhighest = max(employees, key=lambda e: e[\"salary\"])\nlowest = min(employees, key=lambda e: e[\"salary\"])\n\nprint(f\"Highest: {highest['name']} with {highest['salary']}\")\nprint(f\"Lowest: {lowest['name']} with {lowest['salary']}\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'lambda args: expression', 'example': 'lambda x: x ** 2', 'description': 'Anonymous function - ek line mein function define karna'},
      {'syntax': 'sorted(iterable, key=lambda)', 'example': 'sorted(list, key=lambda x: x[1])', 'description': 'Lambda ko key function ki tarah use karna'},
      {'syntax': 'max(iterable, key=lambda)', 'example': 'max(dict_list, key=lambda x: x[\"score\"])', 'description': 'Lambda ke saath max/min functions'},
    ],
    'commonMistakes': [
      'Lambda mein multiple statements daalne ki koshish - lambda sirf ek expression leta hai, semicolon bhi kaam nahi karta',
      'Lambda ko variable mein store karna jab zaroorat nahi - agar ek baar use karna hai toh direct use karo',
      'Complex lambda likhna - 2-3 lines ka ho toh def use karo, lambda chhota aur simple hona chahiye',
    ],
  };
}

Map<String, dynamic> topic13_3() {
  return {
    'id': 'topic_13_3',
    'name': 'String Methods',
    'chapterId': 'chapter_13',
    'subjectId': 'python',
    'order': 48,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=31080',
    'keyPoints': [
      'Python mein strings ke saath kaam karne ke liye bahut saare built-in methods hain',
      'Upper/lower: str.upper(), str.lower(), str.capitalize(), str.title()',
      'Checking: str.isalpha(), str.isdigit(), str.isalnum(), str.isspace()',
      'Searching: str.find(), str.index(), str.count(), str.startswith(), str.endswith()',
      'Manipulation: str.replace(), str.strip(), str.split(), str.join()',
      'str.split() string ko list mein convert karta hai delimiter ke hisaab se',
      'str.join() list ko string mein convert karta hai, delimiter ke saath',
      'Strings immutable hote hain - methods naya string return karte hain, original change nahi hota',
    ],
    'keyConcepts': [
      'String methods',
      'String immutability',
      'split() and join()',
      'strip() and replace()',
      'isalpha(), isdigit(), isalnum()',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge String Methods - jo Python mein bahut powerful hain.

Strings ke saath kaam karte waqt aapko often manipulation karni padti hai - uppercase karna, lowercase karna, parts nikaalna, replace karna. Python ke paas bahut saare built-in methods hain yeh sab karne ke liye.

Chalo kuch important methods dekhte hain:

1. Case conversion:
   "hello".upper() -> "HELLO"
   "HELLO".lower() -> "hello"
   "hello world".title() -> "Hello World"

2. Checking:
   "123".isdigit() -> True
   "abc".isalpha() -> True
   "abc123".isalnum() -> True

3. Searching:
   "hello world".find("world") -> 6
   "hello".startswith("he") -> True
   "hello".count("l") -> 2

4. Manipulation:
   "  hello  ".strip() -> "hello"
   "hello world".replace("world", "Python") -> "hello Python"
   "a,b,c".split(",") -> ["a", "b", "c"]
   ", ".join(["a", "b", "c"]) -> "a, b, c"

Sabse important baat - strings immutable hote hain. Matlab koi bhi method original string change nahi karta. Woh ek naya string return karta hai.

Jaise:
text = "Hello"
text.upper()
print(text)  # Abhi bhi "Hello" print hoga

Upper ka result use karne ke liye:
text_upper = text.upper()

String methods seekh lo - data cleaning aur text processing mein bahut kaam aate hain.

Chalo ab examples dekhte hain!''',
    'codeExamples': [
      {
        'title': 'String Case Methods and Validation',
        'code': "text = \"  Python Programming is Fun!  \"\n\n# Case methods\nprint(\"Upper:\", text.upper())\nprint(\"Lower:\", text.lower())\nprint(\"Title:\", text.title())\nprint(\"Capitalize:\", text.strip().capitalize())\n\n# Validation methods\ndata1 = \"Hello123\"\ndata2 = \"12345\"\ndata3 = \"Python\"\nprint(f\"\\\"{data1}\\\" isalnum:\", data1.isalnum())\nprint(f\"\\\"{data2}\\\" isdigit:\", data2.isdigit())\nprint(f\"\\\"{data3}\\\" isalpha:\", data3.isalpha())",
        'explanation': 'upper() saare characters ko uppercase karta hai, lower() lowercase. title() har word ka first letter capital karta hai. strip() leading/trailing whitespace hataata hai. isalnum() check karta hai ki string mein sirf alphabets aur numbers hain. isdigit() sirf digits check karta hai. isalpha() sirf alphabets check karta hai.',
        'output': 'Upper:   PYTHON PROGRAMMING IS FUN! \nLower:   python programming is fun! \nTitle:   Python Programming Is Fun! \nCapitalize: Python programming is fun!\n"Hello123" isalnum: True\n"12345" isdigit: True\n"Python" isalpha: True',
      },
      {
        'title': 'split(), join(), replace(), and find()',
        'code': "csv_data = \"apple,banana,cherry,date\"\n\n# Split string into list\nfruits = csv_data.split(\",\")\nprint(\"Split:\", fruits)\n\n# Join list into string\nsentence = \" - \".join(fruits)\nprint(\"Join:\", sentence)\n\n# Replace\nphone = \"123-456-7890\"\nformatted = phone.replace(\"-\", \" \")\nprint(\"Replace:\", formatted)\n\n# Find\nmessage = \"Welcome to Python programming\"\nposition = message.find(\"Python\")\nprint(f\"'Python' found at index:\", position)\n\n# Check start/end\nprint(\"Starts with 'Welcome':\", message.startswith(\"Welcome\"))\nprint(\"Ends with 'programming':\", message.endswith(\"programming\"))",
        'explanation': 'split() string ko delimiter ke hisaab se list mein todta hai. join() list ke elements ko ek string mein jodta hai. replace() substring ko doosre substring se badalta hai. find() substring ki position return karta hai (ya -1 agar nahi mila). startswith/endswith boolean return karte hain.',
        'output': 'Split: [\"apple\", \"banana\", \"cherry\", \"date\"]\nJoin: apple - banana - cherry - date\nReplace: 123 456 7890\n\'Python\' found at index: 11\nStarts with \'Welcome\': True\nEnds with \'programming\': True',
      },
    ],
    'challenges': [
      {
        'question': 'User se ek sentence input lo aur usme har word ko capitalize karo (title case). Phir output do. Jaise "hello world" -> "Hello World".',
        'hint': 'input().title() use karo. Ya .split() karo, har word ko capitalize(), phir .join() karo.',
        'solution': "sentence = input(\"Enter a sentence: \")\nprint(\"Title case:\", sentence.title())",
        'difficulty': 'easy',
      },
      {
        'question': 'User se ek email address lo (jaise "user@example.com"). Split karo @ aur . ke hisaab se. Username, domain, aur extension alag-alag print karo. Jaise username="user", domain="example", extension="com".',
        'hint': 'Pehle "@" se split karo -> username aur rest. Phir rest ko "." se split karo -> domain aur extension.',
        'solution': "email = input(\"Enter email: \")\nusername, rest = email.split(\"@\")\ndomain, extension = rest.split(\".\")\nprint(f\"Username: {username}\")\nprint(f\"Domain: {domain}\")\nprint(f\"Extension: {extension}\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek paragraph lo jisme multiple spaces hain, extra whitespace hai, aur punctuations hain. Ek program likho jo: (1) extra spaces hata de (2) punctuations hata de (3) saare words ko lowercase kare (4) unique words ki alphabetically sorted list return kare.',
        'hint': 'import string; for p in string.punctuation: text = text.replace(p, ""). split() karo, set() use karo unique ke liye, sorted() use karo.',
        'solution': "import string\n\ntext = \"Hello!!! This is  a  sample... Text with  extra spaces & punctuation.\"\n\n# Remove punctuation\nfor p in string.punctuation:\n    text = text.replace(p, \"\")\n\n# Split, lowercase, unique, sort\nwords = sorted(set(text.lower().split()))\n\nprint(\"Cleaned unique words:\")\nprint(words)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'str.upper() / .lower() / .title()', 'example': '\"hello\".upper()', 'description': 'String case convert karta hai'},
      {'syntax': 'str.split(separator)', 'example': '\"a,b,c\".split(\",\")', 'description': 'String ko list mein split karta hai'},
      {'syntax': 'separator.join(list)', 'example': '\", \".join([\"a\", \"b\"])', 'description': 'List ko string mein join karta hai'},
      {'syntax': 'str.replace(old, new)', 'example': '\"hello\".replace(\"l\", \"w\")', 'description': 'Substring ko replace karta hai'},
      {'syntax': 'str.find(sub)', 'example': '\"hello\".find(\"el\")', 'description': 'Substring ki position return karta hai'},
    ],
    'commonMistakes': [
      'String methods original string modify karte hain yeh sochna - strings immutable hain, method naya string return karta hai',
      'split() aur join() ka order confuse karna - split string se list banata hai, join list se string banata hai',
      'Case-sensitive bhoolna - "Python".find("python") returns -1 kyunki case match nahi karta',
    ],
  };
}

Map<String, dynamic> topic13_4() {
  return {
    'id': 'topic_13_4',
    'name': 'map, filter, reduce',
    'chapterId': 'chapter_13',
    'subjectId': 'python',
    'order': 49,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=31080',
    'keyPoints': [
      'map() function har element par ek function apply karta hai aur naya iterator return karta hai',
      'Syntax: map(function, iterable) - jaise map(str.upper, ["a", "b"])',
      'filter() function un elements ko filter karta hai jo condition satisfy karte hain',
      'Syntax: filter(function, iterable) - function True/False return karega',
      'reduce() function elements ko accumulate karta hai ek single value mein',
      'reduce functools module mein hai - import karna padta hai: from functools import reduce',
      'Map aur filter list comprehension se bhi achieve kiye ja sakte hain',
      'Ye functions functional programming ka part hain - code concise banata hai',
    ],
    'keyConcepts': [
      'map() function',
      'filter() function',
      'reduce() function',
      'functools module',
      'Functional programming style',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge teen powerful functions - map, filter aur reduce.

Yeh functions functional programming style mein aate hain. Matlab aap ek function ko doosre function par pass karte ho.

Pehle baat karte hain map() ki.

Map ka kaam hai - ek iterable ke har element par ek function apply karna. Jaise:

numbers = [1, 2, 3, 4]
squares = list(map(lambda x: x ** 2, numbers))
print(squares)  # [1, 4, 9, 16]

Yahan map ne har number par lambda function apply kiya. Result ek map object hai, isliye list() mein convert karna padta hai.

Ab filter() ki baat:

Filter un elements ko nikaalta hai jo condition satisfy karte hain. Jaise:

numbers = [1, 2, 3, 4, 5, 6]
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # [2, 4, 6]

Yahan filter ne sirf woh numbers rakhe jinke liye lambda ne True return kiya.

Ab reduce() ki baat. Yeh sabse interesting hai.

Reduce ek iterable ke elements ko accumulate karta hai ek single value mein. Jaise saare numbers ka sum:

from functools import reduce
numbers = [1, 2, 3, 4]
total = reduce(lambda a, b: a + b, numbers)
print(total)  # 10

Yahan reduce pehle 1 + 2 = 3 karega, phir 3 + 3 = 6, phir 6 + 4 = 10.

Map aur filter ko aap list comprehension se bhi kar sakte ho. Reduce ka koi direct alternative nahi hai.

Yeh functions code ko concise aur readable banate hain. Functional programming style mein likhna seekho - bahut kaam aayega!

Chalo ab examples dekhte hain!''',
    'codeExamples': [
      {
        'title': 'map() Function',
        'code': "numbers = [1, 2, 3, 4, 5]\n\n# Using map with lambda\nsquared = list(map(lambda x: x ** 2, numbers))\nprint(\"Squared:\", squared)\n\n# Map with existing function\nstr_numbers = list(map(str, numbers))\nprint(\"Strings:\", str_numbers)\n\n# Map with multiple iterables\na = [1, 2, 3]\nb = [4, 5, 6]\nsummed = list(map(lambda x, y: x + y, a, b))\nprint(\"Summed:\", summed)\n\n# Equivalent list comprehension\nsquared_lc = [x ** 2 for x in numbers]\nprint(\"LC Squared:\", squared_lc)",
        'explanation': 'map() pehla argument function leta hai, doosra iterable. Har element par function apply hota hai. str existing function hai jo number ko string mein convert karta hai. Map multiple iterables bhi le sakta hai - tab function ko utne hi arguments chahiye. List comprehension map ka alternative hai.',
        'output': 'Squared: [1, 4, 9, 16, 25]\nStrings: [\'1\', \'2\', \'3\', \'4\', \'5\']\nSummed: [5, 7, 9]\nLC Squared: [1, 4, 9, 16, 25]',
      },
      {
        'title': 'filter() Function',
        'code': "numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\n\n# Filter even numbers\nevens = list(filter(lambda x: x % 2 == 0, numbers))\nprint(\"Evens:\", evens)\n\n# Filter numbers greater than 5\ngreater = list(filter(lambda x: x > 5, numbers))\nprint(\"Greater than 5:\", greater)\n\n# Filter with strings\nwords = [\"apple\", \"hi\", \"python\", \"ok\", \"amazing\"]\nlong_words = list(filter(lambda w: len(w) > 3, words))\nprint(\"Long words:\", long_words)\n\n# Equivalent list comprehension\nevens_lc = [x for x in numbers if x % 2 == 0]\nprint(\"LC Evens:\", evens_lc)",
        'explanation': 'filter() un elements ko leta hai jinke liye function True return karta hai. Lambda condition check karta hai. filter bhi iterator return karta hai, isliye list() mein convert karte hain. Strings ke saath bhi kaam karta hai - yahan length 3 se zyada wale words filter kiye.',
        'output': 'Evens: [2, 4, 6, 8, 10]\nGreater than 5: [6, 7, 8, 9, 10]\nLong words: [\'apple\', \'python\', \'amazing\']\nLC Evens: [2, 4, 6, 8, 10]',
      },
      {
        'title': 'reduce() Function',
        'code': "from functools import reduce\n\nnumbers = [1, 2, 3, 4, 5]\n\n# Sum all numbers\ntotal = reduce(lambda a, b: a + b, numbers)\nprint(\"Sum:\", total)\n\n# Find maximum\nmaximum = reduce(lambda a, b: a if a > b else b, numbers)\nprint(\"Max:\", maximum)\n\n# Factorial using reduce\nfact = reduce(lambda a, b: a * b, range(1, 6))\nprint(\"5! =\", fact)\n\n# Reduce with initial value\ntotal_with_init = reduce(lambda a, b: a + b, numbers, 10)\nprint(\"Sum + 10:\", total_with_init)",
        'explanation': 'reduce functools module mein hai. Pehle do elements par function apply hota hai, phir result aur next element par, aage badhta hai. Sum ke liye lambda a, b: a + b. Max ke liye lambda dono mein se bada return karta hai. Initial value de sakte ho jo pehle element ki tarah treat hoti hai.',
        'output': 'Sum: 15\nMax: 5\n5! = 120\nSum + 10: 25',
      },
    ],
    'challenges': [
      {
        'question': 'Ek list of integers lo [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]. Filter karo sirf odd numbers, phir map se unka square nikaalo, phir reduce se sum calculate karo.',
        'hint': 'filter(lambda x: x % 2 != 0) phir map(lambda x: x**2) phir reduce(lambda a, b: a + b).',
        'solution': "from functools import reduce\n\nnumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\n\nodds = list(filter(lambda x: x % 2 != 0, numbers))\nsquares = list(map(lambda x: x ** 2, odds))\ntotal = reduce(lambda a, b: a + b, squares)\n\nprint(f\"Odd numbers: {odds}\")\nprint(f\"Squares of odds: {squares}\")\nprint(f\"Sum of squares: {total}\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek list of strings lo ["apple", "banana", "cherry", "date", "elderberry"]. Map se har string ki length nikaalo. Filter se sirf woh length rakho jo 5 se zyada hain. Reduce se unki average length nikaalo.',
        'hint': 'map(len, words). filter(lambda x: x > 5, lengths). reduce(lambda a, b: a + b, filtered) / len(filtered).',
        'solution': "from functools import reduce\n\nwords = [\"apple\", \"banana\", \"cherry\", \"date\", \"elderberry\"]\n\nlengths = list(map(len, words))\nlong_lengths = list(filter(lambda x: x > 5, lengths))\navg = reduce(lambda a, b: a + b, long_lengths) / len(long_lengths)\n\nprint(f\"Lengths: {lengths}\")\nprint(f\"Long lengths (>5): {long_lengths}\")\nprint(f\"Average: {avg:.2f}\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Students ki list hai jisme dictionaries hain: [{"name": "Alice", "marks": [80, 90, 85]}, {"name": "Bob", "marks": [70, 65, 75]}, {"name": "Charlie", "marks": [95, 92, 98]}]. Map use karke har student ka average marks nikaalo. Filter use karke sirf unhe rakho jinka average 80+ ho. Reduce use karke unke averages ka maximum nikaalo.',
        'hint': 'Har student ke marks ka average nikaalne ke liye map mein lambda. Filter mein lambda x > 80. Reduce mein max function.',
        'solution': "from functools import reduce\n\nstudents = [\n    {\"name\": \"Alice\", \"marks\": [80, 90, 85]},\n    {\"name\": \"Bob\", \"marks\": [70, 65, 75]},\n    {\"name\": \"Charlie\", \"marks\": [95, 92, 98]}\n]\n\n# Calculate averages using map\naverages = list(map(lambda s: {\"name\": s[\"name\"], \"avg\": sum(s[\"marks\"]) / len(s[\"marks\"])}, students))\nprint(\"Averages:\", averages)\n\n# Filter students with avg >= 80\ntoppers = list(filter(lambda s: s[\"avg\"] >= 80, averages))\nprint(\"Toppers:\", toppers)\n\n# Find max average using reduce\nmax_avg = reduce(lambda a, b: a if a[\"avg\"] > b[\"avg\"] else b, toppers)\nprint(f\"Top performer: {max_avg['name']} with {max_avg['avg']:.2f}\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'map(function, iterable)', 'example': 'map(lambda x: x*2, [1,2,3])', 'description': 'Har element par function apply karta hai'},
      {'syntax': 'filter(function, iterable)', 'example': 'filter(lambda x: x>0, [-1, 2, -3, 4])', 'description': 'Condition satisfy karne wale elements filter karta hai'},
      {'syntax': 'reduce(function, iterable, initial)', 'example': 'reduce(lambda a,b: a+b, [1,2,3])', 'description': 'Elements ko accumulate karta hai single value mein'},
      {'syntax': 'from functools import reduce', 'example': 'from functools import reduce', 'description': 'Reduce import karna zaroori hai - built-in nahi hai'},
    ],
    'commonMistakes': [
      'reduce() ko bina import kiye use karna - reduce functools module mein hai, built-in nahi hai',
      'map() ya filter() ka result directly print karna - yeh iterator hote hain, list() mein convert karna padta hai',
      'map aur filter mein lambda ki jagah function mein parentheses laga dena - map(func(), list) nahi, map(func, list)',
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
