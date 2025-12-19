import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static final Uuid _uuid = Uuid();

  /// Generate a random UUID (v4)
  static String generateUUID() {
    return _uuid.v4();
  }

  /// Generate a time-based UUID (v1)
  static String generateTimeUUID() {
    return _uuid.v1();
  }
}

String formatPrice(dynamic price, {String currency = "\$"}) {
  final value = (price is double)
      ? price
      : double.tryParse(price.toString()) ?? 0.0;
  return "$currency${value.toStringAsFixed(2)}";
}

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inMinutes < 1) return "just now";
  if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
  if (diff.inHours < 24) return "${diff.inHours}h ago";
  return "${diff.inDays}d ago";
}
//Padding

double listTop(BuildContext context, {double extra = 0}) {
  final safeTop = MediaQuery.of(context).padding.top;
  const topBarHeight = 56.0; // your Dashboard SafeArea Row
  const searchBoxHeight = 56.0;
  return safeTop + topBarHeight + searchBoxHeight + 8 + extra;
}

double listBottom(BuildContext context, {double extra = 0}) {
  final safeBottom = MediaQuery.of(context).padding.bottom;
  const bottomBarHeight = 64.0; // your Dashboard bottom bar height

  return safeBottom + bottomBarHeight + 16 + extra;
}

double appTopPadding(BuildContext context, {double extra = 0}) {
  final safeTop = MediaQuery.of(context).padding.top;
  const topBarHeight = 48.0; // your Dashboard SafeArea Row
  final listTop =
      safeTop + topBarHeight + 8 + extra; // search bar height + spacing

  return listTop;
}

double appBottomPadding(BuildContext context, {double extra = 0}) {
  final safeBottom = MediaQuery.of(context).padding.bottom;
  // const topBarHeight = 48.0; // your Dashboard SafeArea Row

  final listTop = safeBottom + 8 + extra; // search bar height + spacing

  return listTop;
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void showSnackBar(
  BuildContext context, {
  required String message,
  Color? bgColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: bgColor ?? Colors.black87,
      duration: const Duration(seconds: 2),
    ),
  );
}

String getWorkDurationFromString(String? joiningDateStr) {
  if (joiningDateStr == null || joiningDateStr.isEmpty) {
    return "Not Available";
  }

  DateTime? joiningDate;

  try {
    joiningDate = DateTime.parse(joiningDateStr); // e.g. "2023-05-10"
  } catch (e) {
    return "Invalid Date";
  }

  final now = DateTime.now();

  int years = now.year - joiningDate.year;
  int months = now.month - joiningDate.month;
  int days = now.day - joiningDate.day;

  // Fix day negative values
  if (days < 0) {
    final previousMonth = DateTime(now.year, now.month, 0);
    days += previousMonth.day;
    months -= 1;
  }

  // Fix negative months
  if (months < 0) {
    months += 12;
    years -= 1;
  }

  return "$years year $months month $days days";
}

//Date Time
DateTime getCurrentDateTime() {
  return DateTime.now();
}

//Format date and time
String formateDateTime(
  DateTime dateTime, {
  String format = 'yyyy-MM-dd HH:mm:ss',
}) {
  return DateFormat(format).format(dateTime);
}

//get only date (default yyyy-MM-dd)
String getFormattedDate(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
  return DateFormat(format).format(dateTime);
}

String formatDate(String? date, {String format = "dd-MMM-yy"}) {
  if (date == null || date.isEmpty) return '';
  try {
    final parsed = DateTime.parse(date);
    return DateFormat(format).format(parsed);
  } catch (_) {
    return date;
  }
}

//Get only time (default HH:mm:ss)
String getFormattedTime(DateTime dateTime, {String format = 'HH:mm:ss'}) {
  return DateFormat(format).format(dateTime);
}

String convertDate(String? date, {String format = "dd-MMM-yy"}) {
  if (date == null || date.isEmpty) return '-';
  try {
    final parsed = DateTime.parse(date);
    return DateFormat(format).format(parsed);
  } catch (_) {
    return date;
  }
}

String comrateStartEndate(dynamic startDate, dynamic endDate) {
  String formattedDate;

  if (startDate == endDate) {
    // Same Date
    formattedDate = convertDate(startDate, format: "dd MMM yyyy");
  } else {
    // Date Range
    formattedDate =
        '${convertDate(startDate, format: "dd MMM yyyy")} To ${convertDate(endDate, format: "dd MMM yyyy")}';
  }
  return formattedDate;
}

String formatDay(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final day = date.day;
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    return '$day$suffix ';
  } catch (_) {
    return dateString;
  }
}

String? setImagePath(String? imageUrl) {
  return (imageUrl != null && imageUrl.isNotEmpty)
      ? "${ApiConfig.imageBaseUrl}$imageUrl"
      : null;
}

String removeHtmlTags(String htmlText) {
  final regex = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
  return htmlText.replaceAll(regex, "").trim();
}

String getLeaveTypeName(String? code) {
  const map = {"CL": "Casual Leave", "SL": "Sick Leave", "PL": "Paid Leave"};
  return map[code] ?? code ?? "Unknown Leave";
}

void showRejectLeaveDialog(
  BuildContext context,
  Function(String reason) onConfirmReject,
) {
  final TextEditingController reasonController = TextEditingController();
  String? errorText; // <-- move here (persistent)
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        // for validation update
        builder: (context, setState) {
          // String? errorText;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Reject Leave",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  const Text(
                    "Reason",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 8),

                  // TextField With Validation
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter reason...",
                      border: OutlineInputBorder(),
                      errorText: errorText,
                    ),
                    onChanged: (_) {
                      if (errorText != null) {
                        setState(() {
                          errorText = null; // remove error on typing
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text("Confirm"),
                        onPressed: () {
                          if (reasonController.text.trim().isEmpty) {
                            setState(
                              () => errorText = "Reason cannot be empty",
                            );
                            return;
                          }
                          Navigator.pop(context);
                          onConfirmReject(reasonController.text.trim());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class StatusConfig {
  final Color color;
  final IconData icon;
  final String label;
  StatusConfig(this.color, this.icon, this.label);
}

// StatusConfig _statusConfig(String status) {
//   switch (status.toLowerCase()) {
//     case 'online':
//       return StatusConfig(Colors.green, Icons.check_circle, 'Online');

//     case 'offline':
//       return StatusConfig(Colors.grey, Icons.cancel, 'Offline');

//     case 'on-break':
//       return StatusConfig(Colors.orange, Icons.pause_circle, 'On Break');

//     case 'wfh':
//       return StatusConfig(Colors.blue, Icons.home, 'WFH');

//     case 'on-leave':
//       return StatusConfig(Colors.red, Icons.event_busy, 'On Leave');

//     default:
//       return StatusConfig(Colors.grey, Icons.help, 'Unknown');
//   }
//}
