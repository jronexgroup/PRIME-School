import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  DocumentReference _docRef(String subjectId) {
    final uid = _userId;
    if (uid == null) throw Exception('User not logged in');
    return _firestore
        .collection('progress')
        .doc(uid)
        .collection(subjectId)
        .doc('main');
  }

  Future<Map<String, dynamic>> getProgress(String subjectId) async {
    final uid = _userId;
    if (uid == null) return _defaultProgress();
    try {
      final doc = await _docRef(subjectId).get();
      if (!doc.exists) return _defaultProgress();
      final data = doc.data();
      if (data is Map<String, dynamic>) return data;
      return _defaultProgress();
    } catch (_) {
      return _defaultProgress();
    }
  }

  Map<String, dynamic> _defaultProgress() => {
        'completedChallenges': <String>[],
        'completedTopics': <String>[],
        'completedChapters': <String>[],
        'challengeStats': {'easy': 0, 'medium': 0, 'hard': 0},
        'streak': 0,
        'lastStudyDate': null,
      };

  Future<void> markChallengeComplete(String subjectId, String challengeId, String difficulty) async {
    final uid = _userId;
    if (uid == null) return;

    final docRef = _docRef(subjectId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        final stats = {'easy': 0, 'medium': 0, 'hard': 0};
        stats[difficulty] = (stats[difficulty] as int) + 1;
        transaction.set(docRef, {
          'completedChallenges': [challengeId],
          'completedTopics': <String>[],
          'completedChapters': <String>[],
          'challengeStats': stats,
          'streak': 1,
          'lastStudyDate': today,
        });
        return;
      }
      final raw = doc.data();
      if (raw is! Map<String, dynamic>) return;
      final data = raw;
      final completedChallenges = List<String>.from(data['completedChallenges'] ?? []);
      if (!completedChallenges.contains(challengeId)) {
        completedChallenges.add(challengeId);
      }

      final stats = Map<String, dynamic>.from(data['challengeStats'] ?? {});
      stats[difficulty] = (stats[difficulty] as int? ?? 0) + 1;

      transaction.update(docRef, {
        'completedChallenges': completedChallenges,
        'challengeStats': stats,
      });
    });
  }

  Future<void> markTopicComplete(String subjectId, String topicId) async {
    try {
      final docRef = _docRef(subjectId);
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) return;
        final raw = doc.data();
        if (raw is! Map<String, dynamic>) return;
        final completedTopics = List<String>.from(raw['completedTopics'] ?? []);
        if (!completedTopics.contains(topicId)) {
          completedTopics.add(topicId);
        }
        transaction.update(docRef, {'completedTopics': completedTopics});
      });
    } catch (_) {}
  }

  Future<void> markChapterComplete(String subjectId, String chapterId) async {
    try {
      final docRef = _docRef(subjectId);
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) return;
        final raw = doc.data();
        if (raw is! Map<String, dynamic>) return;
        final completedChapters = List<String>.from(raw['completedChapters'] ?? []);
        if (!completedChapters.contains(chapterId)) {
          completedChapters.add(chapterId);
        }
        transaction.update(docRef, {'completedChapters': completedChapters});
      });
    } catch (_) {}
  }

  Future<void> autoCompleteTopic(String subjectId, String topicId, List<String> topicChallengeIds) async {
    final uid = _userId;
    if (uid == null) return;

    final docRef = _docRef(subjectId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;
      final raw = doc.data();
      if (raw is! Map<String, dynamic>) return;
      final completedChallenges = List<String>.from(raw['completedChallenges'] ?? []);

      final allSolved = topicChallengeIds.every((cId) => completedChallenges.contains(cId));
      if (!allSolved) return;

      final completedTopics = List<String>.from(raw['completedTopics'] ?? []);
      if (!completedTopics.contains(topicId)) {
        completedTopics.add(topicId);
      }
      transaction.update(docRef, {'completedTopics': completedTopics});
    });
  }

  Future<void> autoCompleteChapter(String subjectId, String chapterId, List<String> chapterTopicIds) async {
    final uid = _userId;
    if (uid == null) return;

    final docRef = _docRef(subjectId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;
      final raw = doc.data();
      if (raw is! Map<String, dynamic>) return;
      final completedTopics = List<String>.from(raw['completedTopics'] ?? []);

      final allTopicsComplete = chapterTopicIds.every((tId) => completedTopics.contains(tId));
      if (!allTopicsComplete) return;

      final completedChapters = List<String>.from(raw['completedChapters'] ?? []);
      if (!completedChapters.contains(chapterId)) {
        completedChapters.add(chapterId);
      }
      transaction.update(docRef, {'completedChapters': completedChapters});
    });
  }

  Future<void> updateStreak(String subjectId) async {
    final uid = _userId;
    if (uid == null) return;

    final docRef = _docRef(subjectId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        transaction.set(docRef, {
          'completedChallenges': <String>[],
          'completedTopics': <String>[],
          'completedChapters': <String>[],
          'challengeStats': {'easy': 0, 'medium': 0, 'hard': 0},
          'streak': 1,
          'lastStudyDate': today,
        });
        return;
      }
      final raw = doc.data();
      if (raw is! Map<String, dynamic>) return;
      final data = raw;
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

  int countChapterTopicsCompleted(Map<String, dynamic> progress, String chapterId) {
    final completedTopics = List<String>.from(progress['completedTopics'] ?? []);
    return completedTopics.where((t) => t.startsWith(chapterId)).length;
  }

  bool isChapterComplete(Map<String, dynamic> progress, String chapterId, int totalTopics) {
    final completedTopics = List<String>.from(progress['completedTopics'] ?? []);
    final chapterTopics = completedTopics.where((t) => t.startsWith(chapterId)).length;
    return chapterTopics >= totalTopics;
  }
}
