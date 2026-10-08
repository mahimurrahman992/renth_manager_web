import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  static const fallbackLocale = Locale('en', 'US');
  static final supportedLocales = [
    Locale('en', 'US'),
    Locale('bn', 'BD'),
  ];

  static Map<String, Map<String, String>> _translations = {};

  /// Load translations before app starts
  static Future<void> init() async {
    _translations = {
      'en_US': await _loadTranslation('en'),
      'bn_BD': await _loadTranslation('bn'),
    };
  }

  static Future<Map<String, String>> _loadTranslation(String lang) async {
    final data = await rootBundle.loadString('assets/lang/$lang.json');
    final json = jsonDecode(data) as Map<String, dynamic>;
    return json.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;

  static void changeLocale(String langCode) {
    final locale = supportedLocales.firstWhere((locale) => locale.languageCode == langCode);
    Get.updateLocale(locale);
  }
}
