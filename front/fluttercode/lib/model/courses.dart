class CoursesModel {
  int? id;
  String? title;
  String? desc;
  String? nivel;
  int? time;
  Null? enterprise;
  String? urlbanner;
  String? price;
  bool? private;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;
  List<Null>? videos;

  CoursesModel(
      {this.id,
      this.title,
      this.desc,
      this.nivel,
      this.time,
      this.enterprise,
      this.urlbanner,
      this.price,
      this.private,
      this.publishedAt,
      this.createdAt,
      this.updatedAt,
      this.videos});

  CoursesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    nivel = json['nivel'];
    time = json['time'];
    enterprise = json['enterprise'];
    urlbanner = json['urlbanner'];
    price = json['price'];
    private = json['private'];
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
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
