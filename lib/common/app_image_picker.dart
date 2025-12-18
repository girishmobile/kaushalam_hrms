import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/main.dart';
import 'package:permission_handler/permission_handler.dart';

class AppImagePicker {
  static Future<String?> pickImage({required BuildContext context}) async {
    /// 1️⃣ Ask user to choose source
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => _buildBottomSheet(context),
    );
    if (source == null) return null;

    /// 2️⃣ ANDROID: ask permissions manually
    if (Platform.isAndroid) {
      final bool granted = await _requestAndroidPermission(source);
      if (!granted) return null;
    }

    /// 3️⃣ iOS: DO NOTHING (ImagePicker handles permission)
    /// Apple requires this behavior

    /// 4️⃣ Pick image (this triggers iOS permission popup)
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 680,
    );
    if (pickedFile == null) return null;

    /// 5️⃣ Crop image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: color3,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.blue,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    return croppedFile?.path;
  }

  static Future<bool> _requestAndroidPermission(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await _showPermissionDialog(isPermanent: true);
      return false;
    }

    await _showPermissionDialog();
    return false;
  }
}

Widget _buildBottomSheet(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appGradientText(
          text: "Choose from camera or Library",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          gradient: appGradient(),
        ),
        const SizedBox(height: 8),
        loadSubText(
          title:
              "Choose an option below to set your profile picture from camera or Library.",
          fontSize: 12,
        ),
        const SizedBox(height: 16),
        _buidRowItem(
          icon: Icons.camera_alt_outlined,
          title: "From camera",
          onTapped: () => Navigator.pop(context, ImageSource.camera),
        ),
        const SizedBox(height: 12),
        _buidRowItem(
          icon: Icons.photo_outlined,
          title: "From Library",
          onTapped: () => Navigator.pop(context, ImageSource.gallery),
        ),
        const SizedBox(height: 12),
        _buidRowItem(
          icon: Icons.close,
          title: "Cancel",
          fontWeight: FontWeight.w600,
          onTapped: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Widget _buidRowItem({
  required IconData icon,
  required String title,
  required VoidCallback onTapped,
  FontWeight? fontWeight = FontWeight.w400,
}) {
  return appViewEffect(
    onTap: onTapped,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        appCircleIcon(icon: icon, iconSize: 24, gradient: appGradient()),
        appGradientText(
          text: title, //"From Library",
          style: TextStyle(fontSize: 14, fontWeight: fontWeight),
          gradient: appGradient(),
        ),
      ],
    ),
  );
}

Future<void> _showPermissionDialog({bool isPermanent = false}) async {
  return showDialog(
    context: navigatorKey.currentContext!,
    builder: (ctx) => CupertinoAlertDialog(
      title: loadSubText(
        title: "Permission Required",
        fontSize: 16,
        fontWight: FontWeight.w600,
      ),
      content: loadSubText(
        title: isPermanent
            ? "Permission permanently denied. Please enable it from Settings."
            : "Permission is required to continue.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            openAppSettings();
          },
          child: const Text("Open Settings"),
        ),
      ],
    ),
  );
}
