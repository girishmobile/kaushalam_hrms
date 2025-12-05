class MyWorkModel {
  List<Data1>? data;
  String? wrikeId;
  String? name;
  List<Projects>? projects;
  String? message;
  bool? success;

  MyWorkModel({
    this.data,
    this.wrikeId,
    this.name,
    this.projects,
    this.message,
    this.success,
  });

  MyWorkModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data']['data'] != null) {
      data = <Data1>[];
      for (var v in (json['data']['data'] as List)) {
        data!.add(Data1.fromJson(v));
      }
    }
    if (json['data'] != null) {
      wrikeId = json['data']['wrike_id'];
      name = json['data']['name'];
      if (json['data']['projects'] != null) {
        projects = <Projects>[];
        for (var v in (json['data']['projects'] as List)) {
          projects!.add(Projects.fromJson(v));
        }
      }
    }
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['wrike_id'] = wrikeId;
    data['name'] = name;
    if (projects != null) {
      data['projects'] = projects!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class Data1 {
  String? id;
  String? title;
  Project? project;
  List<Tasks>? tasks;
  double? totalEffort;
  double? totalHours;

  Data1({
    this.id,
    this.title,
    this.project,
    this.tasks,
    this.totalEffort,
    this.totalHours,
  });

  Data1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    project = json['project'] != null ? Project.fromJson(json['project']) : null;
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(Tasks.fromJson(v));
      });
    }
    totalEffort = (json['totalEffort'] ?? 0).toDouble();
    totalHours = (json['totalHours'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (project != null) data['project'] = project!.toJson();
    if (tasks != null) data['tasks'] = tasks!.map((v) => v.toJson()).toList();
    data['totalEffort'] = totalEffort;
    data['totalHours'] = totalHours;
    return data;
  }
}

class Project {
  String? authorId;
  List<String>? ownerIds;
  String? status;
  String? customStatusId;
  String? createdDate;

  Project({
    this.authorId,
    this.ownerIds,
    this.status,
    this.customStatusId,
    this.createdDate,
  });

  Project.fromJson(Map<String, dynamic> json) {
    authorId = json['authorId'];
    ownerIds = json['ownerIds'] != null ? List<String>.from(json['ownerIds']) : [];
    status = json['status'];
    customStatusId = json['customStatusId'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authorId'] = authorId;
    data['ownerIds'] = ownerIds;
    data['status'] = status;
    data['customStatusId'] = customStatusId;
    data['createdDate'] = createdDate;
    return data;
  }
}

class Tasks {
  String? id;
  String? accountId;
  String? title;
  List<String>? responsibleIds;
  String? status;
  String? importance;
  String? createdDate;
  String? updatedDate;
  String? completedDate;
  Dates? dates;
  String? scope;
  String? customStatusId;
  String? permalink;
  String? priority;
  EffortAllocation? effortAllocation;
  List<Timelogs>? timelogs;

  Tasks({
    this.id,
    this.accountId,
    this.title,
    this.responsibleIds,
    this.status,
    this.importance,
    this.createdDate,
    this.updatedDate,
    this.completedDate,
    this.dates,
    this.scope,
    this.customStatusId,
    this.permalink,
    this.priority,
    this.effortAllocation,
    this.timelogs,
  });

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['accountId'];
    title = json['title'];
    responsibleIds = json['responsibleIds'] != null ? List<String>.from(json['responsibleIds']) : [];
    status = json['status'];
    importance = json['importance'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    completedDate = json['completedDate'];
    dates = json['dates'] != null ? Dates.fromJson(json['dates']) : null;
    scope = json['scope'];
    customStatusId = json['customStatusId'];
    permalink = json['permalink'];
    priority = json['priority'];
    effortAllocation = json['effortAllocation'] != null ? EffortAllocation.fromJson(json['effortAllocation']) : null;
    if (json['timelogs'] != null) {
      timelogs = <Timelogs>[];
      json['timelogs'].forEach((v) {
        timelogs!.add(Timelogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accountId'] = accountId;
    data['title'] = title;
    data['responsibleIds'] = responsibleIds;
    data['status'] = status;
    data['importance'] = importance;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    data['completedDate'] = completedDate;
    if (dates != null) data['dates'] = dates!.toJson();
    data['scope'] = scope;
    data['customStatusId'] = customStatusId;
    data['permalink'] = permalink;
    data['priority'] = priority;
    if (effortAllocation != null) data['effortAllocation'] = effortAllocation!.toJson();
    if (timelogs != null) data['timelogs'] = timelogs!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Dates {
  String? type;
  int? duration;
  String? start;
  String? due;

  Dates({this.type, this.duration, this.start, this.due});

  Dates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    duration = json['duration'];
    start = json['start'];
    due = json['due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['duration'] = duration;
    data['start'] = start;
    data['due'] = due;
    return data;
  }
}

class EffortAllocation {
  String? mode;
  double? dailyAllocationPercentage;
  int? totalEffort;

  EffortAllocation({this.mode, this.dailyAllocationPercentage, this.totalEffort});

  EffortAllocation.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    dailyAllocationPercentage = (json['dailyAllocationPercentage'] ?? 0).toDouble();
    totalEffort = json['totalEffort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mode'] = mode;
    data['dailyAllocationPercentage'] = dailyAllocationPercentage;
    data['totalEffort'] = totalEffort;
    return data;
  }
}

class Timelogs {
  String? id;
  String? taskId;
  String? userId;
  String? billingType;
  double? hours;
  String? createdDate;
  String? updatedDate;
  String? trackedDate;
  String? comment;

  Timelogs({
    this.id,
    this.taskId,
    this.userId,
    this.billingType,
    this.hours,
    this.createdDate,
    this.updatedDate,
    this.trackedDate,
    this.comment,
  });

  Timelogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['taskId'];
    userId = json['userId'];
    billingType = json['billingType'];
    hours = (json['hours'] ?? 0).toDouble();
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    trackedDate = json['trackedDate'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskId'] = taskId;
    data['userId'] = userId;
    data['billingType'] = billingType;
    data['hours'] = hours;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    data['trackedDate'] = trackedDate;
    data['comment'] = comment;
    return data;
  }
}

class Projects {
  String? projectId;
  String? perEmpBookHrs;

  Projects({this.projectId, this.perEmpBookHrs});

  Projects.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    perEmpBookHrs = json['per_emp_book_hrs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['project_id'] = projectId;
    data['per_emp_book_hrs'] = perEmpBookHrs;
    return data;
  }
}
