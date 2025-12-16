// ignore_for_file: non_constant_identifier_names

import 'package:neeknots_admin/utility/secure_storage.dart';

class ApiConfig {
  // static String BaseUrl = "https://redefinecommerce.net/krms/backend/api";
  static String BaseUrl = "https://www.kaushalam.info/backend/api";

  //static String imageBaseUrl = "https://redefinecommerce.net/krms/backend/public/upload/";
  static String imageBaseUrl =
      "https://www.kaushalam.info/backend/public/upload/";

  //End point
  static String loginUrl = "$BaseUrl/login";
  static String forgotPasswordUrl = "$BaseUrl/forgotPassword";

  static String attendanceUrl =
      "$BaseUrl/hikattendance/currentMonthHikAttendanceRecord";
  static String leaveCountDataUrl = "$BaseUrl/leave_application/summary";
  static String leaveBalanceUrl = "$BaseUrl/user_leave/getLeaveByEmp";
  static String upcomingLeaveHolidayUrl = "$BaseUrl/user/getUpcomingBdays";

  static String allHolidays = "$BaseUrl/getHolidayData2025";
  static String employeeLeaveBalance = "$BaseUrl/datatable/getAllUserLeaves";
  static String getLeaveDataUrl =
      "$BaseUrl/leave_application/getSelfLeaveRequiredData";

  static String applyLeave =
      "$BaseUrl/leave_application/save_leave_application";
  static String getAllEmployeeLeaveUrl = "$BaseUrl/datatable/getAllLeaves";
  static String getLeaveDataDashboardUrl =
      "$BaseUrl/dashboard/getLeaveDataDashboard";

  static String employeeLeavesUrl = "$BaseUrl/datatable/getLeaveRequiredData";
  static String deleteLeaveUrl =
      "$BaseUrl/leave_application/delete_leave_application";

  static String getUserDetailsByIdUrl = "$BaseUrl/user/getEmployeeById";
  static String employeeNotificationUrl =
      "$BaseUrl/activity_box/getEmpNotifications?start=0&length=10";

  static String rejectLeaveUrl =
      "$BaseUrl/leave_application/update_reject_status";

  static String approvedLeaveUrl =
      "$BaseUrl/leave_application/update_accept_status";
  static String uploadProfileImageUrl = "$BaseUrl/uploadlogo";

  static String kpiListUrl = "$BaseUrl/kra-kpi/summary";

  static String updateProfileDataUrl = "$BaseUrl/user/update_employee";
  static String userUpdatePasswordURL = "$BaseUrl/user/update_user_password";
  static String getMyHoursURL = "$BaseUrl/project-manage/getSelfProjects";
  static String hotlineCountUrl = "$BaseUrl/attendance/hotline-count";
  static String departmentUrl = "$BaseUrl/department/get_all_department";
  static String getAllDesignationUrl =
      "$BaseUrl/designation/get_all_designation";
  static String hotlineUrl = "$BaseUrl/attendance/hotline";
  static String getAttendanceUrl =
      "$BaseUrl/hikattendance/getUserAttendanceByDate";
  static String calenderUrl = "$BaseUrl/dashboard/getLeavesSelfDashboard";
  static String getDepartmentURL = "$BaseUrl/department/get_all_department";

  static String getAllEmployeeUrl = "$BaseUrl/datatable/getDatatableUsers";
  static String realAllNotification = "$BaseUrl/activity_box/readAllNotificationsEmp";

  //FCM update
  static String updateFCMTokenUrl = "$BaseUrl/user/update-fcm-token";

  //API header
  static Future<Map<String, String>> getApiHeaders() async {
    final token = await SecureStorage.getToken();

    return {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };
  }
}

String? errorMessage = "Something went wrong. Please try again later.";
int globalStatusCode = 404;
