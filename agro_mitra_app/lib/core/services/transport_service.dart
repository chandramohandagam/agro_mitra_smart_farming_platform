import '../api/api_client.dart';
import '../models/transport_model.dart';

class TransportService {
  final ApiClient _apiClient = ApiClient();

  Future<List<TransportBooking>> getBookings() async {
    final response = await _apiClient.get('/api/v1/transport/bookings');
    return (response.data as List).map((e) => TransportBooking.fromJson(e)).toList();
  }

  Future<TransportBooking> bookTransport(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/api/v1/transport/book', data: data);
    return TransportBooking.fromJson(response.data);
  }
}
