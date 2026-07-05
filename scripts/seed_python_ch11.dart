// Run: dart run scripts/seed_python_ch11.dart
// Seeds Python Ch 11: Inheritance (3 topics + roadmap) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Chapter 11...\n');

  // 1. Chapter metadata
  await patchDoc('content/python/chapters/chapter_11', {
    'id': 'chapter_11',
    'subjectId': 'python',
    'name': 'Inheritance & More on OOPs',
    'order': 11,
    'totalTopics': 3,
  });

  // 2. Roadmap
  final roadmapTopics = [
    {'topicId': 'topic_11_1', 'chapterId': 'chapter_11', 'name': 'Inheritance Basics', 'order': 38},
    {'topicId': 'topic_11_2', 'chapterId': 'chapter_11', 'name': 'Multiple & Multilevel Inheritance', 'order': 39},
    {'topicId': 'topic_11_3', 'chapterId': 'chapter_11', 'name': 'Operator Overloading', 'order': 40},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // 3. Topics
  final topics = [topic11_1(), topic11_2(), topic11_3()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/chapter_11/topics/${t['id']}', t);
  }

  print('\nDone! Python Chapter 11 seeded successfully.');
}

Map<String, dynamic> topic11_1() {
  return {
    'id': 'topic_11_1',
    'name': 'Inheritance Basics',
    'chapterId': 'chapter_11',
    'subjectId': 'python',
    'order': 38,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=26618',
    'keyPoints': [
      'Inheritance ka matlab - ek class doosri class ki properties aur methods inherit kar leti hai',
      'Parent class (base class) woh class hai jo apni properties deti hai',
      'Child class (derived class) woh class hai jo properties leti hai',
      'Syntax: class ChildClass(ParentClass): - bas parentheses mein parent ka naam likho',
      'Child class apne parent ki saari attributes aur methods use kar sakti hai',
      'Child class apne khud ke bhi naye attributes aur methods add kar sakti hai',
      'super() function se child class parent ke methods ko call kar sakti hai',
      'super().__init__() se hum parent class ke constructor ko call karte hain',
      'Inheritance se code reuse hota hai - baar baar same code nahi likhna padta',
    ],
    'keyConcepts': [
      'Inheritance',
      'Parent / Base class',
      'Child / Derived class',
      'super() keyword',
      'Code reusability',
    ],
    'aiCoachScript': '''Chalo doston, aaj hum seekhenge Inheritance - jo OOP ka ek powerful concept hai.

Inheritance ka matlab hota hai - virasat. Jaise aapko apne parents se kuch cheezein milti hain - jaise height, skin colour, aur kuch habits. Waise hi Python mein ek class doosri class ki properties aur methods inherit kar leti hai.

Maan lo aapke paas ek Employee class hai:

class Employee:
    company = "ITC"
    def show(self):
        print(f"The name is {self.name} and the salary is {self.salary}")

Ab aap ek Programmer class banana chahte ho jisme woh saari cheezein ho jo Employee mein hain, plus kuch extra. Toh aap inheritance use karoge:

class Programmer(Employee):
    company = "ITC Infotech"
    def showLanguage(self):
        print(f"The name is {self.name} and he is good with {self.language} language")

Dekha? Programmer(Employee) likhne se Programmer ko Employee ki saari properties mil gayin. Programmer ne sirf company override ki aur naya method showLanguage add kiya.

Ab jab aap likhoge:
b = Programmer()
b.show()  - yeh Employee ka method hai, par Programmer use kar raha hai

Yeh hai inheritance ka magic.

Ab aate hain super() par. Jab child class ka apna __init__ hota hai, toh parent ka __init__ automatically call nahi hota. Isliye super().__init__() use karte hain:

class Manager(Programmer):
    def __init__(self):
        super().__init__()
        print("Constructor of Manager")

super() se hum parent class ke methods ko explicitly call kar sakte hain.

Code reuse ka fayda - aapne Employee ka show method nahi likha Programmer mein, lekin woh kaam kar raha hai. Kam code, zyada kaam - inheritance ka yahi maza hai.''',
    'codeExamples': [
      {
        'title': 'Basic Inheritance - Programmer(Employee)',
        'code': "class Employee:\n    company = \"ITC\"\n    def show(self):\n        print(f\"The name of the Employee is {self.name} and the salary is {self.salary}\")\n\nclass Programmer(Employee):\n    company = \"ITC Infotech\"\n    def showLanguage(self):\n        print(f\"The name is {self.name} and he is good with {self.language} language\")\n\na = Employee()\nb = Programmer()\nprint(a.company, b.company)",
        'explanation': 'Programmer(Employee) se Programmer class Employee ki saari properties inherit kar rahi hai. Programmer ne company attribute override kiya aur naya showLanguage method add kiya. show method Employee se inherit hua.',
        'output': 'ITC ITC Infotech',
      },
      {
        'title': 'super() to Call Parent Constructor',
        'code': "class Employee:\n    def __init__(self):\n        print(\"Constructor of Employee\")\n    a = 1\n\nclass Programmer(Employee):\n    def __init__(self):\n        print(\"Constructor of Programmer\")\n    b = 2\n\nclass Manager(Programmer):\n    def __init__(self):\n        super().__init__()\n        print(\"Constructor of Manager\")\n    c = 3\n\no = Manager()\nprint(o.a, o.b, o.c)",
        'explanation': 'Manager ka __init__ super().__init__() call karta hai jo Programmer ke constructor ko call karta hai. Programmer ke constructor mein super() nahi hai, isliye Employee ka constructor auto call nahi hua. super() se parent chain ke saare constructors manually call kar sakte hain.',
        'output': 'Constructor of Programmer\nConstructor of Manager\n1 2 3',
      },
    ],
    'challenges': [
      {
        'question': 'Ek TwoDVector class banao jo i aur j coordinates le. Uska show() method "i + j" format mein vector print kare. Phir ThreeDVector banayo jo TwoDVector se inherit kare, super().__init__(i, j) call kare aur k coordinate add kare. show() method override karo.',
        'hint': 'TwoDVector mein __init__(self, i, j) aur show(). ThreeDVector mein __init__ mein super().__init__(i, j) aur self.k = k. show() override karo teeno coordinates print karne ke liye.',
        'solution': "class TwoDVector:\n    def __init__(self, i, j):\n        self.i = i\n        self.j = j\n    def show(self):\n        print(f\"The vector is {self.i}i + {self.j}j\")\n\nclass ThreeDVector(TwoDVector):\n    def __init__(self, i, j, k):\n        super().__init__(i, j)\n        self.k = k\n    def show(self):\n        print(f\"The vector is {self.i}i + {self.j}j + {self.k}k\")\n\na = TwoDVector(1, 2)\na.show()\nb = ThreeDVector(5, 2, 3)\nb.show()",
        'difficulty': 'easy',
      },
      {
        'question': 'Animals, Pets aur Dog ka hierarchy banao. Animals base class hai, Pets Animals se inherit karta hai, aur Dog Pets se inherit karta hai. Dog mein @staticmethod bark() ho jo "Bow Bow!" print kare. Object bana kar bark() call karo.',
        'hint': 'class Animals: pass, class Pets(Animals): pass, class Dog(Pets):. Dog mein @staticmethod def bark(): print("Bow Bow!") likho. d = Dog() aur d.bark() se call karo.',
        'solution': "class Animals:\n    pass\n\nclass Pets(Animals):\n    pass\n\nclass Dog(Pets):\n    @staticmethod\n    def bark():\n        print(\"Bow Bow!\")\n\nd = Dog()\nd.bark()",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek Employee class banao jisme salary = 234 aur increment = 20 ho. @property salaryAfterIncrement banayo jo salary + salary * increment/100 calculate kare. @salaryAfterIncrement.setter banao jo naye salary ke hisaab se increment calculate kare. Test karo: salaryAfterIncrement = 280.8 set kar ke increment print karo.',
        'hint': '@property def salaryAfterIncrement(self): return self.salary + self.salary * (self.increment/100). Setter mein: self.increment = ((salary / self.salary) - 1) * 100. e.salaryAfterIncrement = 280.8 set karo aur e.increment print karo.',
        'solution': "class Employee:\n    salary = 234\n    increment = 20\n\n    @property\n    def salaryAfterIncrement(self):\n        return (self.salary + self.salary * (self.increment / 100))\n\n    @salaryAfterIncrement.setter\n    def salaryAfterIncrement(self, salary):\n        self.increment = ((salary / self.salary) - 1) * 100\n\ne = Employee()\ne.salaryAfterIncrement = 280.8\nprint(e.increment)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'class Child(Parent):', 'example': 'class Programmer(Employee):', 'description': 'Child class Parent se inherit karta hai'},
      {'syntax': 'super()', 'example': 'super().__init__()', 'description': 'Parent class ke methods ko call karne ke liye'},
      {'syntax': 'class Child(Parent):\n    def __init__(self):\n        super().__init__()', 'example': 'class Manager(Programmer):\n    def __init__(self):\n        super().__init__()', 'description': 'Child constructor se parent constructor call karna'},
    ],
    'commonMistakes': [
      'super() call karna bhoolna - parent ka constructor automatically call nahi hota agar child ka __init__ ho',
      'Inheritance mein child class ke method ka naam parent se match kar jaye - override ho jaata hai',
      'Multiple inheritance mein same naam ke methods hote hain toh MRO (Method Resolution Order) confuse kar sakta hai',
    ],
  };
}

Map<String, dynamic> topic11_2() {
  return {
    'id': 'topic_11_2',
    'name': 'Multiple & Multilevel Inheritance',
    'chapterId': 'chapter_11',
    'subjectId': 'python',
    'order': 39,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=27060',
    'keyPoints': [
      'Multiple inheritance mein ek child class ek se zyada parent classes se inherit karta hai',
      'Syntax: class Child(Parent1, Parent2, Parent3): - comma seperate karo',
      'Multilevel inheritance mein ek chain hoti hai: Grandparent -> Parent -> Child',
      'Multiple inheritance mein MRO (Method Resolution Order) decide karta hai kaunsa method pehle call hoga',
      'MRO left to right jaata hai - jo parent pehle likha hai, uski priority zyada',
      '@classmethod decorator se aisa method banate hain jo class ko refer karta hai, object ko nahi',
      'Class method mein cls parameter hota hai (self ki jagah) jo class ko refer karta hai',
      'Class methods class attribute ko modify kar sakte hain jo saare objects ko affect karta hai',
    ],
    'keyConcepts': [
      'Multiple inheritance',
      'Multilevel inheritance',
      'MRO (Method Resolution Order)',
      '@classmethod decorator',
      'cls parameter',
    ],
    'aiCoachScript': '''Chalo ab baat karte hain Multiple aur Multilevel Inheritance ki.

Pehle samajhte hain Multiple Inheritance. Isme ek child class do ya zyada parent classes se inherit karti hai.

Jaise maan lo:
class Employee:
    company = "ITC"
    def show(self):
        print(f"The name is {self.name} and company is {self.company}")

class Coder:
    language = "Python"
    def printLanguages(self):
        print(f"Your language is {self.language}")

class Programmer(Employee, Coder):
    company = "ITC Infotech"

Yahan Programmer dono Employee aur Coder se inherit kar raha hai. Toh uske paas dono ke methods hain - show() bhi aur printLanguages() bhi.

Agar dono parent mein same naam ka method ho, toh kaunsa call hoga? Iska answer hai MRO - Method Resolution Order. Python left to right parent check karta hai. Pehle Employee, phir Coder.

Ab Multilevel Inheritance:

class Employee:
    a = 1
class Programmer(Employee):
    b = 2
class Manager(Programmer):
    c = 3

Yeh ek chain hai: Employee -> Programmer -> Manager. Manager ke paas a, b, c teeno hain. Programmer ke paas a aur b hain. Employee ke paas sirf a hai.

Ab aate hain @classmethod par. Ye @staticmethod jaisa hi hai, lekin yeh class ko access kar sakta hai:

class Employee:
    a = 1
    @classmethod
    def show(cls):
        print(f"The class attribute of a is {cls.a}")

Yahan cls parameter class ko refer karta hai (Employee), object ko nahi. Agar koi instance attribute a set bhi kare, tab bhi @classmethod class attribute hi print karega.

@classmethod vs @staticmethod:
- @classmethod - class ko access kar sakta hai (cls parameter)
- @staticmethod - class ko access nahi kar sakta (koi cls ya self nahi)

Dono ka apna use case hai. Class methods tab use karo jab aapko class level par kuch change karna ho.''',
    'codeExamples': [
      {
        'title': 'Multiple Inheritance',
        'code': "class Employee:\n    company = \"ITC\"\n    name = \"Default name\"\n    def show(self):\n        print(f\"The name of the Employee is {self.name} and the company is {self.company}\")\n\nclass Coder:\n    language = \"Python\"\n    def printLanguages(self):\n        print(f\"Out of all the languages here is your language: {self.language}\")\n\nclass Programmer(Employee, Coder):\n    company = \"ITC Infotech\"\n    def showLanguage(self):\n        print(f\"The name is {self.company} and he is good with {self.language} language\")\n\nb = Programmer()\nb.show()\nb.printLanguages()\nb.showLanguage()",
        'explanation': 'Programmer dono Employee aur Coder se inherit karta hai. Iske paas Employee ka show(), Coder ka printLanguages(), aur apna khud ka showLanguage() method hai. MRO ke hisaab se Employee ko pehli priority milti hai.',
        'output': 'The name of the Employee is Default name and the company is ITC Infotech\nOut of all the languages here is your language: Python\nThe name is ITC Infotech and he is good with Python language',
      },
      {
        'title': 'Multilevel Inheritance',
        'code': "class Employee:\n    a = 1\n\nclass Programmer(Employee):\n    b = 2\n\nclass Manager(Programmer):\n    c = 3\n\no = Employee()\nprint(o.a)\n\no = Programmer()\nprint(o.a, o.b)\n\no = Manager()\nprint(o.a, o.b, o.c)",
        'explanation': 'Employee -> Programmer -> Manager ki chain hai. Manager ke paas a (Employee se), b (Programmer se), aur c (apna) teeno attributes hain. Programmer ke paas a aur b. Employee ke paas sirf a.',
        'output': '1\n1 2\n1 2 3',
      },
      {
        'title': '@classmethod Decorator',
        'code': "class Employee:\n    a = 1\n\n    @classmethod\n    def show(cls):\n        print(f\"The class attribute of a is {cls.a}\")\n\ne = Employee()\ne.a = 45\ne.show()",
        'explanation': '@classmethod se show() method class ko refer karta hai (cls = Employee), object ko nahi. Jab e.a = 45 set kiya tab bhi cls.a = 1 hi print hoga kyunki show() class attribute access kar raha hai, instance attribute nahi.',
        'output': 'The class attribute of a is 1',
      },
    ],
    'challenges': [
      {
        'question': 'Ek class A banao jisme method show() ho jo "A" print kare. Class B banao jisme method show() ho jo "B" print kare. Class C(A, B) banao jo dono se inherit kare. C ka object bana kar show() call karo - kaunsa print hoga? Phir class C(B, A) karo - kya badalta hai?',
        'hint': 'MRO left to right hota hai. C(A, B) mein A ki priority zyada hai, isliye A ka show() call hoga. C(B, A) mein B ka show() call hoga. MRO check karne ke liye C.__mro__ bhi print kar sakte ho.',
        'solution': "class A:\n    def show(self):\n        print(\"A\")\n\nclass B:\n    def show(self):\n        print(\"B\")\n\nclass C(A, B):\n    pass\n\nc = C()\nc.show()  # Outputs: A\nprint(C.__mro__)\n\nclass D(B, A):\n    pass\n\nd = D()\nd.show()  # Outputs: B\nprint(D.__mro__)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek Vector class banao jo x, y, z coordinates le. __add__ method se do vectors ka addition karo (component-wise). __mul__ method se dot product karo. __str__ method se "x i + y j + z k" format mein print karo. Vectors (1,2,3) aur (4,5,6) ke saath test karo.',
        'hint': '__add__ mein Vector(self.x + other.x, self.y + other.y, self.z + other.z) return karo. __mul__ mein self.x * other.x + self.y * other.y + self.z * other.z return karo. __str__ mein f-string use karo.',
        'solution': "class Vector:\n    def __init__(self, x, y, z):\n        self.x = x\n        self.y = y\n        self.z = z\n    def __add__(self, other):\n        return Vector(self.x + other.x, self.y + other.y, self.z + other.z)\n    def __mul__(self, other):\n        return self.x * other.x + self.y * other.y + self.z * other.z\n    def __str__(self):\n        return f\"{self.x}i + {self.y}j + {self.z}k\"\n\nv1 = Vector(1, 2, 3)\nv2 = Vector(4, 5, 6)\nprint(v1 + v2)\nprint(v1 * v2)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek Vector class banao jo list of numbers le (jaise [1, 2, 3]). __len__ method implement karo jo vector ki length (number of components) return kare. Vector([1, 2, 3]) ka length 3 hona chahiye. Phir inheritance use karke ek NamedVector class banao jo Vector se inherit kare aur usme name attribute add kare.',
        'hint': 'class Vector: def __init__(self, l): self.l = l. __len__ mein return len(self.l). class NamedVector(Vector): def __init__(self, l, name): super().__init__(l); self.name = name.',
        'solution': "class Vector:\n    def __init__(self, l):\n        self.l = l\n    def __len__(self):\n        return len(self.l)\n\nclass NamedVector(Vector):\n    def __init__(self, l, name):\n        super().__init__(l)\n        self.name = name\n\nv1 = Vector([1, 2, 3])\nprint(len(v1))\n\nv2 = NamedVector([4, 5, 6, 7], \"TestVector\")\nprint(len(v2))\nprint(v2.name)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'class Child(Parent1, Parent2):', 'example': 'class Programmer(Employee, Coder):', 'description': 'Multiple inheritance - child class multiple parents se inherit karta hai'},
      {'syntax': 'class Child(Parent):\nclass GrandChild(Child):', 'example': 'class Programmer(Employee):\nclass Manager(Programmer):', 'description': 'Multilevel inheritance - chain of inheritance'},
      {'syntax': '@classmethod\ndef method(cls):', 'example': '@classmethod\ndef show(cls):', 'description': 'Class method - cls parameter class ko refer karta hai'},
    ],
    'commonMistakes': [
      'Multiple inheritance mein diamond problem se confused hona - Python MRO se handle karta hai, par logic complex ho sakti hai',
      '@classmethod aur @staticmethod mein difference na samajhna - @classmethod ko cls milta hai, @staticmethod ko kuch nahi',
      'Multilevel inheritance mein unnecessarily deep chain banana - code complex ho jaata hai, 3-4 levels sufficient hain',
    ],
  };
}

Map<String, dynamic> topic11_3() {
  return {
    'id': 'topic_11_3',
    'name': 'Operator Overloading',
    'chapterId': 'chapter_11',
    'subjectId': 'python',
    'order': 40,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=27877',
    'keyPoints': [
      'Operator overloading ka matlab - +, -, *, / jaise operators ko apne class ke liye define karna',
      'Python mein har operator ke peeche ek dunder method hota hai (double underscore methods)',
      '+ operator ke peeche __add__ method hota hai - a + b actually a.__add__(b) call karta hai',
      'Is tarah aap apne custom classes ke objects ko +, -, * etc. se operate kar sakte hain',
      '__str__ method object ko string mein convert karta hai - print() aur str() use karte hain',
      '@property decorator se aisa method banate hain jo attribute ki tarah access ho',
      '@name.setter se property ko set kar sakte hain - jaise e.name = "Harry Khan"',
      'Operator overloading se code zyada readable aur intuitive ho jaata hai',
    ],
    'keyConcepts': [
      'Operator overloading',
      'Dunder methods (__add__, __mul__)',
      '__str__ method',
      '@property decorator',
      '@name.setter decorator',
    ],
    'aiCoachScript': '''Chalo doston, aaj ka last topic hai Operator Overloading.

Aap jaante ho ki + operator do numbers ko jodta hai - 2 + 3 = 5. Lekin kya aap jaante ho ki Python mein asal mein 2 + 3 likhne par Python 2.__add__(3) call karta hai? Haan, har operator ke peeche ek method hota hai.

+ ka __add__
- ka __sub__
* ka __mul__
/ ka __truediv__
len() ka __len__
print() ka __str__

Aur aap in methods ko apni class mein define kar sakte ho. Isse operator overloading kehte hain.

Dekho yeh example:

class Number:
    def __init__(self, n):
        self.n = n

    def __add__(self, num):
        return self.n + num.n

n = Number(1)
m = Number(2)
print(n + m)  # Yeh 3 print karega

Dekha? n + m likhne par Python n.__add__(m) call karta hai. Aur humne __add__ define kiya hai jo self.n + num.n return karta hai. Toh 1 + 2 = 3.

Isi tarah __str__ object ko string mein convert karta hai. Jab bhi aap print(object) likhte ho, __str__ call hota hai.

Ab @property decorator ki baat karte hain. Isse aap ek method ko attribute ki tarah access kar sakte ho:

@property
def name(self):
    return f"{self.fname} {self.lname}"

Ab e.name likhne par yeh method call hoga aur "fname lname" return karega. Lekin yeh method jaisa nahi lagta - attribute jaisa lagta hai.

Aur @name.setter se aap is property ko set kar sakte ho:

@name.setter
def name(self, value):
    self.fname = value.split(" ")[0]
    self.lname = value.split(" ")[1]

Ab e.name = "Harry Khan" likhne par value split hogi aur fname = "Harry", lname = "Khan" set ho jayenge.

Operator overloading aur property decorators - yeh dono features Python ko elegant aur powerful banate hain. Apne classes ko aise design karo ki unke saath kaam karna natural lage!''',
    'codeExamples': [
      {
        'title': 'Operator Overloading - __add__',
        'code': "class Number:\n    def __init__(self, n):\n        self.n = n\n    def __add__(self, num):\n        return self.n + num.n\n\nn = Number(1)\nm = Number(2)\nprint(n + m)",
        'explanation': 'Number class mein __add__ dunder method define kiya gaya hai. Jab hum n + m likhte hain, Python actually n.__add__(m) call karta hai. self.n = 1 aur num.n = 2, isliye 1 + 2 = 3 return hota hai.',
        'output': '3',
      },
      {
        'title': '@property and @name.setter',
        'code': "class Employee:\n    a = 1\n\n    @property\n    def name(self):\n        return f\"{self.fname} {self.lname}\"\n\n    @name.setter\n    def name(self, value):\n        self.fname = value.split(\" \")[0]\n        self.lname = value.split(\" \")[1]\n\ne = Employee()\ne.name = \"Harry Khan\"\nprint(e.fname, e.lname)",
        'explanation': '@property ne name() method ko attribute bana diya. e.name = "Harry Khan" set karne par @name.setter call hota hai jo space par split karke fname aur lname set karta hai. @property getter hai, @name.setter setter hai.',
        'output': 'Harry Khan',
      },
    ],
    'challenges': [
      {
        'question': 'Ek Complex class banao jo complex numbers represent kare (real r aur imaginary i parts). __add__ implement karo jo do complex numbers ko jode (r1+r2, i1+i2). __mul__ implement karo (real = r1*r2 - i1*i2, imag = r1*i2 + i1*r2). __str__ implement karo jo "r + i i" format mein print kare.',
        'hint': '__add__ mein return Complex(self.r + c2.r, self.i + c2.i). __mul__ mein real = self.r*c2.r - self.i*c2.i, imag = self.r*c2.i + self.i*c2.r. __str__ mein f"{self.r} + {self.i}i" return karo.',
        'solution': "class Complex:\n    def __init__(self, r, i):\n        self.r = r\n        self.i = i\n    def __add__(self, c2):\n        return Complex(self.r + c2.r, self.i + c2.i)\n    def __mul__(self, c2):\n        real = self.r * c2.r - self.i * c2.i\n        imag = self.r * c2.i + self.i * c2.r\n        return Complex(real, imag)\n    def __str__(self):\n        return f\"{self.r} + {self.i}i\"\n\nc1 = Complex(1, 2)\nc2 = Complex(3, 4)\nprint(c1 + c2)\nprint(c1 * c2)",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek Vector class banao jo x, y, z coordinates le. __add__ se component-wise addition karo, __mul__ se dot product karo, __sub__ se component-wise subtraction karo. __str__ se "Vector(x, y, z)" format mein print karo. v1(1,2,3) aur v2(4,5,6) ke saath sab operations test karo.',
        'hint': '__sub__ implement karne ke liye Vector(self.x - other.x, self.y - other.y, self.z - other.z) return karo. Baaki same as previous Vector class. Teeno operations ko ek saath test karo.',
        'solution': "class Vector:\n    def __init__(self, x, y, z):\n        self.x = x\n        self.y = y\n        self.z = z\n    def __add__(self, other):\n        return Vector(self.x + other.x, self.y + other.y, self.z + other.z)\n    def __sub__(self, other):\n        return Vector(self.x - other.x, self.y - other.y, self.z - other.z)\n    def __mul__(self, other):\n        return self.x * other.x + self.y * other.y + self.z * other.z\n    def __str__(self):\n        return f\"Vector({self.x}, {self.y}, {self.z})\"\n\nv1 = Vector(1, 2, 3)\nv2 = Vector(4, 5, 6)\nprint(v1 + v2)\nprint(v1 - v2)\nprint(v1 * v2)",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek class Employee banao jisme name, salary ho. __add__ ko overload karo taake do employees ki salary add ho aur ek naya Employee return ho jiska naam "Combined" ho. __lt__ (less than) overload karo salary compare karne ke liye. @property totalSalary banao jo salary + bonus return kare. @totalSalary.setter banao jo bonus adjust kare.',
        'hint': '__add__ mein return Employee("Combined", self.salary + other.salary). __lt__ mein return self.salary < other.salary. @property totalSalary mein return self.salary + self.bonus. Setter mein self.bonus = value - self.salary.',
        'solution': "class Employee:\n    def __init__(self, name, salary):\n        self.name = name\n        self.salary = salary\n        self.bonus = 0\n    def __add__(self, other):\n        return Employee(\"Combined\", self.salary + other.salary)\n    def __lt__(self, other):\n        return self.salary < other.salary\n    @property\n    def totalSalary(self):\n        return self.salary + self.bonus\n    @totalSalary.setter\n    def totalSalary(self, value):\n        self.bonus = value - self.salary\n    def __str__(self):\n        return f\"Employee({self.name}, {self.salary})\"\n\ne1 = Employee(\"Harry\", 50000)\ne2 = Employee(\"Rohan\", 60000)\nprint(e1 + e2)\nprint(e1 < e2)\ne1.totalSalary = 55000\nprint(e1.bonus)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'def __add__(self, other):', 'example': 'def __add__(self, num): return self.n + num.n', 'description': '+ operator overload karta hai - a + b call karta hai a.__add__(b)'},
      {'syntax': '@property\ndef method(self):', 'example': '@property\ndef name(self): return self.fname', 'description': 'Method ko attribute ki tarah access karne deta hai - e.name se call hota hai'},
      {'syntax': '@name.setter\ndef method(self, value):', 'example': '@name.setter\ndef name(self, value): self.fname = value', 'description': 'Property set karne ke liye - e.name = value call karta hai'},
      {'syntax': 'def __str__(self):', 'example': 'def __str__(self): return f"{self.r} + {self.i}i"', 'description': 'Object ko string mein convert karta hai - print() aur str() use karte hain'},
    ],
    'commonMistakes': [
      'Dunder method ka naam galat likhna - __add__ nahi __ad__ ya __sum__ - Python specific names hi recognize karta hai',
      '__str__ define na karna - phir print(object) se <__main__.Object at 0x...> type ka output aata hai jo helpful nahi',
      '@property aur @name.setter ka naam match na karna - setter ka naam exactly getter jaisa hona chahiye with @property_name.setter',
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
