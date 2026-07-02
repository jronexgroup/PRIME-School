// Run: dart run scripts/seed_tech_python.dart
// Seeds CodeWithHarry Python course into Firestore /tech/python/

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

const videoUrl = 'https://youtube.com/watch?v=UrsmFxEIp5k';

Future<void> main() async {
  print('Seeding Tech: Python (CodeWithHarry)...\n');

  final techBase = 'tech/python';
  final roadmapBase = '$techBase/roadmap';
  final topicsBase = '$techBase/topics';

  final transcript = await _readTranscript();

  await patchDoc('$techBase/transcript', {
    'subjectId': 'python',
    'fullTranscript': transcript,
    'source': 'CodeWithHarry',
    'videoUrl': videoUrl,
  });

  final topics = _allTopics();
  for (final t in topics) {
    final id = t['id']!;
    await patchDoc('$roadmapBase/$id', {
      'order': t['order']!,
      'name': t['name']!,
      'topicId': id,
      'videoUrl': videoUrl,
    });
    await patchDoc('$topicsBase/$id', {
      'id': id,
      'subjectId': 'python',
      'name': t['name']!,
      'order': t['order']!,
      'videoUrl': videoUrl,
      'keyPoints': t['keyPoints']!,
      'codeExamples': t['codeExamples']!,
      'challenges': t['challenges']!,
      'keyConcepts': t['keyConcepts']!,
      'importantSyntax': t['importantSyntax']!,
      'commonMistakes': t['commonMistakes']!,
    });
  }

  print('\nDone! Python tech content seeded successfully (${topics.length} topics).');
}

Future<String> _readTranscript() async {
  try {
    return await File('scripts/codewithharrypythonfullcourse11hourstranscript.txt').readAsString();
  } catch (_) {
    return '(Transcript file not found)';
  }
}

List<Map<String, dynamic>> _allTopics() {
  return [
    _topic1(),
    _topic2(),
    _topic3(),
    _topic4(),
    _topic5(),
    _topic6(),
    _topic7(),
    _topic8(),
    _topic9(),
    _topic10(),
    _topic11(),
    _topic12(),
    _topic13(),
    _topic14(),
  ];
}

Map<String, dynamic> _topic1() => {
  'id': 'python_topic_1',
  'order': 1,
  'name': 'Introduction & Setup',
  'keyPoints': [
    'Python is the most loved and easiest language according to Stack Overflow',
    'No prior programming knowledge needed — Python can be your first language',
    'Install Python from python.org, choose the latest version',
    'VS Code is the recommended code editor with Python extension',
    'First program: print("Hello World")',
    'Python can be used for web development, data science, AI, machine learning, and general scripting',
    'This course is designed with job aspect in mind — covers real-world skills',
  ],
  'codeExamples': [
    {
      'title': 'Hello World',
      'code': 'print("Hello World")',
      'explanation': 'The print() function outputs text to the console. This is the first program every Python developer writes.',
      'output': 'Hello World',
    },
    {
      'title': 'Simple Math',
      'code': 'print(5 + 3)\nprint(10 - 4)\nprint(6 * 7)\nprint(20 / 4)',
      'explanation': 'Python can do basic arithmetic right inside the print function.',
      'output': '8\n6\n42\n5.0',
    },
  ],
  'challenges': [
    {
      'question': 'Write a program that prints your name and age on separate lines.',
      'hint': 'Use two print() statements, one for name and one for age.',
      'difficulty': 'easy',
      'solution': 'print("My name is Harry")\nprint("I am 20 years old")',
    },
    {
      'question': 'Print the result of 15 multiplied by 3, then divided by 5.',
      'hint': 'You can do math inside print(): print(15 * 3 / 5)',
      'difficulty': 'easy',
      'solution': 'print(15 * 3 / 5)',
    },
  ],
  'keyConcepts': [
    'Python is an interpreted, high-level programming language',
    'The print() function is used to display output',
    'Comments start with # and are ignored by Python',
    'Python files have .py extension',
    'Code runs from top to bottom',
  ],
  'importantSyntax': [
    {'syntax': 'print(value)', 'example': 'print("Hello")', 'description': 'Outputs value to console'},
    {'syntax': '# comment', 'example': '# This is a comment', 'description': 'Single-line comment'},
  ],
  'commonMistakes': [
    'Forgetting parentheses: print "Hello" → Error, should be print("Hello")',
    'Using single quote inside single-quoted string without escaping',
    'Not saving file with .py extension before running',
  ],
};

Map<String, dynamic> _topic2() => {
  'id': 'python_topic_2',
  'order': 2,
  'name': 'Variables & Data Types',
  'keyPoints': [
    'Variables store data in memory — like labeled boxes',
    'No need to declare type in Python — it is dynamically typed',
    'Common data types: int, float, str, bool',
    'Use type() function to check variable type',
    'Variable names: letters, numbers, underscore; cannot start with number',
    'Case-sensitive: name and Name are different variables',
    'Input from user: input() function returns a string',
    'Type conversion: int(), float(), str() to convert between types',
  ],
  'codeExamples': [
    {
      'title': 'Variables',
      'code': 'name = "Harry"\nage = 20\nheight = 5.9\nis_student = True\nprint(name)\nprint(age)\nprint(height)\nprint(is_student)',
      'explanation': 'We create variables by assigning values. Python automatically determines the type.',
      'output': 'Harry\n20\n5.9\nTrue',
    },
    {
      'title': 'Type Check & Conversion',
      'code': 'x = 10\nprint(type(x))  # <class \'int\'>\ny = str(x)\nprint(type(y))  # <class \'str\'>\n\n# User input\nage = input("Enter your age: ")\nprint("You are " + age + " years old")',
      'explanation': 'type() shows the data type. str() converts to string. input() always returns a string.',
      'output': '<class \'int\'>\n<class \'str\'>\nEnter your age: 25\nYou are 25 years old',
    },
  ],
  'challenges': [
    {
      'question': 'Create variables for your name, favorite number, and whether you like Python (True/False). Print all three.',
      'hint': 'Create three variables with meaningful names and print each one.',
      'difficulty': 'easy',
      'solution': 'my_name = "Alice"\nfav_num = 42\nlikes_python = True\nprint(my_name)\nprint(fav_num)\nprint(likes_python)',
    },
    {
      'question': 'Take two numbers as input from user, convert them to integers, and print their sum.',
      'hint': 'Use input() twice, convert both with int(), then add them.',
      'difficulty': 'easy',
      'solution': 'a = input("Enter first number: ")\nb = input("Enter second number: ")\nsum = int(a) + int(b)\nprint("Sum:", sum)',
    },
  ],
  'keyConcepts': [
    'Variables store data for later use',
    'Python has dynamic typing — type is inferred from value',
    'int: whole numbers (1, 100, -5)',
    'float: decimal numbers (3.14, -0.5)',
    'str: text/strings ("hello", \'hello\')',
    'bool: True or False',
    'f-strings: f"Hello {name}" for embedding variables in strings',
  ],
  'importantSyntax': [
    {'syntax': 'var_name = value', 'example': 'age = 25', 'description': 'Assign value to variable'},
    {'syntax': 'type(variable)', 'example': 'type(age)', 'description': 'Get data type of variable'},
    {'syntax': 'int(value), str(value), float(value)', 'example': 'int("10")', 'description': 'Type conversion functions'},
  ],
  'commonMistakes': [
    'Trying to concatenate string and number without conversion: "Age: " + age (error)',
    'Variable name starting with digit: 1name = "Harry" → SyntaxError',
    'Using Python keywords as variable names: class, for, if, etc.',
    'Forgetting to convert input() result when doing math',
  ],
};

Map<String, dynamic> _topic3() => {
  'id': 'python_topic_3',
  'order': 3,
  'name': 'Strings',
  'keyPoints': [
    'Strings are sequences of characters enclosed in quotes',
    'Can use single quotes (\') or double quotes (")',
    'Triple quotes (""" or \'\'\') for multi-line strings',
    'String concatenation: + operator joins strings',
    'String repetition: * operator repeats string',
    'Indexing: string[0] gets first character, negative indices count from end',
    'Slicing: string[start:end:step] extracts portions',
    'len() returns string length',
    'Common methods: upper(), lower(), strip(), replace(), split(), join()',
    'Escape sequences: \\n (newline), \\t (tab), \\\\ (backslash)',
    'f-strings: f"Hello {name}, you are {age}" — easiest formatting',
  ],
  'codeExamples': [
    {
      'title': 'String Basics',
      'code': 'name = "CodeWithHarry"\nprint(name[0])      # C\nprint(name[-1])     # y\nprint(name[0:4])    # Code\nprint(len(name))    # 13\nprint(name.upper()) # CODEWITHHARRY\nprint(name.lower()) # codewithharry',
      'explanation': 'Strings support indexing, slicing, and many built-in methods.',
      'output': 'C\ny\nCode\n13\nCODEWITHHARRY\ncodewithharry',
    },
    {
      'title': 'f-strings',
      'code': 'name = "Harry"\nchannel = "CodeWithHarry"\nsubs = 6000000\nprint(f"Hi, I am {name} from {channel}")\nprint(f"I have {subs:,} subscribers")',
      'explanation': 'f-strings let you embed variables and expressions directly in string with {}. Use :, for comma formatting.',
      'output': 'Hi, I am Harry from CodeWithHarry\nI have 6,000,000 subscribers',
    },
  ],
  'challenges': [
    {
      'question': 'Take a user\'s first and last name as input. Print their full name in uppercase and the total number of characters.',
      'hint': 'Use input() twice, concatenate with + or f-string, then apply .upper() and len().',
      'difficulty': 'easy',
      'solution': 'first = input("First name: ")\nlast = input("Last name: ")\nfull = first + " " + last\nprint(full.upper())\nprint("Total chars:", len(full))',
    },
    {
      'question': 'Ask the user for a sentence. Replace all spaces with hyphens and print the result.',
      'hint': 'Use the .replace() method: text.replace(" ", "-")',
      'difficulty': 'easy',
      'solution': 'text = input("Enter a sentence: ")\nprint(text.replace(" ", "-"))',
    },
  ],
  'keyConcepts': [
    'Strings are immutable — methods return new strings, they don\'t modify original',
    'Indexing starts at 0',
    'Negative index -1 is the last character',
    'Slicing: [start:end] — end is exclusive',
    'Escape sequences allow special characters in strings',
    'Raw strings with r"..." treat backslashes as literal',
  ],
  'importantSyntax': [
    {'syntax': 'string[index]', 'example': '"Hello"[1]', 'description': 'Character at index'},
    {'syntax': 'string[start:end]', 'example': '"Hello"[1:4]', 'description': 'Slice substring'},
    {'syntax': 'f"text {var}"', 'example': 'f"Age: {age}"', 'description': 'Formatted string literal'},
  ],
  'commonMistakes': [
    'String index out of range: accessing string[len(string)] (valid indices: 0 to len-1)',
    'Confusing string methods that return new string vs modifying in place (strings don\'t modify in place)',
    'Forgetting to close quotes properly — mismatch of quote types',
  ],
};

Map<String, dynamic> _topic4() => {
  'id': 'python_topic_4',
  'order': 4,
  'name': 'Lists & Tuples',
  'keyPoints': [
    'Lists store multiple items in a single variable — ordered, changeable',
    'Defined with square brackets: fruits = ["apple", "banana", "cherry"]',
    'Lists can hold different data types: mixed = [1, "hello", 3.14, True]',
    'List methods: append(), insert(), remove(), pop(), sort(), reverse()',
    'Tuples are like lists but IMMUTABLE — cannot be changed after creation',
    'Tuples defined with parentheses: colors = ("red", "green", "blue")',
    'Use tuples for data that should not change (constants, coordinates)',
    'Both support indexing, slicing, and len()',
    'List comprehension: [x**2 for x in range(10)] — concise way to create lists',
  ],
  'codeExamples': [
    {
      'title': 'List Operations',
      'code': 'fruits = ["apple", "banana", "cherry"]\nfruits.append("date")\nfruits.insert(1, "blueberry")\nfruits.remove("banana")\nprint(fruits)\nprint(fruits[2])\n\n# List comprehension\nsquares = [x**2 for x in range(5)]\nprint(squares)',
      'explanation': 'Lists are mutable — we can add, remove, and modify items. List comprehension is a powerful Python feature.',
      'output': '[\'apple\', \'blueberry\', \'cherry\', \'date\']\ncherry\n[0, 1, 4, 9, 16]',
    },
    {
      'title': 'Tuples',
      'code': 'point = (3, 4)\nprint(point[0])  # 3\nprint(point[1])  # 4\n\n# Unpacking\nx, y = point\nprint(f"X: {x}, Y: {y}")\n\n# This would ERROR:\n# point[0] = 5  # TypeError: tuple does not support assignment',
      'explanation': 'Tuples pack related values together. Unpacking assigns each element to a variable in one line.',
      'output': '3\n4\nX: 3, Y: 4',
    },
  ],
  'challenges': [
    {
      'question': 'Create a list of 5 numbers. Add a 6th number at the end, remove the 3rd number, and print the list in reverse order.',
      'hint': 'Use append(), pop(index), and reverse() or slicing [::-1].',
      'difficulty': 'medium',
      'solution': 'nums = [10, 20, 30, 40, 50]\nnums.append(60)\nnums.pop(2)\nnums.reverse()\nprint(nums)',
    },
    {
      'question': 'Given a list of numbers [1, 2, 3, 4, 5, 6], create a new list containing only the even numbers using list comprehension.',
      'hint': 'Use [x for x in list if x % 2 == 0]',
      'difficulty': 'medium',
      'solution': 'numbers = [1, 2, 3, 4, 5, 6]\nevens = [x for x in numbers if x % 2 == 0]\nprint(evens)',
    },
  ],
  'keyConcepts': [
    'Lists are mutable (can change), tuples are immutable (cannot change)',
    'List comprehension: [expression for item in iterable if condition]',
    'Negative indexing and slicing work same as strings',
    'Nested lists: matrix = [[1,2], [3,4], [5,6]]',
    'Use tuples for dictionary keys (lists cannot be keys)',
  ],
  'importantSyntax': [
    {'syntax': 'list.append(item)', 'example': 'nums.append(5)', 'description': 'Add item to end of list'},
    {'syntax': 'list.pop(index)', 'example': 'nums.pop(2)', 'description': 'Remove and return item at index'},
    {'syntax': '[expr for x in iter]', 'example': '[x*2 for x in range(5)]', 'description': 'List comprehension'},
  ],
  'commonMistakes': [
    'Trying to modify a tuple: t[0] = 5 → TypeError',
    'Forgetting that pop() modifies the list and returns the removed element',
    'Using = to copy a list instead of .copy() or [:] — creates reference, not copy',
  ],
};

Map<String, dynamic> _topic5() => {
  'id': 'python_topic_5',
  'order': 5,
  'name': 'Dictionaries & Sets',
  'keyPoints': [
    'Dictionaries store key-value pairs — like a real dictionary (word → definition)',
    'Defined with curly braces: student = {"name": "Harry", "age": 20}',
    'Keys must be unique and immutable (strings, numbers, tuples)',
    'Access values: dict["key"] or dict.get("key")',
    'Dictionary methods: keys(), values(), items(), update(), pop()',
    'Sets are unordered collections of UNIQUE elements',
    'Defined with curly braces: {1, 2, 3} or set() for empty',
    'Sets automatically remove duplicates',
    'Set operations: union (|), intersection (&), difference (-)',
  ],
  'codeExamples': [
    {
      'title': 'Dictionary Basics',
      'code': 'student = {\n  "name": "Harry",\n  "age": 20,\n  "course": "Python"\n}\nprint(student["name"])\nprint(student.get("grade", "N/A"))\nstudent["age"] = 21\nstudent["city"] = "Mumbai"\nprint(student.keys())\nprint(student.values())',
      'explanation': 'Dictionaries map keys to values. Use get() with default to avoid KeyError.',
      'output': 'Harry\nN/A\ndict_keys([\'name\', \'age\', \'course\', \'city\'])\ndict_values([\'Harry\', 21, \'Python\', \'Mumbai\'])',
    },
    {
      'title': 'Sets',
      'code': 'nums = [1, 2, 2, 3, 3, 3, 4]\nunique = set(nums)\nprint(unique)\n\nset_a = {1, 2, 3, 4}\nset_b = {3, 4, 5, 6}\nprint(set_a | set_b)  # Union\nprint(set_a & set_b)  # Intersection\nprint(set_a - set_b)  # Difference',
      'explanation': 'Sets are perfect for removing duplicates and performing mathematical set operations.',
      'output': '{1, 2, 3, 4}\n{1, 2, 3, 4, 5, 6}\n{3, 4}\n{1, 2}',
    },
  ],
  'challenges': [
    {
      'question': 'Create a dictionary with 3 students and their scores. Add a 4th student, update one score, then print all names and scores.',
      'hint': 'Create dict, use dict[new_key] = value to add, dict[key] = new_val to update.',
      'difficulty': 'medium',
      'solution': 'scores = {"Alice": 85, "Bob": 92, "Charlie": 78}\nscores["Diana"] = 95\nscores["Alice"] = 90\nfor name, score in scores.items():\n    print(f"{name}: {score}")',
    },
    {
      'question': 'Given two lists list1 = [1, 2, 3, 4, 5] and list2 = [4, 5, 6, 7, 8], find the common elements using sets.',
      'hint': 'Convert both to sets and use & operator.',
      'difficulty': 'medium',
      'solution': 'list1 = [1, 2, 3, 4, 5]\nlist2 = [4, 5, 6, 7, 8]\ncommon = set(list1) & set(list2)\nprint(common)',
    },
  ],
  'keyConcepts': [
    'Dictionaries are mutable, unordered (Python 3.6+ preserves insertion order)',
    'Keys must be immutable (strings, numbers, or tuples of immutables)',
    'sets are mutable but elements must be immutable',
    'Frozen sets: frozenset() — immutable version of set',
    'Dictionary comprehension: {k: v for k, v in iterable}',
  ],
  'importantSyntax': [
    {'syntax': 'dict[key] = value', 'example': 'd["name"] = "Harry"', 'description': 'Add or update key-value pair'},
    {'syntax': 'dict.get(key, default)', 'example': 'd.get("age", 0)', 'description': 'Safe access with default'},
    {'syntax': 'set1 | set2, set1 & set2', 'example': '{1,2} | {2,3}', 'description': 'Union and intersection'},
  ],
  'commonMistakes': [
    'Accessing a non-existent key without get(): dict["missing"] → KeyError',
    'Using mutable objects (lists, dicts) as dictionary keys → TypeError',
    'Confusing set {} with empty dictionary {} — use set() for empty set',
    'Assuming sets maintain order — they don\'t (until Python 3.7+, but don\'t rely on it)',
  ],
};

Map<String, dynamic> _topic6() => {
  'id': 'python_topic_6',
  'order': 6,
  'name': 'Conditionals (if-else)',
  'keyPoints': [
    'Conditionals let code take different paths based on conditions',
    'if, elif, else — evaluate from top to bottom, first True condition executes',
    'Indentation is crucial in Python — it defines code blocks',
    'Comparison operators: ==, !=, <, >, <=, >=',
    'Logical operators: and, or, not',
    'Membership operators: in, not in',
    'Identity operators: is, is not (check if same object, not same value)',
    'Ternary operator: x = "Even" if num % 2 == 0 else "Odd"',
  ],
  'codeExamples': [
    {
      'title': 'If-elif-else',
      'code': 'marks = 85\nif marks >= 90:\n    print("Grade: A+")\nelif marks >= 80:\n    print("Grade: A")\nelif marks >= 70:\n    print("Grade: B+")\nelif marks >= 60:\n    print("Grade: B")\nelse:\n    print("Grade: C")\n\n# Ternary\nresult = "Pass" if marks >= 40 else "Fail"\nprint(result)',
      'explanation': 'Python checks conditions top-to-bottom. The first matching block executes. Ternary operator is a compact if-else.',
      'output': 'Grade: A\nPass',
    },
    {
      'title': 'Logical & Membership Operators',
      'code': 'age = 20\nhas_id = True\nif age >= 18 and has_id:\n    print("You can enter")\n\nfruits = ["apple", "banana", "mango"]\nif "mango" in fruits:\n    print("Mango is available!")\n\nnum = 15\nif num > 10 and num < 20:\n    print("Between 10 and 20")',
      'explanation': 'Combine conditions with and/or. Use "in" to check membership in collections.',
      'output': 'You can enter\nMango is available!\nBetween 10 and 20',
    },
  ],
  'challenges': [
    {
      'question': 'Write a program that takes a number as input and prints whether it is positive, negative, or zero.',
      'hint': 'Use if num > 0, elif num < 0, else.',
      'difficulty': 'easy',
      'solution': 'num = float(input("Enter a number: "))\nif num > 0:\n    print("Positive")\nelif num < 0:\n    print("Negative")\nelse:\n    print("Zero")',
    },
    {
      'question': 'Take a year as input and check if it is a leap year. (Leap year: divisible by 400, or divisible by 4 but not by 100)',
      'hint': 'Use nested conditions: year % 400 == 0 or (year % 4 == 0 and year % 100 != 0)',
      'difficulty': 'medium',
      'solution': 'year = int(input("Enter year: "))\nif year % 400 == 0:\n    print("Leap year")\nelif year % 4 == 0 and year % 100 != 0:\n    print("Leap year")\nelse:\n    print("Not a leap year")',
    },
  ],
  'keyConcepts': [
    'Python uses indentation (4 spaces) instead of braces {}',
    'Colon : at end of if/elif/else line',
    'Any non-zero, non-empty value is truthy; 0, None, empty are falsy',
    'Short-circuit evaluation: and stops at first False, or stops at first True',
  ],
  'importantSyntax': [
    {'syntax': 'if condition:', 'example': 'if x > 5:', 'description': 'If statement'},
    {'syntax': 'elif condition:', 'example': 'elif x == 5:', 'description': 'Else if condition'},
    {'syntax': 'val if cond else val2', 'example': '"Even" if n%2==0 else "Odd"', 'description': 'Ternary operator'},
  ],
  'commonMistakes': [
    'Forgetting colon at end of if/elif/else line → SyntaxError',
    'Using = instead of == for comparison',
    'Inconsistent indentation — mixing spaces and tabs',
    'Putting else if instead of elif',
  ],
};

Map<String, dynamic> _topic7() => {
  'id': 'python_topic_7',
  'order': 7,
  'name': 'Loops (for & while)',
  'keyPoints': [
    'Loops repeat code multiple times',
    'for loop: iterate over sequences (list, string, range, dict)',
    'range(start, stop, step): generate number sequences',
    'while loop: runs while condition is True',
    'break: exit loop immediately',
    'continue: skip rest of current iteration, go to next',
    'else clause on loops: executes if loop completes without break',
    'Nested loops: loop inside a loop',
    'enumerate(): get both index and value when iterating',
  ],
  'codeExamples': [
    {
      'title': 'For Loop with Range',
      'code': '# Count from 1 to 5\nfor i in range(1, 6):\n    print(i)\n\n# Iterate list\nfruits = ["apple", "banana", "cherry"]\nfor fruit in fruits:\n    print(f"I like {fruit}")\n\n# enumerate\nfor index, fruit in enumerate(fruits):\n    print(f"{index + 1}. {fruit}")',
      'explanation': 'range(1,6) gives 1,2,3,4,5. for loops can iterate any sequence. enumerate gives index + value.',
      'output': '1\n2\n3\n4\n5\nI like apple\nI like banana\nI like cherry\n1. apple\n2. banana\n3. cherry',
    },
    {
      'title': 'While Loop with Break/Continue',
      'code': 'num = 0\nwhile num < 10:\n    num += 1\n    if num == 3:\n        continue  # Skip 3\n    if num == 8:\n        break     # Stop at 7\n    print(num)\nelse:\n    print("Loop completed")  # Won\'t execute because break happened',
      'explanation': 'continue skips to next iteration. break exits the loop entirely. else runs only if no break.',
      'output': '1\n2\n4\n5\n6\n7',
    },
  ],
  'challenges': [
    {
      'question': 'Print the multiplication table of a number entered by the user (1 to 10).',
      'hint': 'Use a for loop with range(1, 11) and print(f"{num} x {i} = {num*i}").',
      'difficulty': 'easy',
      'solution': 'num = int(input("Enter a number: "))\nfor i in range(1, 11):\n    print(f"{num} x {i} = {num * i}")',
    },
    {
      'question': 'Print all prime numbers between 1 and 50.',
      'hint': 'Use nested loops. For each number, check if it has any divisor other than 1 and itself.',
      'difficulty': 'hard',
      'solution': 'for num in range(2, 51):\n    is_prime = True\n    for i in range(2, int(num**0.5) + 1):\n        if num % i == 0:\n            is_prime = False\n            break\n    if is_prime:\n        print(num)',
    },
  ],
  'keyConcepts': [
    'range(stop) → 0 to stop-1; range(start, stop) → start to stop-1; range(start, stop, step)',
    'Infinite loop: while True: — use with break to exit',
    'for-else and while-else: else block runs if loop finishes normally (no break)',
    'Loop control: break, continue, pass (do nothing placeholder)',
  ],
  'importantSyntax': [
    {'syntax': 'for item in sequence:', 'example': 'for x in [1,2,3]:', 'description': 'For loop'},
    {'syntax': 'while condition:', 'example': 'while x < 10:', 'description': 'While loop'},
    {'syntax': 'break / continue', 'example': 'break', 'description': 'Exit loop / skip iteration'},
  ],
  'commonMistakes': [
    'Forgetting to increment counter in while loop → infinite loop',
    'Modifying list while iterating over it → unexpected behavior',
    'Off-by-one errors with range: range(len(list)) gives 0 to len-1, not len',
    'Using == instead of != in while condition leading to immediate exit',
  ],
};

Map<String, dynamic> _topic8() => {
  'id': 'python_topic_8',
  'order': 8,
  'name': 'Functions & Recursion',
  'keyPoints': [
    'Functions group reusable code — define once, call many times',
    'def function_name(parameters): defines a function',
    'return statement sends value back to caller',
    'Parameters with default values: def greet(name, greeting="Hello")',
    '*args for variable positional arguments, **kwargs for variable keyword arguments',
    'Functions are objects — can be passed as arguments, returned from other functions',
    'Scope: variables inside function are local, use global keyword to modify global variables',
    'Recursion: function calling itself — must have base case to stop',
    'Lambda functions: small anonymous functions — lambda x: x * 2',
  ],
  'codeExamples': [
    {
      'title': 'Function Basics',
      'code': 'def greet(name, greeting="Hello"):\n    """Print a greeting message."""\n    print(f"{greeting}, {name}!")\n\ndef add(a, b):\n    return a + b\n\ngreet("Harry")\ngreet("Harry", "Namaste")\nresult = add(10, 20)\nprint(result)',
      'explanation': 'Functions defined with def. Default parameters make arguments optional. Docstring in """ describes function.',
      'output': 'Hello, Harry!\nNamaste, Harry!\n30',
    },
    {
      'title': 'Recursion — Factorial',
      'code': 'def factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)\n\nprint(factorial(5))  # 5 * 4 * 3 * 2 * 1\n\n# Lambda example\nsquare = lambda x: x ** 2\ndouble = lambda x: x * 2\nprint(square(5))\nprint(double(10))',
      'explanation': 'Recursive function calls itself. Base case (n <= 1) stops recursion. Lambda creates anonymous function.',
      'output': '120\n25\n20',
    },
  ],
  'challenges': [
    {
      'question': 'Write a function is_palindrome(s) that returns True if string s is a palindrome (same forwards and backwards), False otherwise.',
      'hint': 'Compare string with its reverse: s == s[::-1]',
      'difficulty': 'medium',
      'solution': 'def is_palindrome(s):\n    s = s.lower().replace(" ", "")\n    return s == s[::-1]\n\nprint(is_palindrome("racecar"))\nprint(is_palindrome("hello"))',
    },
    {
      'question': 'Write a recursive function fibonacci(n) that returns the nth Fibonacci number (0, 1, 1, 2, 3, 5, 8...).',
      'hint': 'Base cases: fib(0)=0, fib(1)=1. Recursive: fib(n)=fib(n-1)+fib(n-2)',
      'difficulty': 'hard',
      'solution': 'def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n-1) + fibonacci(n-2)\n\nfor i in range(10):\n    print(fibonacci(i))',
    },
  ],
  'keyConcepts': [
    'DRY: Don\'t Repeat Yourself — functions help reuse code',
    'Parameters vs Arguments: parameters are defined in function, arguments are passed',
    'Return vs Print: return sends value back to caller, print only displays',
    'Docstrings: """...""" for documentation — accessible via help(function_name)',
    'Variable scope: LEGB rule (Local, Enclosing, Global, Built-in)',
  ],
  'importantSyntax': [
    {'syntax': 'def name(params):', 'example': 'def add(a, b):', 'description': 'Function definition'},
    {'syntax': 'return value', 'example': 'return a + b', 'description': 'Return value from function'},
    {'syntax': 'lambda x: expr', 'example': 'lambda x: x**2', 'description': 'Anonymous function'},
  ],
  'commonMistakes': [
    'Forgetting return keyword — function returns None by default',
    'Modifying mutable default parameters (e.g., def f(lst=[]) → shared across calls)',
    'Infinite recursion — missing or wrong base case',
    'Confusing local and global scope — modifying global var without global keyword',
  ],
};

Map<String, dynamic> _topic9() => {
  'id': 'python_topic_9',
  'order': 9,
  'name': 'File I/O',
  'keyPoints': [
    'Files store data persistently — between program runs',
    'open(filename, mode) opens a file; modes: r (read), w (write), a (append), r+ (read+write)',
    'Always close files: file.close() — or better, use with statement (context manager)',
    'with open("file.txt", "r") as f: — automatically closes file after block',
    'Read methods: read() (entire file), readline() (one line), readlines() (list of lines)',
    'Write methods: write(string), writelines(list_of_strings)',
    'File modes: t (text, default), b (binary — for images, audio)',
    'Paths: absolute vs relative. Use os.path or pathlib for cross-platform paths.',
  ],
  'codeExamples': [
    {
      'title': 'Reading & Writing Files',
      'code': '# Writing to file\nwith open("notes.txt", "w") as f:\n    f.write("Python is awesome!\\n")\n    f.write("File handling is easy.\\n")\n\n# Reading from file\nwith open("notes.txt", "r") as f:\n    content = f.read()\n    print(content)\n\n# Append mode\nwith open("notes.txt", "a") as f:\n    f.write("This line is appended.\\n")\n\n# Read line by line\nwith open("notes.txt", "r") as f:\n    for line in f:\n        print(line.strip())',
      'explanation': 'with statement ensures file closes automatically. "w" overwrites, "a" appends.',
      'output': 'Python is awesome!\nFile handling is easy.\n\nPython is awesome!\nFile handling is easy.\nThis line is appended.',
    },
    {
      'title': 'Working with CSV',
      'code': '# Writing CSV\nimport csv\n\nwith open("students.csv", "w", newline="") as f:\n    writer = csv.writer(f)\n    writer.writerow(["Name", "Age", "Grade"])\n    writer.writerow(["Harry", 20, "A"])\n    writer.writerow(["Hermione", 19, "A+"])\n\n# Reading CSV\nwith open("students.csv", "r") as f:\n    reader = csv.reader(f)\n    for row in reader:\n        print(", ".join(row))',
      'explanation': 'csv module makes it easy to work with comma-separated files. writerow() writes one row at a time.',
      'output': 'Name, Age, Grade\nHarry, 20, A\nHermione, 19, A+',
    },
  ],
  'challenges': [
    {
      'question': 'Write a program that asks the user for a filename and a word, then counts how many times that word appears in the file.',
      'hint': 'Read file, split into words, use .count() or loop.',
      'difficulty': 'medium',
      'solution': 'filename = input("Filename: ")\nword = input("Word to count: ")\n\nwith open(filename, "r") as f:\n    content = f.read()\n    count = content.lower().split().count(word.lower())\n    print(f"\'{word}\' appears {count} times")',
    },
    {
      'question': 'Write a program that copies the contents of one file to another file, but reverses each line.',
      'hint': 'Read all lines, reverse each line with [::-1], write to new file.',
      'difficulty': 'medium',
      'solution': 'with open("input.txt", "r") as f:\n    lines = f.readlines()\n\nwith open("output.txt", "w") as f:\n    for line in lines:\n        f.write(line.strip()[::-1] + "\\n")',
    },
  ],
  'keyConcepts': [
    'Context manager (with) is preferred over manual close()',
    'Binary mode for non-text files: "rb", "wb"',
    'File paths: use os.path.join() or pathlib.Path for cross-platform',
    'Exceptions during file operations: wrap in try-except',
    'Encoding: specify encoding="utf-8" for proper text handling',
  ],
  'importantSyntax': [
    {'syntax': 'with open(path, mode) as f:', 'example': 'with open("f.txt","r") as f:', 'description': 'File context manager'},
    {'syntax': 'f.read() / f.readline() / f.readlines()', 'example': 'f.read()', 'description': 'Read file contents'},
    {'syntax': 'f.write(text) / f.writelines(lines)', 'example': 'f.write("hello")', 'description': 'Write to file'},
  ],
  'commonMistakes': [
    'Forgetting to close file (use with to avoid this)',
    'Reading file after closing',
    'Trying to read from file opened in "w" mode → io.UnsupportedOperation',
    'Not handling FileNotFoundError when file doesn\'t exist',
    'Binary vs text mode confusion when reading images',
  ],
};

Map<String, dynamic> _topic10() => {
  'id': 'python_topic_10',
  'order': 10,
  'name': 'Exception Handling',
  'keyPoints': [
    'Exceptions handle runtime errors gracefully without crashing',
    'try block: code that might raise an exception',
    'except block: handle specific exceptions',
    'Multiple except blocks for different exception types',
    'else block: runs if no exception occurred',
    'finally block: ALWAYS runs, regardless of exception — for cleanup',
    'Common exceptions: ValueError, TypeError, FileNotFoundError, ZeroDivisionError',
    'Raise exceptions manually: raise ValueError("Invalid input")',
    'Custom exceptions: create class that inherits from Exception',
  ],
  'codeExamples': [
    {
      'title': 'Try-Except-Else-Finally',
      'code': 'try:\n    num = int(input("Enter a number: "))\n    result = 10 / num\n    print(f"Result: {result}")\nexcept ValueError:\n    print("That\'s not a valid number!")\nexcept ZeroDivisionError:\n    print("Cannot divide by zero!")\nexcept Exception as e:\n    print(f"Something went wrong: {e}")\nelse:\n    print("Division successful!")\nfinally:\n    print("This always runs.")',
      'explanation': 'try monitors code for exceptions. except catches specific errors. else runs on success. finally always runs.',
      'output': 'Enter a number: 0\nCannot divide by zero!\nThis always runs.',
    },
    {
      'title': 'Raising Custom Exceptions',
      'code': 'def withdraw(balance, amount):\n    if amount > balance:\n        raise ValueError("Insufficient balance!")\n    if amount < 0:\n        raise ValueError("Amount cannot be negative!")\n    return balance - amount\n\ntry:\n    new_balance = withdraw(1000, 1500)\n    print(f"New balance: {new_balance}")\nexcept ValueError as e:\n    print(f"Error: {e}")',
      'explanation': 'raise manually triggers an exception. The except block catches and handles it.',
      'output': 'Error: Insufficient balance!',
    },
  ],
  'challenges': [
    {
      'question': 'Write a safe_divide(a, b) function that returns a/b, but handles ZeroDivisionError and TypeError. Return None if error occurs.',
      'hint': 'Wrap the division in try-except, catch both exception types.',
      'difficulty': 'medium',
      'solution': 'def safe_divide(a, b):\n    try:\n        return a / b\n    except ZeroDivisionError:\n        print("Cannot divide by zero")\n        return None\n    except TypeError:\n        print("Both arguments must be numbers")\n        return None\n\nprint(safe_divide(10, 2))\nprint(safe_divide(10, 0))\nprint(safe_divide(10, "two"))',
    },
  ],
  'keyConcepts': [
    'Never catch bare except: — catches keyboard interrupts, system exits too',
    'Exception hierarchy: BaseException → Exception → specific errors',
    'Use specific exception types, not generic Exception',
    'finally is for cleanup (closing files, releasing resources)',
    'with statement internally uses try/finally for resource management',
  ],
  'importantSyntax': [
    {'syntax': 'try: ... except Type: ...', 'example': 'try: x=int(y) except ValueError:', 'description': 'Try-except block'},
    {'syntax': 'raise ExceptionType("msg")', 'example': 'raise ValueError("bad")', 'description': 'Raise exception'},
    {'syntax': 'try: ... else: ... finally: ...', 'example': 'see example above', 'description': 'Complete exception structure'},
  ],
  'commonMistakes': [
    'Catching too broad: except: (catches everything including SystemExit)',
    'Swallowing exceptions: except: pass (hides errors silently)',
    'Putting too much code in try block (be specific about what might fail)',
    'Not preserving original exception: raise without args loses traceback',
  ],
};

Map<String, dynamic> _topic11() => {
  'id': 'python_topic_11',
  'order': 11,
  'name': 'OOP: Classes & Objects',
  'keyPoints': [
    'OOP organizes code using classes and objects',
    'Class: blueprint/template. Object: instance of a class.',
    '__init__ method: constructor, initializes object attributes',
    'self: refers to current instance — must be first parameter of instance methods',
    'Instance attributes: unique per object. Class attributes: shared across all objects',
    'Inheritance: class Child(Parent): — child gets all parent attributes/methods',
    'Method overriding: redefine parent method in child',
    'super(): call parent class methods from child',
    'Encapsulation: _protected (single underscore) and __private (double underscore)',
    'Polymorphism: same method name works differently for different classes',
  ],
  'codeExamples': [
    {
      'title': 'Class Basics',
      'code': 'class Student:\n    school = "PRIME School"  # Class attribute\n\n    def __init__(self, name, age):\n        self.name = name      # Instance attribute\n        self.age = age\n\n    def introduce(self):\n        return f"Hi, I\'m {self.name}, age {self.age}"\n\n    @classmethod\n    def change_school(cls, new_school):\n        cls.school = new_school\n\ns1 = Student("Harry", 20)\ns2 = Student("Hermione", 19)\nprint(s1.introduce())\nprint(s1.school)\nStudent.change_school("Hogwarts")\nprint(s2.school)',
      'explanation': '__init__ runs on object creation. self is the instance. @classmethod works on class, not instance.',
      'output': 'Hi, I\'m Harry, age 20\nPRIME School\nHogwarts',
    },
    {
      'title': 'Inheritance',
      'code': 'class Animal:\n    def __init__(self, name):\n        self.name = name\n\n    def speak(self):\n        return "... (generic sound)"\n\nclass Dog(Animal):\n    def speak(self):\n        return "Woof! Woof!"\n\nclass Cat(Animal):\n    def speak(self):\n        return "Meow!"\n\nanimals = [Dog("Buddy"), Cat("Kitty")]\nfor a in animals:\n    print(f"{a.name} says: {a.speak()}")',
      'explanation': 'Dog and Cat inherit from Animal. Each overrides speak() for polymorphic behavior.',
      'output': 'Buddy says: Woof! Woof!\nKitty says: Meow!',
    },
  ],
  'challenges': [
    {
      'question': 'Create a BankAccount class with deposit(), withdraw(), and show_balance() methods. Initialize with owner name and starting balance.',
      'hint': 'Use __init__ to set owner and balance. withdraw should check for sufficient funds.',
      'difficulty': 'medium',
      'solution': 'class BankAccount:\n    def __init__(self, owner, balance=0):\n        self.owner = owner\n        self.balance = balance\n\n    def deposit(self, amount):\n        self.balance += amount\n        print(f"Deposited {amount}. Balance: {self.balance}")\n\n    def withdraw(self, amount):\n        if amount > self.balance:\n            print("Insufficient funds!")\n        else:\n            self.balance -= amount\n            print(f"Withdrew {amount}. Balance: {self.balance}")\n\n    def show_balance(self):\n        print(f"{self.owner}\'s balance: {self.balance}")\n\nacc = BankAccount("Harry", 1000)\nacc.deposit(500)\nacc.withdraw(200)\nacc.show_balance()',
    },
  ],
  'keyConcepts': [
    'self is not a keyword — could be any name, but self is convention',
    '__init__ is not a constructor — it\'s an initializer (object already created)',
    'Methods vs Functions: methods are functions defined inside a class',
    '@staticmethod: method that doesn\'t need self or cls',
    '@property: method that behaves like an attribute',
    'Multiple inheritance: class Child(Parent1, Parent2): — use sparingly',
  ],
  'importantSyntax': [
    {'syntax': 'class ClassName:', 'example': 'class Car:', 'description': 'Class definition'},
    {'syntax': 'def __init__(self, ...):', 'example': 'def __init__(self, name):', 'description': 'Constructor'},
    {'syntax': 'class Child(Parent):', 'example': 'class Dog(Animal):', 'description': 'Inheritance'},
  ],
  'commonMistakes': [
    'Forgetting self parameter in instance methods',
    'Using class attribute when instance attribute is intended (or vice versa)',
    'Misunderstanding __init__ vs __new__',
    'Overcomplicating with deep inheritance hierarchies',
  ],
};

Map<String, dynamic> _topic12() => {
  'id': 'python_topic_12',
  'order': 12,
  'name': 'Modules, pip & Virtual Environments',
  'keyPoints': [
    'Modules are Python files (.py) containing functions, classes, variables — reusable code',
    'import module_name — imports entire module',
    'from module import function — imports specific items',
    'import module as alias — imports with shorter name',
    'pip: Python\'s package installer — installs packages from PyPI',
    'Common pip commands: pip install, pip uninstall, pip list, pip freeze',
    'Virtual environments (venv): isolated Python environments for projects',
    'Why venv: different projects can have different package versions',
    'Create: python -m venv myenv',
    'Activate: source myenv/bin/activate (Linux/Mac) or myenv\\Scripts\\activate (Windows)',
    'Requirements.txt: pip freeze > requirements.txt and pip install -r requirements.txt',
  ],
  'codeExamples': [
    {
      'title': 'Importing Modules',
      'code': 'import math\nfrom datetime import datetime\nimport numpy as np\n\nprint(math.sqrt(16))\nprint(datetime.now())\nprint(np.pi)',
      'explanation': 'Standard library modules like math and datetime are built-in. numpy requires pip install.',
      'output': '4.0\n2026-07-02 15:30:00.123456\n3.141592653589793',
    },
    {
      'title': 'Creating Your Own Module',
      'code': '# mymodule.py (create this file)\ndef greet(name):\n    return f"Hello, {name}!"\n\nPI = 3.14159\n\n# main.py (import it)\nimport mymodule\n\nprint(mymodule.greet("Harry"))\nprint(mymodule.PI)',
      'explanation': 'Any .py file is a module. Place it in same directory and import it by filename (without .py).',
      'output': 'Hello, Harry!\n3.14159',
    },
  ],
  'challenges': [
    {
      'question': 'Install the requests library using pip, then write a program that fetches and prints the current weather from a public API (like wttr.in).',
      'hint': 'pip install requests, then requests.get("https://wttr.in/Mumbai?format=3")',
      'difficulty': 'hard',
      'solution': 'import requests\n\nresponse = requests.get("https://wttr.in/Mumbai?format=3")\nprint(response.text)',
    },
  ],
  'keyConcepts': [
    'Python has a rich standard library — "batteries included" philosophy',
    'PyPI (Python Package Index) has over 500,000 packages',
    'Always use virtual environments for project isolation',
    'requirements.txt documents project dependencies',
    '__pycache__ stores compiled bytecode for faster loading',
  ],
  'importantSyntax': [
    {'syntax': 'import module', 'example': 'import math', 'description': 'Import entire module'},
    {'syntax': 'from module import item', 'example': 'from math import sqrt', 'description': 'Import specific item'},
    {'syntax': 'pip install package', 'example': 'pip install requests', 'description': 'Install package'},
  ],
  'commonMistakes': [
    'Installing packages globally instead of in virtual environment',
    'Forgetting to activate virtual environment → ModuleNotFoundError',
    'Committing __pycache__ or virtual environment to git',
    'Not creating requirements.txt → others can\'t reproduce environment',
  ],
};

Map<String, dynamic> _topic13() => {
  'id': 'python_topic_13',
  'order': 13,
  'name': 'Advanced Python',
  'keyPoints': [
    'List comprehensions: [expr for item in iterable if condition] — concise, fast',
    'Lambda functions: small anonymous functions for short operations',
    'map(function, iterable): applies function to every item',
    'filter(function, iterable): keeps items where function returns True',
    'zip(*iterables): pairs elements from multiple iterables together',
    'Decorators (@decorator): modify/enhance functions without changing their code',
    'Generators (yield): produce items one at a time, memory efficient',
    'Iterators vs Iterables: iterables have __iter__(), iterators have __next__()',
  ],
  'codeExamples': [
    {
      'title': 'Map, Filter, Lambda & List Comprehension',
      'code': 'numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\n\n# List comprehension\nsquares = [x**2 for x in numbers]\n\n# map + lambda\ndoubled = list(map(lambda x: x * 2, numbers))\n\n# filter + lambda\nevens = list(filter(lambda x: x % 2 == 0, numbers))\n\n# zip\nnames = ["Harry", "Ron", "Hermione"]\nscores = [85, 92, 98]\nfor name, score in zip(names, scores):\n    print(f"{name}: {score}")\n\nprint(f"Squares: {squares}")\nprint(f"Doubled: {doubled}")\nprint(f"Evens: {evens}")',
      'explanation': 'Map applies function to every element. Filter keeps matching elements. Zip pairs iterables.',
      'output': 'Harry: 85\nRon: 92\nHermione: 98\nSquares: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]\nDoubled: [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]\nEvens: [2, 4, 6, 8, 10]',
    },
    {
      'title': 'Decorators',
      'code': 'def timer(func):\n    import time\n    def wrapper(*args, **kwargs):\n        start = time.time()\n        result = func(*args, **kwargs)\n        end = time.time()\n        print(f"{func.__name__} took {end-start:.4f}s")\n        return result\n    return wrapper\n\n@timer\ndef slow_function():\n    total = sum(range(1000000))\n    return total\n\nprint(slow_function())',
      'explanation': 'Decorators wrap functions to add behavior (logging, timing, caching). @timer is syntactic sugar for slow_function = timer(slow_function).',
      'output': 'slow_function took 0.0342s\n499999500000',
    },
  ],
  'challenges': [
    {
      'question': 'Use a list comprehension to create a list of all even squares from 1 to 100 (square numbers that are even).',
      'hint': 'Combine: [x**2 for x in range(1, 101) if (x**2) % 2 == 0]',
      'difficulty': 'medium',
      'solution': 'even_squares = [x**2 for x in range(1, 101) if (x**2) % 2 == 0]\nprint(even_squares)',
    },
    {
      'question': 'Create a decorator @uppercase that converts the return value of a function to uppercase.',
      'hint': 'Define wrapper that calls the function and applies .upper() to result.',
      'difficulty': 'hard',
      'solution': 'def uppercase(func):\n    def wrapper(*args, **kwargs):\n        result = func(*args, **kwargs)\n        return result.upper()\n    return wrapper\n\n@uppercase\ndef greet(name):\n    return f"Hello, {name}!"\n\nprint(greet("harry"))',
    },
  ],
  'keyConcepts': [
    'List comprehensions are faster than for loops in most cases',
    'Generators use yield and produce items lazily — memory efficient for large data',
    'Decorators are functions that take/return functions — used for cross-cutting concerns',
    '*args passes variable positional arguments, **kwargs passes variable keyword arguments',
    'Use map/filter instead of loops when applying simple transformations',
  ],
  'importantSyntax': [
    {'syntax': '[expr for x in iter]', 'example': '[x*2 for x in range(5)]', 'description': 'List comprehension'},
    {'syntax': 'map(func, iter)', 'example': 'map(str, [1,2,3])', 'description': 'Apply function to all items'},
    {'syntax': '@decorator', 'example': '@timer\ndef f(): pass', 'description': 'Decorator syntax'},
  ],
  'commonMistakes': [
    'Confusing map() with filter() — map transforms, filter selects',
    'Forgetting to convert map/filter to list — they return iterators',
    'Decorator without *args, **kwargs — breaks decorated functions with parameters',
    'Generator exhaustion — generators can only be iterated once',
  ],
};

Map<String, dynamic> _topic14() => {
  'id': 'python_topic_14',
  'order': 14,
  'name': 'Projects & Practice Sets',
  'keyPoints': [
    'Building projects is the best way to learn Python',
    'Start with simple CLI projects, then move to GUI and web',
    'Practice sets reinforce concepts learned in each chapter',
    'Project ideas: Calculator, To-Do List, Password Generator, Weather App',
    'Break projects into small, manageable functions',
    'Test each function as you build — don\'t write everything at once',
    'Use version control (git) for project management',
    'Read documentation and existing code — learn from real-world examples',
    'Projects for resume: show employers what you can build',
  ],
  'codeExamples': [
    {
      'title': 'Simple Calculator',
      'code': 'def calculator():\n    print("Simple Calculator")\n    print("Operations: +, -, *, /")\n\n    while True:\n        try:\n            a = float(input("Enter first number: "))\n            op = input("Enter operation (+, -, *, /): ")\n            b = float(input("Enter second number: "))\n\n            if op == "+":\n                print(f"Result: {a + b}")\n            elif op == "-":\n                print(f"Result: {a - b}")\n            elif op == "*":\n                print(f"Result: {a * b}")\n            elif op == "/":\n                if b == 0:\n                    print("Cannot divide by zero!")\n                else:\n                    print(f"Result: {a / b}")\n            else:\n                print("Invalid operation!")\n\n            again = input("Another calculation? (y/n): ")\n            if again.lower() != "y":\n                break\n        except ValueError:\n            print("Please enter valid numbers!")\n\ncalculator()',
      'explanation': 'This project combines functions, conditionals, loops, exception handling, and user input into one practical program.',
      'output': 'Simple Calculator\nOperations: +, -, *, /\nEnter first number: 10\nEnter operation (+, -, *, /): *\nEnter second number: 5\nResult: 50.0\nAnother calculation? (y/n): n',
    },
    {
      'title': 'Password Generator',
      'code': 'import random\nimport string\n\ndef generate_password(length=12, use_special=True):\n    chars = string.ascii_letters + string.digits\n    if use_special:\n        chars += string.punctuation\n\n    password = "".join(random.choice(chars) for _ in range(length))\n    return password\n\nprint("Password Generator")\nlength = int(input("Enter password length: "))\nspecial = input("Include special characters? (y/n): ").lower() == "y"\n\npassword = generate_password(length, special)\nprint(f"Generated Password: {password}")',
      'explanation': 'Uses random module and string constants. List comprehension generates random characters.',
      'output': 'Password Generator\nEnter password length: 16\nInclude special characters? (y/n): y\nGenerated Password: aB3#kL9\$mN1*pQ7&',
    },
  ],
  'challenges': [
    {
      'question': 'Build a To-Do List app that runs in the terminal. It should support: adding tasks, viewing all tasks, marking tasks as done, and deleting tasks.',
      'hint': 'Use a list to store tasks. Each task can be a dict with "task" and "done" keys. Use a while loop with menu options.',
      'difficulty': 'hard',
      'solution': 'tasks = []\n\nwhile True:\n    print("\\n=== TO-DO LIST ===")\n    print("1. Add task")\n    print("2. View tasks")\n    print("3. Mark done")\n    print("4. Delete task")\n    print("5. Exit")\n\n    choice = input("Choose (1-5): ")\n\n    if choice == "1":\n        task = input("Enter task: ")\n        tasks.append({"task": task, "done": False})\n        print("Task added!")\n    elif choice == "2":\n        if not tasks:\n            print("No tasks!")\n        else:\n            for i, t in enumerate(tasks):\n                status = "✓" if t["done"] else " " \n                print(f"{i+1}. [{status}] {t[\'task\']}")\n    elif choice == "3":\n        idx = int(input("Task number to mark done: ")) - 1\n        if 0 <= idx < len(tasks):\n            tasks[idx]["done"] = True\n            print("Marked done!")\n    elif choice == "4":\n        idx = int(input("Task number to delete: ")) - 1\n        if 0 <= idx < len(tasks):\n            removed = tasks.pop(idx)\n            print(f"Deleted: {removed[\'task\']}")\n    elif choice == "5":\n        print("Goodbye!")\n        break',
    },
  ],
  'keyConcepts': [
    'Start with pseudocode — plan before coding',
    'Build incrementally — one feature at a time',
    'Use functions to organize project code',
    'Handle edge cases: empty input, invalid data, file not found',
    'Read error messages carefully — they tell you what\'s wrong',
    'Google errors and solutions — every developer does this',
  ],
  'importantSyntax': [
    {'syntax': 'Project structure', 'example': 'project/\n  main.py\n  utils.py\n  README.md', 'description': 'Organize projects with multiple files'},
    {'syntax': 'if __name__ == "__main__":', 'example': 'if __name__ == "__main__":\n    main()', 'description': 'Run only when file is executed directly'},
  ],
  'commonMistakes': [
    'Trying to build everything at once — overwhelmed and gives up',
    'Not testing edge cases (empty list, negative numbers, zero division)',
    'Writing too much code without testing — debugging becomes nightmare',
    'Not reading error messages — the answer is often in the traceback',
  ],
};

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
