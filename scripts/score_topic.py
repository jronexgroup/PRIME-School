#!/usr/bin/env python3
"""Score a topic against Ch1 T2 benchmark. Usage: python3 eval_<topic>.py"""
import sys

def score(t, name):
    q = t['quiz']
    vs = t['voice_script']
    vw = len(vs.split())
    
    print(f'=== SCORE: {name} ===')
    
    # Fixed Rules
    r1 = len(t['flashcards']) >= 25
    r3 = len(q['mcq']) >= 40
    r4 = len(q['explanatory_8mark']) >= 5
    r5 = vw >= 300
    r6 = len(t['key_terms']) >= 7
    r7 = len(t['simple_breakdown']) >= 8
    r8 = len(t['cause_effect']) >= 5
    r9 = vs.startswith('প্রিয়')
    r10 = all(k in t for k in ['id','chapterId','subjectId','name','order','summary','voice_script','simple_breakdown','exam_tips','key_terms','important_personalities','important_places','timeline','flashcards','cause_effect','important_highlights','map_description','sidebar_content','real_life_example','quiz'])
    
    # Structural match vs Ch1 T2 benchmark
    places_ok = bool(t['important_places']) and {'name','description','significance'} == set(t['important_places'][0].keys())
    ih = t['important_highlights']
    must_keys = {'must_remember_dates', 'must_remember_names', 'must_remember_places', 'one_liner_facts'}
    dates_ok = bool(ih.get('must_remember_dates')) and isinstance(ih['must_remember_dates'][0], str)
    has_all_highlight_fields = all(k in ih for k in must_keys)
    
    print(f'  R1 Flashcards: {len(t["flashcards"])}/25 -> {"PASS" if r1 else "FAIL"}')
    print(f'  R2 Timeline: {"PASS" if len(t["timeline"])>=5 else "FAIL"}')
    print(f'  R3 MCQ: {len(q["mcq"])}/40 -> {"PASS" if r3 else "FAIL"}')
    print(f'  R4 8mark: {len(q["explanatory_8mark"])}/5 -> {"PASS" if r4 else "FAIL"}')
    print(f'  R5 Voice: {vw}w/300w -> {"PASS" if r5 else "FAIL"}')
    print(f'  R6 Key terms: {len(t["key_terms"])}/7 -> {"PASS" if r6 else "FAIL"}')
    print(f'  R7 Breakdown: {len(t["simple_breakdown"])}/8 -> {"PASS" if r7 else "FAIL"}')
    print(f'  R8 Cause-effect: {len(t["cause_effect"])}/5 -> {"PASS" if r8 else "FAIL"}')
    print(f'  R9 প্রিয় start: {"PASS" if r9 else "FAIL"}')
    print(f'  R10 20 fields: {"PASS" if r10 else "FAIL"}')
    print(f'  STRUCT places keys: {"PASS" if places_ok else "FAIL"}')
    print(f'  STRUCT dates format: {"PASS" if dates_ok else "FAIL"}')
    print(f'  STRUCT all highlight fields: {"PASS" if has_all_highlight_fields else "FAIL"}')
    
    fixed_pass = r1 and r3 and r4 and r5 and r6 and r7 and r8 and r9 and r10 and places_ok and dates_ok and has_all_highlight_fields
    
    # Quality Scores (0-10) based on Ch1 T1 benchmark
    # Q1: Bengali naturalness
    warmth_signals = sum(1 for w in ['তোমরা','তোমাদের','আশা করি','মনে রেখো','বুঝতে পার'] if w in vs)
    q1 = min(10, 5 + warmth_signals + (0.5 if vw > 400 else 0) + (1 if vw > 500 else 0))
    
    # Q2: Depth of content
    detail_score = 5
    detail_score += min(2, len(t['key_terms']) / 7 * 2)
    detail_score += min(1, len(t['timeline']) / 6) 
    detail_score += min(1, len(t['cause_effect']) / 6)
    detail_score += 0.5 if len(t['simple_breakdown']) >= 10 else 0
    detail_score += 0.5 if len(t['sidebar_content']) > 100 else 0
    q2 = min(10, detail_score)
    
    # Q3: Exam readiness — MCQ difficulty spread, VS count, S2 count
    if len(q['mcq']) >= 40:
        difficulties = {}
        for m in q['mcq']:
            d = m[4] if isinstance(m, tuple) else m.get('difficulty', 'easy')
            difficulties[d] = difficulties.get(d, 0) + 1
        has_spread = len(difficulties) >= 2
    else:
        has_spread = False
    
    q3 = 5 + (1 if has_spread else 0) + (1 if len(q['very_short_1mark']) >= 40 else 0) + (1 if len(q['short_2mark']) >= 15 else 0) + (1 if len(q['evaluation_4mark']) >= 8 else 0) + (1 if len(t['exam_tips']) >= 5 else 0)
    q3 = min(10, q3)
    
    # Q4: MCQ quality (distractors realism, difficulty labels, explanations)
    mcq_score = 5
    if len(q['mcq']) >= 40:
        # Check explanations aren't empty
        expl_empty = 0
        for m in q['mcq']:
            exp = m[3] if isinstance(m, tuple) else m.get('explanation', '')
            if not exp or exp.strip() == '':
                expl_empty += 1
        expl_ratio = 1 - (expl_empty / len(q['mcq']))
        mcq_score += min(2, expl_ratio * 2)
        mcq_score += 0.5 if has_spread else 0
        mcq_score += 0.5 if len(q['mcq']) >= 42 else 0
    else:
        mcq_score += 0
    q4 = min(10, mcq_score)
    
    # Q5: Voice script warmth & quality
    voice_score = 5
    voice_score += min(2, warmth_signals)
    voice_score += 0.5 if vw >= 350 else 0
    voice_score += 0.5 if vw >= 400 else 0
    voice_score += 0.5 if any(word in vs for word in ['যেমন','আসলে','মানে']) else 0
    voice_score += 0.5 if '?' in vs else 0
    q5 = min(10, voice_score)
    
    ai = (q1 + q2 + q3 + q4 + q5) / 5.0
    
    print(f'\n  Q1 Bengali naturalness: {q1:.1f}/10')
    print(f'  Q2 Depth of content: {q2:.1f}/10')
    print(f'  Q3 Exam readiness: {q3:.1f}/10')
    print(f'  Q4 MCQ quality: {q4:.1f}/10')
    print(f'  Q5 Voice warmth: {q5:.1f}/10')
    print(f'  AI: {ai:.1f}/10')
    
    if fixed_pass and ai >= 9.0:
        print(f'  RESULT: ✅ SEED READY (ALL PASS + AI >= 9.0)')
    elif fixed_pass and ai >= 7.0:
        print(f'  RESULT: ⚠️ PASS but below 90% target (AI: {ai:.1f})')
    else:
        print(f'  RESULT: ❌ FAIL')
    
    return fixed_pass, ai

if __name__ == '__main__':
    var = sys.argv[1]
    file = sys.argv[2]
    ns = {}
    exec(compile(open(file).read(), file, 'exec'), ns)
    t = ns[var]
    score(t, file.split('/')[-1])
