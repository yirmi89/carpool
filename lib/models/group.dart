class Group {
  String id;
  final String groupName;
  final String destinationCity;
  final String destinationAddress;
  final int radius;
  final List<String> days;
  final List<String> hours;
  final String creatorId;

  Group({
    required this.id,
    required this.groupName,
    required this.destinationCity,
    required this.destinationAddress,
    required this.radius,
    required this.days,
    required this.hours,
    required this.creatorId,
  });

  factory Group.fromMap(Map<String, dynamic> data, String id) {
    return Group(
      id: id,
      groupName: data['groupName'],
      destinationCity: data['destinationCity'],
      destinationAddress: data['destinationAddress'],
      radius: data['radius'],
      days: List<String>.from(data['days']),
      hours: List<String>.from(data['hours']),
      creatorId: data['creatorId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'destinationCity': destinationCity,
      'destinationAddress': destinationAddress,
      'radius': radius,
      'days': days,
      'hours': hours,
      'creatorId': creatorId,
    };
  }

  String get name => groupName;
  String get description => '$destinationCity, $destinationAddress';
}
