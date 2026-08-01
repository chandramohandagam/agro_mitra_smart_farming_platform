class TransportBooking {
  final String id;
  final String vehicleType;
  final String driverName;
  final String status;
  final String fromLocation;
  final String toLocation;
  final double price;
  final DateTime scheduledTime;

  TransportBooking({
    required this.id,
    required this.vehicleType,
    required this.driverName,
    required this.status,
    required this.fromLocation,
    required this.toLocation,
    required this.price,
    required this.scheduledTime,
  });

  factory TransportBooking.fromJson(Map<String, dynamic> json) {
    return TransportBooking(
      id: json['id'],
      vehicleType: json['vehicle_type'] ?? '',
      driverName: json['driver_name'] ?? '',
      status: json['status'] ?? 'pending',
      fromLocation: json['from_location'] ?? '',
      toLocation: json['to_location'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      scheduledTime: DateTime.parse(json['scheduled_time']),
    );
  }
}
