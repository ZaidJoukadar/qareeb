import 'package:equatable/equatable.dart';
import 'package:qareeb/features/adhan/domain/entities/prayer_day.dart';
import 'package:qareeb/features/adhan/domain/entities/user_location.dart';

enum AdhanStatus { initial, loading, success, failure }

enum AdhanFailureReason {
  locationDenied,
  locationUnavailable,
  locationTimeout,
  locationPluginUnavailable,
  generic,
}

class AdhanState extends Equatable {
  const AdhanState({
    this.status = AdhanStatus.initial,
    this.location,
    this.prayerDays = const [],
    this.failureReason,
    this.errorMessage,
  });

  final AdhanStatus status;
  final UserLocation? location;
  final List<PrayerDay> prayerDays;
  final AdhanFailureReason? failureReason;
  final String? errorMessage;

  AdhanState copyWith({
    AdhanStatus? status,
    UserLocation? location,
    List<PrayerDay>? prayerDays,
    AdhanFailureReason? failureReason,
    String? errorMessage,
    bool clearFailureReason = false,
    bool clearErrorMessage = false,
  }) {
    return AdhanState(
      status: status ?? this.status,
      location: location ?? this.location,
      prayerDays: prayerDays ?? this.prayerDays,
      failureReason: clearFailureReason
          ? null
          : failureReason ?? this.failureReason,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    location,
    prayerDays,
    failureReason,
    errorMessage,
  ];
}
