import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<Map<String, dynamic>> getProgress(String subjectId) async {
    final uid = _userId;
    if (uid == null) return _defaultProgress();
    try {
      final doc = await _firestore
          .collection('progress')
          .doc(uid)
          .collection(subjectId)
          .doc('main')
          .get();
      if (!doc.exists) return _defaultProgress();
      final data = doc.data()!;
      data['completedTopics'] =
          List<String>.from(data['completedTopics'] ?? []);
      return data;
    } catch (_) {
      return _loadLocalProgress(subjectId);
    }
  }

  Map<String, dynamic> _defaultProgress() => {
        'completedTopics': <String>[],
        'challengeStats': {'easy': 0, 'medium': 0, 'hard': 0},
        'streak': 0,
        'lastStudyDate': null,
      };

  Future<void> markTopicComplete(String subjectId, String topicId) async {
    final uid = _userId;
    if (uid == null) return;

    final docRef = _firestore
        .collection('progress')
        .doc(uid)
        .collection(subjectId)
        .doc('main');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        transaction.set(docRef, {
          'completedTopics': [topicId],
          'challengeStats': {'easy': 0, 'medium': 0, 'hard': 0},
          'streak': 1,
          'lastStudyDate': today,
        });
        return;
      }
      final data = doc.data()!;
      final completed = List<String>.from(data['completedTopics'] ?? []);
      if (!completed.contains(topicId)) {
        completed.add(topicId);
      }
      transaction.update(docRef, {'completedTopics': completed});
    });

    await _saveLocalProgress(subjectId, topicId: topicId);
  }

  Future<void> updateChallengeStat(
      String subjectId, String difficulty) async {
    final uid = _userId;
    if (uid == null) return;

    final docRef = _firestore
        .collection('progress')
        .doc(uid)
        .collection(subjectId)
        .doc('main');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        final stats = {'easy': 0, 'medium': 0, 'hard': 0};
        stats[difficulty] = 1;
        transaction.set(docRef, {
          'completedTopics': <String>[],
          'challengeStats': stats,
          'streak': 1,
          'lastStudyDate': today,
        });
        return;
      }
      final data = doc.data()!;
      final stats =
          Map<String, dynamic>.from(data['challengeStats'] ?? {});
      stats[difficulty] = (stats[difficulty] as int? ?? 0) + 1;
      transaction.update(docRef, {'challengeStats': stats});
    });
  }

  Future<void> updateStreak(String subjectId) async {
    final uid = _userId;
    if (uid == null) return;

    final docRef = _firestore
        .collection('progress')
        .doc(uid)
        .collection(subjectId)
        .doc('main');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        transaction.set(docRef, {
          'completedTopics': <String>[],
          'challengeStats': {'easy': 0, 'medium': 0, 'hard': 0},
          'streak': 1,
          'lastStudyDate': today,
        });
        return;
      }
      final data = doc.data()!;
      final lastRaw = data['lastStudyDate'];
      DateTime lastDay;
      if (lastRaw is Timestamp) {
        lastDay = lastRaw.toDate();
      } else if (lastRaw is String) {
        lastDay = DateTime.parse(lastRaw);
      } else {
        lastDay = today.subtract(const Duration(days: 2));
      }
      lastDay = DateTime(lastDay.year, lastDay.month, lastDay.day);
      final diff = today.difference(lastDay).inDays;

      if (diff == 0) return;

      final newStreak = diff == 1 ? (data['streak'] as int? ?? 0) + 1 : 1;

      transaction.update(docRef, {
        'streak': newStreak,
        'lastStudyDate': today,
      });
    });
  }

  Future<Map<String, dynamic>> _loadLocalProgress(String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'completedTopics':
          prefs.getStringList('${subjectId}_completed') ?? [],
      'challengeStats': {
        'easy': prefs.getInt('${subjectId}_challenge_easy') ?? 0,
        'medium': prefs.getInt('${subjectId}_challenge_medium') ?? 0,
        'hard': prefs.getInt('${subjectId}_challenge_hard') ?? 0,
      },
      'streak': prefs.getInt('${subjectId}_streak') ?? 0,
      'lastStudyDate': prefs.getString('${subjectId}_last_study_date'),
    };
  }

  Future<void> _saveLocalProgress(String subjectId,
      {String? topicId}) async {
    final prefs = await SharedPreferences.getInstance();
    if (topicId != null) {
      final list = prefs.getStringList('${subjectId}_completed') ?? [];
      if (!list.contains(topicId)) {
        list.add(topicId);
        await prefs.setStringList('${subjectId}_completed', list);
      }
    }
  }
}
