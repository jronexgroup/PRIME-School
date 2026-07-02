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

  for (int i = 1; i <= {totalTopics}; i++) {{
    final m = switch (i) {{
{topic_switch}
      _ => throw Exception('unknown topic'),
    }};
    await patchDoc('$base/{ch_id}_topic_$i', m);
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

def _fix_item(v, kind):
    """Convert list entries to map entries for Firestore compatibility."""
    if isinstance(v, list) and kind == 'mcq' and len(v) >= 5:
        return {'questionText': v[0], 'options': v[1], 'correctIndex': v[2], 'explanation': v[3], 'difficulty': v[4], 'marks': 1}
    if isinstance(v, list) and kind in ('very_short_1mark','evaluation_4mark','explanatory_8mark') and len(v) >= 2:
        return {'question': v[0], 'answer': v[1]}
    if isinstance(v, list) and kind == 'short_2mark' and len(v) >= 3:
        return {'question': v[0], 'answer': v[1], 'keywords': v[2]}
    if isinstance(v, list):
        return [_fix_item(item, kind) for item in v]
    if isinstance(v, dict):
        return {k: _fix_item(val, k if k in ('mcq','very_short_1mark','short_2mark','evaluation_4mark','explanatory_8mark') else 'other') for k, val in v.items()}
    return v

def generate(gen_name, ch_id, ch_name, order, topics):
    """Generate a seed file for a chapter.
    
    gen_name: eg 'chapter3', used for filename
    ch_id: eg 'chapter3'
    ch_name: Bengali chapter name
    order: chapter number (3, 4, etc.)
    topics: list of dicts, each dict is topic data
    """
    # Convert quiz entries from list to map format for Firestore compatibility
    topics = [_fix_item(t, 'topic') for t in topics]
    total = len(topics)
    
    # Build topic switch
    switch_lines = []
    for i, td in enumerate(topics, 1):
        switch_lines.append(f"      {i} => t{i}(),")
    switch_str = '\n'.join(switch_lines)
    
    header = HEADER.format(
        ch=gen_name,
        ch_name=ch_name,
        ch_id=ch_id,
        order=order,
        totalTopics=total,
        topic_switch=switch_str,
    )
    
    filename = f'scripts/seed_{gen_name}_all.dart'
    with open(filename, 'w') as f:
        f.write(header)
        for i, td in enumerate(topics, 1):
            f.write(f"Map<String, dynamic> t{i}() {{\n")
            f.write("  return ")
            f.write(serialize(td, 1))
            f.write(";\n}\n\n")
            print(f"  Wrote topic {i}: {td['name']}")
    
    lines = sum(1 for _ in open(filename))
    print(f"Wrote {filename} ({lines} lines, {total} topics)")
    return filename
