class CategoryCoursesModel {
  int? id;
  String? name;
  String? urlbanner;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;
  List<Courses>? courses;

  CategoryCoursesModel(
      {this.id,
      this.name,
      this.urlbanner,
      this.publishedAt,
      this.createdAt,
      this.updatedAt,
      this.courses});

  CategoryCoursesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    urlbanner = json['urlbanner'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['urlbanner'] = this.urlbanner;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
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

  Courses(
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
      this.updatedAt});

  Courses.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
