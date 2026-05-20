class AlQuranApiResponse<T> {
  const AlQuranApiResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory AlQuranApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return AlQuranApiResponse(
      code: json['code'] as int,
      status: json['status'] as String,
      data: fromJsonT(json['data']),
    );
  }

  final int code;
  final String status;
  final T data;
}
