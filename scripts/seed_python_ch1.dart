// Run: dart run scripts/seed_python_ch1.dart
// Seeds Python Ch 1: Modules, Comments & pip (5 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 1...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_1', {
    'id': 'chapter_1',
    'subjectId': 'python',
    'name': 'Modules, Comments & pip',
    'order': 1,
    'totalTopics': 5,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_1_1', 'chapterId': 'chapter_1', 'name': 'First Python Program', 'order': 1},
    {'topicId': 'topic_1_2', 'chapterId': 'chapter_1', 'name': 'Understanding Modules', 'order': 2},
    {'topicId': 'topic_1_3', 'chapterId': 'chapter_1', 'name': 'pip Package Manager', 'order': 3},
    {'topicId': 'topic_1_4', 'chapterId': 'chapter_1', 'name': 'Python as Calculator (REPL)', 'order': 4},
    {'topicId': 'topic_1_5', 'chapterId': 'chapter_1', 'name': 'Comments in Python', 'order': 5},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic1_1(), topic1_2(), topic1_3(), topic1_4(), topic1_5()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_1/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 1 seeded successfully.');
}

Map<String, dynamic> topic1_1() {
  return {
    'id': 'topic_1_1',
    'name': 'First Python Program',
    'chapterId': 'chapter_1',
    'subjectId': 'python',
    'order': 1,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=638',
    'keyPoints': [
      'Python ek programming language hai jo computer se baat karne ke liye use hoti hai',
      'VS Code ek editor hai jisme hum code likhte hain - Notepad se better hai features ki wajah se',
      '.py extension Python script ko represent karta hai, jaise .mp4 video ke liye',
      'print() function screen par kuch bhi display karne ke liye use hota hai',
      'Program run karne ke liye terminal mein "python filename.py" type karte hain',
      'Output wahi cheez hoti hai jo program run karne ke screen par dikhti hai',
      'Autosave on rakhna important hai taki code automatically save hota rahe',
      'Python interpreter aapke code ko machine language mein convert karta hai jo computer samajhta hai',
    ],
    'keyConcepts': [
      'print() function',
      '.py extension',
      'Python interpreter',
      'VS Code editor',
      'Terminal / Command Line',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge apna first Python program kaise likhte hain.

Dekho, Python ek programming language hai. Jaise hum Hindi ya English mein baat karte hain, waise hi computer se baat karne ke liye hum programming language use karte hain. Python bilkul simple English jaisa lagta hai — isiliye beginners ke liye best hai.

Sabse pehle, hume ek editor chahiye code likhne ke liye. Main VS Code use kar raha hoon. Ye ek text editor hai jo Notepad se zyada powerful hai — isme syntax highlighting hoti hai, auto-suggestion aati hai, bahut saare features hain.

Toh pehle hum ek folder banayenge "Chapter 1" aur usme ek file banayenge "first.py". .py ka matlab Python script — jaise movies ka .mp4 hota hai.

Ab andar likhenge:
print("Hello World")

Yeh humara first program hai. print() ek function hai jo screen par kuch bhi display karta hai. Double quotes ke andar jo bhi likhenge, woh exactly waise hi print hoga.

Program run karne ke liye terminal mein jayenge aur likhenge:
python first.py

Aur... output aayega: Hello World

Congratulations! Aapne apna first Python program likh liya! 🎉

Yaad rakho:
- print() → output dikhata hai
- .py → Python file ka extension
- python filename.py → run karne ka command

Bahut simple hai na? Chalo ab next topic pe chalte hain!''',
    'codeExamples': [
      {
        'title': 'Hello World Program',
        'code': 'print("Hello World")',
        'explanation': 'Yeh sabse simple Python program hai. print() function ne "Hello World" ko console par output kiya. Double quotes batate hain ki ye ek string hai — matlab text jisko print karna hai.',
        'output': 'Hello World',
      },
      {
        'title': 'Multiple Prints',
        'code': 'print("Hello")\nprint("World")\nprint("Python is fun!")',
        'explanation': 'Aap multiple print() statements use kar sakte hain. Har statement apni alag line mein output dega.',
        'output': 'Hello\nWorld\nPython is fun!',
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo aapka naam print kare. Jaise output aaye: "Mera naam [aapka naam] hai"',
        'hint': 'print() function use karo. Jo bhi print karna hai usko double quotes mein likho.',
        'solution': 'print("Mera naam Rahul hai")',
        'difficulty': 'easy',
      },
      {
        'question': 'Multiple print() statements ka use karke ek simple "Name Card" banayein. Pehli line mein naam, doosri mein class, teesri mein school, aur chauthi mein ek border print karo.',
        'hint': 'Har line ke liye alag print() statement use karo. Jo bhi print karna hai, double quotes mein likho.',
        'solution': 'print("***********")\nprint("Name: Rahul")\nprint("Class: 10")\nprint("School: DPS")\nprint("***********")',
        'difficulty': 'medium',
      },
      {
        'question': 'Sirf print() statements ka use karke ASCII art mein ek simple tree banayein. Upar triangle foliage (patte) aur neeche rectangle trunk (tana) draw karo.',
        'hint': 'Har line carefully design karo. Foliage ke liye stars ka triangle pattern banao, trunk ke liye vertical lines ka rectangle.',
        'solution': 'print("   *")\nprint("  ***")\nprint(" *****")\nprint("*******")\nprint("  |||")\nprint("  |||")',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'print(value)', 'example': 'print("Hello")', 'description': 'Value ko console par print karta hai'},
      {'syntax': '# comment', 'example': '# Yeh ek comment hai', 'description': 'Single line comment - Python ignore karta hai'},
    ],
    'commonMistakes': [
      'Double quotes bhoolna — Python string ko recognize nahi karega aur syntax error dega',
      '.py extension ke bina file save karna — tab Python script run nahi hogi',
      'python first.py likhna bhool kar sirf first.py run karna — error aayega',
    ],
  };
}

Map<String, dynamic> topic1_2() {
  return {
    'id': 'topic_1_2',
    'name': 'Understanding Modules',
    'chapterId': 'chapter_1',
    'subjectId': 'python',
    'order': 2,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=796',
    'keyPoints': [
      'Module ek file hoti hai jisme code pehle se likha hota hai — kisi aur ne likha hai, hum use karte hain',
      'Module use karne ke liye "import" keyword use hota hai — jaise import pyjokes',
      'Module install karne ke liye "pip install" command use hoti hai',
      'Do types hote hain: built-in modules (Python ke saath aate hain) aur external modules (install karne padte hain)',
      'Module use karke hum apni life easy kar dete hain — khud sab kuch nahi likhna padta',
      'VS Code mein module name type karte hi auto-suggestion aati hai — isliye VS Code best hai',
    ],
    'keyConcepts': [
      'import keyword',
      'Module',
      'pyjokes library',
      'Built-in vs External modules',
      'pip install',
    ],
    'aiCoachScript': '''Chalo samajhte hain module kya hota hai.

Module ek aisi file hai jisme code already likha hua hai — kisi aur developer ne likha hai. Aur hum us code ko apne program mein use kar sakte hain. Matlab, jo kaam kisi aur ne pehle se kar rakha hai, hume woh dobara nahi karna padta.

Jaise maan lo, tumhe 5 numbers ka harmonic mean nikalna hai. Uske liye tumhe poora logic khud likhna padega. Lekin agar ek module hai jo pehle se yeh kaam karta hai, toh tum bas use import karo aur apna kaam karo.

Toh module import karne ke liye hum likhte hain:
import module_name

Ab main tumhe ek real example deta hoon — pyjokes. Yeh module random jokes generate karta hai.

Pehle pip install pyjokes karo terminal mein. Phir:
import pyjokes
joke = pyjokes.get_joke()
print(joke)

Dekha? Humne code nahi likha joke generate karne ke liye. Humne kisi aur ka code use kiya — aur kaam ho gaya!

VS Code mein jaise hi aap "pyj" likhte ho, auto-suggestion aati hai "pyjokes" ki. Isliye main kehta hoon VS Code use karo — bahut saari cheezein easy ho jaati hain.

Do types hote hain modules ke:
1. Built-in — Python ke saath aate hain (jaise os, math)
2. External — pip se install karne padte hain (jaise pyjokes, flask)

Aage chalke hum aur bhi modules dekhenge. But for now, bas itna yaad rakho: module = kisi aur ka likha hua code jo hum use kar sakte hain. Aur import = module ko apne program mein laana.''',
    'codeExamples': [
      {
        'title': 'pyjokes Module — Random Joke Generator',
        'code': "import pyjokes\n\njoke = pyjokes.get_joke()\nprint(joke)",
        'explanation': 'pyjokes ek external module hai jo random programming jokes generate karta hai. Pehle "pip install pyjokes" se install karna padta hai. get_joke() function ek random joke return karta hai.',
        'output': "What's the object-oriented way to become wealthy?\nInheritance.",
      },
      {
        'title': 'Built-in Module — os module',
        'code': "import os\n\ncontents = os.listdir('/')\nprint(contents)",
        'explanation': 'os ek built-in module hai — ise install karne ki zaroorat nahi hai. os.listdir() function kisi folder ke andar ki saari files aur folders ki list return karta hai. Yeh Python ke saath hi aata hai.',
        'output': "['bin', 'boot', 'dev', 'etc', 'home', 'lib', 'media', 'mnt', 'opt', 'proc', 'root', 'run', 'sbin', 'srv', 'sys', 'tmp', 'usr', 'var']",
      },
    ],
    'challenges': [
      {
        'question': 'Python ke built-in "math" module ko import karo aur π (pi) ki value print karo.',
        'hint': 'Math module built-in hai — ise pip install karne ki zaroorat nahi. import math likho, phir math.pi use karo.',
        'solution': 'import math\nprint(math.pi)',
        'difficulty': 'easy',
      },
      {
        'question': 'Do built-in modules import karo: "math" aur "os". math.e (Euler\'s number) aur os.name (operating system name) dono ko alag-alag print() se display karo.',
        'hint': 'Do alag import statements likho — import math aur import os. math.e aur os.name attributes hain, isliye () nahi lagana.',
        'solution': 'import math\nimport os\nprint(math.e)\nprint(os.name)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek "System Info" program likho jo built-in modules ka use kare. math.pi, os.name, sys.platform, aur sys.version sab print karo.',
        'hint': 'Teen modules import karne padenge: math, os, aur sys. Har module se attribute access karo — kisi function ko call nahi karna.',
        'solution': 'import math\nimport os\nimport sys\nprint(math.pi)\nprint(os.name)\nprint(sys.platform)\nprint(sys.version)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'import module_name', 'example': 'import pyjokes', 'description': 'Module ko import karta hai'},
      {'syntax': 'module_name.function_name()', 'example': 'pyjokes.get_joke()', 'description': 'Module ke function ko call karta hai'},
      {'syntax': 'from module import function', 'example': 'from pyjokes import get_joke', 'description': 'Sirf specific function import karta hai'},
    ],
    'commonMistakes': [
      'Module install kiye bina import karne ki koshish karna — "ModuleNotFoundError" aayega',
      'Module name galat likhna — case-sensitive hota hai',
      'Import statement file ke top par nahi rakhna — convention hai ki saare imports upar likhein',
    ],
  };
}

Map<String, dynamic> topic1_3() {
  return {
    'id': 'topic_1_3',
    'name': 'pip Package Manager',
    'chapterId': 'chapter_1',
    'subjectId': 'python',
    'order': 3,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=881',
    'keyPoints': [
      'pip Python ka official package manager hai — iski madad se external modules install hote hain',
      'pip install module_name — yeh command kisi bhi external module ko install karti hai',
      'Examples: pip install flask, pip install django, pip install pyjokes',
      'pip Python ke saath hi aata hai (Python 3.4+) — alag se install nahi karna padta',
      'pip ke through hum Python Package Index (PyPI) se modules download karte hain',
      'Successfully installed message aane ke baad module use kar sakte hain',
    ],
    'keyConcepts': [
      'pip',
      'Package Manager',
      'PyPI (Python Package Index)',
      'pip install',
      'External module installation',
    ],
    'aiCoachScript': '''Ab baat karte hain pip ki. Ye Python ka package manager hai.

Package manager ka matlab — ek aisa tool jo modules ko install, update aur manage karne mein help karta hai. Jaise aapke phone mein Play Store ya App Store hota hai apps install karne ke liye, waise hi Python mein pip hai.

pip use karna bahut simple hai. Terminal mein likho:
pip install module_name

Jaise humne pyjokes install kiya:
pip install pyjokes

Aur dekho — "Successfully installed pyjokes" ka message aaya. Matlab module ready hai use karne ke liye.

Kuch popular modules jo pip se install kar sakte ho:
- flask — web apps banane ke liye
- django — bade web applications ke liye
- pandas — data analysis ke liye
- numpy — mathematical operations ke liye
- pygame — games banane ke liye

Humein do tarah ke modules milte hain:
1. Built-in — Python ke saath aate hain, pip ki zaroorat nahi
2. External — pip se install karne padte hain

pip ka full form hai "Pip Installs Packages" — ye ek recursive acronym hai. But theory mein mat padna, bas use karna seekh lo.

Yaad rakho: jab bhi tumhe koi external module chahiye, terminal mein jao aur likho:
pip install module_ka_naam

Bahut simple hai!''',
    'codeExamples': [
      {
        'title': 'Installing pyjokes with pip',
        'code': '# Terminal mein yeh command run karo:\npip install pyjokes\n\n# Phir program mein use karo:\nimport pyjokes\nprint(pyjokes.get_joke())',
        'explanation': 'pip install pyjokes command module ko download aur install karta hai. Ek baar install ho jaye, toh aap import kar ke apne program mein use kar sakte hain.',
        'output': "Successfully installed pyjokes\nHow many programmers does it take to change a light bulb?\nNone. That's a hardware problem.",
      },
      {
        'title': 'Installing pyttsx3 (Text-to-Speech)',
        'code': '# Install:\npip install pyttsx3\n\n# Use:\nimport pyttsx3\nengine = pyttsx3.init()\nengine.say("Hello, I am learning Python")\nengine.runAndWait()',
        'explanation': 'pyttsx3 ek text-to-speech library hai. Pip se install karne ke baad, engine.init() se voice engine start hota hai, say() text ko speech mein convert karta hai, aur runAndWait() usse play karta hai.',
        'output': '(Audio output: "Hello, I am learning Python")',
      },
    ],
    'challenges': [
      {
        'question': 'pyjokes module ko pip se install karo, import karo, aur ek random programming joke print karo.',
        'hint': 'Terminal mein "pip install pyjokes" likho. Phir program mein "import pyjokes" karo aur "pyjokes.get_joke()" use karo.',
        'solution': 'import pyjokes\nprint(pyjokes.get_joke())',
        'difficulty': 'easy',
      },
      {
        'question': 'Pip se koi module install karo, uska version check karo, aur phir us module ke baare mein pip show se information dikhao.',
        'hint': 'pip show module_name se module ki details aati hai. pip list se saare installed modules ki list aati hai.',
        'solution': "# Terminal mein:\npip install requests\npip show requests\npip list",
        'difficulty': 'medium',
      },
      {
        'question': 'pyjokes module ko pip install karo aur 5 alag-alag programming jokes print karo. Har baar pyjokes.get_joke() naya joke return karega.',
        'hint': 'Ek baar pip install karna hoga. Phir import karo aur get_joke() ko baar-baar call karo — har call naya joke degi.',
        'solution': 'import pyjokes\nprint(pyjokes.get_joke())\nprint(pyjokes.get_joke())\nprint(pyjokes.get_joke())\nprint(pyjokes.get_joke())\nprint(pyjokes.get_joke())',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'pip install package_name', 'example': 'pip install flask', 'description': 'External package install karta hai'},
      {'syntax': 'pip uninstall package_name', 'example': 'pip uninstall flask', 'description': 'Package ko uninstall karta hai'},
      {'syntax': 'pip list', 'example': 'pip list', 'description': 'Saare installed packages dikhata hai'},
      {'syntax': 'pip show package_name', 'example': 'pip show flask', 'description': 'Package ki details dikhata hai'},
    ],
    'commonMistakes': [
      'pip install likhte time spelling mistake — "pip" nahi "pip" hota hai',
      'Virtual environment ke bahar module install karna — later confusion hoti hai',
      'Python 2 mein pip2 aur Python 3 mein pip3 hota hai — version mismatch',
      'Internet connection ke bina pip install nahi karega',
    ],
  };
}

Map<String, dynamic> topic1_4() {
  return {
    'id': 'topic_1_4',
    'name': 'Python as Calculator (REPL)',
    'chapterId': 'chapter_1',
    'subjectId': 'python',
    'order': 4,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=1014',
    'keyPoints': [
      'REPL ka full form: Read Evaluate Print Loop — Python interactive mode',
      'Terminal mein "python" likhne se REPL open hota hai',
      'REPL mein aap directly Python code likh sakte hain aur turant output dekh sakte hain',
      'Arithmetic operations: +, -, *, / — sab kaam karta hai',
      'Python calculator ki tarah use ho sakta hai — 5+6 = 11, 4*2 = 8',
      'REPL read karta hai aapka input, evaluate karta hai, print karta hai result, aur loop mein wapas aata hai',
      'Complex calculations bhi Python easily kar leta hai',
      'REPL se bahar aane ke liye exit() ya Ctrl+Z likho',
    ],
    'keyConcepts': [
      'REPL (Read Evaluate Print Loop)',
      'Python Interactive Mode',
      'Arithmetic operators',
      'Terminal',
      'Immediate execution',
    ],
    'aiCoachScript': '''Chalo ab dekhte hain Python ko calculator ki tarah kaise use karte hain.

Terminal mein jaao aur bas "python" likho. Enter maaro. Aur dekho — Python ka REPL open ho gaya!

REPL ka matlab hai: Read, Evaluate, Print, Loop.

Yeh kaam karta hai aise:
1. READ — aapki line padhta hai (jaise 5+6)
2. EVALUATE — usko calculate karta hai (5+6 = 11)
3. PRINT — result dikhata hai (11)
4. LOOP — wapas wait karta hai aapke next input ke liye

Ab aap yahan kuch bhi calculate kar sakte hain:
5 + 6 → 11
4 * 2 → 8
10 / 2 → 5.0
100 - 25 → 75

Koi tricky calculation bhi de do — Python karega. Jaise (25 + 35) * 2 / 10 → 12.0

REPL use karna bahut helpful hai jab aap kisi chhoti cheez ko test karna chahte ho. Bina file banaye, bina program likhe, bas terminal mein type karo aur result dekho.

Aur haan, REPL mein print bhi kaam karta hai:
print("Hello from REPL") → Hello from REPL

REPL se bahar aane ke liye exit() likho ya Ctrl+Z dabao.

Yaad rakho: REPL = turant execution. File = program save karke run karna. Dono ki apni jagah hai. Chhoti testing ke liye REPL, bade programs ke liye files use karo.''',
    'codeExamples': [
      {
        'title': 'REPL mein Arithmetic Operations',
        'code': '>>> 5 + 6\n11\n>>> 4 * 2\n8\n>>> 10 / 3\n3.3333333333333335\n>>> (25 + 35) * 2 / 10\n12.0',
        'explanation': 'REPL open karne ke liye terminal mein "python" type karo. Phir seedha expressions likho aur enter maro — result turant dikh jaayega. >>> REPL ka prompt hai.',
        'output': 'REPL session showing calculations',
      },
      {
        'title': 'REPL mein Table of 5',
        'code': '>>> 5*1\n5\n>>> 5*2\n10\n>>> 5*3\n15\n>>> 5*4\n20\n>>> 5*5\n25',
        'explanation': 'Aap REPL mein ek-ek karke calculations kar sakte hain. Har baar enter dene par yeh evaluate karta hai aur result print karta hai. Is tarah aap table of 5 bhi nikaal sakte hain.',
        'output': 'Table of 5 printed line by line',
      },
    ],
    'challenges': [
      {
        'question': 'REPL use karke kisi bhi 3 numbers ka average nikaalo. Jaise numbers hain: 15, 25, 35',
        'hint': 'Average formula: (num1 + num2 + num3) / 3. REPL mein direct type karo.',
        'solution': '>>> (15 + 25 + 35) / 3\n25.0',
        'difficulty': 'easy',
      },
      {
        'question': 'REPL mein ek tricky expression likho jisme +, -, *, / teeno operators aaye. Jaise: (10+5)*3-8/2. Phir output check karo.',
        'hint': 'BODMAS rule follow hota hai — multiplication/division pehle, phir addition/subtraction. Parentheses use kar ke customize kar sakte ho.',
        'solution': '>>> (10 + 5) * 3 - 8 / 2\n41.0',
        'difficulty': 'medium',
      },
      {
        'question': 'REPL mein do alag expressions likho jo dikhayein ki brackets (parentheses) ka istemal kaise result badal deta hai. Jaise (25+35-10)*100/3 aur 25+35-(10*100)/3 — dono ke results compare karo.',
        'hint': 'BODMAS rule ke hisaab se brackets pehle evaluate hote hain. Dono expressions ek-ek karke REPL mein type karo.',
        'solution': '>>> (25 + 35 - 10) * 100 / 3\n1666.6666666666667\n>>> 25 + 35 - (10 * 100) / 3\n-273.3333333333333',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'python', 'example': '# terminal mein python type karo', 'description': 'REPL (interactive mode) open karta hai'},
      {'syntax': 'expression', 'example': '5 + 6', 'description': 'REPL mein koi bhi valid expression evaluate hota hai'},
      {'syntax': 'exit()', 'example': 'exit()', 'description': 'REPL se bahar aata hai'},
      {'syntax': '+ - * /', 'example': '10 + 5 * 2', 'description': 'Basic arithmetic operators (BODMAS follow karta hai)'},
    ],
    'commonMistakes': [
      'REPL mein variables save nahi hote — exit() karne ke baad sab delete ho jaata hai',
      'REPL ko file samajh kar bada program likhna — REPL sirf testing ke liye hai',
      'exit() ke bajaye window close karna — theek hai but exit() behtar hai',
      'REPL mein indentation bhoolna — multi-line statements mein kaam nahi karega',
    ],
  };
}

Map<String, dynamic> topic1_5() {
  return {
    'id': 'topic_1_5',
    'name': 'Comments in Python',
    'chapterId': 'chapter_1',
    'subjectId': 'python',
    'order': 5,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=1177',
    'keyPoints': [
      'Comments Python interpreter ke liye nahi hote — woh ignore ho jaate hain, sirf humans ke liye hote hain',
      'Single line comment: # se shuru hota hai (Ctrl + / in VS Code)',
      'Multi-line comment: triple single quotes (simplified) ya triple double quotes mein likha jaata hai',
      'Comments se code readable hota hai — fellow developers ko samajhne mein aasani hoti hai',
      'VS Code mein # ka green color dikhata hai ki yeh comment hai — Python ignore karega',
      'Multi-line strings (triple quotes) technically string hain, comment nahi — lekin agar assign na karein toh ignore ho jaati hain',
      'Aaj kal IDEs ki wajah se mostly single line comments use hote hain — select karo aur Ctrl + /',
    ],
    'keyConcepts': [
      'Single-line comment (#)',
      'Multi-line comment (triple quotes)',
      'Code documentation',
      'Ctrl + / shortcut',
      'Code readability',
    ],
    'aiCoachScript': '''Ab baat karte hain comments ki.

Kabhi aapne socha hai ki aap apne code mein kuch lines aise likhna chahte ho jo program ko affect na karein? Jaise aap likhna chahte ho "yeh line random joke print karti hai" — lekin yeh line execute nahi honi chahiye. Iske liye hote hain COMMENTS.

Comments Python interpreter ke liye nahi hote — woh sirf humans ke liye hote hain. Python unhe ignore kar deta hai.

Do types ke comments hote hain:

1. SINGLE LINE COMMENT — # ka use karo
Jaise: # Yeh ek comment hai
Jo bhi line # se shuru hogi, Python use ignore karega.

VS Code mein bahut easy hai — jis line par comment karna hai, us par Ctrl + / dabaao. Woh line # se start ho jayegi. Dobara Ctrl + / dabaao toh # hatt jayega.

2. MULTI-LINE COMMENT — Triple quotes ka use karo
Jaise:
simplified
"Yeh multiple lines ka comment hai"
"Sab ignore hoga"
simplified

Lekin yaad rakho — technically yeh multi-line string hai, comment nahi. Lekin agar aap ise kisi variable mein assign nahi karte, toh Python ise ignore karta hai.

Aaj kal most programmers sirf single line comments use karte hain. Kyunki IDE mein aap multiple lines select karke Ctrl + / daba sakte ho — aur woh ek-ek karke # se comment ho jaati hain. Zyada convenient hai.

Comments kyun use karte hain?
- Code ko samajhne mein aasani hoti hai
- Fellow developers ko pata chalta hai ki code kya kar raha hai
- Future mein aap khud bhool jaate ho — tab comments kaam aate hain

To chalo, aaj se comments use karna shuru karo. Code likho, comments daalo, aur apne code ko readable banao!''',
    'codeExamples': [
      {
        'title': 'Single Line Comments',
        'code': '# Yeh program ek random joke print karta hai\nimport pyjokes\n\n# Get a random joke\njoke = pyjokes.get_joke()\n\n# Print the joke\nprint(joke)',
        'explanation': '# se shuru hone wali line Python interpreter ignore kar deta hai. Yeh sirf hum humans ke liye hai taake code samajhne mein aasani ho. VS Code mein Ctrl + / se comment toggle hota hai.',
        'output': "What do you call a fake noodle?\nAn impasta.",
      },
      {
        'title': 'Multi-line Comments / Strings',
        'code': "'''\nYeh program pyjokes ka use karta hai\nYeh multiple lines ka comment hai\nPython ise ignore karega\n'''\nimport pyjokes\nprint(pyjokes.get_joke())",
        'explanation': 'Triple single quotes ya triple double quotes se multi-line string banti hai. Jab ise kisi variable mein assign na karein, toh yeh comment ki tarah behave karti hai — Python ignore karta hai.',
        'output': 'Why do programmers prefer dark mode?\nBecause light attracts bugs.',
      },
      {
        'title': 'Why Comments Matter — AI Generated Code',
        'code': "# Select the directory whose content you want to list\ndirectory_path = '/'\n\n# Use the os module to list the directory content\ncontents = os.listdir(directory_path)\n\n# Print the contents of the directory\nprint(contents)",
        'explanation': 'AI se code generate karane par bhi comments aate hain — jaise ChatGPT ne Problem 4 ke liye code diya. Comments se har line ka purpose clear ho jaata hai.',
        'output': "['bin', 'boot', 'dev', 'etc', 'home', 'lib', ...]",
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jisme single-line comments (#) ka use karke explain kiya jaye ki program kya kar raha hai. Program simple ho — sirf ek "Hello World" print kare.',
        'hint': '# symbol line ke shuru mein lagao. Python # ke baad ki saari cheez ignore karega. Comment mein likho ki yeh line kya karegi.',
        'solution': '# Yeh program screen par Hello World print karta hai\nprint("Hello World")',
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jisme har print() statement ke upar ek comment ho jo bataye ki woh line kya print karegi. Teen alag messages print karo — greeting, question, aur farewell.',
        'hint': 'Har print() line se pehle # ka use karo. Jaise: "# Yeh greeting print karega" uske baad print() call karo.',
        'solution': '# Yeh ek greeting print karta hai\nprint("Namaste!")\n# Yeh ek question print karta hai\nprint("Kaise ho aap?")\n# Yeh ek farewell print karta hai\nprint("Phir milenge!")',
        'difficulty': 'medium',
      },
      {
        'question': 'Triple quotes ko do tarah se use karo: (1) print() ke andar multi-line string ki tarah, aur (2) bina print() ke multi-line "comment" ki tarah. Dono cases ka code likho aur difference samjhao.',
        'hint': 'print("""text""") se multi-line string print hoti hai. Lekin """text""" bina print() ke likho toh Python use ignore karta hai — comment ki tarah.',
        'solution': "print('''Yeh multi-line\nstring print hogi''')\n'''\nYeh multi-line comment hai\nPython ise ignore karega\n'''\nprint('Sirf upar wala print hoga')",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': '# comment', 'example': '# This is a comment', 'description': 'Single line comment — # ke baad ki saari line ignore hoti hai'},
      {'syntax': "''' comment '''", 'example': "'''Multi-line\ncomment'''", 'description': 'Multi-line string (triple quotes) — comment ki tarah use hoti hai'},
      {'syntax': '# Region', 'example': '# TODO: Add error handling', 'description': 'Comments ka use marking ke liye bhi hota hai (TODO, FIXME, NOTE)'},
    ],
    'commonMistakes': [
      'Comment ke andar bhi code likh dena jo real code jaisa lage — confusion hoti hai',
      'Zyaada comments likhna — code khud explanatory hona chahiye, comments sirf zaroorat par',
      'Comments update na karna jab code change ho — purane comments misleading ho jaate hain',
      '# ke baad space nahi dena — convention hai ki # ke baad ek space do',
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
