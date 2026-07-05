#!/usr/bin/env python3
"""Generate full-quality Chapter 4 seed. Targets AI >= 9.0."""

import sys; sys.path.insert(0, 'scripts')
from gen_common import generate

def M(q, o, a, e, d): return (q, o, a, e, d)

def make_topic(id_, name, order, summary, voice, breakdown, tips, terms, ppl, places, tl, cards, ce, highlights, map_desc, sidebar, real, mcq, vs, s2, e4, e8):
    return {
        'id': id_, 'chapterId': 'chapter4', 'subjectId': 'history',
        'name': name, 'order': order,
        'summary': summary, 'voice_script': voice, 'simple_breakdown': breakdown,
        'exam_tips': tips, 'key_terms': terms,
        'important_personalities': ppl, 'important_places': places,
        'timeline': tl, 'flashcards': cards, 'cause_effect': ce,
        'important_highlights': highlights, 'map_description': map_desc,
        'sidebar_content': sidebar, 'real_life_example': real,
        'quiz': {'mcq': mcq, 'very_short_1mark': vs, 'short_2mark': s2,
                 'evaluation_4mark': e4, 'explanatory_8mark': e8},
    }

topics = []

# ---- Helper: generate N MCQ variants for a topic ----
def make_mcq(mcq_specs):
    """mcq_specs: list of (question, correct_answer, wrong_answers:list, explanation, difficulty)"""
    out = []
    for q, ca, wa, exp, diff in mcq_specs:
        opts = wa + [ca]
        import random
        random.shuffle(opts)
        ci = opts.index(ca)
        out.append(M(q, opts, ci, exp, diff))
    return out

# ============ T1: শিল্পবিপ্লব কী ============
t1_name = 'শিল্পবিপ্লব কী'
t1_summary = 'শিল্পবিপ্লব হল অষ্টাদশ শতাব্দীর শেষার্ধে ইংল্যান্ডে শুরু হওয়া শিল্পক্ষেত্রে দ্রুত ও আমূল পরিবর্তন, যেখানে দৈহিক শ্রমের পরিবর্তে যন্ত্রপাতির সাহায্যে উৎপাদন ব্যবস্থায় পরিমাণগত ও গুণগত পরিবর্তন দেখা দেয়। ফরাসি সমাজতত্ত্ববিদ অগাস্ট ব্লাংকি ১৮৩৭ সালে "শিল্পবিপ্লব" কথাটি প্রথম ব্যবহার করেন। কার্ল মার্কস ১৮৬৭ সালে প্রয়োগ করেন। আর্নল্ড টয়েনবি ১৮৮০-৮১ সালে অক্সফোর্ডে বক্তৃতার মাধ্যমে শব্দটিকে জনপ্রিয় করেন। ইংল্যান্ডে প্রথম শুরু হলেও পরে ফ্রান্স, জার্মানি, ইতালি, বেলজিয়াম, রাশিয়ায় ছড়িয়ে পড়ে।'
t1_voice = ''
t1_breakdown = ['শিল্পবিপ্লব হলো শিল্পক্ষেত্রে দ্রুত ও আমূল পরিবর্তন','ইংল্যান্ডে অষ্টাদশ শতাব্দীর শেষার্ধে শুরু','অগাস্ট ব্লাংকি (১৮৩৭) প্রথম শিল্পবিপ্লব শব্দ ব্যবহার','কার্ল মার্কস (১৮৬৭) শব্দ প্রয়োগ','আর্নল্ড টয়েনবি (১৮৮০-৮১) শব্দ জনপ্রিয় করেন','টয়েনবির মতে ১৭৬০, হফম্যানের মতে ১৭৮০','বিপ্লব বনাম বিবর্তন বিতর্ক','পরে ফ্রান্স, জার্মানি, ইতালি, বেলজিয়াম, রাশিয়ায় ছড়িয়ে পড়ে']
t1_tips = ['শিল্পবিপ্লবের সংজ্ঞা ও সময়কাল জানতে হবে','শব্দটির প্রবর্তক ও জনপ্রিয়কারীর নাম মনে রাখো','বিপ্লব বনাম বিবর্তন বিতর্ক সম্পর্কে ধারণা রাখো','ইংল্যান্ড থেকে শুরু হওয়ার কারণ ও প্রথম আবিষ্কারগুলি জানো','পূর্ববর্তী ও পরবর্তী উৎপাদন ব্যবস্থার পার্থক্য বুঝতে হবে']
t1_terms = [{'term':'শিল্পবিপ্লব','meaning':'শিল্পক্ষেত্রে দ্রুত ও আমূল পরিবর্তন','example':'ইংল্যান্ডে ১৭৬০ সালে শুরু'},{'term':'উড়ন্ত মাকু','meaning':'জন কে-র কাপড় বোনার যন্ত্র (১৭৩৩)','example':'বস্ত্রশিল্পে গতি বৃদ্ধি করে'},{'term':'স্পিনিং জেনি','meaning':'হারগ্রিভসের সুতো কাটার যন্ত্র (১৭৬৫)','example':'একসঙ্গে ৮টি সুতো কাটতে পারত'},{'term':'ওয়াটার ফ্রেম','meaning':'আর্করাইটের জলশক্তিচালিত যন্ত্র (১৭৬৯)','example':'বৃহদায়তন উৎপাদন সম্ভব করে'},{'term':'বাষ্পীয় ইঞ্জিন','meaning':'জেমস ওয়াটের বাষ্পচালিত ইঞ্জিন (১৭৬৯)','example':'শিল্পবিপ্লবের চালিকাশক্তি'},{'term':'টেক অফ','meaning':'কুটিরশিল্প থেকে যন্ত্রনির্ভর উৎপাদনে উত্তরণ','example':'টয়েনবি ১৭৬০-কে টেক অফ বলেন'},{'term':'বিবর্তন তত্ত্ব','meaning':'হ্যাজেন-হেজের মতে শিল্পপরিবর্তন দীর্ঘ প্রক্রিয়া','example':'আকস্মিক নয়, ক্রমিক পরিবর্তন'}]
t1_ppl = [{'name':'অগাস্ট ব্লাংকি','title':'ফরাসি সমাজতত্ত্ববিদ','contribution':'১৮৩৭ সালে প্রথম শিল্পবিপ্লব শব্দ ব্যবহার','exam_importance':'শব্দের প্রথম ব্যবহারকারী'},{'name':'কার্ল মার্কস','title':'বৈজ্ঞানিক সমাজতন্ত্রবাদী','contribution':'১৮৬৭ সালে শব্দ প্রয়োগ','exam_importance':'শিল্পবিপ্লব ও পুঁজিবাদী সমালোচনা'},{'name':'আর্নল্ড টয়েনবি','title':'ইংরেজ ঐতিহাসিক','contribution':'অক্সফোর্ডে বক্তৃতায় শিল্পবিপ্লব জনপ্রিয় করেন','exam_importance':'সময়কাল ১৭৬০ নির্ধারণ'},{'name':'হ্যাজেন ও হেজ','title':'ঐতিহাসিক','contribution':'শিল্পপরিবর্তনকে বিবর্তন বলেন','exam_importance':'বিপ্লব বনাম বিবর্তন বিতর্ক'},{'name':'জেমস ওয়াট','title':'আবিষ্কারক','contribution':'বাষ্পীয় ইঞ্জিনের উন্নয়ন (১৭৬৯)','exam_importance':'শিল্পবিপ্লবের চালিকাশক্তি'},{'name':'জন কে','title':'আবিষ্কারক','contribution':'উড়ন্ত মাকু আবিষ্কার (১৭৩৩)','exam_importance':'বস্ত্রশিল্পের প্রথম উদ্ভাবন'}]
t1_places = [{'name':'ইংল্যান্ড','description':'শিল্পবিপ্লবের প্রথম স্থান','significance':'শিল্পবিপ্লবের সূচনা'},{'name':'ফ্রান্স','description':'দ্বিতীয় প্রধান শিল্পায়িত দেশ','significance':'মহাদেশীয় শিল্পায়নের উদাহরণ'},{'name':'জার্মানি','description':'তৃতীয় প্রধান শিল্পায়িত কেন্দ্র','significance':'প্রাশিয়ায় রেলপথ স্থাপন'},{'name':'বেলজিয়াম','description':'মহাদেশীয় ইউরোপের প্রথম শিল্পায়িত দেশ','significance':'ইংল্যান্ডের পরেই শিল্পায়ন'}]
t1_tl = [{'date':'১৭৩৩','event':'জন কে উড়ন্ত মাকু আবিষ্কার','significance':'বস্ত্রশিল্পে প্রথম যুগান্তকারী আবিষ্কার'},{'date':'১৭৬০','event':'টয়েনবির মতে শিল্পবিপ্লব শুরু','significance':'শিল্পবিপ্লবের সূচনা কাল'},{'date':'১৭৬৫','event':'হারগ্রিভস স্পিনিং জেনি আবিষ্কার','significance':'সুতো কাটার গতি বৃদ্ধি'},{'date':'১৭৬৯','event':'ওয়াট বাষ্পীয় ইঞ্জিন ও আর্করাইট ওয়াটার ফ্রেম','significance':'দুটি গুরুত্বপূর্ণ প্রযুক্তিগত উদ্ভাবন'},{'date':'১৮৩৭','event':'ব্লাংকি প্রথম শিল্পবিপ্লব শব্দ ব্যবহার','significance':'শব্দটির প্রথম প্রয়োগ'},{'date':'১৮৬৭','event':'মার্কস শিল্পবিপ্লব শব্দ প্রয়োগ','significance':'তাত্ত্বিক প্রয়োগ'},{'date':'১৮৮০-৮১','event':'টয়েনবি অক্সফোর্ডে বক্তৃতা','significance':'শব্দটি জনপ্রিয়তা লাভ'}]
t1_hl = {
    'must_remember_dates':['১৭৩৩ — জন কে উড়ন্ত মাকু','১৭৬০ — টয়েনবির মতে শুরু','১৭৬৫ — স্পিনিং জেনি','১৭৬৯ — বাষ্পীয় ইঞ্জিন','১৮৩৭ — ব্লাংকি','১৮৬৭ — মার্কস','১৮৮০-৮১ — টয়েনবি'],
    'must_remember_names':['অগাস্ট ব্লাংকি','কার্ল মার্কস','আর্নল্ড টয়েনবি','জেমস ওয়াট','জন কে','হারগ্রিভস','আর্করাইট'],
    'must_remember_places':['ইংল্যান্ড','ফ্রান্স','জার্মানি','বেলজিয়াম'],
    'one_liner_facts':['ব্লাংকি ১৮৩৭ সালে প্রথম শিল্পবিপ্লব শব্দ ব্যবহার','মার্কস ১৮৬৭ সালে দাস ক্যাপিটালে প্রয়োগ','টয়েনবি শব্দটি জনপ্রিয় করেন','হ্যাজেন-হেজ একে বিবর্তন বলেন','শিল্পবিপ্লব প্রথম ইংল্যান্ডে শুরু','বস্ত্রশিল্পে প্রথম শিল্পবিপ্লব ঘটে','বাষ্পীয় ইঞ্জিন শিল্পবিপ্লবের চালিকাশক্তি'],
}

# Reuse voice from textbook
with open('/root/projects/PRIME-School/class-9-history-full-textbook.md', 'r') as f:
    full_text = f.read()

# We'll generate voice scripts per topic later. For now seed placeholder.

t1 = make_topic('chapter4_topic_1', t1_name, 1, t1_summary, '', t1_breakdown, t1_tips, t1_terms, t1_ppl, t1_places, t1_tl, [], [], t1_hl, '', '', '', [],[],[],[],[])
topics.append(t1)

print(f"Total: {len(topics)} topics")
if topics:
    generate('chapter4_full', 'chapter4', 'শিল্পবিপ্লব ও সাম্রাজ্যবাদ', 4, topics)
