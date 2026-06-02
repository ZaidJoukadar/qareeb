class UmmahApiResponse<T> {
  const UmmahApiResponse({
    required this.success,
    required this.data,
  });

  factory UmmahApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return UmmahApiResponse(
      success: json['success'] as bool? ?? false,
      data: fromJsonT(json['data']),
    );
  }

  final bool success;
  final T data;
}

void ensureUmmahSuccess(bool success, {String? message}) {
  if (!success) {
    throw StateError(message ?? 'UmmahAPI request failed');
  }
}
