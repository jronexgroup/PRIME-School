// Run: dart run scripts/seed_python_ch12.dart
// Seeds Python Ch 12: Advanced Python 1 (5 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 12...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_12', {
    'id': 'chapter_12',
    'subjectId': 'python',
    'name': 'Advanced Python 1',
    'order': 12,
    'totalTopics': 5,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_12_1', 'chapterId': 'chapter_12', 'name': 'Walrus Operator', 'order': 41},
    {'topicId': 'topic_12_2', 'chapterId': 'chapter_12', 'name': 'Match Case', 'order': 42},
    {'topicId': 'topic_12_3', 'chapterId': 'chapter_12', 'name': 'Exception Handling', 'order': 43},
    {'topicId': 'topic_12_4', 'chapterId': 'chapter_12', 'name': 'Global & Enumerate', 'order': 44},
    {'topicId': 'topic_12_5', 'chapterId': 'chapter_12', 'name': 'List Comprehensions', 'order': 45},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic12_1(), topic12_2(), topic12_3(), topic12_4(), topic12_5()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_12/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 12 seeded successfully.');
}

Map<String, dynamic> topic12_1() {
  return {
    'id': 'topic_12_1',
    'name': 'Walrus Operator',
    'chapterId': 'chapter_12',
    'subjectId': 'python',
    'order': 41,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=29760',
    'keyPoints': [
      'Walrus operator := Python 3.8 mein aaya hai - ise assignment expression kehte hain',
      'Ye ek expression ke andar variable assign karne deta hai - do kaam ek saath',
      ':= ka matlab hai - assign karo aur phir use karo, ek hi line mein',
      'Bina walrus ke: value = len(list); if value > 5: print(value)',
      'Walrus ke saath: if (value := len(list)) > 5: print(value)',
      'Yeh code ko chhota aur readable banata hai, lekin careful raho - zyada use mat karo',
      'Common use cases: while loops, list comprehensions, condition checking',
      'Walrus operator ko assign karte time parentheses mein rakhna important hai',
    ],
    'keyConcepts': [
      'Walrus operator (:=)',
      'Assignment expression',
      'Python 3.8+ feature',
      'Inline assignment',
      'Expression vs statement',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge ek naya aur powerful operator - Walrus Operator.

Dekho, Python 3.8 mein ek naya feature aaya hai jiska naam hai Walrus Operator. Iska symbol hai :=. Aur ise assignment expression kehte hain.

:= kya karta hai? Ye ek hi line mein do kaam karta hai - pehle variable ko value assign karta hai, aur phir us value ko expression mein use karta hai.

Samjho ek example:

Bina walrus ke, agar hume check karna hai ki list ki length 5 se zyada hai toh hum likhte hain:
n = len(my_list)
if n > 5:
    print(n)

Lekin walrus operator ke saath:
if (n := len(my_list)) > 5:
    print(n)

Dekha? Ek hi line mein length nikaali, variable mein store kiya, aur condition check kar li.

Lekin yaad rakho - := ko hamesha parentheses mein rakhna. Kyonki := ki precedence kam hoti hai. Agar parentheses nahi doge, toh Python confuse ho jayega.

Walrus operator ka istemal karo jab:
1. Kisi expression ki value ko reuse karna ho
2. While loop mein user input check karte waqt
3. List comprehension mein filtering karte waqt

Lekin ek baat - walrus operator ka zyada istemal mat karo. Code ko readable rakhna zyada important hai. Sirf wahan use karo jahan woh actually helpful ho.

Chalo ab kuch code examples dekhte hain!''',
    'codeExamples': [
      {
        'title': 'Basic Walrus Operator',
        'code': "# Without walrus operator\ndata = [1, 2, 3, 4, 5, 6]\nn = len(data)\nif n > 3:\n    print(f\"Length of data is {n}\")\n\n# With walrus operator\nif (n := len(data)) > 3:\n    print(f\"Length of data is {n}\")",
        'explanation': 'Bina walrus ke hume pehle len() ko variable mein store karna padta, phir condition check karni padti. Walrus operator se dono kaam ek hi line mein ho gaye. := ne len(data) ko n mein assign kiya aur wohi value condition mein use hui.',
        'output': 'Length of data is 6\nLength of data is 6',
      },
      {
        'title': 'Walrus in While Loop',
        'code': "# Without walrus\nwhile True:\n    line = input(\"Enter text: \")\n    if line == \"quit\":\n        break\n    print(f\"You entered: {line}\")\n\n# With walrus\nwhile (line := input(\"Enter text: \")) != \"quit\":\n    print(f\"You entered: {line}\")",
        'explanation': 'While loop mein walrus operator kaam aata hai jab hume user input check karna ho. Bina walrus ke hume infinite loop + break use karna padta. Walrus ke saath ek hi line mein input liya, assign kiya, aur condition check ki.',
        'output': "Enter text: hello\nYou entered: hello\nEnter text: quit\n(loop ends)",
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo user se numbers leta rahe jab tak woh 0 na daale. Har number ko double karke print karo. Walrus operator use karo while loop mein.',
        'hint': 'while (n := int(input())) != 0: ke structure mein karo. Har baar n*2 print karo.',
        'solution': "print(\"Enter numbers (0 to stop):\")\nwhile (n := int(input())) != 0:\n    print(f\"Double: {n * 2}\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek list mein se numbers filter karo jo 10 se zyada hain, aur unka square nikaalo. Lekin ek hi list comprehension mein walrus operator ka use karke karo.',
        'hint': 'List comprehension mein [sq for x in list if (sq := x**2) > 50] type syntax use karo.',
        'solution': "numbers = [2, 5, 8, 12, 15, 3, 20]\nresult = [sq for x in numbers if (sq := x**2) > 50]\nprint(result)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek program likho jo ek file ka content padhe aur pehli line jisme "error" word ho usko uppercase mein print kare. Walrus operator ke saath ek hi line mein karo.',
        'hint': 'File read karo, splitlines karo, aur next() ke saath walrus use karo. next((line.upper() for line in lines if (found := \"error\" in line)), \"No error found\")',
        'solution': "with open(\"log.txt\", \"r\") as f:\n    lines = f.read().splitlines()\nfirst_error = next((line.upper() for line in lines if (found := \"error\" in line.lower())), \"No error found\")\nprint(first_error)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': '(variable := expression)', 'example': '(n := len(data))', 'description': 'Expression ko variable mein assign karke us value ko use karta hai'},
      {'syntax': 'while (line := input()):', 'example': 'while (line := input()) != \"quit\":', 'description': 'While loop mein input assign aur check ek saath'},
      {'syntax': '[expr for x in list if (v := f(x))]', 'example': '[sq for x in nums if (sq := x**2) > 10]', 'description': 'List comprehension mein walrus operator'},
      {'syntax': 'if (v := len(x)) > n:', 'example': 'if (n := len(data)) > 5:', 'description': 'Condition ke andar variable assign karna'},
    ],
    'commonMistakes': [
      'Parentheses bhoolna - := ke bina parentheses ke around, precedence issues hote hain',
      'Walrus operator ka overuse - jahan zaroorat nahi wahan bhi use karna, code confusing ho jata hai',
      ':= ko == se confuse karna - := assignment hai, == comparison hai',
    ],
  };
}

Map<String, dynamic> topic12_2() {
  return {
    'id': 'topic_12_2',
    'name': 'Match Case',
    'chapterId': 'chapter_12',
    'subjectId': 'python',
    'order': 42,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=29940',
    'keyPoints': [
      'Match case Python 3.10 mein aaya hai - yeh switch-case ka advanced version hai',
      'Match case se hum multiple patterns ko match kar sakte hain ek saath',
      'Syntax: match variable: case pattern1: ... case pattern2: ...',
      'Default case ke liye case _: use karte hain - underscore wildcard hai',
      'Match case mein hum values, tuples, lists aur objects match kar sakte hain',
      'Case mein condition bhi laga sakte hain using if guard - case x if x > 0:',
      'Or operator use kar sakte hain case mein - case 1 | 2 | 3:',
      'Match case code ko zyada readable banata hai complex if-else chains se',
    ],
    'keyConcepts': [
      'Match case statement',
      'Pattern matching',
      'Wildcard pattern (_)',
      'Guard conditions (if)',
      'Or patterns (|)',
    ],
    'aiCoachScript': '''Chalo ab baat karte hain Match Case ki. Yeh Python 3.10 mein aaya hai aur switch-case ka ek smart version hai.

Aap logo ne if-elif-else ka istemal kiya hoga. Lekin jab bahut saari conditions hoti hain, toh code messy ho jata hai. Wahan Match Case kaam aata hai.

Dekho syntax:

match variable:
    case 1:
        print("One")
    case 2:
        print("Two")
    case _:
        print("Something else")

Yahan _ underscore wildcard hai - matlab kuch bhi. Agar upar koi case match nahi kiya, toh case _ execute hoga. Ye default jaisa hai.

Match case sirf values nahi, balki complex patterns bhi match kar sakta hai. Jaise:

match point:
    case (0, 0):
        print("Origin")
    case (0, y):
        print(f"Y-axis at {y}")
    case (x, 0):
        print(f"X-axis at {x}")
    case (x, y):
        print(f"Point at ({x}, {y})")

Dekha kitna powerful hai? Ye tuple ke structure ko bhi match kar sakta hai.

Aur conditions bhi laga sakte ho using if guard:
case x if x > 0:
    print("Positive")

Or operator bhi use kar sakte ho:
case 1 | 2 | 3:
    print("Small number")

Match case ka istemal karo jab tumhare paas multiple related conditions hain. Code readable aur maintainable banega.

Chalo ab kuch examples dekhte hain!''',
    'codeExamples': [
      {
        'title': 'Basic Match Case - Day of Week',
        'code': "day = 3\n\nmatch day:\n    case 1:\n        print(\"Monday\")\n    case 2:\n        print(\"Tuesday\")\n    case 3:\n        print(\"Wednesday\")\n    case 4:\n        print(\"Thursday\")\n    case 5:\n        print(\"Friday\")\n    case 6 | 7:\n        print(\"Weekend\")\n    case _:\n        print(\"Invalid day\")",
        'explanation': 'Match case simple integer matching dikhata hai. case 6 | 7 mein or operator use kiya gaya hai. case _ default case hai jo kisi bhi value ko match karta hai. Jab day = 3 hai, toh case 3 match hoga aur "Wednesday" print hoga.',
        'output': 'Wednesday',
      },
      {
        'title': 'Pattern Matching with Tuples',
        'code': "def locate_point(p):\n    match p:\n        case (0, 0):\n            print(\"Origin\")\n        case (0, y):\n            print(f\"On Y axis at y={y}\")\n        case (x, 0):\n            print(f\"On X axis at x={x}\")\n        case (x, y) if x == y:\n            print(f\"On diagonal at ({x}, {y})\")\n        case (x, y):\n            print(f\"Point at ({x}, {y})\")\n        case _:\n            print(\"Not a point\")\n\nlocate_point((0, 5))\nlocate_point((3, 3))",
        'explanation': 'Yeh example tuple pattern matching dikhata hai. case (0, 0) exact match karta hai. case (0, y) first coordinate 0 hone par second ko y mein bind karta hai. case (x, y) if x == y mein guard condition use hui hai. Pattern matching ekdum powerful hai!',
        'output': 'On Y axis at y=5\nOn diagonal at (3, 3)',
      },
    ],
    'challenges': [
      {
        'question': 'Ek calculator program likho jo do numbers aur operator lega. Match case ka use karke +, -, *, / ko handle karo aur default case mein "Invalid operator" print karo.',
        'hint': 'match operator: case "+": print(a+b) ... case _: print("Invalid operator")',
        'solution': "a = 10\nb = 5\nop = \"*\"\n\nmatch op:\n    case \"+\":\n        print(f\"{a} + {b} = {a + b}\")\n    case \"-\":\n        print(f\"{a} - {b} = {a - b}\")\n    case \"*\":\n        print(f\"{a} * {b} = {a * b}\")\n    case \"/\":\n        print(f\"{a} / {b} = {a / b}\")\n    case _:\n        print(\"Invalid operator\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek function likho jo HTTP status code le aur match case se uska message bataye. Jaise 200 -> OK, 404 -> Not Found, 500 -> Server Error, 400 -> Bad Request, 300 range -> Redirect, baaki -> Unknown Status.',
        'hint': 'case 200: print("OK"). case 404: print("Not Found"). case range ke liye case 300 | 301 | 302 ... use karo ya if guard lagao.',
        'solution': "def http_status(code):\n    match code:\n        case 200:\n            print(\"OK\")\n        case 201:\n            print(\"Created\")\n        case 301 | 302 | 307:\n            print(\"Redirect\")\n        case 400:\n            print(\"Bad Request\")\n        case 401 | 403:\n            print(\"Unauthorized\")\n        case 404:\n            print(\"Not Found\")\n        case 500:\n            print(\"Internal Server Error\")\n        case _:\n            print(\"Unknown Status\")\n\nhttp_status(404)\nhttp_status(500)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek shape area calculator banao jo match case use kare. Tuples input honge: ("circle", r), ("rectangle", l, w), ("triangle", b, h). Har shape ka area calculate karo. Unknown shape ke liye error do.',
        'hint': 'match shape: case (\"circle\", r): print(3.14 * r * r). case (\"rectangle\", l, w): print(l * w). case (\"triangle\", b, h): print(0.5 * b * h).',
        'solution': "def area(shape):\n    match shape:\n        case (\"circle\", r):\n            print(f\"Area of circle: {3.14 * r * r}\")\n        case (\"rectangle\", l, w):\n            print(f\"Area of rectangle: {l * w}\")\n        case (\"triangle\", b, h):\n            print(f\"Area of triangle: {0.5 * b * h}\")\n        case _:\n            print(\"Unknown shape\")\n\narea((\"circle\", 5))\narea((\"rectangle\", 4, 6))\narea((\"square\", 3))",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'match variable:\n    case pattern:', 'example': 'match x:\n    case 1:\n        print("one")', 'description': 'Variable ko pattern se match karta hai'},
      {'syntax': 'case pattern if condition:', 'example': 'case x if x > 0:', 'description': 'Guard condition ke saath pattern matching'},
      {'syntax': 'case pattern1 | pattern2:', 'example': 'case 1 | 2 | 3:', 'description': 'Multiple patterns ko ek case mein combine karna'},
      {'syntax': 'case _:', 'example': 'case _:', 'description': 'Default / wildcard case - kisi bhi value ko match karta hai'},
    ],
    'commonMistakes': [
      'Case block mein break statement laga dena - Python mein match case ko break ki zaroorat nahi, C jaisa fall through nahi hota',
      'case _ ko upar rakh dena - case _ hamesha sabse last mein aata hai',
      'Patterns ko complicate kar dena - simple rakho, readability important hai',
    ],
  };
}

Map<String, dynamic> topic12_3() {
  return {
    'id': 'topic_12_3',
    'name': 'Exception Handling',
    'chapterId': 'chapter_12',
    'subjectId': 'python',
    'order': 43,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=30240',
    'keyPoints': [
      'Exception handling se hum errors ko gracefully handle karte hain - program crash nahi hota',
      'try block mein woh code likho jisme error aa sakti hai',
      'except block mein error handle karo - program yahan se continue karega',
      'Multiple exceptions handle kar sakte ho - except ValueError:, except ZeroDivisionError:',
      'else block tab chalta hai jab try block mein koi error nahi aati',
      'finally block hamesha chalta hai chahe error aaye ya nahi - cleaning ke liye use hota hai',
      'Custom exception bana sakte ho class(Exception): se',
      'raise keyword se manually error throw kar sakte ho',
    ],
    'keyConcepts': [
      'try-except block',
      'Exception types (ValueError, ZeroDivisionError)',
      'else and finally clauses',
      'raise statement',
      'Custom exceptions',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Exception Handling. Ye concept bahut important hai real-world programs mein.

Jab aap program likhte ho, toh hamesha errors aane ke chances hote hain. Jaise user ne number daalne ki jagah text daal diya, ya kisi number ko zero se divide kar diya. Agar humne error handle nahi kiya, toh program crash ho jayega.

Yahan aati hai exception handling - try aur except.

Dekho syntax:

try:
    a = int(input("Number: "))
    print(10 / a)
except ValueError:
    print("Invalid number!")
except ZeroDivisionError:
    print("Cannot divide by zero!")
except Exception as e:
    print(f"Something went wrong: {e}")
else:
    print("No errors occurred!")
finally:
    print("This always runs")

Samjhe? try block mein risky code rakho. Agar error aayi, toh woh except block mein catch hogi. Agar koi error nahi aayi, toh else block chalega. Aur finally hamesha chalega - chahe error aaye ya nahi.

Multiple exceptions handle karne ke liye multiple except blocks likho. Ya ek hi block mein:
except (ValueError, ZeroDivisionError) as e:

Custom exception bhi bana sakte ho:
class MyError(Exception):
    pass

raise MyError("Something went wrong")

Exception handling use karo jab bhi aap confident nahi ho ki code kaam karega ya nahi - jaise user input, file operations, network requests.

Yaad rakho: errors hamesha hongi. Unhe handle karna seekho, ignore nahi!''',
    'codeExamples': [
      {
        'title': 'Basic Try-Except',
        'code': "try:\n    num = int(input(\"Enter a number: \"))\n    result = 10 / num\n    print(f\"Result: {result}\")\nexcept ValueError:\n    print(\"That is not a valid number!\")\nexcept ZeroDivisionError:\n    print(\"Cannot divide by zero!\")\nexcept Exception as e:\n    print(f\"Some error occurred: {e}\")",
        'explanation': 'try block mein do risky operations hain - int() jo ValueError de sakta hai, aur division jo ZeroDivisionError de sakta hai. Except blocks alag-alag error types handle karte hain. Exception as e se koi bhi unexpected error catch hota hai.',
        'output': "Enter a number: 0\nCannot divide by zero!",
      },
      {
        'title': 'Else and Finally',
        'code': "def divide(a, b):\n    try:\n        result = a / b\n    except ZeroDivisionError:\n        print(\"Cannot divide by zero\")\n        return None\n    else:\n        print(f\"Division successful: {result}\")\n        return result\n    finally:\n        print(\"Cleanup: This always runs\")\n\nprint(\"Result:\", divide(10, 2))\nprint(\"---\")\nprint(\"Result:\", divide(10, 0))",
        'explanation': 'else block tabhi chalta hai jab try block successfully execute ho (koi exception nahi aayi). finally block hamesha chalta hai - chahe exception aaye ya nahi. Finally cleaning ke liye use hota hai - jaise file close karna.',
        'output': "Division successful: 5.0\nCleanup: This always runs\nResult: 5.0\n---\nCannot divide by zero\nCleanup: This always runs\nResult: None",
      },
    ],
    'challenges': [
      {
        'question': 'Ek program likho jo 5 numbers ka input le aur unka average calculate kare. Agar koi invalid input aaye toh error handle karo aur batao ki kaunsa input galat tha.',
        'hint': 'For loop use karo, try-except andar. Count valid numbers. Agar ValueError aaye toh continue karo par error log karo.',
        'solution': "total = 0\ncount = 0\n\nfor i in range(5):\n    try:\n        num = int(input(f\"Enter number {i+1}: \"))\n        total += num\n        count += 1\n    except ValueError:\n        print(f\"Invalid input at position {i+1}, skipping...\")\n\nif count > 0:\n    print(f\"Average of {count} valid numbers: {total / count}\")\nelse:\n    print(\"No valid numbers entered!\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek custom exception NegativeNumberError banao jo Exception se inherit kare. Ek function likho square_root jo positive numbers ka sqrt return kare aur negative number par raise kare.',
        'hint': 'class NegativeNumberError(Exception): pass. def square_root(n): if n < 0: raise NegativeNumberError("Cannot sqrt negative"). Import math.use math.sqrt.',
        'solution': "import math\n\nclass NegativeNumberError(Exception):\n    pass\n\ndef square_root(n):\n    if n < 0:\n        raise NegativeNumberError(\"Cannot find square root of negative number\")\n    return math.sqrt(n)\n\ntry:\n    print(square_root(25))\n    print(square_root(-4))\nexcept NegativeNumberError as e:\n    print(f\"Error: {e}\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek file reader program likho jo file read karta hai. Handle karo: FileNotFoundError, PermissionError, aur UnicodeDecodeError. Try-except-else-finally use karo. Finally mein file close karo chahe error aaye ya nahi.',
        'hint': 'with statement use karne ki jagah manually file open karo. try mein f = open(). else mein content read karo. except blocks alag-alag errors handle karo. finally mein f.close() karo agar f exists kare.',
        'solution': "filename = input(\"Enter filename: \")\nf = None\ntry:\n    f = open(filename, \"r\")\nexcept FileNotFoundError:\n    print(\"File not found!\")\nexcept PermissionError:\n    print(\"Permission denied!\")\nexcept UnicodeDecodeError:\n    print(\"Cannot decode file!\")\nexcept Exception as e:\n    print(f\"Error: {e}\")\nelse:\n    print(\"File contents:\")\n    print(f.read())\nfinally:\n    if f:\n        f.close()\n        print(\"File closed.\")",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'try: ... except ExceptionType:', 'example': 'try:\n    x = int(input())\nexcept ValueError:', 'description': 'Try mein risky code, except mein error handling'},
      {'syntax': 'try: ... else: ... finally:', 'example': 'try:\n    x = int(a)\nexcept:\n    pass\nelse:\n    print(x)\nfinally:\n    print(\"done\")', 'description': 'Else runs on success, finally always runs'},
      {'syntax': 'raise Exception("msg")', 'example': 'raise ValueError("Invalid input")', 'description': 'Manually exception throw karna'},
      {'syntax': 'class CustomError(Exception):', 'example': 'class MyError(Exception):\n    pass', 'description': 'Custom exception define karna'},
    ],
    'commonMistakes': [
      'Bina specific exception type ke bare except Exception: use karna - aise karo toh debugging mushkil hoti hai',
      'Finally mein return statement - finally ka return try/except ke return ko override kar deta hai',
      'Exception handle kar ke ignore karna - sirf pass likh dena, koi action nahi lena',
    ],
  };
}

Map<String, dynamic> topic12_4() {
  return {
    'id': 'topic_12_4',
    'name': 'Global & Enumerate',
    'chapterId': 'chapter_12',
    'subjectId': 'python',
    'order': 44,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=30600',
    'keyPoints': [
      'Global keyword function ke andar global variable ko modify karne ke liye use hota hai',
      'Bina global keyword ke, function mein variable assign karne par local variable ban jaata hai',
      'Enumerate function list ke har element ke saath index bhi return karta hai',
      'Syntax: enumerate(list) returns (index, value) pairs',
      'Enumerate ka start parameter se index customize kar sakte ho - enumerate(list, start=1)',
      'Global variables careful use karo - zyada global variables code ko messy banate hain',
      'Enumerate for loops mein index access karne ka cleanest tarika hai',
    ],
    'keyConcepts': [
      'global keyword',
      'Global vs Local variables',
      'enumerate() function',
      'Index-value pairs',
      'enumerate start parameter',
    ],
    'aiCoachScript': '''Chalo doston, aaj do cheezein seekhenge - Global keyword aur Enumerate function.

Pehle baat karte hain Global keyword ki.

Jab aap kisi function ke andar koi variable banate ho, toh woh local variable hota hai - sirf function ke andar accessible hota hai. Lekin agar aap function ke bahar koi variable banate ho, toh woh global variable hota hai. Simple hai.

Lekin problem tab aati hai jab aap function ke andar global variable ki value change karna chahte ho. Direct aise nahi kar sakte:

x = 10

def change_x():
    x = 20  # Yeh new local variable banayega, global x change nahi hoga

change_x()
print(x)  # Abhi bhi 10 print hoga

Global variable ko modify karne ke liye global keyword use karo:

def change_x():
    global x
    x = 20

Ab x = 20 ho jayega globally.

Ab aate hain Enumerate par.

Kabhi aapne for loop chalaya hai aur saath mein index bhi chahiye tha? Toh aap aise karte the:

i = 0
for fruit in fruits:
    print(i, fruit)
    i += 1

Lekin enumerate se clean tarika hai:

for i, fruit in enumerate(fruits):
    print(i, fruit)

Aur aap start parameter de sakte ho:

for i, fruit in enumerate(fruits, start=1):
    print(f"{i}. {fruit}")

Yeh bahut useful hai jab aapko loop mein index ki zaroorat ho. Index manually rakhne ki zaroorat nahi.

Chalo ab examples dekhte hain!''',
    'codeExamples': [
      {
        'title': 'Global Keyword',
        'code': "count = 0\n\ndef increment():\n    global count\n    count += 1\n    print(f\"Count inside function: {count}\")\n\nprint(f\"Count before: {count}\")\nincrement()\nincrement()\nprint(f\"Count after: {count}\")",
        'explanation': 'global count statement se function ke andar hum global variable count ko modify kar rahe hain. Bina global keyword ke, count += 1 ek new local variable banata aur error deta. global keyword ke saath hum global variable ki value change kar sakte hain.',
        'output': 'Count before: 0\nCount inside function: 1\nCount inside function: 2\nCount after: 2',
      },
      {
        'title': 'Enumerate Function',
        'code': "fruits = [\"apple\", \"banana\", \"cherry\", \"date\"]\n\nprint(\"With enumerate (start=1):\")\nfor i, fruit in enumerate(fruits, start=1):\n    print(f\"{i}. {fruit}\")\n\nprint(\"\\nWith enumerate (default start=0):\")\nfor i, fruit in enumerate(fruits):\n    print(f\"Index {i}: {fruit}\")",
        'explanation': 'enumerate() function har element ke saath uski index return karta hai. Default index 0 se start hota hai. start=1 se index 1 se shuru hota hai - numbering ke liye useful. enumerate do values return karta hai - index aur element.',
        'output': 'With enumerate (start=1):\n1. apple\n2. banana\n3. cherry\n4. date\n\nWith enumerate (default start=0):\nIndex 0: apple\nIndex 1: banana\nIndex 2: cherry\nIndex 3: date',
      },
    ],
    'challenges': [
      {
        'question': 'Ek counter variable banao global, aur do functions likho - increment() aur reset(). Increment global counter ko 1 badhaye, reset use 0 kare. Har increment ke baad counter print karo.',
        'hint': 'global count. increment mein global count; count += 1. reset mein global count; count = 0.',
        'solution': "counter = 0\n\ndef increment():\n    global counter\n    counter += 1\n    print(f\"Counter: {counter}\")\n\ndef reset():\n    global counter\n    counter = 0\n    print(\"Counter reset to 0\")\n\nincrement()\nincrement()\nreset()\nincrement()",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek list of student names lo aur enumerate use karke ranking print karo. Jaise list = ["Alice", "Bob", "Charlie"] ho toh output aaye: "1. Alice", "2. Bob", "3. Charlie".',
        'hint': 'for i, name in enumerate(students, start=1): print(f"{i}. {name}")',
        'solution': "students = [\"Alice\", \"Bob\", \"Charlie\", \"Diana\"]\n\nprint(\"Student Rankings:\")\nfor rank, name in enumerate(students, start=1):\n    print(f\"{rank}. {name}\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek shopping cart program banao. Ek global list cart mein items store karo. Functions: add_item(item) global cart mein append kare, show_cart() enumerate se numbered list print kare, remove_item(index) global cart se item remove kare. Index starting 1 se ho.',
        'hint': 'global cart. add_item mein global cart; cart.append(item). show_cart mein enumerate(cart, start=1). remove_item mein global cart; cart.pop(index-1).',
        'solution': "cart = []\n\ndef add_item(item):\n    global cart\n    cart.append(item)\n    print(f\"Added: {item}\")\n\ndef show_cart():\n    if not cart:\n        print(\"Cart is empty\")\n        return\n    print(\"Your Cart:\")\n    for i, item in enumerate(cart, start=1):\n        print(f\"{i}. {item}\")\n\ndef remove_item(index):\n    global cart\n    if 1 <= index <= len(cart):\n        removed = cart.pop(index - 1)\n        print(f\"Removed: {removed}\")\n    else:\n        print(\"Invalid index\")\n\nadd_item(\"Laptop\")\nadd_item(\"Mouse\")\nadd_item(\"Keyboard\")\nshow_cart()\nremove_item(2)\nshow_cart()",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'global variable_name', 'example': 'global x', 'description': 'Function ke andar global variable access/modify karne ke liye'},
      {'syntax': 'enumerate(iterable, start=0)', 'example': 'enumerate(fruits, start=1)', 'description': 'Iterable ke elements ke saath index return karta hai'},
      {'syntax': 'for i, val in enumerate(list):', 'example': 'for i, fruit in enumerate(fruits):', 'description': 'Loop mein index aur value ek saath access karna'},
    ],
    'commonMistakes': [
      'global keyword bhoolna - function mein global variable modify karte waqt error aata hai (UnboundLocalError)',
      'Global variables ka overuse - zyada global variables se code track karna mushkil ho jata hai',
      'enumerate bhool kar manually index rakhna - extra variable aur i += 1, enumerate cleaner hai',
    ],
  };
}

Map<String, dynamic> topic12_5() {
  return {
    'id': 'topic_12_5',
    'name': 'List Comprehensions',
    'chapterId': 'chapter_12',
    'subjectId': 'python',
    'order': 45,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=30720',
    'keyPoints': [
      'List comprehension ek concise tarika hai list banane ka - ek line mein loop + list',
      'Syntax: [expression for item in iterable]',
      'Conditional comprehension: [expression for item in iterable if condition]',
      'If-else comprehension: [expression_if_true if condition else expression_if_false for item in iterable]',
      'Nested loops bhi comprehension mein use kar sakte ho',
      'List comprehension comparable for loop se faster hota hai',
      'Set comprehension bhi hoti hai: {x for x in list} - curly braces se',
      'Dict comprehension: {key: value for key, value in iterable}',
    ],
    'keyConcepts': [
      'List comprehension',
      'Set comprehension',
      'Dict comprehension',
      'Conditional filtering',
      'Nested loops in comprehension',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge list comprehension - jo Python ki ek powerful aur elegant feature hai.

Dekho, kabhi kabhi aapko ek list se doosri list banani hoti hai. Jaise numbers ki list se squares ki list. Aap for loop se bhi kar sakte ho, lekin list comprehension se ek hi line mein ho jata hai.

Example: Numbers ka square nikaalna hai.

For loop se:
squares = []
for x in range(10):
    squares.append(x ** 2)

List comprehension se:
squares = [x ** 2 for x in range(10)]

Dekha kitna chhota hai? Ek line mein kaam ho gaya.

Syntax hai:
[expression for item in iterable]

Aur agar condition lagaani ho toh:
[expression for item in iterable if condition]

Jaise even numbers ke squares:
evens = [x ** 2 for x in range(10) if x % 2 == 0]

If-else bhi laga sakte ho:
result = ["Even" if x % 2 == 0 else "Odd" for x in range(5)]

Yahan if-else expression ke andar hai, comprehension ke nahi. Yeh important difference hai.

Sirf list nahi, set comprehension bhi hoti hai:
{x ** 2 for x in range(10)}

aur dict comprehension:
{x: x ** 2 for x in range(5)}

List comprehension seekh lo - code elegant aur fast banega. Lekin complex comprehensions se bacho - readability important hai. Agar comprehension 2-3 lines mein fit nahi ho raha, toh for loop use karo.

Chalo ab examples dekhte hain!''',
    'codeExamples': [
      {
        'title': 'Basic List Comprehension - Squares',
        'code': "# Traditional approach\nsquares_loop = []\nfor i in range(1, 6):\n    squares_loop.append(i ** 2)\nprint(\"Loop:\", squares_loop)\n\n# List comprehension\nsquares_lc = [i ** 2 for i in range(1, 6)]\nprint(\"LC:\", squares_lc)",
        'explanation': 'Traditional for loop mein 3 lines lagti hain. List comprehension se ek hi line mein kaam ho gaya. [i ** 2 for i in range(1, 6)] ka matlab - range(1,6) ke har i ke liye, i ** 2 calculate karo aur list mein daalo.',
        'output': 'Loop: [1, 4, 9, 16, 25]\nLC: [1, 4, 9, 16, 25]',
      },
      {
        'title': 'Conditional Comprehension - Even Numbers',
        'code': "numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\n\n# Even numbers\nevens = [n for n in numbers if n % 2 == 0]\nprint(\"Evens:\", evens)\n\n# Even squares (square only if even)\neven_squares = [n ** 2 for n in numbers if n % 2 == 0]\nprint(\"Even squares:\", even_squares)\n\n# If-else: label each number\nlabels = [\"Even\" if n % 2 == 0 else \"Odd\" for n in numbers]\nprint(\"Labels:\", labels)",
        'explanation': 'Pehla comprehension sirf un numbers ko leta hai jo even hain (if condition). Dusra even numbers ka square nikaalta hai. Teesra if-else comprehension hai - har number ke liye check karta hai even hai ya odd aur string assign karta hai.',
        'output': 'Evens: [2, 4, 6, 8, 10]\nEven squares: [4, 16, 36, 64, 100]\nLabels: [\"Odd\", \"Even\", \"Odd\", \"Even\", \"Odd\", \"Even\", \"Odd\", \"Even\", \"Odd\", \"Even\"]',
      },
      {
        'title': 'Set and Dict Comprehension',
        'code': "numbers = [1, 2, 2, 3, 3, 3, 4, 5, 5]\n\n# Set comprehension (no duplicates)\nunique_squares = {n ** 2 for n in numbers}\nprint(\"Set:\", unique_squares)\n\n# Dict comprehension\nsquare_dict = {n: n ** 2 for n in range(1, 6)}\nprint(\"Dict:\", square_dict)\n\n# Nested comprehension (flatten matrix)\nmatrix = [[1, 2], [3, 4], [5, 6]]\nflat = [item for row in matrix for item in row]\nprint(\"Flattened:\", flat)",
        'explanation': 'Set comprehension curly braces {} se hoti hai aur duplicates automatically remove ho jaate hain. Dict comprehension mein key-value pairs define karte hain. Nested comprehension pehle outer loop (row) chalata hai phir inner loop (item).',
        'output': 'Set: {1, 4, 9, 16, 25}\nDict: {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}\nFlattened: [1, 2, 3, 4, 5, 6]',
      },
    ],
    'challenges': [
      {
        'question': 'Ek list comprehension likho jo 1 se 20 tak ke numbers mein se woh numbers return kare jo 3 aur 5 dono se divisible hain.',
        'hint': '[n for n in range(1, 21) if n % 3 == 0 and n % 5 == 0]',
        'solution': "result = [n for n in range(1, 21) if n % 3 == 0 and n % 5 == 0]\nprint(result)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek list of strings lo ["hello", "world", "python", "list"] aur list comprehension se har string ko uppercase mein convert karo aur uski length ke saath tuple banao. Jaise ("HELLO", 5).',
        'hint': '[(s.upper(), len(s)) for s in words]',
        'solution': "words = [\"hello\", \"world\", \"python\", \"list\"]\nresult = [(w.upper(), len(w)) for w in words]\nprint(result)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek nested list comprehension likho jo 3x3 multiplication table generate kare. Output [[1,2,3], [2,4,6], [3,6,9]] aisa ho.',
        'hint': '[[i * j for j in range(1, 4)] for i in range(1, 4)]. Outer loop rows ke liye, inner loop columns ke liye.',
        'solution': "table = [[i * j for j in range(1, 4)] for i in range(1, 4)]\nfor row in table:\n    print(row)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': '[expr for item in iterable]', 'example': '[x ** 2 for x in range(5)]', 'description': 'Simple list comprehension'},
      {'syntax': '[expr for item in iterable if condition]', 'example': '[x for x in range(10) if x % 2 == 0]', 'description': 'Conditional filtering ke saath comprehension'},
      {'syntax': '{expr for item in iterable}', 'example': '{x ** 2 for x in range(5)}', 'description': 'Set comprehension - duplicates automatically remove'},
      {'syntax': '{k: v for k, v in iterable}', 'example': '{x: x ** 2 for x in range(5)}', 'description': 'Dict comprehension - key-value pairs'},
    ],
    'commonMistakes': [
      'If-else comprehension mein syntax confuse karna - if condition expression ke baad aata hai if filtering ke liye, aur ternary if-else expression ke andar hota hai',
      'Comprehension ko complex bana dena - nested comprehensions with conditions readable nahi rehte, for loop better hai',
      'Set comprehension mein curly braces {} bhool kar square brackets [] laga dena - set nahi list ban jayegi',
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
