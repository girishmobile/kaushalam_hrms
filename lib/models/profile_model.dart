class ProfileModel {
  int? id;
  String? firstname;
  String? lastname;
  String? employeeId;
  String? about;
  dynamic companyName;
  String? spouseName;
  String? spouseOccuption;
  SpouseDob? spouseDob;
  String? child1Name;
  String? child1Occuption;
  SpouseDob? child1Dob;
  dynamic child2Name;
  dynamic child2Occuption;
  dynamic child2Dob;
  dynamic child3Name;
  dynamic child3Occuption;
  dynamic child3Dob;
  String? email;
  String? companyEmail;
  String? address;
  String? perAddress;
  bool? allowedLogin;
  bool? isWfhAllowed;
  bool? onProbation;
  bool? onNotice;
  dynamic onTraining;
  bool? isManager;
  bool? maritalStatus;
  SpouseDob? probationEndDate;
  SpouseDob? joiningDate;
  dynamic incrementDate;
  dynamic exitDate;
  bool? userExitStatus;
  SpouseDob? dateOfBirth;
  SpouseDob? marriageAnniversaryDate;
  String? contactNo;
  String? emergencyContactNo;
  String? emergencyContactPerson;
  String? bloodGroup;
  dynamic drivingLicenseNumber;
  String? panNumber;
  String? aadharNumber;
  dynamic aadharPassword;
  dynamic voterIdNumber;
  dynamic uanNumber;
  dynamic pfNumber;
  dynamic esicNumber;
  dynamic drivingLicenseImage;
  dynamic panIdImage;
  dynamic aadharIdImage;
  dynamic voterIdImage;
  dynamic lc;
  dynamic marksheet;
  dynamic offerLaterFile;
  dynamic joiningLetterFile;
  dynamic contractFile;
  dynamic resumeFile;
  dynamic appointmentLetter;
  dynamic incrementLetter;
  dynamic promotionLetter;
  dynamic relievingLetter;
  dynamic expLetter;
  dynamic appreciationLetter;
  dynamic documentReturnsLetter;
  dynamic noDueCertificate;
  dynamic acknowledgementLetter;
  dynamic warningLetter;
  dynamic passportNumber;
  dynamic passportIssueDate;
  dynamic passportExpiryDate;
  dynamic passportImage;
  dynamic visaNumber;
  dynamic visaIssueDate;
  dynamic visaExpiryDate;
  dynamic visaImage;
  dynamic slackUsername;
  dynamic linkdinUsername;
  dynamic facebookUsername;
  dynamic profileImage;
  dynamic twitterUsername;
  dynamic certificationsCourses;
  dynamic otherWorkExperirnce;
  SpouseDob? createdAt;
  SpouseDob? updatedAt;
  dynamic deletedAt;
  dynamic rememberToken;
  List<Roles>? roles;
  dynamic status;
  Gender? gender;
  Department? department;
  Department? designation;
  Location? location;
  dynamic primaryAccount;
  List<dynamic>? userWork;
  List<dynamic>? userQualification;
  List<dynamic>? userAccount;
  List<UserLeaves>? userLeaves;
  List<dynamic>? userCommitteeList;
  List<dynamic>? userTagList;
  ReportTo? reportTo;

  ProfileModel({
    this.id,
    this.firstname,
    this.lastname,
    this.employeeId,
    this.about,
    this.companyName,
    this.spouseName,
    this.spouseOccuption,
    this.spouseDob,
    this.child1Name,
    this.child1Occuption,
    this.child1Dob,
    this.child2Name,
    this.child2Occuption,
    this.child2Dob,
    this.child3Name,
    this.child3Occuption,
    this.child3Dob,
    this.email,
    this.companyEmail,
    this.address,
    this.perAddress,
    this.allowedLogin,
    this.isWfhAllowed,
    this.onProbation,
    this.onNotice,
    this.onTraining,
    this.isManager,
    this.maritalStatus,
    this.probationEndDate,
    this.joiningDate,
    this.incrementDate,
    this.exitDate,
    this.userExitStatus,
    this.dateOfBirth,
    this.marriageAnniversaryDate,
    this.contactNo,
    this.emergencyContactNo,
    this.emergencyContactPerson,
    this.bloodGroup,
    this.drivingLicenseNumber,
    this.panNumber,
    this.aadharNumber,
    this.aadharPassword,
    this.voterIdNumber,
    this.uanNumber,
    this.pfNumber,
    this.esicNumber,
    this.drivingLicenseImage,
    this.panIdImage,
    this.aadharIdImage,
    this.voterIdImage,
    this.lc,
    this.marksheet,
    this.offerLaterFile,
    this.joiningLetterFile,
    this.contractFile,
    this.resumeFile,
    this.appointmentLetter,
    this.incrementLetter,
    this.promotionLetter,
    this.relievingLetter,
    this.expLetter,
    this.appreciationLetter,
    this.documentReturnsLetter,
    this.noDueCertificate,
    this.acknowledgementLetter,
    this.warningLetter,
    this.passportNumber,
    this.passportIssueDate,
    this.passportExpiryDate,
    this.passportImage,
    this.visaNumber,
    this.visaIssueDate,
    this.visaExpiryDate,
    this.visaImage,
    this.slackUsername,
    this.linkdinUsername,
    this.facebookUsername,
    this.profileImage,
    this.twitterUsername,
    this.certificationsCourses,
    this.otherWorkExperirnce,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.rememberToken,
    this.roles,
    this.status,
    this.gender,
    this.department,
    this.designation,
    this.location,
    this.primaryAccount,
    this.userWork,
    this.userQualification,
    this.userAccount,
    this.userLeaves,
    this.userCommitteeList,
    this.userTagList,
    this.reportTo,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    employeeId = json['employee_id'];
    about = json['about'];
    companyName = json['company_name'];
    spouseName = json['spouse_name'];
    spouseOccuption = json['spouse_occuption'];
    spouseDob =
        (json['spouse_dob'] != null &&
            json['spouse_dob'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['spouse_dob'])
        : null;
    child1Name = json['child1_name'];
    child1Occuption = json['child1_occuption'];
    child1Dob =
        (json['child1_dob'] != null &&
            json['child1_dob'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['child1_dob'])
        : null;
    child2Name = json['child2_name'];
    child2Occuption = json['child2_occuption'];
    child2Dob = json['child2_dob'];
    child3Name = json['child3_name'];
    child3Occuption = json['child3_occuption'];
    child3Dob = json['child3_dob'];
    email = json['email'];
    companyEmail = json['company_email'];
    address = json['address'];
    perAddress = json['per_address'];
    allowedLogin = json['allowed_login'];
    isWfhAllowed = json['is_wfh_allowed'];
    onProbation = json['on_probation'];
    onNotice = json['on_notice'];
    onTraining = json['on_training'];
    isManager = json['is_manager'];
    maritalStatus =
        json['marital_status'] == true || json['marital_status'] == "true";

    probationEndDate =
        (json['probation_end_date'] != null &&
            json['probation_end_date'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['probation_end_date'])
        : null;
    joiningDate =
        (json['joining_date'] != null &&
            json['joining_date'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['joining_date'])
        : null;
    incrementDate = json['increment_date'];
    exitDate = json['exit_date'];
    userExitStatus = json['user_exit_status'];
    dateOfBirth =
        (json['date_of_birth'] != null &&
            json['date_of_birth'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['date_of_birth'])
        : null;

    marriageAnniversaryDate =
        (json['marriage_anniversary_date'] != null &&
            json['marriage_anniversary_date'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['marriage_anniversary_date'])
        : null;

    contactNo = json['contact_no'];
    emergencyContactNo = json['emergency_contact_no'];
    emergencyContactPerson = json['emergency_contact_person'];
    bloodGroup = json['blood_group'];
    drivingLicenseNumber = json['driving_license_number'];
    panNumber = json['pan_number'];
    aadharNumber = json['aadhar_number'];
    aadharPassword = json['aadhar_password'];
    voterIdNumber = json['voter_id_number'];
    uanNumber = json['uan_number'];
    pfNumber = json['pf_number'];
    esicNumber = json['esic_number'];
    drivingLicenseImage = json['driving_license_image'];
    panIdImage = json['pan_id_image'];
    aadharIdImage = json['aadhar_id_image'];
    voterIdImage = json['voter_id_image'];
    lc = json['lc'];
    marksheet = json['marksheet'];
    offerLaterFile = json['offer_later_file'];
    joiningLetterFile = json['joining_letter_file'];
    contractFile = json['contract_file'];
    resumeFile = json['resume_file'];
    appointmentLetter = json['appointment_letter'];
    incrementLetter = json['increment_letter'];
    promotionLetter = json['promotion_letter'];
    relievingLetter = json['relieving_letter'];
    expLetter = json['exp_letter'];
    appreciationLetter = json['appreciation_letter'];
    documentReturnsLetter = json['document_returns_letter'];
    noDueCertificate = json['no_due_certificate'];
    acknowledgementLetter = json['acknowledgement_letter'];
    warningLetter = json['warning_letter'];
    passportNumber = json['passport_number'];
    passportIssueDate = json['passport_issue_date'];
    passportExpiryDate = json['passport_expiry_date'];
    passportImage = json['passport_image'];
    visaNumber = json['visa_number'];
    visaIssueDate = json['visa_issue_date'];
    visaExpiryDate = json['visa_expiry_date'];
    visaImage = json['visa_image'];
    slackUsername = json['slack_username'];
    linkdinUsername = json['linkdin_username'];
    facebookUsername = json['facebook_username'];
    profileImage = json['profile_image'];
    twitterUsername = json['twitter_username'];
    certificationsCourses = json['certifications_courses'];
    otherWorkExperirnce = json['other_work_experirnce'];
    createdAt =
        (json['created_at'] != null &&
            json['created_at'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['created_at'])
        : null;
    updatedAt =
        (json['updated_at'] != null &&
            json['updated_at'] is Map<String, dynamic>)
        ? SpouseDob.fromJson(json['updated_at'])
        : null;

    deletedAt = json['deletedAt'];
    rememberToken = json['rememberToken'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    status = json['status'];
    gender = json['gender'] != null ? Gender.fromJson(json['gender']) : null;
    department =
        (json['department'] != null &&
            json['department'] is Map<String, dynamic>)
        ? Department.fromJson(json['department'])
        : null;

    designation =
        (json['designation'] != null &&
            json['designation'] is Map<String, dynamic>)
        ? Department.fromJson(json['designation'])
        : null;
    location =
        (json['location'] != null && json['location'] is Map<String, dynamic>)
        ? Location.fromJson(json['location'])
        : null;

    primaryAccount = json['primary_account'];
    /*if (json['user_work'] != null) {
      userWork = <Null>[];
      json['user_work'].forEach((v) {
        userWork!.add(new Null.fromJson(v));
      });
    }*/
    if (json['user_work'] != null) {
      userWork = List<dynamic>.from(json['user_work']);
    }
    /*if (json['user_qualification'] != null) {
      userQualification = <Null>[];
      json['user_qualification'].forEach((v) {
        userQualification!.add(new Null.fromJson(v));
      });
    }*/
    if (json['user_qualification'] != null) {
      userQualification = List<dynamic>.from(json['user_qualification']);
    }
    /* if (json['user_account'] != null) {
      userAccount = <Null>[];
      json['user_account'].forEach((v) {
        userAccount!.add(new Null.fromJson(v));
      });
    }*/
    if (json['user_account'] != null) {
      userAccount = List<dynamic>.from(json['user_account']);
    }
    if (json['user_leaves'] != null) {
      userLeaves = <UserLeaves>[];
      json['user_leaves'].forEach((v) {
        userLeaves!.add(UserLeaves.fromJson(v));
      });
    }
    /*   if (json['user_committee_list'] != null) {
      userCommitteeList = <Null>[];
      json['user_committee_list'].forEach((v) {
        userCommitteeList!.add(new Null.fromJson(v));
      });
    }*/
    if (json['user_committee_list'] != null) {
      userCommitteeList = List<dynamic>.from(json['user_committee_list']);
    }

    if (json['user_tag_list'] != null) {
      userTagList = List<dynamic>.from(json['user_tag_list']);
    }
    /*if (json['user_tag_list'] != null) {
      userTagList = <Null>[];
      json['user_tag_list'].forEach((v) {
        userTagList!.add(new Null.fromJson(v));
      });
    }*/
    reportTo = json['report_to'] != null
        ? ReportTo.fromJson(json['report_to'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['employee_id'] = employeeId;
    data['about'] = about;
    data['company_name'] = companyName;
    data['spouse_name'] = spouseName;
    data['spouse_occuption'] = spouseOccuption;
    if (spouseDob != null) {
      data['spouse_dob'] = spouseDob!.toJson();
    }
    data['child1_name'] = child1Name;
    data['child1_occuption'] = child1Occuption;
    if (child1Dob != null) {
      data['child1_dob'] = child1Dob!.toJson();
    }
    data['child2_name'] = child2Name;
    data['child2_occuption'] = child2Occuption;
    data['child2_dob'] = child2Dob;
    data['child3_name'] = child3Name;
    data['child3_occuption'] = child3Occuption;
    data['child3_dob'] = child3Dob;
    data['email'] = email;
    data['company_email'] = companyEmail;
    data['address'] = address;
    data['per_address'] = perAddress;
    data['allowed_login'] = allowedLogin;
    data['is_wfh_allowed'] = isWfhAllowed;
    data['on_probation'] = onProbation;
    data['on_notice'] = onNotice;
    data['on_training'] = onTraining;
    data['is_manager'] = isManager;
    data['marital_status'] = maritalStatus;
    if (probationEndDate != null) {
      data['probation_end_date'] = probationEndDate!.toJson();
    }
    if (joiningDate != null) {
      data['joining_date'] = joiningDate!.toJson();
    }
    data['increment_date'] = incrementDate;
    data['exit_date'] = exitDate;
    data['user_exit_status'] = userExitStatus;
    if (dateOfBirth != null) {
      data['date_of_birth'] = dateOfBirth!.toJson();
    }
    if (marriageAnniversaryDate != null) {
      data['marriage_anniversary_date'] = marriageAnniversaryDate!.toJson();
    }
    data['contact_no'] = contactNo;
    data['emergency_contact_no'] = emergencyContactNo;
    data['emergency_contact_person'] = emergencyContactPerson;
    data['blood_group'] = bloodGroup;
    data['driving_license_number'] = drivingLicenseNumber;
    data['pan_number'] = panNumber;
    data['aadhar_number'] = aadharNumber;
    data['aadhar_password'] = aadharPassword;
    data['voter_id_number'] = voterIdNumber;
    data['uan_number'] = uanNumber;
    data['pf_number'] = pfNumber;
    data['esic_number'] = esicNumber;
    data['driving_license_image'] = drivingLicenseImage;
    data['pan_id_image'] = panIdImage;
    data['aadhar_id_image'] = aadharIdImage;
    data['voter_id_image'] = voterIdImage;
    data['lc'] = lc;
    data['marksheet'] = marksheet;
    data['offer_later_file'] = offerLaterFile;
    data['joining_letter_file'] = joiningLetterFile;
    data['contract_file'] = contractFile;
    data['resume_file'] = resumeFile;
    data['appointment_letter'] = appointmentLetter;
    data['increment_letter'] = incrementLetter;
    data['promotion_letter'] = promotionLetter;
    data['relieving_letter'] = relievingLetter;
    data['exp_letter'] = expLetter;
    data['appreciation_letter'] = appreciationLetter;
    data['document_returns_letter'] = documentReturnsLetter;
    data['no_due_certificate'] = noDueCertificate;
    data['acknowledgement_letter'] = acknowledgementLetter;
    data['warning_letter'] = warningLetter;
    data['passport_number'] = passportNumber;
    data['passport_issue_date'] = passportIssueDate;
    data['passport_expiry_date'] = passportExpiryDate;
    data['passport_image'] = passportImage;
    data['visa_number'] = visaNumber;
    data['visa_issue_date'] = visaIssueDate;
    data['visa_expiry_date'] = visaExpiryDate;
    data['visa_image'] = visaImage;
    data['slack_username'] = slackUsername;
    data['linkdin_username'] = linkdinUsername;
    data['facebook_username'] = facebookUsername;
    data['profile_image'] = profileImage;
    data['twitter_username'] = twitterUsername;
    data['certifications_courses'] = certificationsCourses;
    data['other_work_experirnce'] = otherWorkExperirnce;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    data['rememberToken'] = rememberToken;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    if (gender != null) {
      data['gender'] = gender!.toJson();
    }
    if (department != null) {
      data['department'] = department!.toJson();
    }
    if (designation != null) {
      data['designation'] = designation!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['primary_account'] = primaryAccount;
    if (userWork != null) {
      data['user_work'] = userWork!.map((v) => v.toJson()).toList();
    }
    if (userQualification != null) {
      data['user_qualification'] = userQualification!
          .map((v) => v.toJson())
          .toList();
    }
    if (userAccount != null) {
      data['user_account'] = userAccount!.map((v) => v.toJson()).toList();
    }
    if (userLeaves != null) {
      data['user_leaves'] = userLeaves!.map((v) => v.toJson()).toList();
    }
    if (userCommitteeList != null) {
      data['user_committee_list'] = userCommitteeList!
          .map((v) => v.toJson())
          .toList();
    }
    if (userTagList != null) {
      data['user_tag_list'] = userTagList!.map((v) => v.toJson()).toList();
    }
    if (reportTo != null) {
      data['report_to'] = reportTo!.toJson();
    }
    return data;
  }
}

class SpouseDob {
  String? date;
  int? timezoneType;
  String? timezone;
  SpouseDob({this.date, this.timezoneType, this.timezone});
  SpouseDob.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['timezone_type'] = timezoneType;
    data['timezone'] = timezone;
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? description;
  SpouseDob? createdAt;
  SpouseDob? updatedAt;
  Null deletedAt;

  Roles({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'] != null
        ? SpouseDob.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? SpouseDob.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class Gender {
  int? id;
  String? keyText;
  String? valueText;
  SpouseDob? createdAt;
  SpouseDob? updatedAt;
  Null deletedAt;

  Gender({
    this.id,
    this.keyText,
    this.valueText,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Gender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyText = json['key_text'];
    valueText = json['value_text'];
    createdAt = json['created_at'] != null
        ? SpouseDob.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? SpouseDob.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key_text'] = keyText;
    data['value_text'] = valueText;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class Department {
  int? id;
  String? name;
  SpouseDob? createdAt;
  SpouseDob? updatedAt;
  Null deletedAt;

  Department({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'] != null
        ? SpouseDob.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? SpouseDob.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class Location {
  int? id;
  String? name;
  Null address;
  SpouseDob? officeStartTime;
  SpouseDob? officeEndTime;
  bool? employeeSelfChecking;
  bool? overtimePay;
  bool? halfDayAllowed;
  SpouseDob? halfDayHours;
  bool? clockReminder;
  SpouseDob? clockReminderTime;
  String? lateMarkAfterMinute;
  Null allowedIp;
  String? workingDays;
  Null altSat;
  SpouseDob? createdAt;
  SpouseDob? updatedAt;
  Null deletedAt;

  Location({
    this.id,
    this.name,
    this.address,
    this.officeStartTime,
    this.officeEndTime,
    this.employeeSelfChecking,
    this.overtimePay,
    this.halfDayAllowed,
    this.halfDayHours,
    this.clockReminder,
    this.clockReminderTime,
    this.lateMarkAfterMinute,
    this.allowedIp,
    this.workingDays,
    this.altSat,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    officeStartTime = json['office_start_time'] != null
        ? SpouseDob.fromJson(json['office_start_time'])
        : null;
    officeEndTime = json['office_end_time'] != null
        ? SpouseDob.fromJson(json['office_end_time'])
        : null;
    employeeSelfChecking = json['employee_self_checking'];
    overtimePay = json['overtime_pay'];
    halfDayAllowed = json['half_day_allowed'];
    halfDayHours = json['half_day_hours'] != null
        ? SpouseDob.fromJson(json['half_day_hours'])
        : null;
    clockReminder = json['clock_reminder'];
    clockReminderTime = json['clock_reminder_time'] != null
        ? SpouseDob.fromJson(json['clock_reminder_time'])
        : null;
    lateMarkAfterMinute = json['late_mark_after_minute'];
    allowedIp = json['allowed_ip'];
    workingDays = json['working_days'];
    altSat = json['alt_sat'];
    createdAt = json['created_at'] != null
        ? SpouseDob.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? SpouseDob.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    if (officeStartTime != null) {
      data['office_start_time'] = officeStartTime!.toJson();
    }
    if (officeEndTime != null) {
      data['office_end_time'] = officeEndTime!.toJson();
    }
    data['employee_self_checking'] = employeeSelfChecking;
    data['overtime_pay'] = overtimePay;
    data['half_day_allowed'] = halfDayAllowed;
    if (halfDayHours != null) {
      data['half_day_hours'] = halfDayHours!.toJson();
    }
    data['clock_reminder'] = clockReminder;
    if (clockReminderTime != null) {
      data['clock_reminder_time'] = clockReminderTime!.toJson();
    }
    data['late_mark_after_minute'] = lateMarkAfterMinute;
    data['allowed_ip'] = allowedIp;
    data['working_days'] = workingDays;
    data['alt_sat'] = altSat;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class UserLeaves {
  int? id;
  String? cl;
  String? pl;
  String? sl;
  String? usedUpl;
  bool? employmentStarted;
  bool? oneYearCompleted;
  SpouseDob? createdAt;
  SpouseDob? updatedAt;
  Null deletedAt;

  UserLeaves({
    this.id,
    this.cl,
    this.pl,
    this.sl,
    this.usedUpl,
    this.employmentStarted,
    this.oneYearCompleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  UserLeaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cl = json['cl'];
    pl = json['pl'];
    sl = json['sl'];
    usedUpl = json['used_upl'];
    employmentStarted = json['employment_started'];
    oneYearCompleted = json['one_year_completed'];
    createdAt = json['created_at'] != null
        ? SpouseDob.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? SpouseDob.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cl'] = cl;
    data['pl'] = pl;
    data['sl'] = sl;
    data['used_upl'] = usedUpl;
    data['employment_started'] = employmentStarted;
    data['one_year_completed'] = oneYearCompleted;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class ReportTo {
  int? id;
  String? firstname;
  String? lastname;
  String ?profileImage;

  ReportTo({this.id, this.firstname, this.lastname, this.profileImage});

  ReportTo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
    return data;
  }
}
