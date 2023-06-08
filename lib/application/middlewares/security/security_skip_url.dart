class SecuritySkipUrl {
  String url;

  SecuritySkipUrl({
    required this.url,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SecuritySkipUrl && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
