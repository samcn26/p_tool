enum Format {
  webp,
  jpg,
  png,
  all,
}

extension FormatExtension on Format {
  String get name {
    switch (this) {
      case Format.webp:
        return 'webp';
      case Format.jpg:
        return 'jpg';
      case Format.png:
        return 'png';
      case Format.all:
        return 'all';
    }
  }

  static Format fromString(String value) {
    switch (value.toLowerCase()) {
      case 'webp':
        return Format.webp;
      case 'jpg':
      case 'jpeg':
        return Format.jpg;
      case 'png':
        return Format.png;
      case 'all':
        return Format.all;
      default:
        throw ArgumentError('无效的格式: $value');
    }
  }
}

class FormatOption {
  final Format value;
  final String label;

  FormatOption(this.value, this.label);
}
