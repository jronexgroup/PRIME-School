# Manual Dart Seed Pipeline — WB Madhyamik Class 9 History

## Goal
Write all remaining WB Madhyamik Class 9 History topics (Ch3 T7, T9–T11, Ch4–Ch7) at the **Ch1 T2 benchmark** quality level (≥ 9.0 AI score) — using **manually written Dart seed files** (no Python gen scripts), seeded to Firestore.

## Reference Structure (Ch1 T2 Benchmark)
**File:** `scripts/seed_ch1_all.dart` → function `t2()` at line 360

### 20 Required Fields
| # | Field | Format |
|---|-------|--------|
| 1 | `id` | `'chapterN_topic_M'` |
| 2 | `chapterId` | `'chapterN'` |
| 3 | `subjectId` | `'history'` |
| 4 | `name` | Bengali topic title |
| 5 | `order` | integer |
| 6 | `summary` | 200-300w Bengali summary |
| 7 | `voice_script` | 400+ words, starts `প্রিয় ছাত্রছাত্রীরা`, has warmth signals (তোমরা/তোমাদের/আশা করি/মনে রেখো/বুঝতে পার), conversational, `?` for engagement |
| 8 | `simple_breakdown` | array of strings (≥8) |
| 9 | `exam_tips` | array of strings (≥5) |
| 10 | `key_terms` | `{'term', 'meaning', 'example'}` (≥7) |
| 11 | `important_personalities` | `{'name', 'title', 'contribution', 'exam_importance'}` |
| 12 | `important_places` | `{'name', 'description', 'significance'}` |
| 13 | `timeline` | `{'date', 'event', 'significance'}` (≥5) |
| 14 | `flashcards` | `{'front', 'back', 'type', 'importance'}` (≥25) |
| 15 | `cause_effect` | `{'cause', 'effect'}` (≥5) |
| 16 | `important_highlights` | 4 sub-fields (see below) |
| 17 | `map_description` | string or `null` |
| 18 | `sidebar_content` | string |
| 19 | `real_life_example` | string |
| 20 | `quiz` | 6 sub-sections (see below) |

### `important_highlights` sub-fields (all string arrays)
- `must_remember_dates`
- `must_remember_names`
- `must_remember_places`
- `one_liner_facts`

### Quiz Structure
| Sub-section | Count | Format |
|-------------|-------|--------|
| `mcq` | ≥40 | `{'question', 'options': [4], 'correctIndex', 'marks': 1, 'explanation', 'difficulty'}` |
| `very_short_1mark` | ≥40 | `{'question', 'answer', 'marks': 1}` |
| `short_2mark` | ≥15 | `{'question', 'answer', 'marks': 2, 'key_points': []}` |
| `evaluation_4mark` | ≥8 | `{'question', 'answer', 'marks': 4}` |
| `explanatory_8mark` | ≥5 | `{'question', 'answer', 'marks': 8}` |

### MCQ Difficulty Spread
Mix of `easy`, `medium`, `hard` (≥2 difficulty levels represented).

## Pipeline Steps

### Step 1: Read Textbook Content
Read the topic from `class-9-history-full-textbook.md` (search by chapter/topic).

### Step 2: Read Benchmark for Reference
Read `scripts/seed_ch1_all.dart` (function `t2()` at line ~360) to copy the exact field structure.

### Step 3: Write Manual Dart Seed File
Create `scripts/seed_chN_tM.dart` with:
```dart
// Run: dart run scripts/seed_chN_tM.dart
// Seeds ChN TM — <topic name in Bengali>

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl = 'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async { /* ... patchDoc call ... */ }
Future<void> patchDoc(String path, Map<String, dynamic> data) async { /* ... */ }
dynamic _encode(dynamic v) { /* ... */ }
Map<String, dynamic> buildTopic() { /* return 20-field map */ }
```

### Step 4: Create Python Eval Script
Create `scripts/eval_chN_tM.py` that:
- Constructs the same topic dict in Python (mirroring Dart data)
- Calls `score()` from `scripts/score_topic.py`

### Step 5: Run Eval & Fix
```bash
python3 scripts/eval_chN_tM.py
```
Target: **AI ≥ 9.0 + ALL fixed rules PASS**.
If below target: add more MCQs, expand voice, add flashcards, fix missing fields.

### Step 6: Seed to Firestore
```bash
cd prime_school && dart run scripts/seed_chN_tM.dart
```

### Step 7: Known Bug — Patch totalTopics
Individual seed scripts overwrite the chapter doc with `totalTopics: 1`. After ALL topics in a chapter are seeded, run a fix to set correct count.

## Scoring Rules (`scripts/score_topic.py`)

### Fixed Rules (ALL must PASS)
- R1: ≥25 flashcards
- R2: ≥5 timeline entries
- R3: ≥40 MCQ
- R4: ≥5 explanatory_8mark
- R5: ≥300w voice (but aim for ≥400)
- R6: ≥7 key_terms
- R7: ≥8 simple_breakdown entries
- R8: ≥5 cause_effect entries
- R9: voice starts with `প্রিয়`
- R10: all 20 fields present
- STRUCT: `important_places` has `name`/`description`/`significance` keys
- STRUCT: `must_remember_dates` is non-empty string array
- STRUCT: all 4 highlight fields present

### Quality Scores (0-10, averaged to AI)
- **Q1 Bengali naturalness:** warmth signals + voice length
- **Q2 Depth of content:** key_terms, timeline, cause_effect, breakdown, sidebar
- **Q3 Exam readiness:** difficulty spread, VS count, S2 count, E4 count, exam_tips
- **Q4 MCQ quality:** explanations, difficulty spread, quantity
- **Q5 Voice warmth:** warmth signals, length, conversational style

## Current Status

| Chapter | Topics | Status |
|---------|--------|--------|
| Ch1 | T1-T4 | ✅ Seeded (gold benchmark) |
| Ch2 | T1-T5 | ✅ Seeded |
| Ch3 | T1-T8 (except T7), T9-T11 | ✅ T7, T9-T11 seeded manually |
| Ch3 | T1-T8 (original gen) | ⚠️ Need audit vs Ch1 T2 benchmark |
| Ch4 | T1-T3 | ✅ Seeded manually |
| Ch4 | T4-T9 | ❌ Need manual Dart seeds |
| Ch5 | T1-T12 | ❌ Need manual Dart seeds |
| Ch6 | T1-T8 | ❌ Need manual Dart seeds |
| Ch7 | T1-T2 | ❌ Need manual Dart seeds |

## Firestore Path
```
content/history/chapters/chapterN/topics/chapterN_topic_M
```
Project: `prime-school-de654`
