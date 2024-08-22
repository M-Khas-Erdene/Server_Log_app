class History {
  final int id;
  final String serverName;
  final String reasonForFailure;
  final DateTime? dateOfFailure;
  final DateTime? dateOfStartup;
  final DateTime? change_timestamp;
  final String status;
  final String username;

  History({
    required this.id,
    required this.serverName,
    required this.reasonForFailure,
    required this.dateOfFailure,
    required this.dateOfStartup,
    required this.change_timestamp,
    required this.status,
    required this.username,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      serverName: json['server_name'],
      reasonForFailure: json['reason_for_failure'] ?? '',
      dateOfFailure: json['date_of_failure'] != null
          ? DateTime.parse(json['date_of_failure'])
          : null,
      dateOfStartup: json['date_of_startup'] != null
          ? DateTime.parse(json['date_of_startup'])
          : null,
      change_timestamp: DateTime.parse(json['change_timestamp']),
      status: json['status'],
      username: json['username'],
    );
  }
}
