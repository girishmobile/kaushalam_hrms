// ignore_for_file: non_constant_identifier_names

class BirthHolidayModel {
  List<BirthDay> birthdays;
  List<Holiday> holidays;
  BirthHolidayModel({required this.birthdays, required this.holidays});

  /// From API JSON
  factory BirthHolidayModel.fromApiJson(Map<String, dynamic> json) {
    return BirthHolidayModel(
      birthdays: (json["birthdays"] as List<dynamic>)
          .map((e) => BirthDay.fromApiJson(e))
          .toList(),
      holidays: (json["holidays"] as List<dynamic>)
          .map((e) => Holiday.fromApiJson(e))
          .toList(),
    );
  }
}

class BirthDay {
  int id;
  String firstname;
  String lastname;
  String? profile_image;
  String department;
  String designation;
  DateOfBirth dateOfBirth;

  BirthDay({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.profile_image,
    required this.department,
    required this.designation,
    required this.dateOfBirth,
  });
  factory BirthDay.fromApiJson(Map<String, dynamic> json) {
    return BirthDay(
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      profile_image: json["profile_image"],
      department: json["department"],
      designation: json["designation"],
      dateOfBirth: DateOfBirth.fromApiJson(json["date_of_birth"]),
    );
  }
}

class DateOfBirth {
  DateTime date;
  int timezone_type;
  String timezone;
  DateOfBirth({
    required this.date,
    required this.timezone_type,
    required this.timezone,
  });
  factory DateOfBirth.fromApiJson(Map<String, dynamic> json) {
    return DateOfBirth(
      date: DateTime.parse(json["date"]),
      timezone_type: json["timezone_type"],
      timezone: json["timezone"],
    );
  }
}

class Holiday {
  int id;
  String event_name;
  int year;
  int? is_company_event;
  DateOfBirth start_date;
  DateOfBirth end_date;
  String? holiday_image;
  DateOfBirth? created_at;
  DateOfBirth? updated_at;
  dynamic deletedAt;

  Holiday({
    required this.id,
    required this.event_name,
    required this.year,
    this.is_company_event,
    required this.start_date,
    required this.end_date,
    this.holiday_image,
    this.created_at,
    this.updated_at,
    this.deletedAt,
  });
  factory Holiday.fromApiJson(Map<String, dynamic> json) {
    return Holiday(
      id: json["id"],
      event_name: json["event_name"],
      year: json["year"],
      is_company_event: json["is_company_event"],
      start_date: DateOfBirth.fromApiJson(json["start_date"]),
      end_date: DateOfBirth.fromApiJson(json["end_date"]),
      holiday_image: json["holiday_image"],
      created_at: json["created_at"] != null
          ? DateOfBirth.fromApiJson(json["created_at"])
          : null,
      updated_at: json["updated_at"] != null
          ? DateOfBirth.fromApiJson(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
    );
  }
}
