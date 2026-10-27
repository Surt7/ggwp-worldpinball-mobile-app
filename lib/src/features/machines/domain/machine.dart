import 'package:equatable/equatable.dart';

class Machine extends Equatable {
final String machineId;
final String ipId;
final String displayName;
final String serialNumber;
final String manufacturer;
final String status;
final DateTime registeredAt;

const Machine({
required this.machineId,
required this.ipId,
  required this.displayName,
required this.serialNumber,
required this.manufacturer,
required this.status,
required this.registeredAt,
});

factory Machine.fromJson(Map<String, dynamic> json) {
  return Machine(
    machineId: json['machineId']?.toString() ?? '',
    ipId: json['ipId']?.toString() ?? '',
    displayName: json['displayName']?.toString() ?? '',
    serialNumber: json['serialNumber']?.toString() ?? '',
    manufacturer: json['manufacturer']?.toString() ?? 'Stern Pinball',
    status: json['status']?.toString() ?? 'Online',
    registeredAt: json['registeredAt'] != null
        ? DateTime.parse(json['registeredAt'].toString())
        : DateTime.now(),
  );
}

  @override
  // Equatable uses 'props' to compare objects. 
  // It helps Flutter know when to rebuild the UI.
  List<Object?> get props => [
        machineId,
        ipId,
        displayName,
        serialNumber,
        manufacturer,
        status,
        registeredAt,
      ];
}
