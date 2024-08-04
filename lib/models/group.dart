import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String groupName;
  final String destinationAddress;
  final int radius;
  final String creatorId;
  final int maxUsers;
  final int currentUsers;
  final int remainingParticipants;
  final List<String> participants;
  final List<Map<String, dynamic>> schedule;
  final DateTime startDate;
  final DateTime endDate;
  final bool roundTrip;

  Group({
    required this.id,
    required this.groupName,
    required this.destinationAddress,
    required this.radius,
    required this.creatorId,
    required this.maxUsers,
    required this.currentUsers,
    required this.remainingParticipants,
    required this.participants,
    required this.schedule,
    required this.startDate,
    required this.endDate,
    required this.roundTrip,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'destinationAddress': destinationAddress,
      'radius': radius,
      'creatorId': creatorId,
      'maxUsers': maxUsers,
      'currentUsers': currentUsers,
      'remainingParticipants': remainingParticipants,
      'participants': participants,
      'schedule': schedule,
      'startDate': startDate,
      'endDate': endDate,
      'roundTrip': roundTrip,
    };
  }

  factory Group.fromMap(String id, Map<String, dynamic> map) {
    return Group(
      id: id,
      groupName: map['groupName'] ?? '',
      destinationAddress: map['destinationAddress'] ?? '',
      radius: map['radius']?.toInt() ?? 0,
      creatorId: map['creatorId'] ?? '',
      maxUsers: map['maxUsers']?.toInt() ?? 0,
      currentUsers: map['currentUsers']?.toInt() ?? 0,
      remainingParticipants: map['remainingParticipants']?.toInt() ?? 0,
      participants: List<String>.from(map['participants'] ?? []),
      schedule: List<Map<String, dynamic>>.from(map['schedule'] ?? []),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      roundTrip: map['roundTrip'] ?? false,
    );
  }
}
