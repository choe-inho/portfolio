import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:portfolio/Portfolio.dart';
import 'package:portfolio/controller/About_Me_Controller.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'firebase_options.dart';
import 'Error_Fall_Back_Web.dart';

void main() async{
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeWeb();

    // GetX 컨트롤러 초기화
    _initializeControllers();

    runApp(const Portfolio());
  }catch(e, stackTrace){
    debugPrint('❌ [Main] 앱 초기화 실패: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(const ErrorFallBackWeb());
  }
}


///초기화 정의 클래스
class InitStep{
  final String name;
  final Future<void> Function() function;
  const InitStep(this.name, this.function);
}

Future<void> _initializeWeb() async{
  try{
    debugPrint('🚀 [Main] 포트폴리오 초기화 시작...');

    final steps = [
      InitStep('웹 세로모드 고정', _initializeWebSettings),
      InitStep('파이어베이스 초기화', _initializeFirebase),
      InitStep('환경변수 초기화', _initializeEnv)
    ];

    for (final step in steps) {
      debugPrint('⏳ [Main] ${step.name} 중...');
      await step.function();
      debugPrint('✅ [Main] ${step.name} 완료');
    }
  }catch(e){
    debugPrint('❌ [Main] 초기화 실패: $e');
    rethrow;
  }
}

/// GetX 컨트롤러 초기화
void _initializeControllers() {
  debugPrint('🎮 [Main] GetX 컨트롤러 초기화 시작...');

  // AppController를 영구적으로 등록 (앱 전체에서 사용)
  // permanent: true로 설정하여 앱이 종료될 때까지 유지
  Get.put(AppController(), permanent: true);
  Get.put(AboutMeController(), permanent: true);

  debugPrint('✅ [Main] GetX 컨트롤러 초기화 완료');

  // AppController 초기화 확인
  try {
    final appController = Get.find<AppController>();
    debugPrint('✅ [Main] AppController 확인 완료 - device: ${appController.device.value}');
  } catch (e) {
    debugPrint('⚠️ [Main] AppController 확인 실패: $e');
  }
}

//파이어베이스 초기화
Future<void> _initializeFirebase() async{
  try{
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );

    debugPrint('✅ [Main] 파이어베이스 초기화 완료');
  } catch (e) {
    debugPrint('⚠️ [Main] 파이어베이스 초기화 실패 (무시됨): $e');
  }
}

//환경변수 초기화
Future<void> _initializeEnv() async{
  try{
    await dotenv.load(fileName: '.env');
    debugPrint('✅ [Main] 환경변수 초기화 완료');
  } catch (e) {
    debugPrint('⚠️ [Main] 환경변수 초기화 실패 (무시됨): $e');
  }
}

//웹 기본 설정 초기화
Future<void> _initializeWebSettings() async{
  try{
    // 시스템 UI 기본 설정
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    // 화면 방향 고정 (세로 모드)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    debugPrint('✅ [Main] 기본 설정 초기화 완료');
  } catch (e) {
    debugPrint('⚠️ [Main] 기본 설정 초기화 실패 (무시됨): $e');
  }
}