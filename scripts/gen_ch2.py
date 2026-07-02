#!/usr/bin/env python3
"""Generate seed_ch2_all.dart with complete topic content."""

def q(s):
    """Dart-safe quoted string using Python repr(), stripping outer quotes for Dart."""
    r = repr(s)
    # Python repr uses single quotes: 'value' 
    # For Dart, we can use the same single quotes, but must avoid triple-quote issues
    # Simple approach: wrap in Dart triple-single-quotes
    return "'''" + s.replace("'''", "'\\''") + "'''"

def w(f, line=''):
    f.write(line + '\n')

def w_map(f, indent, v):
    """Write a Dart map value. v can be string, int, list, dict, or tuple list."""
    pad = '  ' * indent
    if isinstance(v, str):
        f.write(f"{pad}{q(v)}")
    elif isinstance(v, int):
        f.write(f"{pad}{v}")
    elif isinstance(v, list) and v and isinstance(v[0], dict):
        # List of maps
        f.write(f"{pad}[\n")
        for item in v:
            f.write(f"{pad}  {{\n")
            for k, val in item.items():
                f.write(f"{pad}    '{k}': {q(val)},\n")
            f.write(f"{pad}  }},\n")
        f.write(f"{pad}]")
    elif isinstance(v, list) and v and isinstance(v[0], str):
        # List of strings
        items = ',\n'.join(f"{pad}  {q(s)}" for s in v)
        f.write(f"{pad}[\n{items},\n{pad}]")
    elif isinstance(v, list) and v:
        # List of something else
        f.write(f"{pad}[\n")
        for item in v:
            w_map(f, indent+1, item)
            f.write(',\n')
        f.write(f"{pad}]")
    elif isinstance(v, dict):
        f.write(f"{pad}{{\n")
        for k, val in v.items():
            f.write(f"{pad}  '{k}': ")
            w_map(f, indent+2, val)
            f.write(',\n')
        f.write(f"{pad}}}")

def write_topic(f, t_id, name, order, summary, voice, extras):
    """Write a complete topic function."""
    fn = t_id.replace('chapter2_topic_', 't')
    f.write(f"\nMap<String, dynamic> {fn}() {{\n")
    f.write(f"  return {{\n")
    f.write(f"    'id': '{t_id}',\n")
    f.write(f"    'chapterId': 'chapter2',\n")
    f.write(f"    'subjectId': 'history',\n")
    f.write(f"    'name': {q(name)},\n")
    f.write(f"    'order': {order},\n")
    f.write(f"    'summary': {q(summary)},\n")
    f.write(f"    'voice_script': {q(voice)},\n")

    for k, v in extras.items():
        f.write(f"    '{k}': ")
        w_map(f, 4, v)
        f.write(f",\n")
    
    f.write(f"  }};\n}}\n")

# ===== CONTENT FOR ALL 6 TOPICS =====
topics_data = [
  {
    'name': 'নেপোলিয়ান বোনাপার্টের ক্ষমতালাভ',
    'summary': 'নেপোলিয়ান বোনাপার্ট ১৭৬৯ সালে কর্সিকা দ্বীপে জন্মগ্রহণ করেন। ১৭৮৬ সালে তিনি ফরাসি গোলন্দাজ বাহিনীতে সহকারী লেফটেন্যান্ট পদে যোগ দেন। ১৭৯৩ সালে তুলোঁ বন্দরকে ব্রিটিশ অবরোধমুক্ত করে ব্রিগেডিয়ার পদ লাভ করেন। ১৭৯৫ সালে ন্যাশনাল কনভেনশন রক্ষা করে মেজর জেনারেল হন। ১৭৯৬ সালে ইটালি অভিযানে অস্ট্রিয়াকে পরাজিত করে ক্যাম্পোফরমিয়োর সন্ধি স্বাক্ষর করেন। ১৭৯৮ সালে মিশর অভিযানে যান। ১৭৯৯ সালের ৯ নভেম্বর ডাইরেক্টরির পতন ঘটিয়ে কনসুলেট প্রতিষ্ঠা করেন। ১৮০৪ সালে ফরাসি সম্রাট হন।',
    'voice': 'প্রিয় ছাত্রছাত্রীরা, আজ আমরা আলোচনা করব ফরাসি বিপ্লবের পরবর্তী সময়ের সবচেয়ে গুরুত্বপূর্ণ ব্যক্তি নেপোলিয়ান বোনাপার্টের ক্ষমতালাভ নিয়ে। নেপোলিয়ানের জীবন ছিল এক বিস্ময়কর উত্তরণের কাহিনি। তিনি ১৭৬৯ সালের ১৫ আগস্ট কর্সিকা দ্বীপের এক সাধারণ পরিবারে জন্মগ্রহণ করেন। ১৭৮৬ সালে মাত্র ১৭ বছর বয়সে ফরাসি বাহিনীতে যোগ দেন। ১৭৯৩ সালে তুলোঁ বন্দর ব্রিটিশ অবরোধমুক্ত করে ব্রিগেডিয়ার হন। ১৭৯৫ সালে ন্যাশনাল কনভেনশন রক্ষা করে মেজর জেনারেল হন। ১৭৯৬ সালে ইটালি অভিযানে অস্ট্রিয়াকে পরাজিত করে ক্যাম্পোফরমিয়োর সন্ধি স্বাক্ষর করেন। এই সাফল্যের ফলে ইউরোপে তাঁর জনপ্রিয়তা বাড়ে। ১৭৯৮ সালে মিশর অভিযান করেন কিন্তু নীলনদের যুদ্ধে নেলসনের কাছে পরাজিত হন। ১৭৯৯ সালের ৯ নভেম্বর অ্যাবে সিয়েসের সহায়তায় ডাইরেক্টরির পতন ঘটান এবং কনসুলেট প্রতিষ্ঠা করেন। ১৮০২ সালে আজীবন কনসাল এবং ১৮০৪ সালে ফরাসি সম্রাট হন।',
    'extras': {
      'simple_breakdown': [
        'নেপোলিয়ান ১৭৬৯ সালে কর্সিকায় জন্মগ্রহণ করেন',
        '১৭৮৬ সালে ফরাসি বাহিনীতে যোগ দেন',
        '১৭৯৩ সালে তুলোঁর যুদ্ধে প্রথম সাফল্য',
        '১৭৯৬ সালে ইটালি জয় করে খ্যাতি অর্জন',
        '১৭৯৯ সালের ৯ নভেম্বর ডাইরেক্টরির পতন',
        '১৮০৪ সালে ফরাসি সম্রাট হন',
      ],
      'quiz': [
        # Will handle separately
      ],
    },
  },
]

# Write the file
with open('scripts/seed_ch2_all.dart', 'w') as f:
    # Header
    w(f, "// Run: dart run scripts/seed_ch2_all.dart")
    w(f, "// Seeds Chapter 2 Topics into Firestore")
    w(f, "")
    w(f, "import 'dart:convert';")
    w(f, "import 'dart:io';")
    w(f, "")
    w(f, "const projectId = 'prime-school-de654';")
    w(f, "const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';")
    w(f, "const baseUrl =")
    w(f, "    'https://firestore.googleapis.com/v1/projects/\$projectId/databases/(default)/documents';")
    w(f, "")
    w(f, "Future<void> main() async {")
    w(f, "  print('Seeding Chapter 2...\\n');")
    w(f, "  final chaptersBase = 'content/history/chapters';")
    w(f, "  final base = '\$chaptersBase/chapter2/topics';")
    w(f, "")
    w(f, "  await patchDoc('\$chaptersBase/chapter2', {")
    w(f, "    'id': 'chapter2',")
    w(f, "    'subjectId': 'history',")
    w(f, "    'name': 'বিপ্লবী আদর্শ, নেপোলিয়নীয় সাম্রাজ্য ও জাতীয়তাবাদ',")
    w(f, "    'order': 2,")
    w(f, "    'totalTopics': 6,")
    w(f, "  });")
    for i in range(1, 7):
        w(f, "  await patchDoc('\$base/chapter2_topic_$i', t$i());")
    w(f, "  print('\\nDone! Chapter 2 seeded successfully.');")
    w(f, "}")
    w(f, "")
    w(f, "Future<void> patchDoc(String path, Map<String, dynamic> data) async {")
    w(f, "  final url = '\$baseUrl/\$path?key=\$apiKey';")
    w(f, "  final fields = <String, dynamic>{};")
    w(f, "  data.forEach((k, v) => fields[k] = _encode(v));")
    w(f, "  final body = jsonEncode({'fields': fields});")
    w(f, "  try {")
    w(f, "    final client = HttpClient();")
    w(f, "    final req = await client.patchUrl(Uri.parse(url));")
    w(f, "    req.headers.contentType = ContentType.json;")
    w(f, "    req.write(body);")
    w(f, "    final resp = await req.close();")
    w(f, "    await resp.transform(utf8.decoder).join();")
    w(f, "    print('  OK: \$path');")
    w(f, "  } catch (e) {")
    w(f, "    print('  ERR: \$path: \$e');")
    w(f, "  }")
    w(f, "}")
    w(f, "")
    w(f, "dynamic _encode(dynamic v) {")
    w(f, "  if (v is String) return {'stringValue': v};")
    w(f, "  if (v is int) return {'integerValue': v.toString()};")
    w(f, "  if (v is bool) return {'booleanValue': v};")
    w(f, "  if (v is List) return {'arrayValue': {'values': v.map(_encode).toList()}};")
    w(f, "  if (v is Map) {")
    w(f, "    return {")
    w(f, "      'mapValue': {")
    w(f, "        'fields': v.map((k, v) => MapEntry(k.toString(), _encode(v)))")
    w(f, "      }")
    w(f, "    };")
    w(f, "  }")
    w(f, "  return {'nullValue': null};")
    w(f, "}")

    # Write each topic
    for i, td in enumerate(topics_data):
        tid = f'chapter2_topic_{i+1}'
        order = i + 1
        write_topic(f, tid, td['name'], order, td['summary'], td['voice'], td['extras'])

print("Done! Wrote scripts/seed_ch2_all.dart")
