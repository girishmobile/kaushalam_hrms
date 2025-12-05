class UserModel {
  final String token;
  final String firstname;
  final String lastname;
  final String email;
  final String? profile;
  final int id;
  final List permission;
  final String employeeId;
  final Map<String, dynamic> role;

  UserModel({
    required this.token,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.id,
    required this.employeeId,
    required this.permission,
    this.profile,
    required this.role,
  });

  /// From API JSON
  factory UserModel.fromApiJson(Map<String, dynamic> json) {
    final data = json["data"];
    final user = data["user"];

    return UserModel(
      token: data["token"],
      firstname: user["firstname"],
      lastname: user["lastname"],
      email: user["email"],
      id: user["id"],
      employeeId: user["employee_id"],
      permission: user["permission"],
      profile: user["profile"],
      role: user["role"],
    );
  }

  /// From local storage
  factory UserModel.fromLocalJson(Map<String, dynamic> json) {
    return UserModel(
      token: json["token"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      id: json["id"],
      employeeId: json["employee_id"],
      permission: json["permission"],
      profile: json["profile"],
      role: json["role"],
    );
  }

  /// To local storage JSON
  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "id": id,
      "employee_id": employeeId,
      "profile": profile,
      "permission": permission,
      "role": role,
    };
  }
}
