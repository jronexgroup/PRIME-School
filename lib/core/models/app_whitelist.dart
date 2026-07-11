class AppWhitelist {
  final List<String> allowedPackageNames;
  final List<String> allowedWebUrls;

  const AppWhitelist({
    this.allowedPackageNames = const [],
    this.allowedWebUrls = const [],
  });

  bool isPackageAllowed(String packageName) =>
      allowedPackageNames.contains(packageName);

  bool isUrlAllowed(String url) {
    for (final allowed in allowedWebUrls) {
      if (url.contains(allowed)) return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    'allowedPackageNames': allowedPackageNames,
    'allowedWebUrls': allowedWebUrls,
  };

  factory AppWhitelist.fromJson(Map<String, dynamic> json) => AppWhitelist(
    allowedPackageNames: List<String>.from(json['allowedPackageNames'] ?? []),
    allowedWebUrls: List<String>.from(json['allowedWebUrls'] ?? []),
  );
}
