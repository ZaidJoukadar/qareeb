enum AppFlavor {
  dev,
  staging,
  production;

  static AppFlavor fromName(String value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => AppFlavor.dev,
    );
  }

  bool get isDev => this == AppFlavor.dev;
  bool get isStaging => this == AppFlavor.staging;
  bool get isProduction => this == AppFlavor.production;
}
