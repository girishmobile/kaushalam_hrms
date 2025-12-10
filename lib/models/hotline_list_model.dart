class HotlineListModel {
  Item? data;

  HotlineListModel({this.data});
  HotlineListModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Item.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Item {
  int? currentPage;
  List<HotLineData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Item({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Item.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <HotLineData>[];
      json['data'].forEach((v) {
        data!.add(HotLineData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class HotLineData {
  int? id;
  String? firstname;
  String? lastname;
  String? profileImage;
  bool? isWfhAllowed;
  String? email;
  String? employeeId;
  int? depId;
  String? departmentname;
  String? designation;
  int? desId;
  List<dynamic>? userTagList;
  Department? department;
  String? workStatus;

  HotLineData({
    this.id,
    this.firstname,
    this.lastname,
    this.profileImage,
    this.isWfhAllowed,
    this.email,
    this.employeeId,
    this.depId,
    this.departmentname,
    this.designation,
    this.desId,
    this.userTagList,
    this.department,
    this.workStatus,
  });

  HotLineData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
    isWfhAllowed = json['is_wfh_allowed'];
    email = json['email'];
    employeeId = json['employee_id'];
    depId = json['dep_id'];
    departmentname = json['departmentname'];
    designation = json['designation'];
    desId = json['des_id'];
    /*  if (json['user_tag_list'] != null) {
      userTagList = <Null>[];
      json['user_tag_list'].forEach((v) {
        userTagList!.add(new Null.fromJson(v));
      });
    }*/
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    workStatus = json['work_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
    data['is_wfh_allowed'] = isWfhAllowed;
    data['email'] = email;
    data['employee_id'] = employeeId;
    data['dep_id'] = depId;
    data['departmentname'] = departmentname;
    data['designation'] = designation;
    data['des_id'] = desId;
    if (userTagList != null) {
      data['user_tag_list'] = userTagList!.map((v) => v.toJson()).toList();
    }
    if (department != null) {
      data['department'] = department!.toJson();
    }
    data['work_status'] = workStatus;
    return data;
  }
}

class Department {
  int? id;
  String? name;

  Department({this.id, this.name});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
