enum Format {
  webp,
  jpg,
  png,
  all,
}

class FormatOption {
  final Format value;
  final String label;

  FormatOption(this.value, this.label);
}