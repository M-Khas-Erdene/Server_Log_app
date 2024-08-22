class Server {
  final int id;
  final String serverName;
  final String location;
  final String systemRunning;
  final String internalAddress;
  final String externalAddress;
  final String reasonForFailure;
  final DateTime dateOfFailure;
  final DateTime dateOfStartup;
  final String status;

  Server({
    required this.id,
    required this.serverName,
    required this.location,
    required this.systemRunning,
    required this.internalAddress,
    required this.externalAddress,
    required this.reasonForFailure,
    required this.dateOfFailure,
    required this.dateOfStartup,
    required this.status,
  });

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      id: json['id'],
      serverName: json['server_name'],
      location: json['location'],
      systemRunning: json['system_running'],
      internalAddress: json['internal_address'],
      externalAddress: json['external_address'],
      reasonForFailure: json['reason_for_failure'],
      dateOfFailure: DateTime.parse(json['date_of_failure']),
      dateOfStartup: DateTime.parse(json['date_of_startup']),
      status: json['status'],
    );
  }
}
