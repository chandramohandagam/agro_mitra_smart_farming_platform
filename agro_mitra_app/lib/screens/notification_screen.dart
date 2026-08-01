import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/providers/notification_provider.dart';
import '../core/models/notification_model.dart';
import '../theme/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBright.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchNotifications(),
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationProvider provider) {
    if (provider.status == NotificationStatus.loading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == NotificationStatus.error) {
      return Center(child: Text(provider.errorMessage ?? 'Error loading notifications'));
    }

    if (provider.notifications.isEmpty) {
      return const Center(child: Text('No new notifications.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.notifications.length,
      itemBuilder: (context, index) {
        final notification = provider.notifications[index];
        return _buildNotificationCard(context, provider, notification);
      },
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationProvider provider, AppNotification n) {
    return GestureDetector(
      onTap: () => provider.markRead(n.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: n.isRead ? Colors.white.withValues(alpha: 0.6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: n.isRead ? Colors.transparent : AppColors.primary.withValues(alpha: 0.1)),
          boxShadow: [if (!n.isRead) BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(n.type, n.isRead),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold, fontSize: 16))),
                      if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(n.body, style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 8),
                  Text(DateFormat('MMM dd, hh:mm a').format(n.timestamp), style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(NotificationType type, bool isRead) {
    IconData icon = Icons.notifications;
    Color color = AppColors.primary;

    switch (type) {
      case NotificationType.weather:
        icon = Icons.wb_sunny;
        color = AppColors.tertiary;
        break;
      case NotificationType.market:
        icon = Icons.trending_up;
        color = AppColors.primary;
        break;
      case NotificationType.alert:
        icon = Icons.warning;
        color = AppColors.error;
        break;
      case NotificationType.system:
        icon = Icons.settings;
        color = AppColors.outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withValues(alpha: isRead ? 0.05 : 0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
