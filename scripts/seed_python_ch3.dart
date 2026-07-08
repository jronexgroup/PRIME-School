// Run: dart run scripts/seed_python_ch3.dart
// Seeds Python Ch 3: Strings (4 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 3...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_3', {
    'id': 'chapter_3',
    'subjectId': 'python',
    'name': 'Strings',
    'order': 3,
    'totalTopics': 4,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_3_1', 'chapterId': 'chapter_3', 'name': 'String Basics', 'order': 12},
    {'topicId': 'topic_3_2', 'chapterId': 'chapter_3', 'name': 'String Slicing', 'order': 13},
    {'topicId': 'topic_3_3', 'chapterId': 'chapter_3', 'name': 'String Functions', 'order': 14},
    {'topicId': 'topic_3_4', 'chapterId': 'chapter_3', 'name': 'Escape Sequences', 'order': 15},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic3_1(), topic3_2(), topic3_3(), topic3_4()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_3/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 3 seeded successfully.');
}

Map<String, dynamic> topic3_1() {
  return {
    'id': 'topic_3_1',
    'name': 'String Basics',
    'chapterId': 'chapter_3',
    'subjectId': 'python',
    'order': 12,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=4563',
    'keyPoints': [
      'String ek sequence of characters hota hai jo quotes ke andar likha jaata hai',
      'String ko teen tarah se likh sakte hain: single quotes, double quotes, triple quotes',
      'Triple quotes multi-line strings ke liye use hote hain -- jaise twinkle twinkle poem',
      'Indexing 0 se start hoti hai -- first character ka index 0 hota hai',
      'String slicing: name[0:3] means start from 0 all the way till 3 (excluding 3)',
      'len() function se string ki length pata karte hain',
      'String immutable hoti hai -- matlab ek baar bana di to change nahi kar sakte',
      'name[1] se ek single character access kar sakte hain at that index',
      'Strings can contain any data type characters -- letters, numbers, symbols, spaces',
    ],
    'keyConcepts': [
      'String data type',
      'Indexing (0-based)',
      'String slicing',
      'Immutability',
      'len() function',
    ],
    'aiCoachScript': """Chalo doston, Chapter 3 mein welcome hain! Aaj hum seekhenge Strings ke baare mein.

String ek sequence of characters hota hai. Jaise "Harry" ek string hai -- H, a, r, r, y characters ka combination. Simple definition: jo bhi aap quotes mein likhte ho, woh string ban jaata hai.

Python mein string likhne ke 3 tarike hain:
1. Single quotes: 'Harry'
2. Double quotes: "Harry"
3. Triple quotes (''' ''') -- ye multi-line strings ke liye use hota hai

Ab baat karte hain indexing ki. Python mein counting 0 se shuru hoti hai. Toh "Harry" mein:
- H index 0
- a index 1
- r index 2
- r index 3
- y index 4

Name[0:3] likhne ka matlab hai -- index 0 se lekar index 3 tak (lekin 3 include nahi hoga). Toh output aayega "Har".

Ek important baat -- String IMMUTABLE hoti hai. Matlab aap existing string ko change nahi kar sakte. Jaise aap name[0] = 'P' nahi kar sakte. Naya string banana padega. Yeh concept bahut important hai.

Aaj ke liye itna hi. Practice karo, code likho, aur mazza karo!""",
    'codeExamples': [
      {
        'title': 'String Creation and Indexing',
        'code': "name = \"Harry\"\n\nnameshort = name[0:3] # start from index 0 all the way till 3 (excluding 3)\nprint(nameshort)\ncharacter1 = name[1]\nprint(character1)",
        'explanation': 'String banaya "Harry". Phir name[0:3] se pehle 3 characters slice kiye -- H, a, r. name[1] se index 1 ka character a print hua. Output: Har, a.',
        'output': 'Har\na',
      },
      {
        'title': 'Multi-line Strings with Triple Quotes',
        'code': "poem = '''Twinkle twinkle little star\nHow I wonder what you are\nUp above the world so high'''\nprint(poem)",
        'explanation': 'Triple quotes se multi-line string banate hain. Jitni lines likhenge, woh string mein include hongi. print() karne par waisa hi output aayega.',
        'output': 'Twinkle twinkle little star\nHow I wonder what you are\nUp above the world so high',
      },
    ],
    'challenges': [
      {
        'question': 'Apna naam ek string mein store karo aur uske first 3 characters print karo using slicing.',
        'hint': 'name[0:3] use karo. Yaad rakho 3 exclude hota hai.',
        'solution': "name = \"Rahul\"\nprint(name[0:3])",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek string lo "Programming" aur uske middle 3 characters print karo using slicing (sirf start:end). Jaise "ram" print karna hai.',
        'hint': 'len() // 2 se string ki half length nikaalo. Phir name[mid-1:mid+2] use karo.',
        'solution': 'text = "Programming"\nmid = len(text) // 2\nprint(text[mid-1:mid+2])',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek string lo "Python" aur uske first character ko last character ke saath swap karo. Naye string ka naam result rakho. Kyunki string immutable hai, aapko concatenation karna padega.',
        'hint': 'first = name[0], last = name[-1], middle = name[1:-1]. Phir result = last + middle + first.',
        'solution': 'name = "Python"\nfirst = name[0]\nlast = name[-1]\nmiddle = name[1:-1]\nresult = last + middle + first\nprint(result)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'str[index]', 'example': 'name[0]', 'description': 'Index par character access karta hai (0-based)'},
      {'syntax': 'str[start:end]', 'example': 'name[0:3]', 'description': 'String slice karta hai start se end-1 tak'},
      {'syntax': 'len(str)', 'example': 'len(name)', 'description': 'String ki length return karta hai'},
      {'syntax': "'''multi-line string'''", 'example': "'''Hello\nWorld'''", 'description': 'Triple quotes se multi-line string banate hain'},
    ],
    'commonMistakes': [
      'Index out of range -- string ki length se zyada index access karte hain to "IndexError" aata hai',
      'Slicing mein end index galat samajhna -- name[0:3] means index 0,1,2 (3 nahi), yeh bhoolna common hai',
      'String ko list ki tarah modify karne ki koshish -- name[0]="P" karoge to TypeError aayega kyunki string immutable hai',
    ],
  };
}

Map<String, dynamic> topic3_2() {
  return {
    'id': 'topic_3_2',
    'name': 'String Slicing',
    'chapterId': 'chapter_3',
    'subjectId': 'python',
    'order': 13,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=4680',
    'keyPoints': [
      'Negative slicing mein reverse counting hoti hai -- last character ka index -1 hota hai',
      'Negative index ko convert karo corresponding positive index mein -- easiest way',
      'Jaise name[-4:-1] = name[1:4] -- minus ko plus mein badlo aur answer milega',
      'Agar start index nahi diya (jaise :4) to wo 0 mana jaata hai',
      'Agar end index nahi diya (jaise 1:) to wo length tak mana jaata hai',
      'Colon ke saath only start:end nahi, aap step size bhi de sakte hain name[0:5:2]',
      'Step size (skip value) se aap specific gaps par characters le sakte hain',
      'Step size -1 se string reverse hoti hai -- name[::-1] interview mein poochha jaata hai',
    ],
    'keyConcepts': [
      'Negative indexing',
      'Positive index conversion',
      'Default start and end',
      'Step size / Skip value',
      'Extended slicing [start:end:step]',
    ],
    'aiCoachScript': '''Chalo ab negative slicing aur advanced slicing seekhte hain.

Negative slicing -- yeh thoda confusing lagta hai but ek simple trick hai. Jab bhi negative index dekho, usse corresponding positive index mein convert karo.

Jaise "Harry" mein:
Positively: H(0), a(1), r(2), r(3), y(4)
Negatively: y(-1), r(-2), r(-3), a(-4), H(-5)

Agar likha name[-4:-1], to -4 ka positive 1 hai aur -1 ka positive 4 hai. Toh wahi hai name[1:4] -- "arr". Simple hai na?

Ab ek aur baat -- jab aap :4 likhte ho (start blank), to matlab 0:4. Aur 1: likhte ho (end blank) to matlab 1:length. Yeh bhoolna nahi chahiye.

Step size bhi use kar sakte hain! Jaise name[0:5:2] -- iska matlab hai index 0 se 5 tak, lekin har 2nd character. Toh 0, 2, 4 index ke characters -- "Hry" aayega.

Aur sabse mazedar baat -- name[::-1] se string reverse ho jaati hai! "Harry" -> "yrraH". Interview mein aksar poochhte hain.

To yaad rakho:
- [:4] = [0:4]
- [1:] = [1:length]
- [::-1] = reverse
- Negative index ko positive mein convert karo

Bahut easy hai! Practice karo aur comments mein batao kaise laga!''',
    'codeExamples': [
      {
        'title': 'Negative Slicing Conversion',
        'code': "name = \"Harry\"\n\nprint(name[0:3])  # Har\n\nprint(name[-4:-1])  # arr\nprint(name[1:4])    # same as above\n\nprint(name[:4])   # is same as print(name[0:4]) -> Harr\nprint(name[1:])   # is same as print(name[1:5]) -> arry\nprint(name[1:5])  # arry",
        'explanation': 'Negative indices ko positive mein convert karna easiest tarika hai. -4 = 1, -1 = 4. Blank start means 0, blank end means string length.',
        'output': 'Har\narr\narr\nHarr\narry\narry',
      },
      {
        'title': 'Step Size / Skip Value',
        'code': "a = \"HarryIsAGoodBoy\"\nprint(a[1:7:3])  # aI\nprint(a[::2])    # HrIsoBoy\nprint(a[::-1])   # yoBdooGAsIyrraH",
        'explanation': 'Teen numbers: start:end:step. Step 3 means har 3rd character. Step -1 means reverse order.',
        'output': 'aI\nHrIsoBoy\nyoBdooGAsIyrraH',
      },
    ],
    'challenges': [
      {
        'question': 'Ek string "Programming" lo aur negative slicing ka use karke last 4 characters print karo.',
        'hint': 'Last 4 characters ke liye name[-4:] use karo.',
        'solution': 'text = "Programming"\nprint(text[-4:])',
        'difficulty': 'easy',
      },
      {
        'question': 'Ek string lo aur uske aadhe characters print karo -- pehle half using slicing. Jaise "Python" ka "Pyt" print karo.',
        'hint': 'String ki half length nikaalo using len() // 2. Phir name[:half] use karo.',
        'solution': 'text = "Python"\nhalf = len(text) // 2\nprint(text[:half])',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek string "malayalam" lo aur check karo ki wo palindrome hai ya nahi (aage aur peeche se same) using slicing.',
        'hint': 'Palindrome means string reverse karne par wahi aaye. text == text[::-1] se check karo.',
        'solution': 'text = "malayalam"\nif text == text[::-1]:\n    print("Palindrome")\nelse:\n    print("Not Palindrome")',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'str[-start:-end]', 'example': 'name[-4:-1]', 'description': 'Negative indexing -- last se count karta hai'},
      {'syntax': 'str[:end]', 'example': 'name[:4]', 'description': 'Start default 0 hota hai'},
      {'syntax': 'str[start:]', 'example': 'name[1:]', 'description': 'End default string length hota hai'},
      {'syntax': 'str[start:end:step]', 'example': 'name[0:5:2]', 'description': 'Step size ke saath extended slicing'},
      {'syntax': 'str[::-1]', 'example': 'name[::-1]', 'description': 'String reverse karta hai'},
    ],
    'commonMistakes': [
      'Negative slicing mein confuse hona -- yaad rakho -1 last character hai, -2 second last. Hamesha positive mein convert karo',
      'Step size negative dene par start aur end swap ho jaate hain -- start bada aur end chhota hona chahiye for -1',
      'Slice indices out of range error nahi dete -- agar end index length se zyada hai to bas length tak le leta hai, yeh unexpected result de sakta hai',
    ],
  };
}

Map<String, dynamic> topic3_3() {
  return {
    'id': 'topic_3_3',
    'name': 'String Functions',
    'chapterId': 'chapter_3',
    'subjectId': 'python',
    'order': 14,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=4860',
    'keyPoints': [
      'len() -- string ki length batata hai, kitne characters hain',
      'endswith("rry") -- check karta hai ki string diye gaye substring se end hoti hai ya nahi (returns True/False)',
      'startswith("ha") -- check karta hai ki string diye gaye substring se start hoti hai ya nahi',
      'capitalize() -- string ke first character ko capital (uppercase) karta hai, baaki lowercase',
      'String functions case-sensitive hote hain -- "Harry" aur "harry" alag hain',
      'replace() -- kisi word ya character ko replace karta hai, saare occurrences change ho jaate hain',
      'find() -- kisi word ki first occurrence ka index return karta hai, nahi mila to -1 return karta hai',
      'Yeh functions original string ko change nahi karte kyunki strings immutable hain -- naya string return karte hain',
      'ChatGPT use karke aur functions explore kar sakte ho -- jaise lower(), upper(), title(), strip()',
    ],
    'keyConcepts': [
      'len() function',
      'endswith()',
      'startswith()',
      'capitalize()',
      'replace()',
      'find()',
    ],
    'aiCoachScript': '''Ab baat karte hain string functions ki -- yeh bahut useful hain.

Sabse pehla function hai len() -- yeh string ki length batata hai. Kitne characters hain string mein. Jaise "harry" ki length 5 hai.

Endswith() -- check karta hai ki string kisi particular word se end hoti hai ya nahi. Jaise name.endswith("rry") -> True. name.endswith("ry") -> True. Case-sensitive hai!

Startswith() -- same as endswith but start ke liye. Jaise name.startswith("ha") -> True.

Capitalize() -- string ka first character capital karta hai. Jaise "harry" ko "Harry" kar deta hai. Baaki ke characters pe kuch nahi karta.

Replace() -- yeh bahut powerful hai. Jaise a.replace("good", "bad") to saare "good" ko "bad" kar dega. Saare occurrences replace hote hain!

Find() -- yeh kisi word ki first occurrence ka index return karta hai. Jaise "Harry is a good boy" mein find("good") -> 10. Agar word nahi mila to -1 return karta hai.

Yaad rakho -- yeh functions original string change nahi karte kyunki strings immutable hain. Yeh naya string return karte hain.

ChatGPT se aur functions poochh lo -- jaise lower(), upper(), title(), strip(). Bohot saare functions hain, sab yaad karne ki zaroorat nahi. Jab chahiye tab ChatGPT se puch lo!''',
    'codeExamples': [
      {
        'title': 'Basic String Functions',
        'code': "name = \"harry\"\n\nprint(len(name))          # 5\nprint(name.endswith(\"rry\"))  # True\nprint(name.startswith(\"ha\")) # True\nprint(name.capitalize())     # Harry",
        'explanation': 'len() returns length 5. endswith("rry") checks if string ends with "rry" -> True. startswith("ha") -> True. capitalize() makes first letter uppercase -> "Harry".',
        'output': '5\nTrue\nTrue\nHarry',
      },
      {
        'title': 'Find and Replace',
        'code': "a = \"Harry is a good boy\"\nprint(a.find(\"good\"))   # 12\nprint(a.replace(\"good\", \"bad\"))  # Harry is a bad boy\nprint(a)  # original unchanged -> \"Harry is a good boy\"",
        'explanation': 'find("good") returns index 12 where "good" starts. replace("good", "bad") returns new string with "bad". Note: original string a is unchanged (immutability).',
        'output': '12\nHarry is a bad boy\nHarry is a good boy',
      },
    ],
    'challenges': [
      {
        'question': 'User se ek input lo aur check karo ki wo ".com" se end hota hai ya nahi.',
        'hint': 'Input lo using input(), phir endswith(".com") use karo.',
        'solution': "url = input(\"Enter website: \")\nprint(url.endswith(\".com\"))",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek sentence lo jisme multiple baar double space ho. Find() use karke double space ki position pata karo. Agar replace use karo to double space ko single space mein badlo.',
        'hint': 'find("  ") double space ka index dega. replace("  ", " ") se double space single ho jayega.',
        'solution': 's = "Hello  World  Python"\nsingle = s.replace("  ", " ")\nprint(single)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo ek URL "https://www.example.com/page" se domain name (www.example.com) extract kare using sirf find() aur slicing.',
        'hint': 'find("www") se "www" ka index mil jayega. find(".com") se ".com" ka index milega. Domain start se end tak slice karo using [start:end+4].',
        'solution': 'url = "https://www.example.com/page"\nstart = url.find("www")\nend = url.find(".com") + 4\ndomain = url[start:end]\nprint(domain)',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'len(str)', 'example': 'len("Harry")', 'description': 'String ki length return karta hai'},
      {'syntax': 'str.endswith(suffix)', 'example': 'name.endswith("rry")', 'description': 'Check karta hai string suffix se end hoti hai ya nahi'},
      {'syntax': 'str.startswith(prefix)', 'example': 'name.startswith("Ha")', 'description': 'Check karta hai string prefix se start hoti hai ya nahi'},
      {'syntax': 'str.capitalize()', 'example': 'name.capitalize()', 'description': 'First character capital karta hai'},
      {'syntax': 'str.find(sub)', 'example': 'a.find("good")', 'description': 'Substring ka index return karta hai, nahi mila to -1'},
      {'syntax': 'str.replace(old, new)', 'example': 'a.replace("good", "bad")', 'description': 'Old substring ko new se replace karta hai'},
    ],
    'commonMistakes': [
      'Case sensitivity bhoolna -- "Harry".endswith("rry") True hai lekin "Harry".endswith("Rry") False hoga',
      'String functions ko original string change karne wala samajhna -- replace(), capitalize() etc naya string return karte hain, original nahi badalta',
      'find() mein -1 return hone par index out of range assume karna -- -1 ka matlab hai nahi mila, exception nahi hai',
    ],
  };
}

Map<String, dynamic> topic3_4() {
  return {
    'id': 'topic_3_4',
    'name': 'Escape Sequences',
    'chapterId': 'chapter_3',
    'subjectId': 'python',
    'order': 15,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=5220',
    'keyPoints': [
      'Escape sequence characters special characters hote hain jo backslash \\ se shuru hote hain',
      '\\n -- new line character, string mein nayi line shuru karta hai',
      '\\t -- tab character, space provide karta hai (indentation ke liye)',
      "\\' -- single quote escape, jab string single quotes mein ho aur andar single quote chahiye",
      '\\" -- double quote escape, jab string double quotes mein ho aur andar double quote chahiye',
      '\\\\ -- literal backslash print karne ke liye, ek backslash dikhata hai',
      'Escape sequences ka special meaning hota hai -- Python unhe as a single character treat karta hai',
      '\\n ek character count hota hai, do characters nahi -- len() check kar ke dekh sakte ho',
      'ChatGPT se aur escape sequences explore karo -- jaise \\r (carriage return), \\b (backspace)',
    ],
    'keyConcepts': [
      'Escape sequence character',
      '\\n (new line)',
      '\\t (tab)',
      "\\' and \\\" (quote escape)",
      '\\\\ (backslash literal)',
    ],
    'aiCoachScript': '''Chalo ab escape sequence characters ke baare mein baat karte hain.

Escape sequence characters wo special characters hote hain jo backslash ke saath aate hain aur unka Python mein special meaning hota hai.

Sabse common hai \\n -- new line. Jaise aap chahte ho ki "Harry is a good boy" ke baad nayi line mein "but not a bad boy" likhe. Toh aap likhenge: "Harry is a good boy\\nbut not a bad boy". Output mein dono alag lines mein aayenge.

\\t -- tab character. Yeh kuch space chhod deta hai. Jaise indentation ke liye use hota hai.

Ab ek problem -- agar aapne string single quotes mein likhi hai, aur andar bhi single quote use karna hai:
'This is Harry's book' -- Python confuse ho jayega. Toh aap backslash single quote use karo: 'This is Harry\\'s book'. Same for double quotes.

Agar aap actual backslash print karna chahte ho, to \\\\ likhna padega. Kyunki ek \\ se escape sequence start hota hai.

Yaad rakho -- har escape sequence character Python mein sirf ek character count hota hai. Jaise "\\n" ki length 1 hoti hai, 2 nahi.

Mera suggestion -- aap ChatGPT se aur escape sequences explore karo. Jaise \\r (carriage return), \\b (backspace), \\a (bell) etc. Lekin practically \\n, \\t aur \\' sabse zyada use hote hain.

To chalo practice karte hain!''',
    'codeExamples': [
      {
        'title': 'New Line and Quote Escape',
        'code': "a = 'Harry is a good boy\\nbut not a bad \\'boy\\''\nprint(a)",
        'explanation': "\\n ne 'boy' ke baad new line create kiya. \\'boy\\' ne single quotes ko escape kiya taake Python confuse na ho. Output mein boy single quotes ke andar dikhega.",
        'output': "Harry is a good boy\nbut not a bad 'boy'",
      },
      {
        'title': 'Tab Escape and Backslash',
        'code': "letter = \"Dear Harry,\\n\\tThis python course is nice.\\nThanks!\"\nprint(letter)",
        'explanation': '\\n se new line, \\t se tab (indentation). Output properly formatted letter jaisa dikhta hai.',
        'output': 'Dear Harry,\n\tThis python course is nice.\nThanks!',
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo 3 lines ka poem print kare jisme har line ke beech new line ho aur second line tab se shuru ho.',
        'hint': '\\n se new line, \\t se tab. Single print statement mein sab kuch likho.',
        'solution': "print(\"Roses are red,\\n\\tViolets are blue,\\nPython is fun!\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek string lo jo double quotes mein hai aur uske andar double quotes print karne hain. Jaise output: He said, "Python is great!"',
        'hint': '\\" double quote escape karo. Ya phir string single quotes mein likho and directly double quotes use karo.',
        'solution': 'print("He said, \\"Python is great!\\"")',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo ek file path print kare jaise C:\\Users\\Name\\Documents. Ensure karo ki backslash sahi dikhe.',
        'hint': 'Single backslash \\ escape sequence start karta hai. Double backslash \\\\ use karo actual backslash print karne ke liye.',
        'solution': 'print("C:\\\\Users\\\\Name\\\\Documents")',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': "\\n", 'example': '"Hello\\nWorld"', 'description': 'New line character -- nayi line mein le jaata hai'},
      {'syntax': "\\t", 'example': '"Hello\\tWorld"', 'description': 'Tab character -- space/indentation deta hai'},
      {'syntax': "\\'", 'example': "'Harry\\'s'", 'description': "Single quote escape -- string ke andar single quote"},
      {'syntax': '\\"', 'example': '"He said \\"Hi\\""', 'description': 'Double quote escape -- string ke andar double quote'},
      {'syntax': '\\\\', 'example': '"Path: C:\\\\Users"', 'description': 'Backslash escape -- actual backslash print karta hai'},
    ],
    'commonMistakes': [
      'Backslash bhoolna -- jab andar quotes chahiye aur escape nahi kiya to "SyntaxError: invalid syntax" aayega',
      'Actual backslash print karne ke liye sirf ek \\ likhna -- \\n new line ban jayega, backslash print nahi hoga. Double backslash lagao',
      'Escape sequence ko 2 characters samajhna -- jaise \\n actually 1 character hota hai, len() check kar ke dekh sakte ho',
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
