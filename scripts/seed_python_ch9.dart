// Run: dart run scripts/seed_python_ch9.dart
// Seeds Python Ch 9: File I/O (3 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 9...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_9', {
    'id': 'chapter_9',
    'subjectId': 'python',
    'name': 'File I/O',
    'order': 9,
    'totalTopics': 3,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_9_1', 'chapterId': 'chapter_9', 'name': 'Reading Files', 'order': 33},
    {'topicId': 'topic_9_2', 'chapterId': 'chapter_9', 'name': 'Writing Files', 'order': 34},
    {'topicId': 'topic_9_3', 'chapterId': 'chapter_9', 'name': 'File Methods & With Statement', 'order': 35},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic9_1(), topic9_2(), topic9_3()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_9/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 9 seeded successfully.');
}

Map<String, dynamic> topic9_1() {
  return {
    'id': 'topic_9_1',
    'name': 'Reading Files',
    'chapterId': 'chapter_9',
    'subjectId': 'python',
    'order': 33,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=21600',
    'keyPoints': [
      'File I/O ka matlab File Input/Output - file se data padhna aur file mein data likhna',
      'open() function file ko open karne ke liye use hota hai - jaise: f = open("file.txt")',
      '"r" mode reading ke liye hota hai - yeh default mode hai, alag se likhna zaroori nahi',
      'f.read() file ka poora content ek string mein padh leta hai',
      'File close karna bahut important hai - f.close() se resources free hote hain',
      'Agar file exist nahi karti toh FileNotFoundError aayega',
      'File path do tarah ka ho sakta hai: relative (sirf naam) aur absolute (poora path)',
      'Read mode mein file modify nahi kar sakte - sirf padh sakte ho',
      'File I/O real-world applications mein bahut use hota hai - data processing, logs, configuration',
    ],
    'keyConcepts': [
      'open() function',
      'File modes (r, w, a)',
      'f.read() method',
      'f.close() method',
      'FileNotFoundError',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge files ke saath kaam karna - File I/O.

File I/O ka matlab hai File Input aur Output. Input = file se data padhna, Output = file mein data likhna. Bahut saare real programs files ke saath kaam karte hain. Jaise koi game hiscore save karta hai file mein, ya koi app configuration file padhti hai.

Sabse pehle seekhte hain file kaise padhte hain.

Python mein file padhne ke liye open() function use hota hai:
f = open("file.txt", "r")

Yahan "r" ka matlab read mode. Aur yeh default mode hai, toh aap sirf yeh bhi likh sakte ho:
f = open("file.txt")

Phir data read karne ke liye:
data = f.read()
print(data)

Aur akhir mein:
f.close()

Close kyun important hai? Kyunki file open rahne se system resources waste hote hain. Dusre programs bhi file access nahi kar payenge. Hamesha close karo.

Lekin agar file exist nahi karti, toh:
f = open("file.txt")  # FileNotFoundError!

Toh error handle karna important hai. Baad mein seekhenge try-except se.

Ab ek real example. Maan lo ek poem.txt file mein poem likhi hai. Aapko check karna hai ki usme "twinkle" word present hai ya nahi:

f = open("poem.txt")
content = f.read()
if("twinkle" in content):
    print("Word found!")
else:
    print("Word not found")
f.close()

Dekha? File open kiya, content padha, check kiya, close kiya.

Yaad rakho:
- open() file kholta hai
- read() content padhta hai
- close() file band karta hai
- Default mode "r" (read) hota hai
- File nahi mili toh error

Bahut simple hai. Chalo ab writing files seekhte hain!''',
    'codeExamples': [
      {
        'title': 'Reading a File with open() and read()',
        'code': "f = open('file.txt', 'r')\n"
            "data = f.read()\n"
            "print(data)\n"
            "f.close()",
        'explanation': 'open() file.txt ko read mode mein kholta hai. f.read() poore content ko string mein store karta hai. Phir hum print karte hain aur akhir mein f.close() se file band karte hain.',
        'output': "Hey Harry you are amazing\nPython is fun!",
      },
      {
        'title': 'Checking if a Word Exists in a File',
        'code': "f = open('poem.txt')\n"
            "content = f.read()\n"
            "if('twinkle' in content):\n"
            "    print('The word twinkle is present')\n"
            "else:\n"
            "    print('The word twinkle is not present')\n"
            "f.close()",
        'explanation': "File ko open karo, content read karo aur phir 'in' operator se check karo ki word file mein hai ya nahi. Agar hai toh present, nahi toh not present print karo.",
        'output': "The word twinkle is present",
      },
      {
        'title': 'Reading a File Without Explicit Mode',
        'code': "f = open('file.txt')\n"
            "print(f.read())\n"
            "f.close()",
        'explanation': "Yahan humne 'r' mode explicitly specify nahi kiya. Python default mode 'r' hi leta hai. Yeh same kaam karta hai jaise 'r' specify karna.",
        'output': "Hey Harry you are amazing\nPython is fun!",
      },
    ],
    'challenges': [
      {
        'question': 'Ek poem.txt file hai. Program likho jo check kare ki usme "twinkle" word present hai ya nahi. Agar hai toh print karo "The word twinkle is present in the content".',
        'hint': "open() se file kholo, .read() se content padho, phir 'in' operator use karo. Agar word hai toh condition True hogi.",
        'solution': "f = open('poem.txt')\n"
            "content = f.read()\n"
            "if('twinkle' in content):\n"
            "    print('The word twinkle is present in the content')\n"
            "else:\n"
            "    print('The word twinkle is not present in the content')\n"
            "f.close()",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek log.txt file hai. Program likho jo check kare ki usme "python" word present hai ya nahi. Agar hai toh "Yes python is present" print karo.',
        'hint': 'open() se file kholo, .read() se content padho, close() karo. Phir "in" operator se check karo.',
        'solution': "f = open('log.txt')\n"
            "content = f.read()\n"
            "f.close()\n\n"
            "if('python' in content):\n"
            "    print('Yes python is present')\n"
            "else:\n"
            "    print('No Python is not present')",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek log.txt file hai. Program likho jo count kare ki "python" word us file mein kitni baar aaya hai. open(), read() aur close() use karo.',
        'hint': 'Pehle file open karo, read karo, close karo. Phir for loop mein har position check karo using slicing content[i:i+6] == "python".',
        'solution': "f = open('log.txt')\n"
            "content = f.read()\n"
            "f.close()\n\n"
            "word = 'python'\n"
            "count = 0\n"
            "for i in range(len(content) - len(word) + 1):\n"
            "    if content[i:i+len(word)] == word:\n"
            "        count += 1\n\n"
            "print('Total count:', count)",
        'difficulty': 'medium',
      },
    ],
    'importantSyntax': [
      {'syntax': 'f = open("filename", "r")', 'example': 'f = open("data.txt", "r")', 'description': 'File ko read mode mein open karta hai. "r" default hai, optional hai.'},
      {'syntax': 'f.read()', 'example': 'content = f.read()', 'description': 'Poori file ka content ek string mein return karta hai.'},
      {'syntax': 'f.close()', 'example': 'f.close()', 'description': 'File ko band karta hai - resources free karta hai. Hamesha call karo.'},
      {'syntax': 'if "word" in content:', 'example': 'if("python" in content):', 'description': 'Check karta hai ki word string mein present hai ya nahi, boolean return karta hai.'},
    ],
    'commonMistakes': [
      'File close karna bhoolna - resources waste hote hain, file locked reh sakti hai',
      'File path galat dena - FileNotFoundError aa jaayega',
      'Write mode mein read karne ki koshish karna - UnsupportedOperation error',
      'f.read() ke baad dobara f.read() karna - pehli baar poora content padh liya, ab empty string milega',
    ],
  };
}

Map<String, dynamic> topic9_2() {
  return {
    'id': 'topic_9_2',
    'name': 'Writing Files',
    'chapterId': 'chapter_9',
    'subjectId': 'python',
    'order': 34,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=21865',
    'keyPoints': [
      'File writing ke liye do modes hote hain: "w" (write) aur "a" (append)',
      '"w" mode file ko overwrite karta hai - purana content delete ho jaata hai, naya likha jaata hai',
      '"a" mode file ke end mein naya content add karta hai - purana content safe rehta hai',
      'f.write("text") function string ko file mein likhta hai',
      'Agar "w" mode mein file exist nahi karti, toh Python nayi file create kar deta hai',
      'f.close() writing ke baad bhi zaroori hai - data buffer se file mein flush hota hai',
      'f.write() returns number of characters written',
      'with statement use karo toh close() khud ho jaata hai - safe aur clean',
      'Real-world use: game hiscore save karna, logs write karna, data export karna',
    ],
    'keyConcepts': [
      'Write mode ("w")',
      'Append mode ("a")',
      'f.write() method',
      'File creation on write',
      'Overwriting vs appending',
    ],
    'aiCoachScript': '''Chalo ab seekhte hain files mein kaise likhte hain.

File writing ke do modes hote hain:
1. "w" - Write mode. Yeh file ko overwrite karta hai. Matlab purana content delete ho jaata hai aur naya content likha jaata hai.
2. "a" - Append mode. Yeh file ke end mein naya content add karta hai. Purana content safe rehta hai.

Write mode ka example:
f = open("myfile.txt", "w")
f.write("Hey Harry you are amazing")
f.close()

Isse myfile.txt mein "Hey Harry you are amazing" likh jaayega. Agar file pehle se thi, toh usme jo bhi tha - sab delete ho jayega aur sirf yeh naya content bachega.

Ab Append mode:
f = open("myfile.txt", "a")
f.write("Hey Harry you are amazing")
f.close()

Isse file ke end mein "Hey Harry you are amazing" add ho jayega. Purana content kuch nahi hoga.

Important: Agar "w" mode mein file exist nahi karti, toh Python apne aap nayi file create kar deta hai. Koi error nahi aata. Lekin "r" mode mein agar file nahi hai toh FileNotFoundError aata hai.

Ab ek interesting example - game hiscore:
Ek game hai jo random score generate karta hai. High score file mein save hota hai.

def game():
    score = random.randint(1, 62)
    with open("hiscore.txt") as f:
        hiscore = f.read()
        if(hiscore != ""):
            hiscore = int(hiscore)
        else:
            hiscore = 0
    if(score > hiscore):
        with open("hiscore.txt", "w") as f:
            f.write(str(score))
    return score

Dekha? Pehle hiscore file padhta hai, phir compare karta hai. Agar naya score zyada hai toh write karta hai.

Aur ek aur use case - multiplication tables generate karna:
def generateTable(n):
    table = ""
    for i in range(1, 11):
        table += f"{n} X {i} = {n*i}\n"
    with open(f"tables/table_{n}.txt", "w") as f:
        f.write(table)

Yeh 2 se 20 tak saare tables ki alag-alag files bana deta hai.

Yaad rakho: "w" overwrite karta hai, "a" append karta hai. Dono mein file exist na ho toh nayi file create hoti hai. Aur close() bhoolna mat!''',
    'codeExamples': [
      {
        'title': 'Writing to a File with "w" Mode',
        'code': "st = 'Hey Harry you are amazing'\n\n"
            "f = open('myfile.txt', 'w')\n"
            "f.write(st)\n"
            "f.close()",
        'explanation': '"w" mode file ko write ke liye kholta hai. Agar file exist karti hai toh overwrite hoti hai. Agar nahi karti toh nayi file create hoti hai. f.write() string ko file mein likhta hai.',
        'output': "(myfile.txt created with content: 'Hey Harry you are amazing')",
      },
      {
        'title': 'Appending to a File with "a" Mode',
        'code': "st = 'Hey Harry you are amazing'\n\n"
            "f = open('myfile.txt', 'a')\n"
            "f.write(st)\n"
            "f.close()",
        'explanation': '"a" mode file ko append ke liye kholta hai. Yeh file ke end mein naya content add karta hai bina purane content ko delete kiye. Multiple runs se content bar-abar add hota rehta hai.',
        'output': "(myfile.txt now has previous content + 'Hey Harry you are amazing' appended)",
      },
      {
        'title': 'Game Hiscores - Reading and Writing',
        'code': "import random\n\n"
            "def game():\n"
            "    score = random.randint(1, 62)\n"
            "    with open('hiscore.txt') as f:\n"
            "        hiscore = f.read()\n"
            "        if(hiscore != ''):\n"
            "            hiscore = int(hiscore)\n"
            "        else:\n"
            "            hiscore = 0\n"
            "    print(f'Your score: {score}')\n"
            "    if(score > hiscore):\n"
            "        with open('hiscore.txt', 'w') as f:\n"
            "            f.write(str(score))\n"
            "    return score\n\n"
            "game()",
        'explanation': 'Pehle hiscore.txt read karta hai, existing high score nikaalta hai. Phir current score se compare karta hai. Agar naya score zyada hai toh "w" mode mein file mein write karta hai. with statement ensure karta hai ki file apne aap close ho.',
        'output': "Your playing the game..\nYour score: 42\n(If score > hiscore, hiscore.txt is updated with new score)",
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo user se 5 cities ke naam input le aur har naam ko cities.txt file mein write kare (har naam nayi line mein). open() aur close() use karo.',
        'hint': "open('cities.txt', 'w') se file write mode mein kholo. range(5) ka for loop chalao, input() se naam lo aur f.write(name + '\\n') se write karo. Close mat bhoolna.",
        'solution': "f = open('cities.txt', 'w')\n"
            "for i in range(5):\n"
            "    name = input('Enter city name: ')\n"
            "    f.write(name + '\\n')\n"
            "f.close()\n"
            "print('Cities saved!')",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo 2 se 20 tak multiplication tables generate kare aur har table ko alag file mein save kare (jaise table_2.txt, table_3.txt, etc.).',
        'hint': 'def generateTable(n) function banao jo table string banaye. range(1,11) se loop karo. str(n) + " X " + str(i) + " = " + str(n*i) use karo. open() aur close() se file handle karo.',
        'solution': "def generateTable(n):\n"
            "    table = ''\n"
            "    for i in range(1, 11):\n"
            "        table += str(n) + ' X ' + str(i) + ' = ' + str(n * i) + '\\n'\n"
            "    f = open('tables/table_' + str(n) + '.txt', 'w')\n"
            "    f.write(table)\n"
            "    f.close()\n\n"
            "for i in range(2, 21):\n"
            "    generateTable(i)",
        'difficulty': 'hard',
      },
      {
        'question': 'Ek file.txt hai jisme "Donkey" word hai. Program likho jo "Donkey" ko "######" se replace kare aur file ko update kare.',
        'hint': 'Pehle "r" mode mein open karo, read karo, close karo. Phir str.replace("Donkey", "######") se replace karo. Phir "w" mode mein open karo, write karo, close karo.',
        'solution': "word = 'Donkey'\n\n"
            "f = open('file.txt', 'r')\n"
            "content = f.read()\n"
            "f.close()\n\n"
            "contentNew = content.replace(word, '######')\n\n"
            "f = open('file.txt', 'w')\n"
            "f.write(contentNew)\n"
            "f.close()",
        'difficulty': 'easy',
      },
    ],
    'importantSyntax': [
      {'syntax': 'f = open("file", "w")', 'example': 'f = open("data.txt", "w")', 'description': 'Write mode - file create karega ya overwrite karega'},
      {'syntax': 'f = open("file", "a")', 'example': 'f = open("log.txt", "a")', 'description': 'Append mode - file ke end mein content add karega'},
      {'syntax': 'f.write(string)', 'example': 'f.write("Hello World")', 'description': 'String ko file mein likhta hai. Purana content "w" mein delete hota hai, "a" mein nahi'},
      {'syntax': 'str(int_value)', 'example': 'f.write(str(score))', 'description': 'Integer ko string mein convert karta hai taake file mein likh sakein'},
    ],
    'commonMistakes': [
      '"w" mode mein file kholna jab append karna chahte ho - purana data delete ho jayega',
      'f.write() mein integer directly pass karna - TypeError aayega, pehle str() mein convert karo',
      'f.close() bhoolna - writing buffer flush nahi hoga, data loss ho sakta hai',
      'File path nahi dena - current directory mein file create/overwrite hogi, kabhi unexpected',
    ],
  };
}

Map<String, dynamic> topic9_3() {
  return {
    'id': 'topic_9_3',
    'name': 'File Methods & With Statement',
    'chapterId': 'chapter_9',
    'subjectId': 'python',
    'order': 35,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=22305',
    'keyPoints': [
      'f.readline() file ki ek line padhta hai - har call par next line return karta hai',
      'Jab file khatam ho jaati hai toh readline() empty string ("") return karta hai',
      'f.readlines() saari lines ki list return karta hai - [line1, line2, line3]',
      'with statement file ko automatically close karta hai - alag se f.close() ki zaroorat nahi',
      'with open("file") as f: - yeh syntax hai, file sirf with block ke andar accessible hai',
      'with block ke bahar file automatically close ho jaati hai - bina close() call kiye',
      'readline() ka use while loop ke saath karke line-by-line processing kar sakte ho',
      'File methods jaise .read(), .readline(), .readlines() teeno useful hain',
      'with statement Pythonic tarika hai file handling ka - recommended approach hai',
    ],
    'keyConcepts': [
      'f.readline() method',
      'f.readlines() method',
      'with statement',
      'Context manager',
      'Automatic file closing',
    ],
    'aiCoachScript': '''Chalo doston, ab seekhenge kuch advanced file methods aur with statement ke baare mein.

Pehle baat karte hain file methods ki:

1. f.read() - poora content ek string mein (humne seekh liya)
2. f.readline() - ek line padhta hai, har call next line
3. f.readlines() - saari lines ki list return karta hai

readline() ka use:
f = open("file.txt")
line = f.readline()
while(line != ""):
    print(line)
    line = f.readline()
f.close()

Jab tak line empty nahi hoti (matlab file khatam nahi hoti), tab tak loop chalta hai. Har baar nayi line padhta hai.

readlines() ka use:
lines = f.readlines()
for line in lines:
    print(line)

Saari lines ek list mein aa jaati hain. Phir aap for loop se process kar sakte ho.

Ab baat karte hain WITH STATEMENT ki.

Jab bhi aap file open karte ho, close karna important hai. Lekin kabhi kabhi bhool jaate ho. Kya ho agar automatic close ho jaaye?

with open("file.txt") as f:
    print(f.read())

Bas! File apne aap close ho jayegi jaise hi with block khatam hota hai. No f.close() needed.

Yeh Python ka context manager feature hai. Sirf file ke liye nahi, aur bhi cheezo ke liye kaam karta hai.

With statement ke faayde:
1. Automatic close - bhoolne ka dar nahi
2. Cleaner code - less lines
3. Safe - exceptions ke case mein bhi file close hoti hai

Real-world example - file copy:
with open("this.txt") as f:
    content = f.read()

with open("this_copy.txt", "w") as f:
    f.write(content)

Dekho kitna clean hai. Pehle with mein read, phir with mein write. No close calls.

Yeh Python ka recommended tarika hai file handling ka. Hamesha with statement use karo jab bhi possible ho.

Yaad rakho:
- readline() = ek line
- readlines() = saari lines ki list
- with = automatic close
- with open("file") as f: - modern, safe, clean

Chalo ab practice karte hain!''',
    'codeExamples': [
      {
        'title': 'Reading Line by Line with readline()',
        'code': "f = open('file.txt')\n"
            "line = f.readline()\n"
            "while(line != ''):\n"
            "    print(line)\n"
            "    line = f.readline()\n"
            "f.close()",
        'explanation': 'readline() har call par ek line return karta hai. Jab file khatam hoti hai, empty string return karta hai. While loop tab tak chalta hai jab tak line empty na ho. Yeh memory-efficient hai - poori file ek saath load nahi hoti.',
        'output': "Hey Harry you are amazing\n\nPython is fun!\n",
      },
      {
        'title': 'The with Statement - Automatic File Closing',
        'code': "# Without with (manual close):\n"
            "f = open('file.txt')\n"
            "print(f.read())\n"
            "f.close()\n\n"
            "# With with (auto close):\n"
            "with open('file.txt') as f:\n"
            "    print(f.read())",
        'explanation': 'Dono same kaam karte hain. But with statement f.close() automatically call karta hai jab block khatam ho. Zyada safe aur clean. with block ke bahar file access nahi kar sakte.',
        'output': "Hey Harry you are amazing\nPython is fun!\n\nHey Harry you are amazing\nPython is fun!",
      },
      {
        'title': 'Copying a File using with Statement',
        'code': "with open('this.txt') as f:\n"
            "    content = f.read()\n\n"
            "with open('this_copy.txt', 'w') as f:\n"
            "    f.write(content)",
        'explanation': 'Pehla with block this.txt ko read karta hai. Dusra with block content ko this_copy.txt mein write karta hai. Dono files apne-aap close ho jaate hain. File copy ka simple aur clean solution.',
        'output': "(File this_copy.txt created with identical content to this.txt)",
      },
    ],
    'challenges': [
      {
        'question': 'Ek file.txt hai jisme kuch words hain: "Donkey", "bad", "ganda". Program likho jo in teeno words ko hash symbols ("#") se replace kare. Har word ko utne hashtags se replace karo jitne usme letters hain.',
        'hint': 'words list banao ["Donkey", "bad", "ganda"]. File read karo. Har word ke liye content.replace(word, "#" * len(word)). Phir overwrite karo.',
        'solution': "words = ['Donkey', 'bad', 'ganda']\n\n"
            "with open('file.txt', 'r') as f:\n"
            "    content = f.read()\n\n"
            "for word in words:\n"
            "    content = content.replace(word, '#' * len(word))\n\n"
            "with open('file.txt', 'w') as f:\n"
            "    f.write(content)",
        'difficulty': 'medium',
      },
      {
        'question': 'Program likho jo this.txt file ka content this_copy.txt mein copy kare. Dono files identical honi chahiye after copy.',
        'hint': 'Do with blocks use karo. Pehle read karo this.txt se, phir write karo this_copy.txt mein. Simple read aur write.',
        'solution': "with open('this.txt') as f:\n"
            "    content = f.read()\n\n"
            "with open('this_copy.txt', 'w') as f:\n"
            "    f.write(content)",
        'difficulty': 'easy',
      },
      {
        'question': 'Do files this.txt aur this_copy.txt hain. Program likho jo check kare ki dono files identical hain ya nahi. Agar identical hain toh "Yes these files are identical" print karo.',
        'hint': 'Dono files ko alag-alag with blocks mein read karo. Phir content1 == content2 compare karo. Strings compare kar rahe ho.',
        'solution': "with open('this.txt') as f:\n"
            "    content1 = f.read()\n\n"
            "with open('this_copy.txt') as f:\n"
            "    content2 = f.read()\n\n"
            "if(content1 == content2):\n"
            "    print('Yes these files are identical')\n"
            "else:\n"
            "    print('No these files are not identical')",
        'difficulty': 'medium',
      },
    ],
    'importantSyntax': [
      {'syntax': 'f.readline()', 'example': 'line = f.readline()', 'description': 'File ki ek line padhta hai. Har call next line return karta hai. File khatam hone par "" return karta hai.'},
      {'syntax': 'f.readlines()', 'example': 'lines = f.readlines()', 'description': 'Saari lines ki list return karta hai. Har line list ka ek element hoti hai.'},
      {'syntax': 'with open("file") as f:', 'example': 'with open("data.txt") as f:', 'description': 'Context manager - file automatically close hoti hai block ke bahar jaate hi. f.close() ki zaroorat nahi.'},
      {'syntax': 'while(line != ""):', 'example': 'while(line != ""): print(line)', 'description': 'File ko line-by-line padhne ka pattern. Jab line empty hai, file khatam.'},
    ],
    'commonMistakes': [
      'readline() ke saath while loop mein infinite loop - line update karna bhoolna',
      'with block ke bahar file variable access karna - file already close ho chuki hai',
      'readlines() bhool kar readline() use karna jab saari lines chahiye - extra loops lagenge',
      'readline() ka result empty string check karna bhoolna - extra empty iteration ho sakti hai',
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
