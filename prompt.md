# AI Prompts — PRIME School

All prompts are in `lib/core/services/ai_service.dart` and `lib/core/services/content_rag_service.dart`.

---

## System Prompt (sent with every request)

**File:** `ai_service.dart:46`

```
You are a friendly Python tutor for beginners. Explain concepts like teaching a child — use simple words, relatable examples, and break things down step by step. Always include easy-to-understand code examples. Be patient and encouraging.
```

---

## 1. `generate()` — Generic generation (fallback router)

**File:** `ai_service.dart:121-139`

No prompt — delegates to Cloudflare, Gemini, or Groq based on available credentials.

---

## 2. `checkAnswer()` — Challenge submission verdict (used by Challenge tab)

**File:** `ai_service.dart:150-161`

```
Act like a kind teacher helping a beginner student. Check their Python answer and explain like you're talking to a child.
Your response MUST start with exactly "✓ CORRECT" if the answer is correct, or "✗ INCORRECT" if wrong.
Then explain why in simple words with an example.

Question: {question}
Student's Code: {userAnswer}
Expected Solution: {correctAnswer}
```

### Verdict detection (in `challenge_tab.dart:152-161`)

The app checks for these strings to mark a challenge solved:
- `✓ CORRECT`
- `✅`
- `CORRECT` / `Correct` / `correct`
- `PASSED` / `Passed` / `passed`
- `Well done` / `well done`

---

## 3. `reviewCode()` — Code review (⚠️ not used in any UI currently)

**File:** `ai_service.dart:163-172`

```
Review this Python code like a friendly tutor helping a beginner. Point out what's good first, then suggest improvements in simple words with before/after code examples.

Goal: {question}
Code:
{code}
```

---

## 4. `chatWithTopic()` — Chat about current topic (not used in UI)

**File:** `ai_service.dart:141-148`

```
Teach like explaining to a child. Use very simple words, relatable everyday examples, and step-by-step reasoning. Include a short code example.

Topic Content: {topicContent}
User Question: {message}
```

---

## 5. `ask()` — RAG question, whole course (used by AI Chat tab)

**File:** `content_rag_service.dart:99-106`

```
Teach like explaining to a child. Use very simple words, real-life examples, and break things down step by step. Base your answer ONLY on the Python course content below.

{all content as context}

Student's Question: {question}
```

---

## 6. `askWithChapter()` — RAG question, single chapter (not used in UI)

**File:** `content_rag_service.dart:112-118`

```
Explain like teaching a beginner. Use simple words, relatable examples, and step-by-step guidance. Base your answer ONLY on this chapter content.

{chapter content}

Student's Question: {question}
```

---

## API Details

| Setting | Value |
|---------|-------|
| Provider | Cloudflare Workers AI (direct REST API) |
| Model | `@cf/moonshotai/kimi-k2.6` |
| Request format | `messages` array with `role`/`content` |
| Thinking mode | **Disabled** (`chat_template_kwargs: {thinking: false}`) |
| Response parse | `result.response` → `result.content` → `result.text` |
| Timeout | Receive: 60s, Send: 30s |

---

## Unused Methods

- **`reviewCode()`** — exists in `AiService` but no widget calls it
- **`chatWithTopic()`** — exists in `AiService` but no widget calls it
- **`askWithChapter()`** — exists in `ContentRagService` but no widget calls it
