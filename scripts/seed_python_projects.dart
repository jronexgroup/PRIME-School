// Run: dart run scripts/seed_python_projects.dart
// Seeds Python Projects (4 projects) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Python Projects...\n');

  // Projects chapter metadata
  await patchDoc('content/python/chapters/projects', {
    'id': 'projects',
    'subjectId': 'python',
    'name': 'Projects',
    'order': 14,
    'totalTopics': 4,
  });

  // Roadmap entries
  final roadmapTopics = [
    {'topicId': 'project_1', 'chapterId': 'projects', 'name': 'Snake Water Gun Game', 'order': 50},
    {'topicId': 'project_2', 'chapterId': 'projects', 'name': 'Guess The Number', 'order': 51},
    {'topicId': 'project_3', 'chapterId': 'projects', 'name': 'Mega Project 1: Jarvis AI Assistant', 'order': 52},
    {'topicId': 'project_4', 'chapterId': 'projects', 'name': 'Mega Project 2: AI AutoReply Bot', 'order': 53},
  ];
  for (final r in roadmapTopics) {
    await patchDoc('content/python/roadmap/${r['topicId']}', r);
  }

  // Projects
  final topics = [project1(), project2(), project3(), project4()];
  for (final t in topics) {
    await patchDoc('content/python/chapters/projects/topics/${t['id']}', t);
  }

  print('\nDone! Python Projects seeded successfully.');
}

Map<String, dynamic> project1() {
  return {
    'id': 'project_1',
    'name': 'Snake Water Gun Game',
    'chapterId': 'projects',
    'subjectId': 'python',
    'order': 50,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=21322',
    'keyPoints': [
      'Snake Water Gun ek classic game hai — Snake beats Water, Water beats Gun, Gun beats Snake',
      'Computer randomly choose karta hai -1, 0, 1 mein se using random.choice()',
      'User input leta hai "s" for Snake, "w" for Water, "g" for Gun',
      'Dictionary use karte hain mapping ke liye: {"s": 1, "w": -1, "g": 0}',
      'Game logic if-else conditions se implement hoti hai',
      'Shortened version mein mathematical formula use hota hai: (computer - you)',
      'Draw condition tab hoti hai jab computer aur user ka choice same ho',
      'Yeh project Chapter 1-7 ke concepts cover karta hai',
    ],
    'keyConcepts': [
      'random.choice()',
      'Dictionary for mapping',
      'Nested if-else logic',
      'Mathematical game logic',
      'User input handling',
    ],
    'aiCoachScript': '''Chalo doston, ab banate hain mazedar Snake Water Gun game!

Yeh game bahut simple hai. Teen choices hain: Snake, Water, aur Gun. Rules hain:
- Snake Water ko haarata hai (Snake drinks water)
- Water Gun ko haarata hai (Water rusts Gun)
- Gun Snake ko haarata hai (Gun kills Snake)

Computer randomly select karega teen options mein se. User se input lenge "s", "w", ya "g" ke roop mein. Dictionary use karenge mapping ke liye.

Main logic:
- Agar computer aur user ka choice same hai -> Draw
- Warna, specific combinations check karo using if-else

Main wala version saari possible combinations check karta hai specific conditions se. Shortened version mein mathematical trick hai: (computer - you) ki value check karte hain. Agar value -1 ya 2 hai toh user lose karta hai, otherwise win.

Yeh project sab kuch ek saath laata hai:
- Variables aur data types
- Dictionary (mapping ke liye)
- if-else conditionals
- input() function
- random module

Game khelo aur mazza karo!''',
    'codeExamples': [
      {
        'title': 'Full Snake Water Gun Game',
        'code': "import random\n'''\n1 for snake\n-1 for water\n0 for gun\n'''\ncomputer = random.choice([-1, 0, 1])\nyoustr = input(\"Enter your choice (s/w/g): \")\nyouDict = {\"s\": 1, \"w\": -1, \"g\": 0}\nreverseDict = {1: \"Snake\", -1: \"Water\", 0: \"Gun\"}\n\nyou = youDict[youstr]\nprint(f\"You chose {reverseDict[you]}\\nComputer chose {reverseDict[computer]}\")\n\nif(computer == you):\n    print(\"Its a draw\")\nelse:\n    if(computer == -1 and you == 1):\n        print(\"You win!\")\n    elif(computer == -1 and you == 0):\n        print(\"You Lose!\")\n    elif(computer == 1 and you == -1):\n        print(\"You lose!\")\n    elif(computer == 1 and you == 0):\n        print(\"You Win!\")\n    elif(computer == 0 and you == -1):\n        print(\"You Win!\")\n    elif(computer == 0 and you == 1):\n        print(\"You Lose!\")",
        'explanation': 'random.choice() teen numbers mein se ek select karta hai. User se input leta hai, dictionary se map karta hai. Phir if-else conditions check karti hain ki kaun jeeta.',
        'output': 'Enter your choice (s/w/g): s\nYou chose Snake\nComputer chose Water\nYou win!',
      },
      {
        'title': 'Shortened Version with Math Logic',
        'code': "import random\ncomputer = random.choice([-1, 0, 1])\nyoustr = input(\"Enter your choice: \")\nyouDict = {\"s\": 1, \"w\": -1, \"g\": 0}\nreverseDict = {1: \"Snake\", -1: \"Water\", 0: \"Gun\"}\nyou = youDict[youstr]\n\nprint(f\"You chose {reverseDict[you]}\\nComputer chose {reverseDict[computer]}\")\n\nif(computer == you):\n    print(\"Its a draw\")\nelif((computer - you) == -1 or (computer - you) == 2):\n    print(\"You lose!\")\nelse:\n    print(\"You win!\")",
        'explanation': 'Mathematical approach: (computer - you) ki value check karte hain. -1 ya 2 hai toh lose, otherwise win. Bahut shorter aur cleaner code!',
        'output': 'Enter your choice: g\nYou chose Gun\nComputer chose Snake\nYou lose!',
      },
    ],
    'challenges': [
      {
        'question': 'Basic Snake Water Gun game banao jisme computer random choice lega aur user se input lega.',
        'hint': 'random.choice() use karo. Dictionary mapping banavo. if-else se winner decide karo.',
        'solution': "import random\nchoices = [\"snake\", \"water\", \"gun\"]\ncomputer = random.choice(choices)\nuser = input(\"Enter snake/water/gun: \")\nprint(f\"Computer chose: {computer}\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Snake Water Gun game mein score tracking add karo. 5 rounds khelo aur final winner declare karo.',
        'hint': 'Loop 5 times. Har round mein winner ko point do. Final scores compare karo.',
        'solution': "import random\nuser_score = 0\ncomp_score = 0\nfor i in range(5):\n    # game logic here\n    # update scores\nprint(f\"Final: User {user_score} - Computer {comp_score}\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Snake Water Gun game ka AI version banao jo user ke previous moves analyze karke predict kare ki user kya choose karega aur us hisaab se apna move set kare.',
        'hint': 'User ke last 3 moves store karo. Frequency analysis karo ki user most commonly kya choose karta hai. Us frequency ke hisaab se counter move choose karo.',
        'solution': "import random\nhistory = []\n\ndef predict_move(history):\n    if len(history) < 3:\n        return random.choice([-1, 0, 1])\n    # analyze frequency\n    from collections import Counter\n    freq = Counter(history[-3:])\n    most_common = freq.most_common(1)[0][0]\n    # counter that move\n    return {1: -1, -1: 0, 0: 1}[most_common]",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'random.choice(list)', 'example': 'random.choice([-1, 0, 1])', 'description': 'List mein se random element select karta hai'},
      {'syntax': 'dict[key]', 'example': 'youDict["s"]', 'description': 'Dictionary se key ki value nikalta hai'},
      {'syntax': 'f-string with dict', 'example': 'f"You chose {reverseDict[you]}"', 'description': 'Dictionary value ke saath f-string formatting'},
    ],
    'commonMistakes': [
      'User invalid input de toh error aayega — input validation nahi ki toh program crash',
      'Mapping galat banana — "s" ko 1 dena instead of snake. Consistency important hai',
      'Math logic mein galati — (computer - you) ke signs check karna bhool jana',
    ],
  };
}

Map<String, dynamic> project2() {
  return {
    'id': 'project_2',
    'name': 'Guess The Number',
    'chapterId': 'projects',
    'subjectId': 'python',
    'order': 51,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=29330',
    'keyPoints': [
      'Computer randomly choose karta hai 1 se 100 ke beech ek number using random.randint()',
      'User guess karta hai, aur program batata hai ki number higher hai ya lower',
      'Guesses count karte hain taake pata chal sake kitni attempts mein guess kiya',
      'while loop tab tak chalta hai jab tak user sahi guess na kar le',
      'Hints: "Higher number please" (guess chota hai) aur "Lower number please" (guess bada hai)',
      'Best score (minimum guesses) track kiya ja sakta hai using file I/O',
      'Yeh project loops, conditionals, aur random module ka perfect use case hai',
    ],
    'keyConcepts': [
      'random.randint()',
      'while loop with condition',
      'Guess counter',
      'Higher/Lower hints',
      'Best score tracking',
    ],
    'aiCoachScript': '''Chalo ab banate hain Guess The Number game!

Yeh bahut popular game hai. Computer randomly select karega ek number 1 se 100 ke beech. Aap guess karoge. Agar aapka guess zyada hai toh computer kahega "Lower number please". Agar kam hai toh "Higher number please". Jab tak aap sahi number nahi guess kar lete, game chalta rahega.

random.randint(1, 100) use karo — yeh 1 aur 100 ke beech random integer generate karega.

While loop use karo. Jab tak aapka guess (a) original number (n) ke equal nahi ho jata, tab tak loop chalta rahe.

Har guess ke saath attempts count karo. Jab aap sahi guess kar lo, display karo: "You have guessed the number X correctly in Y attempts".

Chaho toh hiscore bhi track kar sakte ho using file I/O — previous best score file mein save karo, aur har baar check karo ki aapne record toda ya nahi.

Simple hai na? Chalo code karo!''',
    'codeExamples': [
      {
        'title': 'Basic Guess The Number',
        'code': "import random\nn = random.randint(1, 100)\na = -1\nguesses = 1\n\nwhile(a != n):\n    a = int(input(\"Guess the number: \"))\n    if(a > n):\n        print(\"Lower number please\")\n        guesses += 1\n    elif(a < n):\n        print(\"Higher number Please\")\n        guesses += 1\n\nprint(f\"You have guessed the number {n} correctly in {guesses} attempts\")",
        'explanation': 'random.randint(1,100) 1-100 ke beech random number generate karta hai. while loop tab tak chalta hai jab tak guess sahi na ho. Har incorrect guess par hint milta hai aur guess counter increment hota hai.',
        'output': 'Guess the number: 50\nLower number please\nGuess the number: 25\nHigher number Please\nGuess the number: 37\nYou have guessed the number 37 correctly in 3 attempts',
      },
      {
        'title': 'With Hiscore Tracking',
        'code': "import random\n\ndef game():\n    n = random.randint(1, 100)\n    a = -1\n    guesses = 1\n    \n    with open(\"hiscore.txt\", \"r\") as f:\n        hiscore = int(f.read()) if f.read() else 0\n    \n    while(a != n):\n        a = int(input(\"Guess: \"))\n        if(a > n):\n            print(\"Lower please\")\n            guesses += 1\n        elif(a < n):\n            print(\"Higher please\")\n            guesses += 1\n    \n    if guesses < hiscore or hiscore == 0:\n        with open(\"hiscore.txt\", \"w\") as f:\n            f.write(str(guesses))\n        print(f\"New high score! {guesses} attempts!\")\n    return guesses",
        'explanation': 'File I/O use karke best score track karte hain. hiscore.txt mein minimum attempts save hote hain. Agar current game mein attempts kam hain toh naya record set hota hai.',
        'output': 'Guess: 50\nLower please\nGuess: 25\nNew high score! 2 attempts!',
      },
    ],
    'challenges': [
      {
        'question': 'Basic Guess The Number game banao jisme 1-100 ke beech random number guess karna ho.',
        'hint': 'random.randint() use karo. while loop mein user input lo, higher/lower hint do.',
        'solution': "import random\nn = random.randint(1, 100)\nguess = -1\nwhile guess != n:\n    guess = int(input(\"Guess: \"))\n    if guess > n: print(\"Lower\")\n    elif guess < n: print(\"Higher\")\nprint(\"Correct!\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Game mein difficulty levels add karo: Easy (1-50), Medium (1-100), Hard (1-500). User pehle difficulty select kare.',
        'hint': 'Dictionary use karo mapping ke liye. random.randint(1, max_value) mein max_value difficulty ke hisaab se change karo.',
        'solution': "import random\ndiff = input(\"Choose difficulty (easy/medium/hard): \")\nlimits = {\"easy\": 50, \"medium\": 100, \"hard\": 500}\nn = random.randint(1, limits[diff])\n# rest of game logic",
        'difficulty': 'medium',
      },
      {
        'question': 'Multiplayer version banao jisme 2 players alternate turns lete hain. Har player apne guess karta hai. Jo pehle sahi guess kare, woh jeetta hai. Har player ke attempts count karo.',
        'hint': 'while loop mein player turn variable rakho (0 ya 1). Har iteration mein player switch karo. Jab koi sahi guess kare, loop break karo aur winner declare karo.',
        'solution': "import random\nn = random.randint(1, 100)\nplayer = 1\nwhile True:\n    guess = int(input(f\"Player {player}, guess: \"))\n    if guess == n:\n        print(f\"Player {player} wins!\")\n        break\n    elif guess > n: print(\"Lower\")\n    else: print(\"Higher\")\n    player = 2 if player == 1 else 1",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'random.randint(a, b)', 'example': 'random.randint(1, 100)', 'description': 'a aur b ke beech random integer generate karta hai'},
      {'syntax': 'while condition:', 'example': 'while(a != n):', 'description': 'Loop tab tak chalta hai jab tak condition True hai'},
      {'syntax': 'int(input())', 'example': 'int(input("Guess: "))', 'description': 'User input lete hain aur integer mein convert karte hain'},
      {'syntax': 'with open() as f:', 'example': 'with open("hiscore.txt", "w") as f:', 'description': 'File safely open aur close karta hai'},
    ],
    'commonMistakes': [
      'input() ko int() mein convert karna bhoolna — string se comparison fail hoga',
      'Infinite loop — agar guess kabhi sahi nahi hoga toh loop kabhi nahi rukega',
      'Guesses counter ko update karna bhoolna — hamesha 1 dikhega',
    ],
  };
}

Map<String, dynamic> project3() {
  return {
    'id': 'project_3',
    'name': 'Mega Project 1: Jarvis AI Assistant',
    'chapterId': 'projects',
    'subjectId': 'python',
    'order': 52,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=34223',
    'keyPoints': [
      'Jarvis ek AI voice assistant hai jo speech recognition se user commands sunta hai',
      'speech_recognition module se microphone input capture hota hai',
      'Wake word "Jarvis" ko recognize karta hai using listen() loop',
      'OpenAI GPT API se conversational responses generate karta hai',
      'GTTS (Google Text-to-Speech) se voice output produce hota hai',
      'Virtual environment mein project banaya jaata hai dependencies isolate karne ke liye',
      'Playsound ya pygame se audio output play hota hai',
      'pip install speechrecognition pyttsx3 pyaudio gtts playsound OpenAI',
    ],
    'keyConcepts': [
      'Speech Recognition',
      'Wake Word Detection',
      'OpenAI API',
      'Text-to-Speech (GTTS)',
      'Voice Assistant Architecture',
    ],
    'aiCoachScript': '''Mega Project 1 -- Jarvis AI Assistant!

Yeh project mere dil ke bahut kareeb hai. Jarvis ek voice assistant hai jo aapki baat sunega, samjhega, aur jawab dega.

Sabse pehle virtual environment banao. Phir pip install karo: speechrecognition, pyaudio, gtts, playsound, openai.

Architecture:
1. MICROPHONE SE SUNO -- speech_recognition module use karo
2. WAKE WORD DETECT -- continuous loop mein sunte raho, jab "Jarvis" sunai de, tab action lo
3. PROCESS -- OpenAI API ko bhejo, response lo
4. BOLO -- GTTS se audio banao aur play karo

Speech recognition ka basic code:
import speech_recognition as sr
r = sr.Recognizer()
with sr.Microphone() as source:
    audio = r.listen(source)
    text = r.recognize_google(audio)

Yeh real-world project hai jo AI aur Python ko combine karta hai. Isko improve karte raho -- apne features add karo, nayi functionality integrate karo.

Yeh aapke PRIME voice assistant mein bhi integrate ho sakta hai!''',
    'codeExamples': [
      {
        'title': 'Speech Recognition Basic',
        'code': "import speech_recognition as sr\n\nr = sr.Recognizer()\n\nwith sr.Microphone() as source:\n    print(\"Adjusting for ambient noise...\")\n    r.adjust_for_ambient_noise(source)\n    print(\"Say something!\")\n    audio = r.listen(source)\n\ntry:\n    text = r.recognize_google(audio)\n    print(f\"You said: {text}\")\nexcept sr.UnknownValueError:\n    print(\"Could not understand\")\nexcept sr.RequestError:\n    print(\"API unavailable\")",
        'explanation': 'sr.Recognizer() object banate hain. Microphone se audio capture karte hain. Google Speech API text mein convert karti hai. Error handling important hai - agar audio clear nahi hai toh exception aata hai.',
        'output': 'Adjusting for ambient noise...\nSay something!\nYou said: Hello Jarvis',
      },
      {
        'title': 'Wake Word Detection Loop',
        'code': "import speech_recognition as sr\n\nr = sr.Recognizer()\n\ndef listen_for_wake_word():\n    with sr.Microphone() as source:\n        audio = r.listen(source)\n        try:\n            text = r.recognize_google(audio).lower()\n            if \"jarvis\" in text:\n                print(\"Wake word detected!\")\n                return True\n        except:\n            pass\n    return False\n\nwhile True:\n    if listen_for_wake_word():\n        print(\"How can I help you?\")",
        'explanation': 'Continuous loop mein microphone sunta rehta hai. Jaise hi "Jarvis" word detect hota hai, wake word trigger hota hai. Lower() use karte hain taake case-insensitive comparison ho.',
        'output': '(Listening...)\n(Jarvis detected!)\nHow can I help you?',
      },
    ],
    'challenges': [
      {
        'question': 'Simple voice assistant banao jo "hello" bolne par "Hi there!" reply kare.',
        'hint': 'speech_recognition se input lo. GTTS se output banao. Play karo.',
        'solution': "import speech_recognition as sr\nfrom gtts import gTTS\nimport playsound\n\nr = sr.Recognizer()\nwith sr.Microphone() as source:\n    audio = r.listen(source)\n    text = r.recognize_google(audio)\n\nif \"hello\" in text.lower():\n    tts = gTTS(\"Hi there!\")\n    tts.save(\"hello.mp3\")\n    playsound.playsound(\"hello.mp3\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Jarvis mein weather checking feature add karo. User "what is the weather" bole toh API se weather data fetch karo aur bolkar sunao.',
        'hint': 'OpenWeatherMap API use karo. requests module se data fetch karo. JSON parse karo. GTTS se output banao.',
        'solution': "import requests\n\ndef get_weather(city):\n    url = f\"https://api.openweathermap.org/data/2.5/weather?q={city}&appid=YOUR_KEY\"\n    data = requests.get(url).json()\n    temp = data['main']['temp'] - 273.15\n    return f\"Temperature is {temp:.1f} degrees\"",
        'difficulty': 'medium',
      },
      {
        'question': 'Complete Jarvis system banao jo command history save kare, user ke preferred apps ya websites yaad rakhe, aur machine learning se user ke behavior pattern seekhe.',
        'hint': 'SQLite database use karo history store karne ke liye. User preferences JSON file mein save karo. Frequency analysis karo ki user konse commands repeat karta hai.',
        'solution': "import json\nimport sqlite3\nfrom collections import Counter\n\nconn = sqlite3.connect('jarvis_history.db')\nc = conn.cursor()\nc.execute('''CREATE TABLE IF NOT EXISTS commands\n             (id INTEGER PRIMARY KEY, command TEXT, timestamp DATETIME)''')\n\n# Save command\nc.execute(\"INSERT INTO commands (command, timestamp) VALUES (?, datetime('now'))\",\n          (user_text,))\nconn.commit()",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'sr.Recognizer()', 'example': 'r = sr.Recognizer()', 'description': 'Speech recognition object banata hai'},
      {'syntax': 'r.listen(source)', 'example': 'audio = r.listen(source)', 'description': 'Microphone se audio capture karta hai'},
      {'syntax': 'r.recognize_google(audio)', 'example': 'text = r.recognize_google(audio)', 'description': 'Audio ko text mein convert karta hai'},
      {'syntax': 'gTTS(text)', 'example': 'tts = gTTS("Hello")', 'description': 'Text ko speech mein convert karta hai'},
    ],
    'commonMistakes': [
      'Microphone permissions nahi dena — program audio capture nahi kar payega',
      'pyaudio installation issues — Windows mein alag steps hote hain',
      'API keys hardcode karna — environment variables use karo security ke liye',
      'Background noise ignore karna — adjust_for_ambient_noise() call karna bhoolna',
    ],
  };
}

Map<String, dynamic> project4() {
  return {
    'id': 'project_4',
    'name': 'Mega Project 2: AI AutoReply Bot',
    'chapterId': 'projects',
    'subjectId': 'python',
    'order': 53,
    'videoUrl': 'https://youtu.be/UrsmFxEIp5k?t=37068',
    'keyPoints': [
      'AI AutoReply Bot WhatsApp ya kisi bhi messaging platform ke liye automated replies bhejta hai',
      'pywhatkit ya selenium use karke web automation hoti hai',
      'OpenAI API ka use karke intelligent replies generate hote hain',
      'Cursor position track karke naye messages detect hote hain',
      'Bot continuously monitor karta hai aur automatically reply karta hai',
      'Scheduling features — specific time par messages bhej sakte hain',
      'Multi-language support possible hai OpenAI ke through',
      'Real-world project hai jo messaging automation mein use hota hai',
    ],
    'keyConcepts': [
      'Web Automation',
      'Message Monitoring',
      'AI Reply Generation',
      'Cursor-based Detection',
      'Scheduled Messaging',
    ],
    'aiCoachScript': '''Mega Project 2 -- AI AutoReply Bot!

Yeh bot hai jo WhatsApp ya kisi bhi platform par automatically replies bhej sakta hai. Real-world project hai.

Kaise kaam karta hai:
1. Web WhatsApp kholo (pywhatkit se)
2. Cursor position track karo taake pata chale ki naya message aaya hai
3. OpenAI API ko bhejo aur AI-generated reply lo
4. Woh reply automatically bhej do

Yeh 3 important files hain is project mein:
- 01_get_cursor.py: Screen par cursor ki position track karta hai
- 02_openai.py: OpenAI API se reply generate karta hai
- 03_bot.py: Dono ko combine karke full bot banata hai

Get cursor ka code simple hai -- mouse position capture karo jab user ka message aaye, woh position track karo, aur jab wahan text change ho toh naya message detect karo.

IMPORTANT: Yeh project complex hai. Lekin agar tune Ch 1-12 acche se padha hai toh tu yeh bana sakta hai. Real AI projects aise hi bante hain -- multiple components combine karke.

Try karo, modify karo, aur apna version banao!''',
    'codeExamples': [
      {
        'title': 'Get Cursor Position',
        'code': "import pyautogui\nimport time\n\nprint(\"Move your mouse to the message area\")\nprint(\"You have 5 seconds...\")\ntime.sleep(5)\n\nx, y = pyautogui.position()\nprint(f\"Cursor position: ({x}, {y})\")\n\n# Save to file\nwith open(\"cursor_pos.txt\", \"w\") as f:\n    f.write(f\"{x},{y}\")",
        'explanation': 'pyautogui mouse position capture karta hai. User ko 5 seconds diye jaate hain cursor move karne ke liye. Position file mein save hoti hai taake bot use kar sake.',
        'output': 'Move your mouse to the message area\nYou have 5 seconds...\nCursor position: (1234, 567)',
      },
      {
        'title': 'OpenAI Reply Generator',
        'code': "from openai import OpenAI\n\nclient = OpenAI(api_key=\"your-api-key\")\n\ndef generate_reply(message):\n    response = client.chat.completions.create(\n        model=\"gpt-3.5-turbo\",\n        messages=[\n            {\"role\": \"system\", \"content\": \"You are a helpful assistant replying to WhatsApp messages. Keep replies short and friendly.\"},\n            {\"role\": \"user\", \"content\": message}\n        ]\n    )\n    return response.choices[0].message.content",
        'explanation': 'OpenAI API ka use karke smart replies generate hote hain. System message set karta hai reply ka tone aur style. Response ka content extract karke return karte hain.',
        'output': 'Generated reply: "Hi! Thanks for your message. I will get back to you shortly."',
      },
    ],
    'challenges': [
      {
        'question': 'Simple auto-reply system banao jo kisi bhi text file ko monitor kare. Jab file change ho (new text add ho), automatically "Thanks for your message!" print karo.',
        'hint': 'File ka last modified time track karo using os.path.getmtime(). Jab change ho toh file read karo aur reply do.',
        'solution': "import os\nimport time\n\nfile_path = \"messages.txt\"\nlast_mtime = os.path.getmtime(file_path)\n\nwhile True:\n    current_mtime = os.path.getmtime(file_path)\n    if current_mtime != last_mtime:\n        print(\"New message detected!\")\n        print(\"Auto-reply: Thanks for your message!\")\n        last_mtime = current_mtime\n    time.sleep(1)",
        'difficulty': 'easy',
      },
      {
        'question': 'Bot mein scheduling feature add karo. Specific time par pre-written message bhejne ka feature. User input lega: message aur time.',
        'hint': 'datetime module use karo current time check karne ke liye. Schedule dictionary mein message aur time store karo. while loop mein check karte raho.',
        'solution': "import datetime\nimport time\n\nschedule = [\n    {\"time\": \"09:00\", \"message\": \"Good morning!\"},\n    {\"time\": \"18:00\", \"message\": \"Good evening!\"},\n]\n\nwhile True:\n    now = datetime.datetime.now().strftime(\"%H:%M\")\n    for item in schedule:\n        if item[\"time\"] == now:\n            print(f\"Sending: {item['message']}\")\n    time.sleep(30)",
        'difficulty': 'medium',
      },
      {
        'question': 'Complete auto-reply bot banao jo: (1) Naye messages detect kare, (2) OpenAI se reply generate kare, (3) Reply ko sentiment analysis kare (positive/negative/neutral), (4) Negative messages ko manually review ke liye flag kare, (5) Sab logs database mein save kare.',
        'hint': 'TextBlob ya vaderSentiment use karo sentiment analysis ke liye. SQLite mein logs store karo. Flagged messages alag collection mein rakho.',
        'solution': "from textblob import TextBlob\nimport sqlite3\n\nconn = sqlite3.connect('bot_logs.db')\n\ndef analyze_sentiment(text):\n    blob = TextBlob(text)\n    polarity = blob.sentiment.polarity\n    if polarity > 0: return \"positive\"\n    elif polarity < 0: return \"negative\"\n    return \"neutral\"\n\ndef log_message(sender, message, reply, sentiment):\n    conn.execute(\"INSERT INTO logs VALUES (?, ?, ?, ?, datetime('now'))\",\n                 (sender, message, reply, sentiment))\n    conn.commit()\n\n# Bot loop mein:\nsentiment = analyze_sentiment(incoming_msg)\nif sentiment == \"negative\":\n    print(\"FLAGGED for manual review\")\nreply = generate_reply(incoming_msg)\nlog_message(sender, incoming_msg, reply, sentiment)",
        'difficulty': 'hard',
      },
    ],
    'importantSyntax': [
      {'syntax': 'pyautogui.position()', 'example': 'x, y = pyautogui.position()', 'description': 'Current mouse cursor position return karta hai'},
      {'syntax': 'OpenAI(api_key=key)', 'example': 'client = OpenAI(api_key=key)', 'description': 'OpenAI API client initialize karta hai'},
      {'syntax': 'client.chat.completions.create()', 'example': 'client.chat.completions.create(model="gpt-3.5-turbo", messages=[...])', 'description': 'AI se response generate karta hai'},
    ],
    'commonMistakes': [
      'API key ko code mein hardcode karna — .env file use karo',
      'Rate limiting ignore karna — OpenAI API calls ke beech delay rakhna',
      'Web automation mein element selectors ka galat use — selectors update hote rehte hain',
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
