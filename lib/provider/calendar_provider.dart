import 'dart:convert';
import 'package:flutter/material.dart';

import '../api/api_config.dart';
import '../api/network_repository.dart';

class CalendarProvider extends ChangeNotifier {
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};

  Map<DateTime, List<Map<String, dynamic>>> get events => _events;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> getCalenderList(DateTime monthDate) async {
    final monthStart = DateTime(monthDate.year, monthDate.month, 1);

    final body = {
      "date": monthStart.toIso8601String(), // ✅ valid ISO 8601 timestamp
    };

    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.calenderUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final data = json.decode(response);

        _parseEvents(data, monthDate); // ✅ pass monthDate here
        notifyListeners();
        _setLoading(false);
      } else {
        notifyListeners();
        _setLoading(false);
      }
    } catch (e) {
      notifyListeners();
      _setLoading(false);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Parse response into calendar events
  void _parseEvents(Map<String, dynamic> data, DateTime monthDate) {
    _events.clear();

    final teamMembers = data["team_member"] ?? [];
    for (var member in teamMembers) {
      final leaveData = member["0"];
      if (leaveData == null) continue;

      final start = DateTime.parse(leaveData["leave_date"]["date"]);
      final end = DateTime.parse(leaveData["leave_end_date"]["date"]);

      // Add event for each date in the leave range
      for (
        var d = start;
        d.isBefore(end.add(const Duration(days: 1)));
        d = d.add(const Duration(days: 1))
      ) {
        final dateKey = DateTime(d.year, d.month, d.day);
        _events.putIfAbsent(dateKey, () => []).add({
          "title":
              "${member["firstname"] ?? ''} ${member["lastname"] ?? ''} (${member["leavetype"]})",
          "type": "leave",
          "id": leaveData['id'],
          "status": leaveData["status"],
        });
      }
    }

    // Add birthdays (mark for same month in current year)
    final birthdays = data["month_bday_data"] ?? [];
    for (var person in birthdays) {
      final dob = DateTime.parse(person["date_of_birth"]["date"]);
      final dateKey = DateTime(monthDate.year, dob.month, dob.day); // ✅ fixed
      _events.putIfAbsent(dateKey, () => []).add({
        "title": "${person["firstname"]} ${person["lastname"]}",
        "type": "Birthday",
        "id": person['id'],
        "profile": person["profile_image"],
      });
    }

    notifyListeners();
  }

  /// Return events for a specific day
  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void reset() {
    _events.clear();
    _isLoading = false;
  }
}
