class OneCourse {
  int? id;
  String? title;
  String? desc;
  String? nivel;
  int? time;
  Null? enterprise;
  String? urlbanner;
  Null? price;
  bool? private;
  Null? proof;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;
  List<Videos>? videos;
  List<Profilespinned>? profilespinned;
  List<Null>? profilescerfiticates;
  List<CategoryCourses>? categoryCourses;

  OneCourse(
      {this.id,
      this.title,
      this.desc,
      this.nivel,
      this.time,
      this.enterprise,
      this.urlbanner,
      this.price,
      this.private,
      this.proof,
      this.publishedAt,
      this.createdAt,
      this.updatedAt,
      this.videos,
      this.profilespinned,
      this.profilescerfiticates,
      this.categoryCourses});

  OneCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    nivel = json['nivel'];
    time = json['time'];
    enterprise = json['enterprise'];
    urlbanner = json['urlbanner'];
    price = json['price'];
    private = json['private'];
    proof = json['proof'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    if (json['profilespinned'] != null) {
      profilespinned = <Profilespinned>[];
      json['profilespinned'].forEach((v) {
        profilespinned!.add(new Profilespinned.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['nivel'] = this.nivel;
    data['time'] = this.time;
    data['enterprise'] = this.enterprise;
    data['urlbanner'] = this.urlbanner;
    data['price'] = this.price;
    data['private'] = this.private;
    data['proof'] = this.proof;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    if (this.profilespinned != null) {
      data['profilespinned'] =
          this.profilespinned!.map((v) => v.toJson()).toList();
    }
    if (this.categoryCourses != null) {
      data['category_courses'] =
          this.categoryCourses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  int? id;
  String? name;
  String? desc;
  String? url;
  int? time;
  bool? public;
  int? course;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  Videos(
      {this.id,
      this.name,
      this.desc,
      this.url,
      this.time,
      this.public,
      this.course,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    url = json['url'];
    time = json['time'];
    public = json['public'];
    course = json['course'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['url'] = this.url;
    data['time'] = this.time;
    data['public'] = this.public;
    data['course'] = this.course;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Profilespinned {
  int? id;
  String? email;
  int? user;
  String? fullname;
  int? plan;
  Null? enterprise;
  Null? student;
  Null? curriculumdesc;
  Null? birth;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  Profilespinned(
      {this.id,
      this.email,
      this.user,
      this.fullname,
      this.plan,
      this.enterprise,
      this.student,
      this.curriculumdesc,
      this.birth,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  Profilespinned.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    user = json['user'];
    fullname = json['fullname'];
    plan = json['plan'];
    enterprise = json['enterprise'];
    student = json['student'];
    curriculumdesc = json['curriculumdesc'];
    birth = json['birth'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['user'] = this.user;
    data['fullname'] = this.fullname;
    data['plan'] = this.plan;
    data['enterprise'] = this.enterprise;
    data['student'] = this.student;
    data['curriculumdesc'] = this.curriculumdesc;
    data['birth'] = this.birth;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CategoryCourses {
  int? id;
  String? name;
  String? urlbanner;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  CategoryCourses(
      {this.id,
      this.name,
      this.urlbanner,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  CategoryCourses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    urlbanner = json['urlbanner'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['urlbanner'] = this.urlbanner;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
