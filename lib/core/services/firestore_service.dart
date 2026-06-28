import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firebase_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/topic_model.dart';
import '../../data/models/progress_model.dart';
import '../../data/models/exam_bank_model.dart';
import '../../data/models/settings_model.dart';
import '../../data/models/routine_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Operations
  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .update(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // Content Operations
  Future<List<ChapterModel>> getChapters(String subjectId) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.contentCollection)
        .doc(subjectId)
        .collection('chapters')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => ChapterModel.fromMap(doc.data()))
        .toList();
  }

  Future<List<TopicModel>> getTopics(String subjectId, String chapterId) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.contentCollection)
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .collection('topics')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => TopicModel.fromMap(doc.data()))
        .toList();
  }

  Future<Map<String, dynamic>> getTopicContent(
      String subjectId, String chapterId, String topicId) async {
    final doc = await _firestore
        .collection(FirebaseConstants.contentCollection)
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .collection('topics')
        .doc(topicId)
        .get();

    return doc.data() ?? {};
  }

  // Progress Operations
  Future<void> updateProgress(ProgressModel progress) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(progress.userId)
        .collection(FirebaseConstants.progressCollection)
        .doc('main')
        .set(progress.toMap());
  }

  Future<ProgressModel?> getProgress(String userId) async {
    final doc = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.progressCollection)
        .doc('main')
        .get();

    if (!doc.exists) return null;
    return ProgressModel.fromMap(doc.data()!);
  }

  // Exam Bank Operations
  Future<void> saveToExamBank(ExamBankModel item) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(item.question.topicId.split('_').first)
        .collection(FirebaseConstants.examBankCollection)
        .doc(item.id)
        .set(item.toMap());
  }

  Future<List<ExamBankModel>> getExamBank(String userId,
      {String? subjectId, String? type}) async {
    Query query = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.examBankCollection);

    if (subjectId != null) {
      query = query.where('subjectId', isEqualTo: subjectId);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ExamBankModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> removeFromExamBank(String userId, String itemId) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.examBankCollection)
        .doc(itemId)
        .delete();
  }

  // Settings Operations
  Future<void> updateSettings(SettingsModel settings) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(settings.userId)
        .collection(FirebaseConstants.settingsCollection)
        .doc('main')
        .set(settings.toMap());
  }

  Future<SettingsModel?> getSettings(String userId) async {
    final doc = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.settingsCollection)
        .doc('main')
        .get();

    if (!doc.exists) return null;
    return SettingsModel.fromMap(doc.data()!);
  }

  // Routine Operations
  Future<void> updateRoutine(String userId, List<RoutineModel> routines) async {
    final batch = _firestore.batch();
    final collection = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.routineCollection);

    for (final routine in routines) {
      batch.set(collection.doc(routine.id), routine.toMap());
    }
    await batch.commit();
  }

  Future<List<RoutineModel>> getRoutine(String userId) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.routineCollection)
        .get();

    return snapshot.docs
        .map((doc) => RoutineModel.fromMap(doc.data()))
        .toList();
  }

  // Tech Side Operations
  Future<List<Map<String, dynamic>>> getTechRoadmap(String subjectId) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.techCollection)
        .doc(subjectId)
        .collection('roadmap')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>> getTechTopicContent(
      String subjectId, String topicId) async {
    final doc = await _firestore
        .collection(FirebaseConstants.techCollection)
        .doc(subjectId)
        .collection('topics')
        .doc(topicId)
        .get();

    return doc.data() ?? {};
  }
}
