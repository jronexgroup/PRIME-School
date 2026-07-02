#!/usr/bin/env python3
"""Generate complete seed_ch2_all.dart directly."""

def q(s):
    """Return safe Dart triple-quoted string for Bengali text."""
    return "'''" + s.replace("'''", "'\\''") + "'''"

def write_topic(f, name, order, summary, voice, extras):
    """Write one topic function."""
    n = order
    fields = {
        'id': f"chapter2_topic_{n}",
        'chapterId': 'chapter2',
        'subjectId': 'history',
        'name': name,
        'order': order,
        'summary': summary,
        'voice_script': voice,
    }
    fields.update(extras)
    
    f.write(f"Map<String, dynamic> t{n}() {{\n")
    f.write("  return {\n")
    for k, v in fields.items():
        f.write(f"    '{k}': ")
        if isinstance(v, str):
            f.write(q(v))
        elif isinstance(v, int):
            f.write(str(v))
        elif isinstance(v, list):
            f.write("[\n")
            for item in v:
                f.write("      ")
                if isinstance(item, dict):
                    write_inline_map(f, item, 6)
                elif isinstance(item, str):
                    f.write(q(item))
                f.write(",\n")
            f.write("    ]")
        elif isinstance(v, dict):
            f.write("{\n")
            for dk, dv in v.items():
                f.write(f"      '{dk}': ")
                if isinstance(dv, list):
                    f.write("[\n")
                    for d_item in dv:
                        f.write("        ")
                        write_quiz_item(f, dk, d_item)
                        f.write(",\n")
                    f.write("      ]")
                else:
                    f.write(q(str(dv)))
                f.write(",\n")
            f.write("    }")
        f.write(",\n")
    f.write("  };\n}\n\n")

def write_inline_map(f, m, indent):
    for k, v in m.items():
        f.write(f"{' '*indent}'{k}': {q(v)},\n")

def write_quiz_item(f, qtype, item):
    if qtype == 'mcq':
        q_text, opts, ans, exp, diff = item
        f.write(f"{{ 'question': {q(q_text)}, 'options': {opts.__repr__()}, 'correctIndex': {ans}, 'marks': 1, 'explanation': {q(exp)}, 'difficulty': '{diff}' }}")
    elif qtype == 'very_short_1mark':
        f.write(f"{{ 'question': {q(item[0])}, 'answer': {q(item[1])}, 'marks': 1 }}")
    elif qtype == 'short_2mark':
        f.write(f"{{ 'question': {q(item[0])}, 'answer': {q(item[1])}, 'marks': 2, 'key_points': {item[2].__repr__()} }}")
    elif qtype in ('evaluation_4mark', 'explanatory_8mark'):
        marks = 4 if qtype == 'evaluation_4mark' else 8
        f.write(f"{{ 'question': {q(item[0])}, 'answer': {q(item[1])}, 'marks': {marks} }}")

# ==================== HEADER ====================
HEADER = r"""// Run: dart run scripts/seed_ch2_all.dart
// Seeds Chapter 2 Topics into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Chapter 2...\n');
  final chaptersBase = 'content/history/chapters';
  final base = '$chaptersBase/chapter2/topics';

  await patchDoc('$chaptersBase/chapter2', {
    'id': 'chapter2',
    'subjectId': 'history',
    'name': 'বিপ্লবী আদর্শ, নেপোলিয়নীয় সাম্রাজ্য ও জাতীয়তাবাদ',
    'order': 2,
    'totalTopics': 6,
  });

  await patchDoc('$base/chapter2_topic_1', t1());
  await patchDoc('$base/chapter2_topic_2', t2());
  await patchDoc('$base/chapter2_topic_3', t3());
  await patchDoc('$base/chapter2_topic_4', t4());
  await patchDoc('$base/chapter2_topic_5', t5());
  await patchDoc('$base/chapter2_topic_6', t6());

  print('\nDone! Chapter 2 seeded successfully.');
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

"""

with open('scripts/seed_ch2_all.dart', 'w') as f:
    f.write(HEADER)
    
    # TOPIC 1
    write_topic(f, 'নেপোলিয়ান বোনাপার্টের ক্ষমতালাভ', 1,
        'নেপোলিয়ান বোনাপার্ট ১৭৬৯ সালে কর্সিকা দ্বীপে জন্মগ্রহণ করেন। ১৭৮৬ সালে তিনি ফরাসি গোলন্দাজ বাহিনীতে সহকারী লেফটেন্যান্ট পদে যোগ দেন। ১৭৯৩ সালে তুলোঁ বন্দরকে ব্রিটিশ অবরোধমুক্ত করে ব্রিগেডিয়ার পদ লাভ করেন। ১৭৯৫ সালে ন্যাশনাল কনভেনশন রক্ষা করে মেজর জেনারেল হন। ১৭৯৬ সালে ইটালি অভিযানে অস্ট্রিয়াকে পরাজিত করে ক্যাম্পোফরমিয়োর সন্ধি স্বাক্ষর করেন। ১৭৯৮ সালে মিশর অভিযানে যান। ১৭৯৯ সালের ৯ নভেম্বর ডাইরেক্টরির পতন ঘটিয়ে কনসুলেট প্রতিষ্ঠা করেন। ১৮০৪ সালে ফরাসি সম্রাট হন।',
        'প্রিয় ছাত্রছাত্রীরা, আজ আমরা আলোচনা করব ফরাসি বিপ্লবের পরবর্তী সময়ের সবচেয়ে গুরুত্বপূর্ণ ব্যক্তি নেপোলিয়ান বোনাপার্টের ক্ষমতালাভ নিয়ে। নেপোলিয়ানের জীবন ছিল এক বিস্ময়কর উত্তরণের কাহিনি। তিনি ১৭৬৯ সালের ১৫ আগস্ট কর্সিকা দ্বীপের এক সাধারণ পরিবারে জন্মগ্রহণ করেন। ১৭৮৬ সালে মাত্র ১৭ বছর বয়সে ফরাসি বাহিনীতে যোগ দেন। ১৭৯৩ সালে তুলোঁ বন্দর ব্রিটিশ অবরোধমুক্ত করে ব্রিগেডিয়ার হন। ১৭৯৫ সালে ন্যাশনাল কনভেনশন রক্ষা করে মেজর জেনারেল হন। ১৭৯৬ সালে ইটালি অভিযানে অস্ট্রিয়াকে পরাজিত করে ক্যাম্পোফরমিয়োর সন্ধি স্বাক্ষর করেন। ১৭৯৯ সালের ৯ নভেম্বর অ্যাবে সিয়েসের সহায়তায় ডাইরেক্টরির পতন ঘটান এবং কনসুলেট প্রতিষ্ঠা করেন। ১৮০২ সালে আজীবন কনসাল এবং ১৮০৪ সালে ফরাসি সম্রাট হন। এভাবে এক সাধারণ সৈনিক থেকে ফ্রান্সের সম্রাট হন।',
        {
            'simple_breakdown': ['নেপোলিয়ান ১৭৬৯ সালে কর্সিকায় জন্ম', '১৭৮৬ সালে ফরাসি বাহিনীতে যোগ', '১৭৯৩ সালে তুলোঁর যুদ্ধে সাফল্য', '১৭৯৯ সালের ৯ নভেম্বর ডাইরেক্টরির পতন', '১৮০৪ সালে ফরাসি সম্রাট'],
            'exam_tips': ['নেপোলিয়ানের উত্থানের ধাপ: তুলোঁ → কনভেনশন → ইটালি → মিশর → ডাইরেক্টরি পতন', 'কনসুলেট, আজীবন কনসাল, সম্রাট — তিন স্তর মনে রাখো'],
            'key_terms': [
                {'term': 'কনসুলেট', 'meaning': 'তিন কনসালের শাসন', 'example': '১৭৯৯-১৮০৪'},
                {'term': 'ডাইরেক্টরি', 'meaning': 'পাঁচ ডাইরেক্টরের শাসন', 'example': '১৭৯৫-৯৯'},
            ],
            'people': [
                {'name': 'নেপোলিয়ান বোনাপার্ট', 'title': 'ফরাসি সম্রাট', 'contribution': 'কনসুলেট ও সাম্রাজ্য প্রতিষ্ঠা', 'exam_importance': 'কেন্দ্রীয় চরিত্র'},
                {'name': 'অ্যাবে সিয়েস', 'title': 'ডাইরেক্টর ও কনসাল', 'contribution': 'অভ্যুত্থানে সহায়তা', 'exam_importance': 'দ্বিতীয় কনসাল'},
            ],
            'timeline': [
                {'date': '১৫ আগস্ট ১৭৬৯', 'event': 'নেপোলিয়ানের জন্ম', 'significance': 'কর্সিকায়'},
                {'date': '১৭৯৩', 'event': 'তুলোঁর যুদ্ধ', 'significance': 'প্রথম সাফল্য'},
                {'date': '৯ নভেম্বর ১৭৯৯', 'event': 'ডাইরেক্টরির পতন', 'significance': 'কনসুলেট শুরু'},
                {'date': '২ ডিসেম্বর ১৮০৪', 'event': 'সম্রাট পদপ্রাপ্তি', 'significance': 'ফরাসি সম্রাট'},
            ],
            'flashcards': [
                {'front': 'নেপোলিয়ানের জন্ম', 'back': 'কর্সিকা, ১৭৬৯', 'type': 'date', 'importance': 'high'},
                {'front': 'প্রথম সাফল্য', 'back': 'তুলোঁর যুদ্ধ ১৭৯৩', 'type': 'event', 'importance': 'high'},
                {'front': 'ডাইরেক্টরি পতন', 'back': '৯ নভেম্বর ১৭৯৯', 'type': 'date', 'importance': 'high'},
                {'front': 'সম্রাট হন', 'back': '২ ডিসেম্বর ১৮০৪', 'type': 'date', 'importance': 'high'},
            ],
            'cause_effect': [
                {'cause': 'ডাইরেক্টরির অপশাসন', 'effect': 'জনগণ নেপোলিয়ান চায়'},
                {'cause': 'ইটালি অভিযানে সাফল্য', 'effect': 'নেপোলিয়ানের জনপ্রিয়তা বাড়ে'},
            ],
            'quiz': {
                'mcq': [
                    ('নেপোলিয়ান কোথায় জন্মগ্রহণ করেন?', ['প্যারিস', 'কর্সিকা', 'মার্সেই', 'লিয়ঁ'], 1, 'নেপোলিয়ান কর্সিকা দ্বীপে জন্মগ্রহণ করেন।', 'easy'),
                    ('নেপোলিয়ান কবে ফরাসি বাহিনীতে যোগ দেন?', ['১৭৮৬', '১৭৯৩', '১৭৯৫', '১৭৯৯'], 0, '১৭৮৬ সালে মাত্র ১৭ বছর বয়সে যোগ দেন।', 'medium'),
                    ('তুলোঁর যুদ্ধ কবে হয়?', ['১৭৮৬', '১৭৯৩', '১৭৯৫', '১৭৯৯'], 1, '১৭৯৩ সালে তুলোঁ বন্দর ব্রিটিশ অবরোধমুক্ত করেন।', 'easy'),
                    ('ক্যাম্পোফরমিয়োর সন্ধি কবে হয়?', ['ফেব্রুয়ারি ১৭৯৭', 'অক্টোবর ১৭৯৭', 'নভেম্বর ১৭৯৯', '১৮০৪'], 1, '১৭ অক্টোবর ১৭৯৭ অস্ট্রিয়ার সাথে এই সন্ধি হয়।', 'hard'),
                    ('নীলনদের যুদ্ধে নেপোলিয়ান কাদের কাছে পরাজিত হন?', ['অস্ট্রিয়া', 'প্রাশিয়া', 'ব্রিটেন নেলসন', 'রাশিয়া'], 2, 'ব্রিটিশ সেনাপতি নেলসনের কাছে ১৭৯৮ সালে পরাজিত।', 'medium'),
                    ('ডাইরেক্টরির পতন কবে?', ['১৭৯৫', '৯ নভেম্বর ১৭৯৯', '২ ডিসেম্বর ১৮০৪', '১৫ আগস্ট ১৭৬৯'], 1, '১৭৯৯ সালের ৯ নভেম্বর নেপোলিয়ান ডাইরেক্টরির পতন ঘটান।', 'easy'),
                    ('কনসুলেটের প্রথম কনসাল কে?', ['অ্যাবে সিয়েস', 'নেপোলিয়ান', 'রজার ডুকো', 'ব্যারাস'], 1, 'নেপোলিয়ান ছিলেন প্রথম প্রধান কনসাল।', 'easy'),
                    ('নেপোলিয়ান কবে সম্রাট হন?', ['১৭৯৯', '১৮০২', '১৮০৪', '১৮০৭'], 2, '১৮০৪ সালে নিজেকে ফরাসি সম্রাট ঘোষণা করেন।', 'easy'),
                    ('নেপোলিয়ান কবে আজীবন কনসাল হন?', ['১৭৯৯', '১৮০০', '১৮০২', '১৮০৪'], 2, '১৮০২ সালে আজীবনের জন্য কনসাল হন।', 'hard'),
                    ('নেপোলিয়ানের জন্ম তারিখ?', ['১৫ আগস্ট ১৭৬৯', '২ ডিসেম্বর ১৮০৪', '৯ নভেম্বর ১৭৯৯', '১৭ অক্টোবর ১৭৯৭'], 0, '১৫ আগস্ট ১৭৬৯ কর্সিকায় জন্ম।', 'easy'),
                ],
                'very_short_1mark': [
                    ('নেপোলিয়ান কোথায় জন্মগ্রহণ করেন?', 'কর্সিকা দ্বীপে'),
                    ('নেপোলিয়ান কবে ফরাসি বাহিনীতে যোগ দেন?', '১৭৮৬ সালে'),
                    ('তুলোঁর যুদ্ধে নেপোলিয়ান কী পদ লাভ করেন?', 'ব্রিগেডিয়ার'),
                    ('ক্যাম্পোফরমিয়োর সন্ধি কবে স্বাক্ষরিত হয়?', '১৭ অক্টোবর ১৭৯৭'),
                    ('নীলনদের যুদ্ধে নেপোলিয়ান কাদের কাছে পরাজিত হন?', 'ব্রিটিশ সেনাপতি নেলসনের কাছে'),
                    ('ডাইরেক্টরির পতন কবে ঘটে?', '৯ নভেম্বর ১৭৯৯'),
                    ('নেপোলিয়ান কবে নিজেকে সম্রাট ঘোষণা করেন?', '২ ডিসেম্বর ১৮০৪'),
                ],
                'short_2mark': [
                    ('নেপোলিয়ানের প্রাথমিক সামরিক সাফল্য বর্ণনা করো।', '১৭৯৩ সালে তুলোঁ বন্দর ব্রিটিশ অবরোধমুক্ত করে ব্রিগেডিয়ার পদ। ১৭৯৫ সালে ন্যাশনাল কনভেনশন রক্ষা করে মেজর জেনারেল। ১৭৯৬ সালে ইটালি অভিযানে সাফল্য ও ক্যাম্পোফরমিয়োর সন্ধি।', ['তুলোঁর যুদ্ধ', 'ইটালি অভিযান']),
                    ('ডাইরেক্টরি পতনের কারণ লেখো।', 'ডাইরেক্টরির অপশাসনে জনগণ ক্ষুব্ধ। নেপোলিয়ানের জনপ্রিয়তা বাড়ে। অ্যাবে সিয়েসের সহায়তায় ৯ নভেম্বর ১৭৯৯ সামরিক অভ্যুত্থান।', ['অপশাসন', 'অভ্যুত্থান']),
                ],
                'evaluation_4mark': [
                    ('নেপোলিয়ানের ক্ষমতালাভে ব্যক্তিগত যোগ্যতা ও পরিস্থিতির ভূমিকা মূল্যায়ন করো।', 'নেপোলিয়ানের সামরিক প্রতিভা অসাধারণ — তুলোঁ, ইটালি, মিশর অভিযানে তা প্রমাণিত। অন্যদিকে ডাইরেক্টরির ব্যর্থতা তাঁকে সুযোগ দেয়। জনগণ দক্ষ শাসক চেয়েছিল। তাঁর উত্থান যোগ্যতা ও পরিস্থিতির সমন্বয়ের ফল।'),
                ],
                'explanatory_8mark': [
                    ('এক সাধারণ সৈনিক থেকে ফরাসি সম্রাট — নেপোলিয়ানের ক্ষমতালাভের বিশ্লেষণ দাও।', 'নেপোলিয়ান ১৭৬৯ সালে কর্সিকায় জন্ম। ১৭৮৬ সালে ফরাসি বাহিনীতে যোগ। ১৭৯৩ সালে তুলোঁতে প্রথম সাফল্য। ১৭৯৫ সালে কনভেনশন রক্ষা করে মেজর জেনারেল। ১৭৯৬-৯৭ সালে ইটালি অভিযান ও ক্যাম্পোফরমিয়োর সন্ধি। ১৭৯৮ সালে মিশর অভিযান। ১৭৯৯ সালের ৯ নভেম্বর ডাইরেক্টরির পতন, কনসুলেট প্রতিষ্ঠা। ১৮০২ সালে আজীবন কনসাল। ১৮০৪ সালে ফরাসি সম্রাট।'),
                ],
            },
        },
    )

    # TOPICS 2-6 (placeholders that will be expanded)
    topic_names = [
        'কোড নেপোলিয়ান',
        'নেপোলিয়নীয় সাম্রাজ্যের সঙ্গে ফরাসি বিপ্লবের আদর্শের সংঘাত',
        'ইউরোপের পুনর্গঠন',
        'নেপোলিয়নীয় সাম্রাজ্যের বিরুদ্ধে জাতীয়তাবাদী প্রতিক্রিয়া',
        'রাশিয়া আক্রমণ ও নেপোলিয়ানের পতন',
    ]
    
    for i, tn in enumerate(topic_names, start=2):
        write_topic(f, tn, i, 
            f'{tn} — এই টপিক সম্পর্কে বিস্তারিত আলোচনা এই সংস্করণের পরবর্তী অংশে যুক্ত করা হবে।',
            f'প্রিয় ছাত্রছাত্রীরা, আজ আমরা আলোচনা করব {tn} নিয়ে। এই টপিকের বিস্তারিত বক্তব্য নির্মাণাধীন।',
            {
                'simple_breakdown': [f'{tn} — বিস্তারিত নির্মাণাধীন'],
                'quiz': {
                    'mcq': [],
                    'very_short_1mark': [],
                    'short_2mark': [],
                    'evaluation_4mark': [],
                    'explanatory_8mark': [],
                },
            },
        )

print("Generated scripts/seed_ch2_all.dart")
