import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/providers/transport_provider.dart';
import '../core/models/transport_model.dart';
import '../theme/app_colors.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportProvider>().fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransportProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surfaceBright.withValues(alpha: 0.9),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Transport Booking',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildBody(context, provider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_road),
        label: const Text('New Booking'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TransportProvider provider) {
    if (provider.status == TransportStatus.loading) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }

    if (provider.status == TransportStatus.error) {
      return SliverFillRemaining(child: Center(child: Text(provider.errorMessage ?? 'Error loading bookings')));
    }

    if (provider.bookings.isEmpty) {
      return const SliverFillRemaining(child: Center(child: Text('No transport bookings found.')));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildBookingCard(context, provider.bookings[index]),
        childCount: provider.bookings.length,
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, TransportBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.vehicleType.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(booking.driverName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              _buildStatusChip(booking.status),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(booking.fromLocation, style: const TextStyle(fontSize: 13))),
              const Icon(Icons.arrow_forward, size: 12, color: AppColors.outline),
              const SizedBox(width: 8),
              Expanded(child: Text(booking.toLocation, style: const TextStyle(fontSize: 13), textAlign: TextAlign.right)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('MMM dd, hh:mm a').format(booking.scheduledTime), style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              Text('₹${booking.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = AppColors.primary;
    if (status == 'pending') color = AppColors.tertiary;
    if (status == 'cancelled') color = AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(9999)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
