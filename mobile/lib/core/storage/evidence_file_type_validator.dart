class EvidenceFileTypeValidator {
  static const Set<String> _supportedImageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'webp'
  };
  static const Set<String> _supportedAudioExtensions = {
    'm4a',
    'wav',
    'aac',
    'mp3'
  };
  static const Set<String> _supportedDocumentExtensions = {
    'json',
    'pdf',
    'csv',
    'txt'
  };

  static bool isSupported(String pathOrFilename) {
    final ext = _extractExtension(pathOrFilename);
    return _supportedImageExtensions.contains(ext) ||
        _supportedAudioExtensions.contains(ext) ||
        _supportedDocumentExtensions.contains(ext);
  }

  static bool isImage(String pathOrFilename) {
    final ext = _extractExtension(pathOrFilename);
    return _supportedImageExtensions.contains(ext);
  }

  static bool isAudio(String pathOrFilename) {
    final ext = _extractExtension(pathOrFilename);
    return _supportedAudioExtensions.contains(ext);
  }

  static String getMimeType(String pathOrFilename) {
    final ext = _extractExtension(pathOrFilename);
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'm4a':
        return 'audio/m4a';
      case 'wav':
        return 'audio/wav';
      case 'aac':
        return 'audio/aac';
      case 'mp3':
        return 'audio/mpeg';
      case 'json':
        return 'application/json';
      case 'pdf':
        return 'application/pdf';
      case 'csv':
        return 'text/csv';
      case 'txt':
      default:
        return 'text/plain';
    }
  }

  static String _extractExtension(String pathOrFilename) {
    if (!pathOrFilename.contains('.')) return '';
    return pathOrFilename.split('.').last.toLowerCase();
  }
}
