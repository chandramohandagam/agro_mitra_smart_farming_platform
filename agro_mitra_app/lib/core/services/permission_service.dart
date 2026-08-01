import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  PermissionService._();

  static final PermissionService instance = PermissionService._();

  /// Requests a specific permission and handles the outcome.
  /// If the permission is permanently denied, it can show a dialog or snackbar.
  Future<bool> requestPermission(Permission permission, {
    required BuildContext context,
    required String explanation,
  }) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(context, explanation);
      }
      return false;
    }

    final result = await permission.request();

    if (result.isGranted) {
      return true;
    } else if (result.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(context, explanation);
      }
    }

    return false;
  }

  /// Specialized helpers for the project's specific features

  Future<bool> requestLocation(BuildContext context) async {
    return requestPermission(
      Permission.locationWhenInUse,
      context: context,
      explanation: "Location access is required to provide accurate weather forecasts and find nearby dealers.",
    );
  }

  Future<bool> requestCamera(BuildContext context) async {
    return requestPermission(
      Permission.camera,
      context: context,
      explanation: "Camera access is required for scanning crops and detecting diseases.",
    );
  }

  Future<bool> requestMicrophone(BuildContext context) async {
    return requestPermission(
      Permission.microphone,
      context: context,
      explanation: "Microphone access is required for the Agro Mitra voice assistant.",
    );
  }

  Future<bool> requestNotifications(BuildContext context) async {
    return requestPermission(
      Permission.notification,
      context: context,
      explanation: "Enable notifications to receive important weather alerts and market updates.",
    );
  }

  void _showSettingsDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
