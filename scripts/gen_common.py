#!/usr/bin/env python3
"""Shared utilities for chapter seed file generation."""

def dart_str(s):
    return "'''" + s.replace("'''", "'\\''") + "'''"

def serialize(v, indent=0):
    pad = '  ' * indent
    inner = '  ' * (indent + 1)
    if isinstance(v, str):
        return dart_str(v)
    elif isinstance(v, (int, float)):
        return str(v)
    elif isinstance(v, bool):
        return 'true' if v else 'false'
    elif isinstance(v, list):
        if not v:
            return '[]'
        lines = [f'{pad}[']
        for item in v:
            lines.append(f'{inner}{serialize(item, indent+1)},')
        lines.append(f'{pad}]')
        return '\n'.join(lines)
    elif isinstance(v, dict):
        if not v:
            return '{}'
        lines = [f'{pad}{{']
        for k, val in v.items():
            lines.append(f'{inner}{dart_str(k)}: {serialize(val, indent+1)},')
        lines.append(f'{pad}}}')
        return '\n'.join(lines)
    elif isinstance(v, tuple):
        return serialize(list(v), indent)
    else:
        return dart_str(str(v))

HEADER = """// Run: dart run scripts/seed_{ch}_all.dart
// Seeds {ch_name} ({{totalTopics}} topics) into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {{
  print('Seeding {ch_name}...\\n');
  final chaptersBase = 'content/history/chapters';
  final base = '$chaptersBase/{ch_id}/topics';

  await patchDoc('$chaptersBase/{ch_id}', {{
    'id': '{ch_id}',
    'subjectId': 'history',
    'name': '{ch_name}',
    'order': {order},
    'totalTopics': {totalTopics},
  }});

  final topicFns = <Map<String, dynamic> Function()>[{topic_fns}];

  for (final fn in topicFns) {{
    final t = fn();
    await patchDoc('$base/${{t['id']}}', t);
  }}

  print('\\nDone! {ch_name} seeded successfully.');
}}

Future<void> patchDoc(String path, Map<String, dynamic> data) async {{
  final url = '$baseUrl/$path?key=$apiKey';
  final fields = <String, dynamic>{{}};
  data.forEach((k, v) => fields[k] = _encode(v));
  final body = jsonEncode({{'fields': fields}});
  try {{
    final client = HttpClient();
    final req = await client.patchUrl(Uri.parse(url));
    req.headers.contentType = ContentType.json;
    req.write(body);
    final resp = await req.close();
    await resp.transform(utf8.decoder).join();
    print('  OK: $path');
  }} catch (e) {{
    print('  ERR: $path: $e');
  }}
}}

dynamic _encode(dynamic v) {{
  if (v is String) return {{'stringValue': v}};
  if (v is int) return {{'integerValue': v.toString()}};
  if (v is bool) return {{'booleanValue': v}};
  if (v is List) return {{'arrayValue': {{'values': v.map(_encode).toList()}}}};
  if (v is Map) {{
    return {{
      'mapValue': {{
        'fields': v.map((k, v) => MapEntry(k.toString(), _encode(v)))
      }}
    }};
  }}
  return {{'nullValue': null}};
}}

"""

def generate(gen_name, ch_id, ch_name, order, topics):
    """Generate a seed file for a chapter.
    
    gen_name: eg 'ch2_t2', used for filename
    ch_id: eg 'chapter2'
    ch_name: Bengali chapter name
    order: chapter number (2, 3, etc.)
    topics: list of dicts, each dict is topic data (must have 'id' field)
    """
    total = len(topics)
    
    # Build inline closures for each topic
    topic_closures = []
    for td in topics:
        serialized = serialize(td, 0)
        topic_closures.append(f"() {{\n    return {serialized};\n  }}")
    
    topic_fns = ",\n  ".join(topic_closures)
    
    header = HEADER.format(
        ch=gen_name,
        ch_name=ch_name,
        ch_id=ch_id,
        order=order,
        totalTopics=total,
        topic_fns=topic_fns,
    )
    
    filename = f'scripts/seed_{gen_name}_all.dart'
    with open(filename, 'w') as f:
        f.write(header)
        print(f"  Wrote topic 1: {topics[0]['name']}")
        for i, td in enumerate(topics[1:], 2):
            print(f"  Wrote topic {i}: {td['name']}")
    
    lines = sum(1 for _ in open(filename))
    print(f"Wrote {filename} ({lines} lines, {total} topics)")
    return filename
