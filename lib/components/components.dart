import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/models/all_leave_model.dart';
import 'package:neeknots_admin/models/birth_holiday_model.dart';
import 'package:neeknots_admin/models/customer_model.dart';
import 'package:neeknots_admin/models/emp_notification_model.dart';
import 'package:neeknots_admin/models/order_model.dart';
import 'package:neeknots_admin/provider/leave_provider.dart';
import 'package:neeknots_admin/utility/utils.dart';
import 'package:provider/provider.dart';

import '../common/image_pick_and_crop_widget.dart';
import '../provider/profile_provider.dart';

double leftPadding = 16;
double rightPadding = 16;

Widget appCircleIcon({
  IconData? icon,
  double? iconSize = 28,
  VoidCallback? onTap,
  Color? iconColor = Colors.white60, // fallback if gradient is null
  Gradient? gradient, // add gradient option
  String? text,
  Color? borderColor,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        child: icon != null
            ? ShaderMask(
                shaderCallback: (bounds) {
                  return gradient?.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ) ??
                      LinearGradient(
                        colors: [iconColor!, iconColor],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      );
                },
                child: Icon(
                  icon,
                  size: iconSize,
                  color: Colors.white, // must keep white to apply shader
                ),
              )
            : Text(
                (text != null && text.isNotEmpty) ? text[0].toUpperCase() : "?",
                style: TextStyle(
                  foreground: gradient != null
                      ? (Paint()
                          ..shader = gradient.createShader(
                            const Rect.fromLTWH(0, 0, 200, 70),
                          ))
                      : null,
                  color: gradient == null ? iconColor : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    ),
  );
}

Widget appCircleImage({
  IconData? icon,
  double radius = 24,
  double? iconSize = 24,
  VoidCallback? onTap,
  Color? iconColor = Colors.white,
  String? text,
  Color? backgroundColor,
  String? imageUrl,
  Color? borderColor = Colors.white24,
}) {
  return Material(
    color: Colors.transparent,
    shape: CircleBorder(
      side: BorderSide(color: borderColor ?? Colors.white24, width: 1),
    ),
    child: InkWell(
      splashColor: Colors.transparent,
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.transparent,
        child: _buildImageOrFallback(
          imageUrl: imageUrl,
          radius: radius,
          icon: icon,
          iconColor: iconColor,
          text: text,
          iconSize: iconSize,
        ),
      ),
    ),
  );
}

Widget commonPrefixIcon({
  required String image,
  double? width,
  double? height,
  Color? colorIcon,
}) {
  return SizedBox(
    width: width ?? 24,
    height: height ?? 24,
    child: Center(
      child: commonAssetImage(
        image,
        width: width ?? 24,
        height: height ?? 24,
        color: colorIcon ?? Colors.grey,
      ),
    ),
  );
}

Widget commonAssetImage(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
  BorderRadius? borderRadius,
  Color? color,
}) {
  Widget image = Image.asset(
    path,
    width: width,
    height: height,
    fit: fit,
    color: color,
  );

  return borderRadius != null
      ? ClipRRect(borderRadius: borderRadius, child: image)
      : image;
}

BoxDecoration commonBoxDecoration({
  Color color = Colors.transparent,
  double borderRadius = 8.0,
  Color borderColor = Colors.transparent,
  double borderWidth = 1.0,

  Gradient? gradient,
  DecorationImage? image,
  BoxShape shape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: color,
    shape: shape,
    image: image,
    borderRadius: shape == BoxShape.rectangle
        ? BorderRadius.circular(borderRadius)
        : null,
    border: Border.all(color: borderColor, width: borderWidth),

    gradient: gradient,
  );
}

Widget loadNetworkImage({
  required String? imageUrl,
  double? width,
  double? height,
  IconData? icon,
  Color? iconColor,
  String? text,
  BoxFit fit = BoxFit.contain,
  double iconSize = 24,
}) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    if (imageUrl.startsWith("http")) {
      // Network image
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width ?? 100,
        height: height ?? 100,
        fit: fit,
        placeholder: (_, __) => Center(
          child: SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, __, ___) =>
           // loadAssetImage(name: errorImage)
            _fallBackContent(icon, iconColor, text, iconSize),
      );
    } else if (imageUrl.contains(".png") ||
        imageUrl.contains(".jpg") ||
        imageUrl.contains(".jpeg") ||
        imageUrl.contains(".svg")) {
      // Asset image (valid extensions only)
      return loadAssetImage(
        name: imageUrl,
        fit: BoxFit.cover,
        width: width ?? 100,
        height: height ?? 100,
      );
    } else {
      // Invalid string (like "Girish") → fallback
      return _fallBackContent(icon, iconColor, text ?? imageUrl, iconSize);
      //return loadAssetImage(name: errorImage);
    }
  }

  // If no imageUrl, show fallback
  return _fallBackContent(icon, iconColor, text, iconSize);
}

Widget _buildImageOrFallback({
  required String? imageUrl,
  required double radius,
  IconData? icon,
  Color? iconColor,
  String? text,
  double? iconSize = 24,
}) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    if (imageUrl.startsWith("http")) {
      // Network image
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (_, __) => Center(
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (_, __, ___) =>
              _fallBackContent(icon, iconColor, text, iconSize),
        ),
      );
    } else if (imageUrl.contains(".png") ||
        imageUrl.contains(".jpg") ||
        imageUrl.contains(".jpeg") ||
        imageUrl.contains(".svg")) {
      // Asset image (valid extensions only)
      return ClipOval(
        child: loadAssetImage(
          name: imageUrl,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
        ),
      );
    } else {
      // Invalid string (like "Girish") → fallback
      return _fallBackContent(
        Icons.image_outlined,
        iconColor,
        text ?? imageUrl,
        iconSize,
      );
    }
  }

  // If no imageUrl, show fallback
  return _fallBackContent(icon, iconColor, text, iconSize);
}

Widget _fallBackContent(
  IconData? icon,
  Color? iconColor,
  String? text,
  double? iconSize,
) {
  if (icon != null) {
    return Icon(icon, color: iconColor, size: iconSize ?? 24);
  } else if (text != null && text.isNotEmpty) {
    return Text(
      text.characters.first.toUpperCase(),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  } else {
    return Icon(Icons.person_outline_rounded, size: 24, color: iconColor);
    //  return  loadAssetImage(name: errorImage);
  }
}

Widget loadAssetImage({
  required String name,
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  Color? color,
  VoidCallback? onTap,
}) {
  final image = Image.asset(
    name,
    width: width,
    height: height,
    fit: fit,
    color: color,
  );

  if (onTap != null) {
    return GestureDetector(onTap: onTap, child: image);
  }
  return image;
}

Widget appGlassEffect({
  required Widget child,
  double borderRadius = 8,
  EdgeInsetsGeometry? padding,
  double blurSigma = 10,
  Color overlayColor = Colors.white,
  double opacity = 0.05,
  Color borderColor = Colors.white,
  double borderWidth = 1.0,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: padding ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: overlayColor.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.35),
            width: borderWidth,
          ),
        ),
        child: child,
      ),
    ),
  );
}

LinearGradient viewBackgroundGradinet() {
  final extraLightOrange = Color(
    0xFFFFF3E8,
  ).withValues(alpha: 0.3); // very soft
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      extraLightOrange, // top soft shade
      Colors.white,
    ],
  );
}

Widget appViewEffect({
  required Widget child,
  double borderRadius = 8,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  double blurSigma = 10,
  Color? overlayColor, // make nullable so we can override
  double opacity = 0.08, // slightly visible orange shade
  Color? borderColor,
  double borderWidth = 1.0,
  VoidCallback? onTap,
}) {
  final effectiveBorderColor =
      borderColor ?? const Color(0xFFFFAC55).withValues(alpha: 0.4);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: viewBackgroundGradinet(),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: borderWidth),
      ),
      child: child,
    ),
  );
}

Widget appGradientText({
  required String text,
  required TextStyle style,
  required Gradient gradient,
}) {
  return ShaderMask(
    shaderCallback: (bounds) {
      return gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      );
    },
    child: Text(
      text,
      style: style.copyWith(
        color: Colors.white,
      ), // color must be white to apply shader
    ),
  );
}

LinearGradient appGradient({
  Alignment begin = Alignment.topLeft,
  Alignment end = Alignment.bottomRight,
  List<Color>? colors,
}) {
  return LinearGradient(
    begin: begin,
    end: end,
    colors: colors ?? [btnColor1, btnColor2],
  );
}

LinearGradient appOffGradient({
  Alignment begin = Alignment.topLeft,
  Alignment end = Alignment.bottomRight,
}) {
  return LinearGradient(
    begin: begin,
    end: end,
    colors: [Colors.grey, Colors.black54],
  );
}

LinearGradient appOrangeOffGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.black45, Colors.black54],
  );
}

LinearGradient appOrangeGradient({
  Alignment begin = Alignment.topLeft,
  Alignment end = Alignment.bottomRight,
}) {
  return LinearGradient(
    begin: begin,
    end: end,
    colors: [color1, color2, color3],
    stops: [0.0, 0.45, 1.0],
  );
}

Widget appTextField({required String hintText, IconData? icon}) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      prefixIcon: icon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12, right: 8), // adjust here
              child: Icon(icon, color: Colors.black54, size: 20),
            )
          : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      // removes extra padding
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.15),
      // glassy effect
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // rounded corners
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.4), // subtle border
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
      ),
    ),
    style: const TextStyle(color: Colors.black87),
  );
}

Widget appOrangeTextField({
  required String hintText,
  IconData? icon,
  TextEditingController? textController,
  bool isPassword = false,
  bool obscure = true,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  final Function(String)? onChanged,
  VoidCallback? onTogglePassword,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    validator: validator,
    controller: textController,
    keyboardType: keyboardType,

    obscureText: isPassword ? obscure : false,
    autocorrect: false,
    enableSuggestions: false,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hintText,

      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),

      // LEFT ICON
      prefixIcon: icon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(icon, color: Colors.black54, size: 20),
            )
          : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),

      // RIGHT ICON (Password)
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: btnColor2.withValues(alpha: 0.8),
              ),
              onPressed: onTogglePassword,
            )
          : suffixIcon,

      filled: true,
      fillColor: color1.withValues(alpha: 0.15),

      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: color2, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: color2, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: color3, width: 1.1),
      ),
    ),
    style: const TextStyle(color: Colors.black87),
  );
}

Widget customerCard(CustomerModel customer) {
  return appGlassEffect(
    child: Row(
      children: [
        appCircleImage(imageUrl: customer.imageUrl, radius: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                customer.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                customer.email,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                "Orders: ${customer.totalOrders} • \$${customer.totalSpent.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Text(
          "${customer.joinedDate.day}/${customer.joinedDate.month}",
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        SizedBox(width: 4),
        appForwardIcon(),
      ],
    ),
  );
}

Widget employeeCard(CustomerModel customer) {
  return appViewEffect(
    child: Row(
      children: [
        appCircleImage(imageUrl: customer.imageUrl, radius: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                customer.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                customer.email,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                "Joined:- 13-June-2013",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 4),
        appForwardIcon(),
      ],
    ),
  );
}

Widget leaveCard({
  required MyLeave item,
  required VoidCallback onReject,
  required VoidCallback onAccept,
}) {
  final leaveDate = comrateStartEndate(
    item.leaveDate?.date.toString(),
    item.leaveEndDate?.date.toString(),
  );

  return appViewEffect(
    child: Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            appCircleImage(
              imageUrl: setImagePath(item.userId?.profileImage),
              radius: 24,
              icon: Icons.person_outline,
              iconColor: color3,
              borderColor: color2,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${item.userId?.firstname} ${item.userId?.lastname}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "Days: ${item.leaveCount}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "Leave On: $leaveDate",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Text(
                        "Reason:",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.reason ?? '-',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Text(
                        "Status:",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.status ?? '-',
                          style: const TextStyle(fontSize: 12, color: color3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 8),
        if (item.status?.toString().toLowerCase() == "pending") ...[
          Row(
            spacing: 32,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              acceptOrRejectBtn(
                bgColor: Colors.green,
                title: "Accept",
                icon: Icons.check,
                onTap: onAccept,
              ),
              acceptOrRejectBtn(
                bgColor: Colors.red,
                title: "Reject",
                icon: Icons.close,
                onTap: onReject,
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget holidayCard({required Holiday item}) {
  final fullImageUrl =
      (item.holiday_image != null && item.holiday_image!.isNotEmpty)
      ? "${ApiConfig.imageBaseUrl}${item.holiday_image}"
      : null;

  return SizedBox(
    width: 300,
    child: appViewEffect(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8, top: 8),
      child: Row(
        spacing: 8,
        children: [
          appCircleImage(
            iconColor: btnColor2,
            borderColor: btnColor2.shade200,

            radius: 32,
            iconSize: 36,
            imageUrl: fullImageUrl,
            icon: Icons.festival_outlined,
          ),
          Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loadTitleText(title: item.event_name, fontSize: 14),
              loadSubText(
                title: getFormattedDate(
                  item.start_date.date,
                  format: "dd MMM yyyy",
                ),
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget birthDayCard({required BirthDay item, double radius = 32}) {
  final fullImageUrl =
      (item.profile_image != null && item.profile_image!.isNotEmpty)
      ? "${ApiConfig.imageBaseUrl}${item.profile_image}"
      : null;

  return SizedBox(
    width: 300,
    child: appViewEffect(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8, top: 8),
      child: Row(
        spacing: 8,
        children: [
          appCircleImage(
            iconColor: btnColor2,
            borderColor: btnColor2.shade200,

            radius: radius,
            iconSize: 36,
            imageUrl: fullImageUrl,
            icon: Icons.cake_outlined,
          ),
          Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loadTitleText(
                title: '${item.firstname} ${item.lastname}',
                fontSize: 14,
              ),
              loadSubText(title: item.designation),
              loadSubText(
                title: getFormattedDate(
                  item.dateOfBirth.date,
                  format: "dd MMM yyyy",
                ),
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget notificationCard(EmpNotificationModel notification) {
  return appViewEffect(
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                notification.title ?? '-',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),

              Html(
                data: notification.details ?? '',
                style: {
                  "body": Style(
                    fontSize: FontSize(12),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                },
              ),
              Text(
                convertDate(
                  notification.updatedAt?.date ?? '',
                  format: "dd-MMM-yyyy hh:mm:ss",
                ),

                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     timeAgo(notification.time),
              //     style: const TextStyle(fontSize: 12, color: Colors.black54),
              //   ),
              // ),
            ],
          ),
        ),

        SizedBox(width: 4),
        appForwardIcon(),
      ],
    ),
  );
}

Widget orderCard(OrderModel order) {
  return appGlassEffect(
    padding: const EdgeInsets.only(left: 1, right: 4, top: 1, bottom: 1),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          child: loadNetworkImage(
            imageUrl: order.items.isNotEmpty
                ? order.items[0].imageUrl
                : productUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              loadTitleText(title: "Order #${order.orderId}", fontSize: 14),
              loadSubText(
                title: "Customer: ${order.customerName}",
                fontSize: 12,
              ),
              loadSubText(
                title: "Total: \$${order.totalAmount.toStringAsFixed(2)}",
                fontSize: 12,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: loadSubText(
                        title: order.status.name,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        appForwardIcon(),
      ],
    ),
  );
}

Widget appForwardIcon() {
  // Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 24),
  return Icon(Icons.chevron_right_outlined, color: Colors.black26);
}

Widget loadTitleText({
  String? title,
  double? fontSize,
  Color? fontColor,
  FontWeight? fontWight,
  TextAlign? textAlign,
  TextOverflow? textOverflow,
}) {
  return Text(
    title ?? "",
    style: TextStyle(
      color: fontColor ?? Colors.black87,
      fontSize: fontSize ?? 16,
      fontWeight: fontWight ?? FontWeight.w600,
    ),
    textAlign: textAlign ?? TextAlign.left,
    overflow: textOverflow,
  );
}

Widget loadSubText({
  String? title,
  double? fontSize,
  Color? fontColor,
  int? maxLines,
  FontWeight? fontWight,
  TextAlign? textAlign,
  TextOverflow? textOverflow,
}) {
  return Text(
    title ?? "",

    maxLines: maxLines,
    style: TextStyle(
      color: fontColor ?? Colors.black54,
      fontSize: fontSize ?? 14,
      fontWeight: fontWight ?? FontWeight.w500,
    ),
    textAlign: textAlign ?? TextAlign.left,
    overflow: textOverflow,
  );
}

Widget appNavigationBar({
  required String title,
  VoidCallback? onTap,
  VoidCallback? onRightIconTap,
  IconData ?rightIcon ,
}) {
  return SafeArea(
    child: Container(
      height: 48,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: appCircleIcon(
              icon: Icons.arrow_back_rounded,
              iconSize: 24,
              gradient: appGradient(),
              //iconColor: Colors.black87,
              onTap: onTap,
            ),
          ),
          appGradientText(
            text: title,
            //textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            gradient: appGradient(),
          ),
          rightIcon!=null?  Align(
            alignment: Alignment.centerRight,
            child: appCircleIcon(
              icon: rightIcon,
              iconSize: 24,
              gradient: appGradient(),
              onTap: onRightIconTap,
            ),
          ):SizedBox.shrink(),
        ],
      ),
    ),
  );
}

Widget gradientCircleView({required Widget child, double size = 50}) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(3), // thickness of the gradient border
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: appGradient(),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // inner circle color
        ),
        child: child,
      ),
    ),
  );
}

Widget gradientButton({
  required String title,
  required VoidCallback onPressed,
}) {
  return Container(
    width: double.infinity,
    height: 52,
    decoration: BoxDecoration(
      gradient: appGradient(colors: [btnColor1, btnColor2]),
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.login, color: Colors.white),
      label: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget appProfileImage({
  String? imageUrl,
  required bool isEdit,
  double radius = 60,
  required BuildContext context,
  EdgeInsetsGeometry? padding,
}) {
  final provider = Provider.of<ProfileProvider>(context);
  return Stack(
    clipBehavior: Clip.hardEdge,
    alignment: AlignmentGeometry.center,
    children: [
      Container(
        padding: padding ?? const EdgeInsets.all(2), // thickness of border
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: appGradient(),
        ),
        child: Container(
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: appCircleImage(
            imageUrl: imageUrl,
         //   icon: Icons.person_outline,
            radius: (radius - 2),
            onTap: () {},
          ),
        ),
      ),
      isEdit
          ? Positioned(
              bottom: 0,
              child: Transform.translate(
                offset: Offset(40, 0), // 👈 left side me 20px shift
                child: InkWell(
                  onTap: () async {
                    final path = await CommonImagePicker.pickImage(
                      context: context,
                    );
                    if (path != null) {
                      provider.setPickedFile(File(path));
                      provider.uploadProfileImage(
                        filePath: path,
                        context: context,
                      );
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: appGradient(),
                    ),
                    child: const Center(
                      child: Icon(Icons.edit_outlined, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    ],
  );
}

Widget appBackdropFilter({required Widget child, double borderRadius = 0}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: child,
    ),
  );
}

Widget loadMultiLineTextField({
  Color? bgColor,
  String? hintText,
  TextEditingController? textController,
  int? maxLine,
  int? minLine,
}) {
  final effectiveBorderColor = const Color(0xFFFFAC55).withValues(alpha: 0.4);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: effectiveBorderColor),

      gradient: viewBackgroundGradinet(),
    ),
    child: TextField(
      keyboardType: TextInputType.multiline,
      controller: textController,
      maxLines: maxLine ?? 7,
      minLines: minLine ?? 4,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText ?? 'Enter your message...',
        hintStyle: TextStyle(
          color: Colors.black45,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget leaveActionButton({
  required String title,
  required Color bgColor,
  required Color textColor,
  IconData? icon,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(4),
    child: Ink(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Container(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: 12),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: textColor),
                SizedBox(width: 6),
              ],
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget acceptOrRejectBtn({
  required Color bgColor,
  required String title,
  IconData? icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.07),
        border: Border.all(color: bgColor.withValues(alpha: 0.6), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: bgColor),
            SizedBox(width: 4),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: bgColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<DateTime?> appDatePicker(
  BuildContext context, {
  required DateTime minDate,
}) async {
  final DateTime today = DateTime.now();
  final DateTime endOfYear = DateTime(today.year, 12, 31);

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: minDate,
    firstDate: minDate,
    lastDate: endOfYear,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.orange,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      );
    },
  );

  return pickedDate; // 👈 return selected date
}

Future<LeaveDropdownItem?> appBottomSheet(
  BuildContext context, {
  LeaveDropdownItem? selected,
  required List<LeaveDropdownItem> dataType,
}) async {
  return await showModalBottomSheet<LeaveDropdownItem>(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Do you want to select a option?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          ...dataType.map((e) {
            // final isSelected = e == selected;
            final isSelected = e.label == selected?.label;
            return GestureDetector(
              onTap: () => Navigator.pop(context, e),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? btnColor2 : color2,
                    width: 1,
                  ),
                  gradient: viewBackgroundGradinet(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check, color: Colors.orange, size: 20),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 12),
        ],
      ),
    ),
  );
}

Future<String?> appSimpleBottomSheet(
  BuildContext context, {
  String? selected,
  required List<String> dataType,
  VoidCallback? onClose,
}) async {
  return await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.only(top: 4, left: 16, right: 8, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Do you want to select a option?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                IconButton(onPressed: onClose, icon: Icon(Icons.close)),
              ],
            ),
            SizedBox(height: 8),
            ...dataType.map((e) {
              final isSelected = e == selected;
              return GestureDetector(
                onTap: () => Navigator.pop(context, e),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? btnColor2 : color2,
                      width: 1,
                    ),
                    gradient: viewBackgroundGradinet(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check, color: Colors.orange, size: 20),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}

Widget showProgressIndicator({Color? color, Color? colorBG}) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        gradient: appGradient(),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(
          color: color ?? Colors.white,
          strokeWidth: 2,
        ),
      ),
    ),
  );
}

Widget appRefreshIndicator({
  required final Future<void> Function() onRefresh,
  required final Widget child,
}) {
  return RefreshIndicator(
    color: color3,
    backgroundColor: Colors.white,
    strokeWidth: 2,
    onRefresh: onRefresh,
    child: child,
  );
}

Future<bool?> showCommonDialog({
  required String title,
  required BuildContext context,
  String? content,
  String confirmText = 'OK',
  bool? barrierDismissible,
  String cancelText = 'Cancel',

  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  VoidCallback? onPressed,

  List<Widget>? actions,
  Widget? contentView,
  bool showCancel = true,
}) {
  return showCupertinoDialog<bool>(
    barrierDismissible: barrierDismissible ?? false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: loadTitleText(
          title: title,
          textAlign: TextAlign.center,
          fontWight: FontWeight.w500,
          fontSize: 18,
        ),
        content:
            contentView ??
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: loadSubText(
                title: content ?? '',
                textAlign: TextAlign.center,
                fontSize: 14,
              ),
            ),
        actions:
            actions ??
            <Widget>[
              if (showCancel)
                CupertinoDialogAction(
                  isDefaultAction: false,
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop(false); // return false
                  },
                  child: loadSubText(
                    title: cancelText.toUpperCase(),
                    fontWight: FontWeight.w500,
                    fontColor: Colors.red,
                  ),
                ),
              CupertinoDialogAction(
                isDefaultAction: true,
                // priority = onOk → onConfirm
                onPressed: () {
                  if (onPressed != null) {
                    Navigator.pop(context);
                    onPressed();
                  } else {
                    onConfirm?.call();
                    Navigator.pop(context, true);
                  }
                },

                child: loadSubText(
                  title: confirmText.toUpperCase(),
                  fontWight: FontWeight.w500,
                ),
              ),
            ],
      );
    },
  );
}

Widget commonRefreshIndicator({
  required final Future<void> Function() onRefresh,
  required final Widget child,
}) {
  return RefreshIndicator(
    color: color3,
    backgroundColor: Colors.white,
    strokeWidth: 2,
    onRefresh: onRefresh,
    child: child,
  );
}

void showCommonBottomSheet({
  required BuildContext context,
  required Widget content,

  bool isDismissible = true,
  EdgeInsetsGeometry? padding,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: isDismissible,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return Padding(
        padding:
            padding ??
            EdgeInsets.only(
              bottom: appBottomPadding(context),
              left: 16,
              right: 16,
              top: 16,
            ),
        child: content,
      );
    },
  );
}

Widget commonBoxView({
  required Widget contentView,
  required String title,
  double? fontSize,
}) {
  return Container(
    decoration: commonBoxDecoration(
      color: color3.withValues(alpha: 0.01),
      borderColor: color3,
      borderRadius: 8,
    ),
    margin: const EdgeInsets.all(0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: title, fontSize: fontSize),

        // Content
        Padding(padding: const EdgeInsets.all(12.0), child: contentView),
      ],
    ),
  );
}

Widget commonHeadingView({String? title, double? fontSize}) {
  return Padding(
    padding: EdgeInsets.all(12.0),
    child: Row(
      children: [
        Expanded(
          child: loadTitleText(
            fontColor: color3,
            title: title ?? "Product Information",
            fontSize: fontSize ?? 16,
            fontWight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget commonRowLeftRightView({
  required String title,
  String? value,
  Widget? customView,
}) {
  return Row(
    children: [
      Expanded(
        child: loadSubText(
          title: title,
          fontWight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      Expanded(
        child:
            customView ??
            loadSubText(
              title: value ?? '',
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              fontWight: FontWeight.w400,
              fontSize: 12,
            ),
      ),
    ],
  );
}
OutlineInputBorder commonTextFiledBorder({
  double? borderRadius,
  Color? borderColor,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius ?? 12),
    borderSide: BorderSide(
      width: 1.1,
      color: borderColor ?? color3,
    ),
  );
}