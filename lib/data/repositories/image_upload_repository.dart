import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PickedImage {
  const PickedImage({
    required this.bytes,
    required this.extension,
    required this.fileName,
  });

  final Uint8List bytes;
  final String extension;
  final String fileName;
}

/// Firebase Storage image upload — same 500KB / jpg-jpeg-png-webp
/// constraints as the legacy `ImageUploadService`.
class ImageUploadRepository {
  ImageUploadRepository(this._storage) : _picker = ImagePicker();

  final FirebaseStorage _storage;
  final ImagePicker _picker;

  static const int maxFileSize = 500 * 1024;
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static String get maxFileSizeText => '500KB';
  static String get allowedFormatsText =>
      allowedExtensions.join(', ').toUpperCase();

  Future<PickedImage?> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (image == null) return null;

    final extension = image.name.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw Exception(
        '지원하지 않는 파일 형식입니다.\n허용 형식: ${allowedExtensions.join(", ")}',
      );
    }

    final bytes = await image.readAsBytes();
    if (bytes.length > maxFileSize) {
      throw Exception(
        '파일 크기가 너무 큽니다.\n'
        '현재: ${_formatFileSize(bytes.length)}\n'
        '최대: $maxFileSizeText\n\n'
        '이미지를 압축하거나 크기를 줄여주세요.',
      );
    }

    return PickedImage(
      bytes: bytes,
      extension: extension,
      fileName: image.name,
    );
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String extension,
    String folder = 'projects/thumbnails',
  }) async {
    final fileName =
        '${const Uuid().v4()}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final ref = _storage.ref().child('$folder/$fileName');

    final metadata = SettableMetadata(
      contentType: _contentType(extension),
      customMetadata: {
        'uploadedAt': DateTime.now().toIso8601String(),
        'fileSize': bytes.length.toString(),
      },
    );

    final snapshot = await ref.putData(bytes, metadata);
    return snapshot.ref.getDownloadURL();
  }

  Future<String?> pickAndUploadImage({
    String folder = 'projects/thumbnails',
  }) async {
    final picked = await pickImage();
    if (picked == null) return null;
    return uploadImage(
      bytes: picked.bytes,
      extension: picked.extension,
      folder: folder,
    );
  }

  Future<void> deleteImage(String imageUrl) async {
    if (!imageUrl.contains('firebasestorage.googleapis.com')) return;
    try {
      await _storage.refFromURL(imageUrl).delete();
    } catch (_) {
      // Best-effort: a stale/broken URL shouldn't block the caller's flow.
    }
  }

  String _contentType(String extension) {
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
