import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/storage/evidence_file_type_validator.dart';

void main() {
  group('EvidenceFileTypeValidator Unit Tests', () {
    test('identifies supported evidence file types', () {
      expect(EvidenceFileTypeValidator.isSupported('photo_01.jpg'), isTrue);
      expect(EvidenceFileTypeValidator.isSupported('voice_rec.m4a'), isTrue);
      expect(
          EvidenceFileTypeValidator.isSupported('packet_schema.json'), isTrue);
      expect(
          EvidenceFileTypeValidator.isSupported('malicious_exec.exe'), isFalse);
    });

    test('classifies image vs audio evidence types', () {
      expect(EvidenceFileTypeValidator.isImage('leak_photo.png'), isTrue);
      expect(EvidenceFileTypeValidator.isImage('audio_memo.wav'), isFalse);

      expect(EvidenceFileTypeValidator.isAudio('audio_memo.wav'), isTrue);
      expect(EvidenceFileTypeValidator.isAudio('leak_photo.png'), isFalse);
    });

    test('resolves correct MIME types for file extensions', () {
      expect(EvidenceFileTypeValidator.getMimeType('photo.jpg'),
          equals('image/jpeg'));
      expect(EvidenceFileTypeValidator.getMimeType('voice.m4a'),
          equals('audio/m4a'));
      expect(EvidenceFileTypeValidator.getMimeType('schema.json'),
          equals('application/json'));
    });
  });
}
