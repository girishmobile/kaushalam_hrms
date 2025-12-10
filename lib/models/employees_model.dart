class EmployeesModel {
  final int draw;
  final int recordsFiltered;
  final int recordsTotal;
  final List<Employee> employees;

  EmployeesModel({
    required this.employees,
    required this.draw,
    required this.recordsFiltered,
    required this.recordsTotal,
  });
  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    // data could be null, empty, or a list
    List<Employee> list = [];

    if (json['data'] != null && json['data'] is List) {
      list = (json['data'] as List)
          .map((item) => Employee.fromJson(item))
          .toList();
    }

    return EmployeesModel(
      employees: list,
      draw: json['draw'] ?? 0,
      recordsFiltered: json['recordsFiltered'] ?? 0,
      recordsTotal: json['recordsTotal'] ?? 0,
    );
  }
}

class Department {
  final int id;
  final String name;
  final int employees;

  Department({required this.id, required this.name, required this.employees});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      employees: json['employees'],
    );
  }
}

class Employee {
  final int id;
  final String firstname;
  final String lastname;
  final String employeeId;
  final String? profileImage;
  final String departmentName;
  final bool? onTraining;
  final String? probationEndDate;
  final DateTime? joiningDate;
  final bool isWfhAllowed;
  final String? location;
  final String? altSat;
  final int totalDays;
  final int leaves;

  Employee({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.employeeId,
    required this.profileImage,
    required this.departmentName,
    required this.onTraining,
    required this.probationEndDate,
    required this.joiningDate,
    required this.isWfhAllowed,
    required this.location,
    required this.altSat,
    required this.totalDays,
    required this.leaves,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      employeeId: json['employee_id']?.toString() ?? '',

      profileImage: json['profile_image'] is String
          ? json['profile_image']
          : null,

      departmentName: json['departmentname'] ?? '',

      onTraining: json['on_training'],

      probationEndDate: json['probation_end_date'] is String
          ? json['probation_end_date']
          : null,

      joiningDate:
          json['joining_date'] != null &&
              json['joining_date'] is Map &&
              json['joining_date']['date'] != null
          ? DateTime.tryParse(json['joining_date']['date'])
          : null,

      isWfhAllowed: json['is_wfh_allowed'] ?? false,

      location: json['location'] is String ? json['location'] : null,

      altSat: json['alt_sat'] is String ? json['alt_sat'] : null,

      totalDays: json['total_days'] ?? 0,
      leaves: json['leaves'] ?? 0,
    );
  }
}
