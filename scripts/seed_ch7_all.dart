// Run: dart run scripts/seed_ch7_all.dart
// Seeds Chapter 7 (জাতিসংঘ) topics into Firestore

import 'dart:convert';
import 'dart:io';

const projectId = 'prime-school-de654';
const apiKey = 'AIzaSyDb1mxA6PusHx1f8uhxKMKoVIVGMuykIIE';
const baseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

Future<void> main() async {
  print('Seeding Chapter 7...\n');
  final chaptersBase = 'content/history/chapters';
  final base = '$chaptersBase/chapter7/topics';

  await patchDoc('$chaptersBase/chapter7', {
    'id': 'chapter7',
    'subjectId': 'history',
    'name': 'জাতিসংঘ (United Nations)',
    'order': 7,
    'totalTopics': 3,
  });

  await patchDoc('$base/chapter7_topic_1', t1());
  await patchDoc('$base/chapter7_topic_2', t2());
  await patchDoc('$base/chapter7_topic_3', t3());

  print('\nDone! Chapter 7 seeded successfully.');
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

Map<String, dynamic> t1() {
  return {
    'id': 'chapter7_topic_1',
    'chapterId': 'chapter7',
    'subjectId': 'history',
    'name': 'জাতিসংঘ প্রতিষ্ঠা ও গঠনতন্ত্র',
    'order': 1,
    'summary': 'দ্বিতীয় বিশ্বযুদ্ধের পর ১৯৪৫ সালে জাতিসংঘ (United Nations) প্রতিষ্ঠিত হয়। এর লক্ষ্য: আন্তর্জাতিক শান্তি ও নিরাপত্তা বজায় রাখা, জাতিসমূহের মধ্যে বন্ধুত্বপূর্ণ সম্পর্ক গড়ে তোলা, দারিদ্র্য মোচন ও মানবাধিকার সুরক্ষা। প্রধান অঙ্গ: সাধারণ পরিষদ, নিরাপত্তা পরিষদ, সচিবালয়, আন্তর্জাতিক ন্যায়বিচার আদালত, অর্থনৈতিক ও সামাজিক পরিষদ। নিরাপত্তা পরিষদের ৫ স্থায়ী সদস্যের (চীন, ফ্রান্স, রাশিয়া, ব্রিটেন, যুক্তরাষ্ট্র) ভেটো ক্ষমতা রয়েছে। লীগ অফ নেশনস-এর ব্যর্থতা থেকে শিক্ষা নিয়ে জাতিসংঘ অধিক কার্যকর কাঠামো নিয়ে প্রতিষ্ঠিত হয়।',
    'simple_breakdown': [
      '১৯৪৫ সালে জাতিসংঘ প্রতিষ্ঠিত',
      'লক্ষ্য: শান্তি, নিরাপত্তা ও মানবাধিকার',
      'সাধারণ পরিষদ: সব সদস্য রাষ্ট্রের সমাবেশ',
      'নিরাপত্তা পরিষদ: শান্তি ও নিরাপত্তার প্রধান দায়িত্ব',
      '৫ স্থায়ী সদস্যের ভেটো ক্ষমতা আছে',
      'সচিবালয়: জাতিসংঘের প্রশাসনিক অঙ্গ',
      'আন্তর্জাতিক ন্যায়বিচার আদালত (ICJ)',
      'লীগ অফ নেশনস-এর ব্যর্থতা থেকে শিক্ষা',
    ],
    'real_life_example': 'তোমাদের ক্লাসে যদি একজন সভাপতি থাকে, আর সবাই মিলে সমস্যার সমাধান করে, তাহলে সেটা অনেকটাই জাতিসংঘের মতো। শুধু পার্থক্য হলো, জাতিসংঘে বিশ্বের প্রায় সব দেশই সদস্য, আর তারা মিলে সিদ্ধান্ত নেয় কীভাবে যুদ্ধ বন্ধ করা যায়, কিভাবে দরিদ্র দেশগুলোকে সাহায্য করা যায়।',
    'key_terms': [
      {'term': 'জাতিসংঘ (UN)', 'meaning': '১৯৪৫ সালে প্রতিষ্ঠিত আন্তর্জাতিক সংস্থা', 'example': '১৯৩টি সদস্য রাষ্ট্র'},
      {'term': 'নিরাপত্তা পরিষদ', 'meaning': 'শান্তি ও নিরাপত্তার জন্য দায়ী জাতিসংঘ অঙ্গ', 'example': '৫ স্থায়ী সদস্য'},
      {'term': 'ভেটো ক্ষমতা', 'meaning': 'গুরুত্বপূর্ণ সিদ্ধান্তে স্থায়ী সদস্যের একক বাধাদানের ক্ষমতা', 'example': 'যুক্তরাষ্ট্রের ভেটো'},
      {'term': 'সাধারণ পরিষদ', 'meaning': 'সকল সদস্য দেশের সমাবেশ', 'example': 'বার্ষিক অধিবেশন'},
      {'term': 'আন্তর্জাতিক ন্যায়বিচার আদালত', 'meaning': 'জাতিসংঘের প্রধান বিচারিক অঙ্গ', 'example': 'হেগ, নেদারল্যান্ডস'},
    ],
    'timeline': [
      {'date': '২৬ জুন ১৯৪৫', 'event': 'সান ফ্রান্সিসকো সম্মেলনে জাতিসংঘ সনদ স্বাক্ষর', 'significance': 'জাতিসংঘের প্রতিষ্ঠা'},
      {'date': '২৪ অক্টোবর ১৯৪৫', 'event': 'জাতিসংঘ আনুষ্ঠানিকভাবে প্রতিষ্ঠিত', 'significance': 'জাতিসংঘ দিবস'},
      {'date': '১৯৪৬', 'event': 'প্রথম সাধারণ পরিষদ অধিবেশন', 'significance': 'কার্যক্রম শুরু'},
    ],
    'cause_effect': [],
    'important_personalities': [
      {'name': 'ফ্রাঙ্কলিন রুজভেল্ট', 'title': 'মার্কিন প্রেসিডেন্ট', 'contribution': 'জাতিসংঘ প্রতিষ্ঠায় গুরুত্বপূর্ণ ভূমিকা', 'exam_importance': 'জাতিসংঘের অন্যতম স্থপতি'},
    ],
    'quiz': {
      'mcq': [
        {'question': 'জাতিসংঘ কবে প্রতিষ্ঠিত হয়?', 'options': ['১৯৪৪', '১৯৪৫', '১৯৪৬', '১৯৪৭'], 'correctIndex': 1, 'marks': 1, 'explanation': '২৪ অক্টোবর ১৯৪৫ জাতিসংঘ প্রতিষ্ঠিত হয়', 'difficulty': 'easy'},
        {'question': 'জাতিসংঘের প্রধান লক্ষ্য কী?', 'options': ['বাণিজ্য সম্প্রসারণ', 'আন্তর্জাতিক শান্তি ও নিরাপত্তা', 'পরিবেশ রক্ষা', 'শিক্ষা প্রসার'], 'correctIndex': 1, 'marks': 1, 'explanation': 'শান্তি ও নিরাপত্তা বজায় রাখা জাতিসংঘের প্রধান লক্ষ্য', 'difficulty': 'easy'},
        {'question': 'নিরাপত্তা পরিষদের কয়টি স্থায়ী সদস্য?', 'options': ['৩', '৪', '৫', '৬'], 'correctIndex': 2, 'marks': 1, 'explanation': '৫টি স্থায়ী সদস্য: চীন, ফ্রান্স, রাশিয়া, ব্রিটেন, যুক্তরাষ্ট্র', 'difficulty': 'medium'},
        {'question': 'ভেটো ক্ষমতা কী?', 'options': ['সাধারণ সদস্যের ভোট', 'স্থায়ী সদস্যের বাধাদানের ক্ষমতা', 'সচিবালয়ের ক্ষমতা', 'সাধারণ পরিষদের ক্ষমতা'], 'correctIndex': 1, 'marks': 1, 'explanation': 'ভেটো ক্ষমতা নিরাপত্তা পরিষদের স্থায়ী সদস্যদের বিশেষ অধিকার', 'difficulty': 'medium'},
        {'question': 'লীগ অফ নেশনস থেকে জাতিসংঘের পার্থক্য কী?', 'options': ['কোনো পার্থক্য নেই', 'অধিক কার্যকর কাঠামো ও ভেটো ক্ষমতা', 'ছোট সংস্থা', 'কম সদস্য'], 'correctIndex': 1, 'marks': 1, 'explanation': 'জাতিসংঘ লীগ অফ নেশনস-এর ব্যর্থতা থেকে শিক্ষা নিয়ে গঠিত', 'difficulty': 'medium'},
        {'question': 'আন্তর্জাতিক ন্যায়বিচার আদালত কোথায় অবস্থিত?', 'options': ['নিউ ইয়র্ক', 'হেগ', 'প্যারিস', 'লন্ডন'], 'correctIndex': 1, 'marks': 1, 'explanation': 'আইসিজে নেদারল্যান্ডসের হেগে অবস্থিত', 'difficulty': 'medium'},
        {'question': 'জাতিসংঘ সনদ কবে স্বাক্ষরিত হয়?', 'options': ['২৪ অক্টোবর ১৯৪৫', '২৬ জুন ১৯৪৫', '১ জানুয়ারি ১৯৪৬', '৮ মে ১৯৪৫'], 'correctIndex': 1, 'marks': 1, 'explanation': '২৬ জুন ১৯৪৫ সান ফ্রান্সিসকো সম্মেলনে সনদ স্বাক্ষরিত হয়', 'difficulty': 'hard'},
      ],
      'very_short_1mark': [
        {'question': 'জাতিসংঘ কবে প্রতিষ্ঠিত?', 'answer': '১৯৪৫'},
        {'question': 'জাতিসংঘের লক্ষ্য?', 'answer': 'শান্তি ও নিরাপত্তা'},
        {'question': 'নিরাপত্তা পরিষদের স্থায়ী সদস্য সংখ্যা?', 'answer': '৫'},
        {'question': 'ভেটো ক্ষমতা কার?', 'answer': 'স্থায়ী সদস্যদের'},
        {'question': 'আইসিজে কোথায়?', 'answer': 'হেগ'},
      ],
      'short_2mark': [],
      'evaluation_4mark': [],
      'explanatory_8mark': [],
    },
  };
}

Map<String, dynamic> t2() {
  return {
    'id': 'chapter7_topic_2',
    'chapterId': 'chapter7',
    'subjectId': 'history',
    'name': 'জাতিসংঘের কার্যক্রম ও সংস্থা',
    'order': 2,
    'summary': 'জাতিসংঘ বিভিন্ন অঙ্গ সংস্থার মাধ্যমে কাজ করে: UNICEF (শিশু কল্যাণ), WHO (স্বাস্থ্য), UNESCO (শিক্ষা ও সংস্কৃতি), ILO (শ্রম অধিকার), UNDP (উন্নয়ন), UNHCR (শরণার্থী), FAO (খাদ্য), IMF ও বিশ্বব্যাংক (অর্থনীতি)। শান্তিরক্ষা মিশনে জাতিসংগ নীল শিরস্ত্রাণ বাহিনী (Blue Helmets) বিভিন্ন সংঘাতপূর্ণ অঞ্চলে কাজ করে। মানবাধিকার ঘোষণা (Universal Declaration of Human Rights, ১৯৪৮) মানবাধিকারের আন্তর্জাতিক মান নির্ধারণ করে। জাতিসংঘের মিলেনিয়াম ডেভেলপমেন্ট গোলস (MDGs) ও সাসটেইনেবল ডেভেলপমেন্ট গোলস (SDGs) উন্নয়নের বৈশ্বিক লক্ষ্য নির্ধারণ করে।',
    'simple_breakdown': [
      'UNICEF: শিশু কল্যাণ ও শিক্ষা',
      'WHO: বিশ্ব স্বাস্থ্য',
      'UNESCO: শিক্ষা, বিজ্ঞান ও সংস্কৃতি',
      'ILO: শ্রমিক অধিকার ও ন্যায্য কাজ',
      'UNDP: উন্নয়ন কর্মসূচি',
      'UNHCR: শরণার্থী সুরক্ষা',
      'FAO: খাদ্য ও কৃষি',
      'IMF ও বিশ্বব্যাংক: অর্থনৈতিক সহযোগিতা',
      'শান্তিরক্ষা মিশন (Blue Helmets)',
      'মানবাধিকার ঘোষণা (১৯৪৮)',
      'SDGs: টেকসই উন্নয়ন লক্ষ্যমাত্রা',
    ],
    'real_life_example': 'তোমরা কি জানো, তোমাদের স্কুলে যাওয়া, টিকা নেওয়া, এমনকি খেলার মাঠেও জাতিসংঘের সংস্থাগুলোর ভূমিকা আছে? UNICEF শিশুদের শিক্ষা নিশ্চিত করে, WHO টিকা দিয়ে রোগ প্রতিরোধ করে, আর UNESCO বিশ্ব ঐতিহ্য রক্ষা করে।',
    'key_terms': [
      {'term': 'UNICEF', 'meaning': 'জাতিসংঘ শিশু তহবিল', 'example': 'শিশু শিক্ষা ও স্বাস্থ্য'},
      {'term': 'WHO', 'meaning': 'বিশ্ব স্বাস্থ্য সংস্থা', 'example': 'কোভিড-১৯ মহামারী মোকাবিলা'},
      {'term': 'UNESCO', 'meaning': 'জাতিসংঘ শিক্ষা, বিজ্ঞান ও সংস্কৃতি সংস্থা', 'example': 'বিশ্ব ঐতিহ্য তালিকা'},
      {'term': 'UNHCR', 'meaning': 'জাতিসংঘ শরণার্থী সংস্থা', 'example': 'শরণার্থী সুরক্ষা'},
      {'term': 'IMF', 'meaning': 'আন্তর্জাতিক মুদ্রা তহবিল', 'example': 'অর্থনৈতিক সহায়তা'},
      {'term': 'শান্তিরক্ষা মিশন', 'meaning': 'সংঘাতপূর্ণ এলাকায় জাতিসংঘের শান্তি বাহিনী', 'example': 'Blue Helmets'},
      {'term': 'মানবাধিকার ঘোষণা', 'meaning': '১৯৪৮ সালের সার্বজনীন মানবাধিকার ঘোষণা', 'example': '৩০টি মানবাধিকার'},
    ],
    'timeline': [
      {'date': '১৯৪৮', 'event': 'মানবাধিকার সার্বজনীন ঘোষণা', 'significance': 'মানবাধিকারের আন্তর্জাতিক মান'},
      {'date': '১৯৫৩', 'event': 'WHO পোলিও ভ্যাকসিন চালু', 'significance': 'বৈশ্বিক স্বাস্থ্য'},
      {'date': '২০০০', 'event': 'মিলেনিয়াম ডেভেলপমেন্ট গোলস (MDGs)', 'significance': 'উন্নয়নের লক্ষ্য'},
      {'date': '২০১৫', 'event': 'সাসটেইনেবল ডেভেলপমেন্ট গোলস (SDGs)', 'significance': 'টেকসই উন্নয়ন লক্ষ্য'},
    ],
    'cause_effect': [],
    'important_personalities': [],
    'quiz': {
      'mcq': [
        {'question': 'UNICEF কী?', 'options': ['স্বাস্থ্য সংস্থা', 'শিশু তহবিল', 'শিক্ষা সংস্থা', 'শ্রম সংস্থা'], 'correctIndex': 1, 'marks': 1, 'explanation': 'UNICEF জাতিসংঘ শিশু তহবিল', 'difficulty': 'easy'},
        {'question': 'WHO কী করে?', 'options': ['শিশু অধিকার', 'বিশ্ব স্বাস্থ্য নিয়ন্ত্রণ', 'শিক্ষা প্রসার', 'শরণার্থী সুরক্ষা'], 'correctIndex': 1, 'marks': 1, 'explanation': 'WHO বিশ্ব স্বাস্থ্য সংস্থা', 'difficulty': 'easy'},
        {'question': 'UNESCO কী সুরক্ষা করে?', 'options': ['শিশু অধিকার', 'বিশ্ব ঐতিহ্য ও সংস্কৃতি', 'স্বাস্থ্য', 'শ্রমিক অধিকার'], 'correctIndex': 1, 'marks': 1, 'explanation': 'UNESCO শিক্ষা, বিজ্ঞান, সংস্কৃতি ও বিশ্ব ঐতিহ্য রক্ষা করে', 'difficulty': 'easy'},
        {'question': 'মানবাধিকার সার্বজনীন ঘোষণা কবে গৃহীত হয়?', 'options': ['১৯৪৫', '১৯৪৮', '১৯৫০', '১৯৬০'], 'correctIndex': 1, 'marks': 1, 'explanation': '১৯৪৮ সালে মানবাধিকার সার্বজনীন ঘোষণা গৃহীত হয়', 'difficulty': 'medium'},
        {'question': 'শান্তিরক্ষা মিশনে জাতিসংঘের বাহিনী কী নামে পরিচিত?', 'options': ['Red Cross', 'Blue Helmets', 'Green Berets', 'White Helmets'], 'correctIndex': 1, 'marks': 1, 'explanation': 'Blue Helmets (নীল শিরস্ত্রাণ) জাতিসংঘের শান্তিরক্ষা বাহিনী', 'difficulty': 'medium'},
      ],
      'very_short_1mark': [
        {'question': 'UNICEF কী?', 'answer': 'শিশু তহবিল'},
        {'question': 'WHO কী?', 'answer': 'বিশ্ব স্বাস্থ্য সংস্থা'},
        {'question': 'UNESCO কী?', 'answer': 'শিক্ষা ও সংস্কৃতি সংস্থা'},
        {'question': 'মানবাধিকার ঘোষণা কবে?', 'answer': '১৯৪৮'},
        {'question': 'শান্তিরক্ষা বাহিনীর নাম?', 'answer': 'Blue Helmets'},
      ],
      'short_2mark': [],
      'evaluation_4mark': [],
      'explanatory_8mark': [],
    },
  };
}

Map<String, dynamic> t3() {
  return {
    'id': 'chapter7_topic_3',
    'chapterId': 'chapter7',
    'subjectId': 'history',
    'name': 'জাতিসংঘের সমালোচনা ও ভবিষ্যৎ',
    'order': 3,
    'summary': 'জাতিসংঘের সমালোচনা: নিরাপত্তা পরিষদের গঠন অগণতান্ত্রিক (৫ স্থায়ী সদস্যের ভেটো ক্ষমতা), দ্বিতীয় বিশ্বযুদ্ধের বিজয়ীদের স্বার্থ প্রতিফলিত করে। বড় শক্তির রাজনৈতিক চাপে জাতিসংঘ প্রায়ই নিষ্ক্রিয় থাকে। জাতিসংঘের সংস্কারের দাবি — নিরাপত্তা পরিষদে ভারত, ব্রাজিল, জার্মানি, জাপানের মতো দেশের স্থায়ী আসন প্রয়োজন। জলবায়ু পরিবর্তন, দারিদ্র্য, সন্ত্রাসবাদ, মহামারীর মতো বৈশ্বিক সমস্যা মোকাবিলায় জাতিসংঘের ভূমিকা গুরুত্বপূর্ণ হলেও অপর্যাপ্ত। ভবিষ্যতে জাতিসংঘকে আরও কার্যকর, গণতান্ত্রিক ও স্বচ্ছ হতে হবে।',
    'simple_breakdown': [
      'নিরাপত্তা পরিষদ অগণতান্ত্রিক — ভেটো ক্ষমতা ৫ দেশের',
      'বড় শক্তির রাজনীতির প্রভাব বেশি',
      'সংস্কার প্রয়োজন: স্থায়ী আসন সম্প্রসারণ',
      'জলবায়ু পরিবর্তন জাতিসংঘের গুরুত্বপূর্ণ এজেন্ডা',
      'দারিদ্র্য মোচনে জাতিসংঘের ভূমিকা সীমিত',
      'সন্ত্রাসবাদ ও মহামারী নতুন চ্যালেঞ্জ',
      'আরও কার্যকর ও গণতান্ত্রিক জাতিসংঘ প্রয়োজন',
    ],
    'real_life_example': '',
    'key_terms': [
      {'term': 'নিরাপত্তা পরিষদ সংস্কার', 'meaning': 'ভারত-ব্রাজিল-জার্মানি-জাপানের স্থায়ী আসনের দাবি', 'example': 'G4 গ্রুপ'},
    ],
    'timeline': [],
    'cause_effect': [],
    'important_personalities': [],
    'quiz': {
      'mcq': [
        {'question': 'জাতিসংঘের প্রধান সমালোচনা কী?', 'options': ['অতিরিক্ত শক্তিশালী', 'নিরাপত্তা পরিষদ অগণতান্ত্রিক', 'অর্থের অভাব', 'কর্মীসংকট'], 'correctIndex': 1, 'marks': 1, 'explanation': 'নিরাপত্তা পরিষদের ৫ স্থায়ী সদস্যের ভেটো ক্ষমতা অগণতান্ত্রিক', 'difficulty': 'medium'},
        {'question': 'জাতিসংঘের সংস্কারের দাবিতে কোন গ্রুপ সক্রিয়?', 'options': ['G7', 'G4 (ভারত-ব্রাজিল-জার্মানি-জাপান)', 'NATO', 'OPEC'], 'correctIndex': 1, 'marks': 1, 'explanation': 'G4 দেশগুলো নিরাপত্তা পরিষদে স্থায়ী আসন চায়', 'difficulty': 'hard'},
        {'question': 'জাতিসংঘের ভবিষ্যৎ চ্যালেঞ্জ কী?', 'options': ['শুধু যুদ্ধ', 'জলবায়ু পরিবর্তন, দারিদ্র্য, সন্ত্রাসবাদ, মহামারী', 'শুধু অর্থনীতি', 'শুধু শিক্ষা'], 'correctIndex': 1, 'marks': 1, 'explanation': 'জাতিসংঘকে বহুমাত্রিক চ্যালেঞ্জ মোকাবিলা করতে হবে', 'difficulty': 'medium'},
      ],
      'very_short_1mark': [
        {'question': 'জাতিসংঘের প্রধান সমালোচনা?', 'answer': 'নিরাপত্তা পরিষদ অগণতান্ত্রিক'},
        {'question': 'G4 গ্রুপ কী চায়?', 'answer': 'স্থায়ী আসন'},
        {'question': 'জাতিসংঘের ভবিষ্যৎ চ্যালেঞ্জ?', 'answer': 'জলবায়ু, দারিদ্র্য সন্ত্রাস'},
      ],
      'short_2mark': [],
      'evaluation_4mark': [],
      'explanatory_8mark': [],
    },
  };
}
