// lib/service/Image_Upload_Service.dart
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

/// Firebase Storage 이미지 업로드 서비스
class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // 최대 파일 크기 (500KB)
  static const int maxFileSize = 500 * 1024; // 500KB in bytes

  // 허용 이미지 확장자
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp'
  ];

  /// 이미지 선택 및 검증
  ///
  /// Returns: 선택된 이미지 데이터와 확장자
  Future<Map<String, dynamic>?> pickImage() async {
    try {
      debugPrint('🖼️ [ImageUploadService] 이미지 선택 시작...');

      // 이미지 선택
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920, // 최대 너비 제한
        maxHeight: 1080, // 최대 높이 제한
        imageQuality: 85, // 품질 85%
      );

      if (image == null) {
        debugPrint('⚠️ [ImageUploadService] 이미지 선택 취소');
        return null;
      }

      debugPrint('✅ [ImageUploadService] 이미지 선택 완료: ${image.name}');

      // 파일 확장자 확인
      final extension = image.name.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        throw Exception(
            '지원하지 않는 파일 형식입니다.\n'
                '허용 형식: ${allowedExtensions.join(", ")}'
        );
      }

      // 파일 크기 확인
      final bytes = await image.readAsBytes();
      final fileSize = bytes.length;

      debugPrint('📊 [ImageUploadService] 파일 크기: ${_formatFileSize(fileSize)}');

      if (fileSize > maxFileSize) {
        throw Exception(
            '파일 크기가 너무 큽니다.\n'
                '현재: ${_formatFileSize(fileSize)}\n'
                '최대: ${_formatFileSize(maxFileSize)}\n\n'
                '이미지를 압축하거나 크기를 줄여주세요.'
        );
      }

      debugPrint('✅ [ImageUploadService] 이미지 검증 완료');

      return {
        'bytes': bytes,
        'extension': extension,
        'fileName': image.name,
        'fileSize': fileSize,
      };
    } catch (e) {
      debugPrint('❌ [ImageUploadService] 이미지 선택 실패: $e');
      rethrow;
    }
  }

  /// Firebase Storage에 이미지 업로드
  ///
  /// [bytes]: 이미지 바이트 데이터
  /// [extension]: 파일 확장자
  /// [folder]: 저장할 폴더 (기본: 'projects/thumbnails')
  ///
  /// Returns: 업로드된 이미지의 다운로드 URL
  Future<String> uploadImage({
    required Uint8List bytes,
    required String extension,
    String folder = 'projects/thumbnails',
  }) async {
    try {
      debugPrint('🚀 [ImageUploadService] 이미지 업로드 시작...');
      debugPrint('📁 [ImageUploadService] 저장 경로: $folder');

      // 고유한 파일명 생성 (UUID + 타임스탬프)
      final uuid = const Uuid().v4();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${uuid}_$timestamp.$extension';
      final filePath = '$folder/$fileName';

      debugPrint('📝 [ImageUploadService] 파일명: $fileName');

      // Firebase Storage 참조
      final ref = _storage.ref().child(filePath);

      // 메타데이터 설정
      final metadata = SettableMetadata(
        contentType: _getContentType(extension),
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'fileSize': bytes.length.toString(),
        },
      );

      // 업로드 태스크
      final uploadTask = ref.putData(bytes, metadata);

      // 업로드 진행률 모니터링
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        debugPrint('📤 [ImageUploadService] 업로드 진행률: ${progress.toStringAsFixed(1)}%');
      });

      // 업로드 완료 대기
      final snapshot = await uploadTask;

      // 다운로드 URL 가져오기
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('✅ [ImageUploadService] 업로드 완료!');
      debugPrint('🔗 [ImageUploadService] URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      debugPrint('❌ [ImageUploadService] 업로드 실패: $e');
      rethrow;
    }
  }

  /// 이미지 삭제
  ///
  /// [imageUrl]: 삭제할 이미지의 Firebase Storage URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      debugPrint('🗑️ [ImageUploadService] 이미지 삭제 시작...');
      debugPrint('🔗 [ImageUploadService] URL: $imageUrl');

      // URL이 Firebase Storage URL인지 확인
      if (!imageUrl.contains('firebasestorage.googleapis.com')) {
        debugPrint('⚠️ [ImageUploadService] Firebase Storage URL이 아님 - 삭제 건너뛰기');
        return;
      }

      // URL에서 Storage 참조 생성
      final ref = _storage.refFromURL(imageUrl);

      // 파일 삭제
      await ref.delete();

      debugPrint('✅ [ImageUploadService] 이미지 삭제 완료');
    } catch (e) {
      debugPrint('⚠️ [ImageUploadService] 이미지 삭제 실패 (무시): $e');
      // 삭제 실패는 치명적이지 않으므로 예외를 던지지 않음
    }
  }

  /// 이미지 선택 및 업로드 (통합)
  ///
  /// Returns: 업로드된 이미지 URL 또는 null
  Future<String?> pickAndUploadImage({
    String folder = 'projects/thumbnails',
  }) async {
    try {
      // 1. 이미지 선택 및 검증
      final imageData = await pickImage();
      if (imageData == null) {
        return null;
      }

      // 2. Firebase Storage 업로드
      final downloadUrl = await uploadImage(
        bytes: imageData['bytes'] as Uint8List,
        extension: imageData['extension'] as String,
        folder: folder,
      );

      return downloadUrl;
    } catch (e) {
      debugPrint('❌ [ImageUploadService] pickAndUploadImage 실패: $e');
      rethrow;
    }
  }

  /// Content-Type 반환
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  /// 파일 크기를 읽기 쉬운 형식으로 변환
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// 파일 크기 제한 문자열
  static String get maxFileSizeText => '500KB';

  /// 허용 형식 문자열
  static String get allowedFormatsText => allowedExtensions.join(', ').toUpperCase();
}