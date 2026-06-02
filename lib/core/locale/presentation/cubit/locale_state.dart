part of 'locale_cubit.dart';

enum LocaleStatus { initial, ready }

class LocaleState extends Equatable {
  const LocaleState({
    this.locale,
    this.status = LocaleStatus.initial,
  });

  final Locale? locale;
  final LocaleStatus status;

  LocaleState copyWith({
    Locale? locale,
    LocaleStatus? status,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [locale, status];
}
