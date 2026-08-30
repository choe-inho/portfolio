import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase 초기화 실패(무시): $e');
  }

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('환경변수 로드 실패(무시): $e');
  }

  runApp(const ProviderScope(child: Portfolio()));
}
