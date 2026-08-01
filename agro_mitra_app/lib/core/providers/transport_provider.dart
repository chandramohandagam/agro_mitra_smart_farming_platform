import 'package:flutter/material.dart';
import '../services/transport_service.dart';
import '../models/transport_model.dart';

enum TransportStatus { loading, loaded, error }

class TransportProvider extends ChangeNotifier {
  final TransportService _service = TransportService();

  TransportStatus _status = TransportStatus.loading;
  List<TransportBooking> _bookings = [];
  String? _errorMessage;

  TransportStatus get status => _status;
  List<TransportBooking> get bookings => _bookings;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBookings() async {
    _status = TransportStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _service.getBookings();
      _status = TransportStatus.loaded;
    } catch (e) {
      _status = TransportStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> createBooking(Map<String, dynamic> data) async {
    try {
      await _service.bookTransport(data);
      await fetchBookings();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
