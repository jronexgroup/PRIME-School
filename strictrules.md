# PRIME School — Autonomous History Content Pipeline

## Our Workflow (Real)

```
নিচের pipeline exact follow করো।
build script লিখো → gen file generate করো → gen file execute করে seed dart বানাও → score করো → seed dart run করে Firestore এ save করো।
```

---

## Context

- **Project**: `prime_school` Flutter app at `/root/projects/PRIME-School/prime_school`
- **Firestore project**: `prime-school-de654`
- **Scripts dir**: `prime_school/scripts/`
- **API key**: `AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE` (in `gen_common.py`)
- **Pattern file** (copy this style): `scripts/build_ch3_t5.py` / `scripts/build_ch3_t6.py`
- **Benchmark**: Ch1 T1 — exact Firestore fields (20 fields, nested quiz)

---

## Step-by-Step

### Step 1: Read .md source

Input file: `prime_school/history_class9_ch[X]_[Y].md`  
Example: `history_class9_ch3_3_8.md`

### Step 2: Write build script

Write `prime_school/scripts/build_ch3_t{N}.py`

Use `wf()` helpers pattern from `build_ch3_t5.py`.  
Include ALL 20 fields matching Ch1 T1:

```
id                     (str, e.g. 'chapter3_topic_8')
name                   (str, Bengali)
order                  (int)
chapterId              → 'chapter3'
subjectId              → 'history'
summary                (str, Bengali paragraph)
simple_breakdown       (list of str, min 8 items)
sidebar_content        (str, Bengali)
voice_script           (str, 350-450 words Bengali teacher voice)
cause_effect           (list of dict [cause, effect], min 5)
important_personalities (list of dict [name,title,contribution,exam_importance])
important_places       (list of dict [name,description,significance])
key_terms              (list of dict [term,meaning,example], min 7)
timeline               (list of dict [date,event,significance])
flashcards             (list of dict [front,back,type,importance], min 25)
exam_tips              (list of str, exactly 5)
important_highlights   (dict with 4 sub-keys:
    important_names, important_places,
    important_dates, one_liner_facts)
map_description        (str or null)
real_life_example      (str, Bengali, relatable to WB Class 9 student)

quiz (nested dict):
  mcq:                min 40, each: question,options[4],correctIndex,
                      marks:1,explanation,difficulty(easy/medium/hard)
  very_short_1mark:   min 40, each: question,answer,marks:1
  short_2mark:        min 15, each: question,answer,marks:2,key_points[...]
  evaluation_4mark:   min 8,  each: question,answer,marks:4
  explanatory_8mark:  min 5,  each: question,answer,marks:8
```

### Step 3: Generate gen file

```bash
cd /root/projects/PRIME-School/prime_school
python3 scripts/build_ch3_t{N}.py
```
→ Produces `scripts/gen_ch3_t{N}.py`

### Step 4: Inspect quiz structure

- If gen file has flat `quiz_mcq`, `quiz_very_short_1mark`, etc. → restructure to nested `quiz: {mcq: [...], ...}` using a post-process script
- If already nested → skip

### Step 5: Generate seed + score

```bash
cd /root/projects/PRIME-School/prime_school
PYTHONPATH=scripts python3 scripts/gen_ch3_t{N}.py
```
→ Produces `scripts/seed_ch3_t{N}_all.dart`

Check counts match benchmarks above.

### Step 6: Save to Firestore

```bash
cd /root/projects/PRIME-School/prime_school
dart run scripts/seed_ch3_t{N}_all.dart
```

---

## Field Structure (Exact Match Required)

```python
topic = {
    'id': 'chapter3_topic_8',
    'name': '...',
    'order': 8,
    'chapterId': 'chapter3',
    'subjectId': 'history',
    'summary': '...',
    'simple_breakdown': ['...', ...],  # min 8
    'sidebar_content': '...',
    'voice_script': '...',  # 350-450 words
    'cause_effect': [{'cause': '...', 'effect': '...'}, ...],  # min 5
    'important_personalities': [
        {'name': '...', 'title': '...', 'contribution': '...', 'exam_importance': '...'},
    ],
    'important_places': [
        {'name': '...', 'description': '...', 'significance': '...'},
    ],
    'key_terms': [
        {'term': '...', 'meaning': '...', 'example': '...'},  # min 7
    ],
    'timeline': [
        {'date': '...', 'event': '...', 'significance': '...'},
    ],
    'flashcards': [
        {'front': '...', 'back': '...', 'type': 'person|date|place|concept|definition', 'importance': 'high|medium|low'},
    ],  # min 25
    'exam_tips': ['...', '...', '...', '...', '...'],  # exactly 5
    'important_highlights': {
        'important_names': ['...', ...],
        'important_places': ['...', ...],
        'important_dates': [{'date': '...', 'event': '...'}, ...],
        'one_liner_facts': ['...', ...],  # min 5
    },
    'map_description': None,  # or str
    'real_life_example': '...',
    'quiz': {
        'mcq': [...],  # min 40
        'very_short_1mark': [...],  # min 40
        'short_2mark': [...],  # min 15
        'evaluation_4mark': [...],  # min 8
        'explanatory_8mark': [...],  # min 5
    },
}
```

---

## Self Scoring

প্রতিটা topic generate করার পর নিজেই score করো।

### Fixed Rules (Fail = ❌ পুরো topic fail)

| Rule | Check | Min |
|------|-------|-----|
| R1 | Flashcards count | >= 25 |
| R2 | Timeline সব dates present | ✅ |
| R3 | MCQ count | >= 40 |
| R4 | 8-mark count | >= 5 |
| R5 | Voice script words | >= 300 |
| R6 | Key terms | >= 7 |
| R7 | simple_breakdown | >= 8 |
| R8 | cause_effect | >= 5 |
| R9 | Bengali natural ✅ | ✅ |
| R10 | All 20 fields present ✅ | ✅ |

### Quality Score (0-10)

| Q | What | 0 | 10 |
|---|------|---|----|
| Q1 | Bengali naturalness | robotic | teacher voice |
| Q2 | Depth of content | surface | deep understanding |
| Q3 | Exam readiness | wrong pattern | perfect Madhyamik |
| Q4 | MCQ quality | bad distractors | realistic traps |
| Q5 | Voice script warmth | textbook | "প্রিয় ছাত্রছাত্রীরা" feel |

AI Score = (Q1+Q2+Q3+Q4+Q5) / 5

### Decision

All fixed PASS + AI Score >= 7.0 → ✅ PASS → save to Firestore  
Any FAIL or AI < 7.0 → ❌ FAIL → fix and retry (max 3)

### Score Report Format

```
=== SCORE: Ch{N} T{M} ===
R1 Flashcards: {count}/25 → ✅/❌
R2 Timeline: → ✅/❌
R3 MCQ: {count}/40 → ✅/❌
R4 8mark: {count}/5 → ✅/❌
R5 Voice: {words}w/300w → ✅/❌
R6 Key terms: {count}/7 → ✅/❌
R7 Breakdown: {count}/8 → ✅/❌
R8 Cause-effect: {count}/5 → ✅/❌
R9 Bengali: → ✅/❌
R10 Fields: {count}/20 → ✅/❌
Q1 Bengali: {x}/10
Q2 Depth: {x}/10
Q3 Exam: {x}/10
Q4 MCQ: {x}/10
Q5 Voice: {x}/10
AI: {x}/10
RESULT: ✅ PASS / ❌ FAIL
========================
```

---

## Retry

FAIL হলে:
1. Exact reason note করো
2. শুধু সেই part fix করো (পুরো rebuild নয়)
3. Rescore
4. Max 3 retries

3 retries তেও FAIL → mark `⚠️ MANUAL REVIEW NEEDED: Ch{N} T{M}` → next topic এ চলে যাও।

---

## Already Done (Skip)

- Ch1 T1–T5 ✅
- Ch2 T1–T6 ✅
- Ch3 T1–T4 ✅
- Ch3 T5–T7 ✅

---

## Start Point

```
START: Chapter 3, Topic 8
Read: prime_school/history_class9_ch3_3_8.md
```

Goal: Build → Gen → Score → Save → Next topic. Repeat until Ch7 T2 done.
