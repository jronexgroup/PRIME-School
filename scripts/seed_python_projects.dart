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
        'question': 'Snake Water Gun game ka AI version banao jo user ke previous moves analyze karke predict kare ki user kya choose karega aur us hisaab se apna move set kare. Dictionary use karo frequency count ke liye, Counter nahi.',
        'hint': 'User ke last 3 moves store karo. Dictionary mein frequency count karo: freq = {}. freq[move] = freq.get(move, 0) + 1. Most common move ka counter select karo.',
        'solution': "import random\nhistory = []\nyouDict = {\"s\": 1, \"w\": -1, \"g\": 0}\nreverseDict = {1: \"Snake\", -1: \"Water\", 0: \"Gun\"}\ncounterMove = {1: -1, -1: 0, 0: 1}\n\ndef predict_move(history):\n    if len(history) < 3:\n        return random.choice([-1, 0, 1])\n    freq = {}\n    for m in history[-3:]:\n        freq[m] = freq.get(m, 0) + 1\n    most_common = max(freq, key=freq.get)\n    return counterMove[most_common]\n\nwhile True:\n    youstr = input(\"Enter s/w/g (or q to quit): \")\n    if youstr == \"q\":\n        break\n    you = youDict[youstr]\n    comp = predict_move(history)\n    print(f\"Computer chose {reverseDict[comp]}, You chose {reverseDict[you]}\")\n    history.append(you)\n    if comp == you:\n        print(\"Draw!\")\n    elif (comp - you) == -1 or (comp - you) == 2:\n        print(\"You lose!\")\n    else:\n        print(\"You win!\")",
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
        'question': 'Ek text-based assistant banao jo user ke input ko match kare. Agar user "hello" ya "hi" bole toh "Hi there! How can I help you?" reply kare. Agar "time" bole toh current time bataye using datetime module. Agar "date" bole toh current date bataye. Unknown input ke liye "I did not understand" bole.',
        'hint': 'input() se text lo. .lower() karo. if-elif se match karo. import datetime use karo time aur date ke liye.',
        'solution': "import datetime\n\nwhile True:\n    cmd = input(\"You: \").lower()\n    if cmd in [\"hello\", \"hi\"]:\n        print(\"Jarvis: Hi there! How can I help you?\")\n    elif cmd == \"time\":\n        now = datetime.datetime.now().strftime(\"%H:%M\")\n        print(f\"Jarvis: Current time is {now}\")\n    elif cmd == \"date\":\n        today = datetime.datetime.now().strftime(\"%d/%m/%Y\")\n        print(f\"Jarvis: Today's date is {today}\")\n    elif cmd == \"quit\":\n        print(\"Jarvis: Goodbye!\")\n        break\n    else:\n        print(\"Jarvis: I did not understand\")",
        'difficulty': 'easy',
      },
      {
        'question': 'Assistant mein todo list feature add karo. User "add task Buy milk" kahe toh "Buy milk" list mein add ho. "show tasks" kahe toh enumerate se numbered list dikhe. "delete 2" kahe toh task number 2 delete ho. "clear" kahe toh saari tasks clear ho.',
        'hint': 'tasks = [] list rakho. split() se command parse karo. add task ke liye tasks.append(). show ke liye enumerate. delete ke liye pop(index-1).',
        'solution': "tasks = []\n\nwhile True:\n    cmd = input(\"You: \").strip()\n    if cmd.startswith(\"add task\"):\n        task = cmd[9:].strip()\n        tasks.append(task)\n        print(f\"Jarvis: Added '{task}'\")\n    elif cmd == \"show tasks\":\n        if not tasks:\n            print(\"Jarvis: No tasks in list\")\n        else:\n            for i, t in enumerate(tasks, 1):\n                print(f\"{i}. {t}\")\n    elif cmd.startswith(\"delete\"):\n        idx = int(cmd.split()[1]) - 1\n        removed = tasks.pop(idx)\n        print(f\"Jarvis: Removed '{removed}'\")\n    elif cmd == \"clear\":\n        tasks.clear()\n        print(\"Jarvis: All tasks cleared\")\n    elif cmd == \"quit\":\n        break\n    else:\n        print(\"Jarvis: Unknown command\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Complete note-taking assistant banao jo: (1) Notes ko file mein save kare using with open(), (2) "save note" se naya note add kare with timestamp, (3) "show notes" se saare notes print kare, (4) "search keyword" se notes search kare using str.find(), (5) "delete last" se last note delete kare.',
        'hint': 'Notes ko list mein store karo. File save karne ke liye with open(\"notes.txt\", \"w\") use karo. Load karne ke liye with open(\"notes.txt\", \"r\"). Timestamp ke liye datetime module.',
        'solution': "import datetime\n\ndef load_notes():\n    try:\n        with open(\"notes.txt\", \"r\") as f:\n            return [line.strip() for line in f.readlines() if line.strip()]\n    except FileNotFoundError:\n        return []\n\ndef save_notes(notes):\n    with open(\"notes.txt\", \"w\") as f:\n        for note in notes:\n            f.write(note + \"\\n\")\n\nnotes = load_notes()\n\nwhile True:\n    cmd = input(\"You: \").strip()\n    if cmd == \"save note\":\n        note_text = input(\"Enter note: \")\n        ts = datetime.datetime.now().strftime(\"%d/%m/%Y %H:%M\")\n        notes.append(f\"[{ts}] {note_text}\")\n        save_notes(notes)\n        print(\"Jarvis: Note saved!\")\n    elif cmd == \"show notes\":\n        if not notes:\n            print(\"Jarvis: No notes saved\")\n        else:\n            for i, n in enumerate(notes, 1):\n                print(f\"{i}. {n}\")\n    elif cmd.startswith(\"search\"):\n        keyword = cmd[7:].strip()\n        found = [n for n in notes if n.lower().find(keyword.lower()) != -1]\n        if found:\n            for n in found:\n                print(f\"  - {n}\")\n        else:\n            print(\"Jarvis: No matching notes\")\n    elif cmd == \"delete last\":\n        if notes:\n            removed = notes.pop()\n            save_notes(notes)\n            print(f\"Jarvis: Deleted: {removed[:30]}...\")\n        else:\n            print(\"Jarvis: No notes to delete\")\n    elif cmd == \"quit\":\n        print(\"Jarvis: Goodbye!\")\n        break",
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
        'question': 'Ek file watcher banao jo "messages.txt" file ko monitor kare. Jab bhi file mein naya text add ho (line count badhe), naye lines ko read kare aur "Auto-reply: Thanks for your message!" print kare.',
        'hint': 'Ek loop mein file read karke line count check karo. Agar line count increase hua hai, naye lines identify karo aur reply print karo.',
        'solution': "with open(\"messages.txt\", \"r\") as f:\n    last_count = len(f.readlines())\n\nwhile True:\n    with open(\"messages.txt\", \"r\") as f:\n        lines = f.readlines()\n        current_count = len(lines)\n    if current_count > last_count:\n        for i in range(last_count, current_count):\n            print(f\"New message: {lines[i].strip()}\")\n            print(\"Auto-reply: Thanks for your message!\")\n        last_count = current_count",
        'difficulty': 'easy',
      },
      {
        'question': 'Ek command-line chatbot banao jo mood detect kare. Positive words (good, happy, great, amazing, love) ke liye "Glad you are feeling great!" reply kare. Negative words (bad, sad, angry, upset, hate) ke liye "Sorry to hear that. I am here for you." reply kare. Neutral ke liye "I see. Tell me more!" reply kare.',
        'hint': 'input() lo, .lower() aur .split() karo. Positive words ki list banao aur check karo using any word in sentence. Negative words ke liye alag list.',
        'solution': "positive = [\"good\", \"happy\", \"great\", \"amazing\", \"love\", \"wonderful\"]\nnegative = [\"bad\", \"sad\", \"angry\", \"upset\", \"hate\", \"terrible\"]\n\nprint(\"Chatbot: Hi! How are you feeling today?\")\nwhile True:\n    msg = input(\"You: \").lower().split()\n    is_positive = any(w in positive for w in msg)\n    is_negative = any(w in negative for w in msg)\n\n    if \"quit\" in msg:\n        print(\"Chatbot: Goodbye!\")\n        break\n    elif is_positive and not is_negative:\n        print(\"Chatbot: Glad you are feeling great!\")\n    elif is_negative:\n        print(\"Chatbot: Sorry to hear that. I am here for you.\")\n    else:\n        print(\"Chatbot: I see. Tell me more!\")",
        'difficulty': 'medium',
      },
      {
        'question': 'Ek contact management system banao jo: (1) Contacts ko file mein save/load kare using with open(), (2) "add" se naya contact (name, phone) add kare using split() for parsing, (3) "search name" se contact find kare using str.find(), (4) "list" se saare contacts dikhaye using enumerate(), (5) "delete number" se contact delete kare.',
        'hint': 'Contacts file mein "name,phone" format mein store karo. Load karte waqt split(",") use karo. Search mein contact[0].find(keyword) != -1 check karo.',
        'solution': "def load_contacts():\n    try:\n        with open(\"contacts.txt\", \"r\") as f:\n            return [line.strip() for line in f.readlines()]\n    except FileNotFoundError:\n        return []\n\ndef save_contacts(contacts):\n    with open(\"contacts.txt\", \"w\") as f:\n        for c in contacts:\n            f.write(c + \"\\n\")\n\ncontacts = load_contacts()\n\nwhile True:\n    cmd = input(\"Enter command (add/search/list/delete/quit): \").strip()\n    if cmd == \"add\":\n        name = input(\"Name: \")\n        phone = input(\"Phone: \")\n        contacts.append(f\"{name},{phone}\")\n        save_contacts(contacts)\n        print(\"Contact added!\")\n    elif cmd.startswith(\"search\"):\n        keyword = cmd[7:].strip()\n        found = [c for c in contacts if c.lower().find(keyword.lower()) != -1]\n        if found:\n            for c in found:\n                name, phone = c.split(\",\")\n                print(f\"  {name} - {phone}\")\n        else:\n            print(\"No matching contacts\")\n    elif cmd == \"list\":\n        for i, c in enumerate(contacts, 1):\n            name, phone = c.split(\",\")\n            print(f\"{i}. {name} - {phone}\")\n    elif cmd.startswith(\"delete\"):\n        idx = int(cmd.split()[1]) - 1\n        removed = contacts.pop(idx)\n        save_contacts(contacts)\n        print(f\"Deleted: {removed.split(',')[0]}\")\n    elif cmd == \"quit\":\n        break\n    else:\n        print(\"Unknown command\")",
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
