class Proof {
  int? id;
  List<Questions>? questions;
  String? title;
  Course? course;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  Proof(
      {this.id,
      this.questions,
      this.title,
      this.course,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  Proof.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    title = json['title'];
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Questions {
  int? id;
  String? question;
  List<String>? options;
  String? correctAnswer;

  Questions({this.id, this.question, this.options, this.correctAnswer});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    options = json['options'].cast<String>();
    correctAnswer = json['correctAnswer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['options'] = this.options;
    data['correctAnswer'] = this.correctAnswer;
    return data;
  }
}

class Course {
  int? id;
  String? title;
  String? desc;
  String? nivel;
  int? time;
  Null? enterprise;
  String? urlbanner;
  String? price;
  bool? private;
  int? proof;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  Course(
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

  Course.fromJson(Map<String, dynamic> json) {
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
