// Run: dart run scripts/seed_python_ch5.dart
// Seeds Python Ch 5: Dictionary & Sets (4 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 5...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_5', {
    'id': 'chapter_5',
    'subjectId': 'python',
    'name': 'Dictionary & Sets',
    'order': 5,
    'totalTopics': 4,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_5_1', 'chapterId': 'chapter_5', 'name': 'Dictionary Properties', 'order': 20},
    {'topicId': 'topic_5_2', 'chapterId': 'chapter_5', 'name': 'Dictionary Methods', 'order': 21},
    {'topicId': 'topic_5_3', 'chapterId': 'chapter_5', 'name': 'Sets', 'order': 22},
    {'topicId': 'topic_5_4', 'chapterId': 'chapter_5', 'name': 'Set Operations', 'order': 23},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic5_1(), topic5_2(), topic5_3(), topic5_4()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_5/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 5 seeded successfully.');
}

Map<String, dynamic> topic5_1() {
  return {
    'id': 'topic_5_1',
    'name': 'Dictionary Properties',
    'chapterId': 'chapter_5',
    'subjectId': 'python',
    'order': 20,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=8787',
    'keyPoints': [
      'Dictionary curly braces {} use karta hai aur har item key-value pair mein hota hai',
      'Key unique hoti hai — same key dobara use karo toh purani value overwrite ho jati hai',
      'Key-value pair colon (:) se separate hota hai aur pairs comma (,) se',
      'Value kuch bhi ho sakti hai — string, number, list, even another dictionary',
      'print(dict_name["key"]) se specific key ki value access karte hain',
      'Error: agar key exist nahi karti toh KeyError aata hai square brackets mein access karne par',
    ],
    'keyConcepts': [
      'Key-value pairs',
      'Dictionary literal {}',
      'Key access with []',
      'Key uniqueness',
      'KeyError',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Python Dictionary ke baare mein.

Dictionary ek data structure hai jo key-value pairs mein data store karta hai. Jaise ek real dictionary hoti hai — word aur uski definition — waise hi Python dictionary mein key hoti hai aur uski value hoti hai.

Dictionary curly braces {} se banti hai. Har key aur value ke beech mein colon (:) lagta hai, aur har pair comma (,) se separate hota hai. Example dekho:

marks = {"Harry": 100, "Shubham": 56, "Rohan": 23}

Yahan "Harry", "Shubham", "Rohan" keys hain aur 100, 56, 23 unki values hain. Keys unique hoti hain — agar aap same key dobara use karo toh purani value overwrite ho jayegi.

Value access karne ke liye square brackets use karo:
print(marks["Harry"]) → 100 print karega

Lekin dhyan rakho — agar aap print(marks["Harry2"]) likhoge aur "Harry2" dictionary mein nahi hai, toh KeyError aayega. Is problem ka solution hum agle topic mein dekhenge.

Dictionary mein keys hamesha unique hoti hain. Values kuch bhi ho sakti hain — strings, numbers, lists, even other dictionaries. Yeh bahut flexible hai.

Yaad rakho: Dictionary = key-value pairs ka collection. Ordered, changeable, aur unique keys.''',
    'codeExamples': [
      {
        'title': 'Dictionary Basics',
        'code': "marks = {\"Harry\": 100, \"Shubham\": 56, \"Rohan\": 23}\nprint(marks[\"Harry\"])",
        'explanation': 'marks ek dictionary hai jisme teen key-value pairs hain. Har student ka naam key hai aur uske marks value hain. print(marks["Harry"]) se Harry ke marks access hote hain — output 100 aayega.',
        'output': '100',
      },
      {
        'title': 'Dictionary with Mixed Value Types',
        'code': "student = {\n    \"name\": \"Rohan\",\n    \"age\": 18,\n    \"marks\": [95, 87, 92]\n}\nprint(student[\"name\"])\nprint(student[\"marks\"])",
        'explanation': 'Dictionary ki value kuch bhi ho sakti hai. Yahan "marks" key ki value ek list hai. Aisi flexibility sirf dictionaries mein milti hai.',
        'output': 'Rohan\n[95, 87, 92]',
      },
    ],
    'challenges': [
      {
        'question': 'Ek dictionary banao jisme 3 friends ke naam aur unke favourite colors store ho. Phir kisi ek friend ka favourite color print karo.',
        'hint': 'Dictionary curly braces {} mein banao. Jaise: {"Ram": "Blue", "Shyam": "Red"}. Phir square brackets [] se access karo.',
        'solution': 'colors = {"Ram": "Blue", "Shyam": "Green", "Mohan": "Red"}\nprint(colors["Shyam"])',
        'difficulty': 'easy',
      },
      {
        'question': 'Do dictionaries lo — pehli mein 2 items: {"a": 1, "b": 2}, doosri mein 2 items: {"c": 3, "d": 4}. Ek third dictionary banao aur manually (bina loop ke) saare 4 items daalo using square brackets assignment.',
        'hint': 'Merged = {} banao. Phir merged["a"] = d1["a"], merged["b"] = d1["b"], merged["c"] = d2["c"], merged["d"] = d2["d"] karo.',
        'solution': "d1 = {\"a\": 1, \"b\": 2}\nd2 = {\"c\": 3, \"d\": 4}\nmerged = {}\nmerged[\"a\"] = d1[\"a\"]\nmerged[\"b\"] = d1[\"b\"]\nmerged[\"c\"] = d2[\"c\"]\nmerged[\"d\"] = d2[\"d\"]\nprint(merged)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek dictionary lo {"a": 1, "b": 2, "c": 3} aur iske keys aur values ko manually swap karo. Ek nayi dictionary banao jisme values keys ban jayein aur keys values ban jayein.',
        'hint': 'Swapped = {} banao. Phir swapped[original["a"]] = "a", swapped[original["b"]] = "b", swapped[original["c"]] = "c" likho.',
        'solution': "original = {\"a\": 1, \"b\": 2, \"c\": 3}\nswapped = {}\nswapped[original[\"a\"]] = \"a\"\nswapped[original[\"b\"]] = \"b\"\nswapped[original[\"c\"]] = \"c\"\nprint(swapped)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'dict = {key: value}', 'example': 'marks = {"Harry": 100}', 'description': 'Dictionary create karta hai'},
      {'syntax': 'dict["key"]', 'example': 'marks["Harry"]', 'description': 'Specific key ki value access karta hai'},
      {'syntax': 'dict["key"] = value', 'example': 'marks["New"] = 75', 'description': 'Naya key-value pair add karta hai'},
    ],
    'commonMistakes': [
      'Key exist nahi karti aur square brackets se access kar rahe ho — KeyError aayega',
      'Key ko double quotes mein na bandhna — variable samjhega Python',
      'Key-value pair ke beech mein colon ki jagah kuch aur laga dena — syntax error',
    ],
  };
}

Map<String, dynamic> topic5_2() {
  return {
    'id': 'topic_5_2',
    'name': 'Dictionary Methods',
    'chapterId': 'chapter_5',
    'subjectId': 'python',
    'order': 21,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=8880',
    'keyPoints': [
      '.items() method dictionary ke saare key-value pairs tuples ki list ki tarah return karta hai',
      '.keys() method sirf saari keys return karta hai — iteration ke liye useful',
      '.values() method sirf saari values return karta hai',
      '.update() method ek dictionary ke saare pairs doosri dictionary mein copy kar deta hai',
      '.get() method key access karne ka safe tarika hai — agar key nahi milti toh None return karta hai (error nahi)',
      'Square brackets [] vs .get(): [] throws KeyError, .get() throws None',
      '.get() mein second argument de sakte ho — default value jo return hogi agar key nahi mili',
    ],
    'keyConcepts': [
      '.items() method',
      '.keys() method',
      '.values() method',
      '.update() method',
      '.get() method vs []',
      'KeyError handling',
    ],
    'aiCoachScript': '''Ab hum seekhenge dictionary methods ke baare mein. Dictionary mein bahut saare built-in methods aate hain jo humari life easy kar dete hain.

Pehla method hai .items(). Yeh dictionary ke saare key-value pairs return karta hai — har pair ek tuple ki form mein. Jaise:

marks = {"Harry": 100, "Shubham": 56}
pairs = marks.items() → dict_items([("Harry", 100), ("Shubham", 56)])

Dusra method .keys() — saare keys ka view return karta hai. For loop mein iterate karne ke liye perfect.

Teessra method .values() — saari values ka view return karta hai.

Chautha method .update() — yeh ek dictionary ke saare pairs doosri dictionary mein merge kar deta hai. Jaise:

marks2 = {"Rohan": 23}
marks.update(marks2) → ab marks mein tino keys hain

Aur sabse important method .get(). Jab aap square brackets se key access karte ho aur key nahi milti, toh KeyError aata hai. Lekin .get() se agar key nahi milti toh None return hota hai — error nahi aata.

print(marks.get("Harry2")) → None
print(marks["Harry2"]) → KeyError!

Aap .get() mein second argument bhi de sakte ho — default value:

print(marks.get("Harry2", 0)) → 0 return karega

Methods ka use karke aap dictionary ke saath safe aur efficient code likh sakte ho. Khas kar .get() ka use karna ek achhi practice hai production code mein.''',
    'codeExamples': [
      {
        'title': 'Dictionary Methods Overview',
        'code': "marks = {\"Harry\": 100, \"Shubham\": 56, \"Rohan\": 23}\n\nprint(marks.items())\nprint(marks.keys())\nprint(marks.values())\n\nmarks.update({\"Harry\": 99, \"Renuka\": 87})\nprint(marks)",
        'explanation': '.items() saare key-value pairs dikhata hai, .keys() sirf keys, .values() sirf values. .update() se naye pairs add hote hain ya existing keys update hoti hain.',
        'output': "dict_items([('Harry', 100), ('Shubham', 56), ('Rohan', 23)])\ndict_keys(['Harry', 'Shubham', 'Rohan'])\ndict_values([100, 56, 23])\n{'Harry': 99, 'Shubham': 56, 'Rohan': 23, 'Renuka': 87}",
      },
      {
        'title': 'Safe Access with .get()',
        'code': "marks = {\"Harry\": 100, \"Shubham\": 56}\n\nprint(marks.get(\"Harry2\"))    # Safe — returns None\nprint(marks.get(\"Harry2\", 0)) # Default value 0\nprint(marks[\"Harry2\"])        # Error! KeyError",
        'explanation': '.get() method safe hai — agar key nahi milti toh None return karta hai. Second argument de kar default value bhi set kar sakte ho. Square brackets se KeyError aayega.',
        'output': 'None\n0\nKeyError: \'Harry2\'',
      },
    ],
    'challenges': [
      {
        'question': 'Ek dictionary banao jisme 5 students ke marks ho. .keys() aur .values() use karke alag-alag keys aur values print karo.',
        'hint': 'Dictionary banao, phir print(dict.keys()) aur print(dict.values()) likho.',
        'solution': "marks = {\"Ram\": 85, \"Shyam\": 92, \"Mohan\": 78, \"Sita\": 95, \"Gita\": 88}\nprint(\"Keys:\", marks.keys())\nprint(\"Values:\", marks.values())",
        'difficulty': 'easy',
      },
      {
        'question': 'Do dictionaries lo — ek mein Hindi-English words hain, doosre mein aur words. .update() method se dono ko merge karo.',
        'hint': 'Pehli dictionary mein {"apple": "seb", "banana": "kela"} rakho. Doosri mein {"mango": "aam"}. Phir pehli.update(doosri) karo.',
        'solution': "hindi_eng = {\"apple\": \"seb\", \"banana\": \"kela\"}\nmore_words = {\"mango\": \"aam\", \"grapes\": \"angoor\"}\n\nhindi_eng.update(more_words)\nprint(hindi_eng)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo user se key input le aur dictionary se value return kare. Agar key nahi hai toh .get() ka use karke "Key not found" return karo.',
        'hint': 'input() se key lo aur dict.get(key, "Key not found") use karo.',
        'solution': "marks = {\"Harry\": 100, \"Shubham\": 56, \"Rohan\": 23}\nkey = input(\"Enter student name: \")\nresult = marks.get(key, \"Key not found\")\nprint(result)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'dict.items()', 'example': 'marks.items()', 'description': 'Key-value pairs ka view return karta hai'},
      {'syntax': 'dict.keys()', 'example': 'marks.keys()', 'description': 'Saari keys ka view return karta hai'},
      {'syntax': 'dict.values()', 'example': 'marks.values()', 'description': 'Saari values ka view return karta hai'},
      {'syntax': 'dict.update(other_dict)', 'example': 'marks.update(new_marks)', 'description': 'Doosri dictionary ke pairs merge karta hai'},
      {'syntax': 'dict.get(key, default)', 'example': 'marks.get("Harry", 0)', 'description': 'Key ki value return karta hai ya default — safe access'},
    ],
    'commonMistakes': [
      '.get() ka use na karna aur square brackets se access karte waqt KeyError aana',
      '.update() ka result variable mein store karna — yeh in-place hota hai, None return karta hai',
      '.keys() ya .values() ko list samajh lena — yeh view objects hain, slicing support nahi karte',
    ],
  };
}

Map<String, dynamic> topic5_3() {
  return {
    'id': 'topic_5_3',
    'name': 'Sets',
    'chapterId': 'chapter_5',
    'subjectId': 'python',
    'order': 22,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=9420',
    'keyPoints': [
      'Set unordered collection hai unique elements ka — duplicate values automatically remove ho jati hain',
      'Empty set banane ke liye set() use karo, {} nahi — kyuki {} empty dictionary banata hai',
      'Set curly braces {} se banta hai — jaise s = {1, 5, 32, 54}',
      'Set mutable hota hai — isme elements add/remove kar sakte hain',
      'Set mein indexing nahi hoti — set[0] nahi likh sakte, TypeError aayega',
      'Set unique elements store karta hai — agar aap 5 ko multiple baar set mein daaloge toh sirf ek baar store hoga',
      'Set mein koi bhi immutable data type daal sakte ho — int, float, string, tuple',
    ],
    'keyConcepts': [
      'Set literal {}',
      'set() constructor',
      'Unique elements',
      'Unordered collection',
      'Mutable',
      'No indexing',
    ],
    'aiCoachScript': '''Chalo ab seekhte hain Sets ke baare mein. Set ek aisa data structure hai jo unique elements ka collection store karta hai.

Set banana bahut simple hai — curly braces use karo:
s = {1, 5, 32, 54, 5, 5, 5}

Dekha aapne? Maine 5 ko multiple baar likha but print(s) karoge toh sirf ek 5 dikhega. Kyunki set duplicate values allow nahi karta — automatically unique rakhta hai.

Important: Empty set banane ke liye set() likhna padega. Agar sirf {} likhoge toh Python samjhega empty dictionary hai, set nahi.

Set unordered hota hai — iska matlab elements ka koi fixed order nahi hai. Har baar print karoge toh koi bhi order aa sakta hai. Isliye set mein indexing nahi hoti. s[0] likhoge toh TypeError aayega.

Set mutable hota hai — hum isme elements add aur remove kar sakte hain. Agle topic mein methods dekhenge.

Set mein aap koi bhi immutable data type daal sakte ho — integers, floats, strings, tuples. Lekin list ya dictionary nahi daal sakte kyunki woh mutable hote hain.

Set use karo jab:
1. Unique elements chahiye
2. Duplicates ko automatically remove karna hai
3. Element ka order matter nahi karta

Chalo example dekhte hain: print(s) karo toh kuch aisa dikhega — {1, 32, 5, 54}. Order alag aa sakta hai, but saare elements unique honge!''',
    'codeExamples': [
      {
        'title': 'Set — Unique Elements',
        'code': "s = {1, 5, 32, 54, 5, 5, 5}\nprint(s)  # Duplicate 5s automatically removed",
        'explanation': 'Set apne aap duplicates remove kar deta hai. Chahe aap 5 ko kitni bhi baar likho, set mein sirf ek baar store hoga. Output mein unique values dikhengi.',
        'output': '{1, 32, 5, 54}',
      },
      {
        'title': 'Empty Set vs Empty Dictionary',
        'code': "e = set()   # Empty set\nprint(type(e))\n\nd = {}      # Empty dictionary (NOT set!)\nprint(type(d))",
        'explanation': 'Empty set banane ke liye set() use karo. {} empty dictionary banata hai, set nahi. type() function se check kar sakte ho.',
        'output': "<class 'set'>\n<class 'dict'>",
      },
    ],
    'challenges': [
      {
        'question': 'Ek set banao jisme numbers 1 se 10 ho, lekin intentionally kuch numbers repeat karo. Set print karo aur dekho ki duplicates remove hue ya nahi.',
        'hint': 'Curly braces mein numbers daalo: {1, 2, 3, 4, 5, 5, 6, 6, 7, 8, 9, 10, 10}. Phir print karo.',
        'solution': 's = {1, 2, 3, 4, 5, 5, 6, 6, 7, 8, 9, 10, 10}\nprint(s)',
        'difficulty': 'easy',
      },
      {
        'question': 'Ek program likho jo ek list se duplicates hata de using set. Jaise list = [1, 2, 2, 3, 4, 4, 5] se {1, 2, 3, 4, 5} banaye.',
        'hint': 'set() constructor mein list pass karo. Jaise: set(list) — yeh automatically duplicates remove kar dega.',
        'solution': 'my_list = [1, 2, 2, 3, 4, 4, 5]\nunique = set(my_list)\nprint(unique)',
        'difficulty': 'medium',
      },
      {
        'question': 'Ek mixed set banao jisme int, float aur string ho. Phir check karo ki length kitni hai. Kya set different data types ke duplicate values ko bhi unique rakhta hai?',
        'hint': 'Set banao: {1, 1.0, "1", 2, 2.0}. Yaad rakho Python mein 1 == 1.0 True hota hai! Isliye set unhe duplicate samjhega.',
        'solution': 's = {1, 1.0, "1", 2, 2.0, "2"}\nprint(s)\nprint(len(s))  # 1 and 1.0 same hain Python ke liye, string "1" alag hai',
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 's = {elem1, elem2}', 'example': 's = {1, 2, 3}', 'description': 'Set create karta hai'},
      {'syntax': 's = set()', 'example': 's = set()', 'description': 'Empty set create karta hai'},
      {'syntax': 'len(s)', 'example': 'len(s)', 'description': 'Set ki length (unique elements count) batata hai'},
    ],
    'commonMistakes': [
      'Empty set ke liye {} ka use karna — yeh dictionary banata hai, set nahi. set() use karo',
      'Set mein indexing try karna — s[0] se TypeError aayega',
      'Set mein list ya dictionary daalne ki koshish — TypeError kyunki woh mutable hain',
    ],
  };
}

Map<String, dynamic> topic5_4() {
  return {
    'id': 'topic_5_4',
    'name': 'Set Operations',
    'chapterId': 'chapter_5',
    'subjectId': 'python',
    'order': 23,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=9600',
    'keyPoints': [
      'Set methods: .add() se ek element add karte hain, .remove() se element delete karte hain',
      '.add(element) set mein ek naya element daalta hai — agar pehle se hai toh kuch nahi hota',
      '.remove(element) set se element hataata hai — agar element nahi milta toh KeyError aata hai',
      '.union() do sets ka combination return karta hai — saare unique elements dono sets se',
      '.intersection() do sets mein common elements return karta hai — sirf wahi jo dono mein hain',
      'type() function se kisi bhi variable ka data type check kar sakte ho',
      'Union aur intersection mathematical operations hain jo set theory se aate hain',
    ],
    'keyConcepts': [
      '.add() method',
      '.remove() method',
      '.union() method',
      '.intersection() method',
      'type() function',
      'Set theory operations',
    ],
    'aiCoachScript': '''Chalo ab set methods aur operations seekhte hain.

Teen important methods hain: .add(), .remove(), aur mathematical operations .union() aur .intersection().

Pehle .add() — set mein ek element add karta hai:
s = {1, 2, 3}
s.add(4) → {1, 2, 3, 4}
Agar element pehle se hai toh kuch nahi hota — set duplicate allow nahi karta.

Dusra .remove() — element delete karta hai:
s.remove(2) → {1, 3, 4}
Dhyan rakho — agar element set mein nahi hai toh KeyError aayega. Iska koi safe version nahi hai dictionary ke .get() jaisa.

Ab baat karte hain union aur intersection ki. Yeh mathematical set operations hain.

.union() do sets ka combination return karta hai — saare elements jo set1 mein hain ya set2 mein hain:
s1 = {1, 2, 3}
s2 = {3, 4, 5}
s1.union(s2) → {1, 2, 3, 4, 5}

.intersection() sirf common elements return karta hai:
s1.intersection(s2) → {3}

Aur type() function se kisi bhi variable ka type check kar sakte ho:
type(s) → <class 'set'>

Yaad rakho: sets powerful hote hain mathematical operations ke liye. Union aur intersection real-world problems solve karne mein bahut help karte hain — jaise do groups ke common members dhundhna.''',
    'codeExamples': [
      {
        'title': 'Set Methods — add and remove',
        'code': "s = {1, 5, 32, 54}\ns.add(100)\nprint(s)\n\ns.remove(5)\nprint(s)\n\nprint(type(s))",
        'explanation': '.add(100) se set mein 100 add ho gaya. .remove(5) se 5 delete ho gaya. type() function se check kiya ki s set hai.',
        'output': "{32, 1, 100, 5, 54}\n{32, 1, 100, 54}\n<class 'set'>",
      },
      {
        'title': 'Union and Intersection',
        'code': "s1 = {1, 2, 3}\ns2 = {3, 4, 5}\n\nprint(s1.union(s2))\nprint(s1.intersection(s2))",
        'explanation': 's1.union(s2) dono sets ke saare unique elements return karta hai — {1, 2, 3, 4, 5}. s1.intersection(s2) sirf common elements return karta hai — {3}.',
        'output': '{1, 2, 3, 4, 5}\n{3}',
      },
    ],
    'challenges': [
      {
        'question': 'Ek set banao jisme 5 elements ho. Phir .add() se 2 naye elements add karo aur .remove() se 1 element remove karo. Har step ke baad set print karo.',
        'hint': 's = {10, 20, 30, 40, 50} banao. Phir s.add(60), s.add(70), s.remove(10). Print karte raho.',
        'solution': "s = {10, 20, 30, 40, 50}\nprint(\"Original:\", s)\ns.add(60)\nprint(\"After add 60:\", s)\ns.add(70)\nprint(\"After add 70:\", s)\ns.remove(20)\nprint(\"After remove 20:\", s)",
        'difficulty': 'easy',
      },
      {
        'question': 'Do sets lo — ek mein 1-5 tak numbers, doosre mein 3-7 tak numbers. Union aur intersection dono find karo aur print karo.',
        'hint': 's1 = {1, 2, 3, 4, 5}, s2 = {3, 4, 5, 6, 7}. s1.union(s2) aur s1.intersection(s2) use karo.',
        'solution': "s1 = {1, 2, 3, 4, 5}\ns2 = {3, 4, 5, 6, 7}\nprint(\"Union:\", s1.union(s2))\nprint(\"Intersection:\", s1.intersection(s2))",
        'difficulty': 'medium',
      },
      {
        'question': 'Teen groups ke students ke naam sets mein store hain. Union use karke saare unique students ki list banao. Phir intersection use karke woh students dhundho jo teeno groups mein hain.',
        'hint': 'Group_A = {"Ram", "Shyam", "Mohan"}, Group_B = {"Shyam", "Sita", "Ram"}, Group_C = {"Ram", "Ravi", "Sita"}. Phir .union() aur .intersection() chain kar sakte ho.',
        'solution': "group_a = {\"Ram\", \"Shyam\", \"Mohan\"}\ngroup_b = {\"Shyam\", \"Sita\", \"Ram\"}\ngroup_c = {\"Ram\", \"Ravi\", \"Sita\"}\n\nall_students = group_a.union(group_b).union(group_c)\ncommon = group_a.intersection(group_b).intersection(group_c)\n\nprint(\"All students:\", all_students)\nprint(\"In all groups:\", common)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 's.add(element)', 'example': 's.add(10)', 'description': 'Set mein ek element add karta hai'},
      {'syntax': 's.remove(element)', 'example': 's.remove(10)', 'description': 'Set se element remove karta hai (error agar nahi mila)'},
      {'syntax': 's1.union(s2)', 'example': 's1.union(s2)', 'description': 'Do sets ka union (saare unique elements) return karta hai'},
      {'syntax': 's1.intersection(s2)', 'example': 's1.intersection(s2)', 'description': 'Do sets ka intersection (common elements) return karta hai'},
      {'syntax': 'type(var)', 'example': 'type(s)', 'description': 'Variable ka data type return karta hai'},
    ],
    'commonMistakes': [
      '.remove() se element delete karte waqt agar element nahi hai toh KeyError — pehle .discard() ya check karlo',
      '.union() aur .intersection() ko in-place samajh lena — yeh naya set return karte hain, original modify nahi karte',
      'Set ko sorted order expect karna — set unordered hota hai, har baar koi bhi order aa sakta hai',
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
