import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
    this.onCancel,
    this.confirmText = "OK",
    this.cancelText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel ?? () => Navigator.pop(context),
                  child: Text(cancelText),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: onConfirm, child: Text(confirmText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
