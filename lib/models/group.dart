class Group {
  String id;
  String name;
  String description;
  int availableSeats;
  List<String> drivingDays;
  String createdBy;
  String schedule; // Add schedule property
  String vehicleInfo; // Add vehicleInfo property

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.availableSeats,
    required this.drivingDays,
    required this.createdBy,
    required this.schedule, // Add schedule property
    required this.vehicleInfo, // Add vehicleInfo property
  });

  // Convert a Group into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'availableSeats': availableSeats,
      'drivingDays': drivingDays,
      'createdBy': createdBy,
      'schedule': schedule, // Add schedule property
      'vehicleInfo': vehicleInfo, // Add vehicleInfo property
    };
  }

  // Create a Group from a Map.
  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      availableSeats: map['availableSeats'],
      drivingDays: List<String>.from(map['drivingDays']),
      createdBy: map['createdBy'],
      schedule: map['schedule'], // Add schedule property
      vehicleInfo: map['vehicleInfo'], // Add vehicleInfo property
    );
  }
}
