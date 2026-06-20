import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _geminiKeys = [];
  List<String> _groqKeys = [];
  List<String> _sarvamKeys = [];
  String _cloudflareAccountId = '';
  String _cloudflareApiToken = '';
  String _cloudflareWorkerUrl = 'https://prime-school-api.jronex.workers.dev';
  bool _isLoading = false;

  List<String> get geminiKeys => _geminiKeys;
  List<String> get groqKeys => _groqKeys;
  List<String> get sarvamKeys => _sarvamKeys;
  String get cloudflareAccountId => _cloudflareAccountId;
  String get cloudflareApiToken => _cloudflareApiToken;
  String get cloudflareWorkerUrl => _cloudflareWorkerUrl;
  bool get isLoading => _isLoading;

  int get geminiKeysConfigured => _geminiKeys.where((k) => k.isNotEmpty).length;
  int get groqKeysConfigured => _groqKeys.where((k) => k.isNotEmpty).length;
  int get sarvamKeysConfigured => _sarvamKeys.where((k) => k.isNotEmpty).length;

  Future<void> loadKeys(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _firestore.collection('api_keys').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        _geminiKeys = List<String>.from(data['geminiKeys'] ?? []);
        _groqKeys = List<String>.from(data['groqKeys'] ?? []);
        _sarvamKeys = List<String>.from(data['sarvamKeys'] ?? []);
        _cloudflareAccountId = data['cloudflareAccountId'] ?? '';
        _cloudflareApiToken = data['cloudflareApiToken'] ?? '';
        _cloudflareWorkerUrl = data['cloudflareWorkerUrl'] ?? _cloudflareWorkerUrl;
      } else {
        _geminiKeys = ['', '', ''];
        _groqKeys = ['', ''];
        _sarvamKeys = ['', ''];
      }
    } catch (e) {
      _geminiKeys = ['', '', ''];
      _groqKeys = ['', ''];
      _sarvamKeys = ['', ''];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveKeys(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('api_keys').doc(userId).set({
        'geminiKeys': _geminiKeys,
        'groqKeys': _groqKeys,
        'sarvamKeys': _sarvamKeys,
        'cloudflareAccountId': _cloudflareAccountId,
        'cloudflareApiToken': _cloudflareApiToken,
        'cloudflareWorkerUrl': _cloudflareWorkerUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateGeminiKey(int index, String value) {
    if (index < _geminiKeys.length) {
      _geminiKeys[index] = value;
      notifyListeners();
    }
  }

  void updateGroqKey(int index, String value) {
    if (index < _groqKeys.length) {
      _groqKeys[index] = value;
      notifyListeners();
    }
  }

  void updateSarvamKey(int index, String value) {
    if (index < _sarvamKeys.length) {
      _sarvamKeys[index] = value;
      notifyListeners();
    }
  }

  void updateCloudflareAccountId(String value) {
    _cloudflareAccountId = value;
    notifyListeners();
  }

  void updateCloudflareApiToken(String value) {
    _cloudflareApiToken = value;
    notifyListeners();
  }

  void updateCloudflareWorkerUrl(String value) {
    _cloudflareWorkerUrl = value;
    notifyListeners();
  }

  void addGeminiKey() {
    _geminiKeys.add('');
    notifyListeners();
  }

  void removeGeminiKey(int index) {
    if (_geminiKeys.length > 1) {
      _geminiKeys.removeAt(index);
      notifyListeners();
    }
  }

  void addGroqKey() {
    _groqKeys.add('');
    notifyListeners();
  }

  void removeGroqKey(int index) {
    if (_groqKeys.length > 1) {
      _groqKeys.removeAt(index);
      notifyListeners();
    }
  }

  void addSarvamKey() {
    _sarvamKeys.add('');
    notifyListeners();
  }

  void removeSarvamKey(int index) {
    if (_sarvamKeys.length > 1) {
      _sarvamKeys.removeAt(index);
      notifyListeners();
    }
  }

  List<String> get activeGeminiKeys => _geminiKeys.where((k) => k.isNotEmpty).toList();
  List<String> get activeGroqKeys => _groqKeys.where((k) => k.isNotEmpty).toList();
  List<String> get activeSarvamKeys => _sarvamKeys.where((k) => k.isNotEmpty).toList();
}
