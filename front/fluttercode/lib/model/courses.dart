class CoursesModel {
  int? id;
  String? title;
  String? desc;
  String? nivel;
  int? time;
  String? urlbanner;
  Null? price;
  Null? private;
  Proof? proof;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  CoursesModel({
    this.id,
    this.title,
    this.desc,
    this.nivel,
    this.time,
    this.urlbanner,
    this.price,
    this.private,
    this.proof,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  CoursesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    nivel = json['nivel'];
    time = json['time'];
    urlbanner = json['urlbanner'];
    price = json['price'];
    private = json['private'];
    proof = json['proof'] != null ? new Proof.fromJson(json['proof']) : null;
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
    data['urlbanner'] = this.urlbanner;
    data['price'] = this.price;
    data['private'] = this.private;
    if (this.proof != null) {
      data['proof'] = this.proof!.toJson();
    }
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Proof {
  int? id;
  List<Questions>? questions;
  String? title;
  int? course;
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
    course = json['course'];
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
    data['course'] = this.course;
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

// class Videos {
//   int? id;
//   String? name;
//   String? desc;
//   String? url;
//   int? time;
//   bool? public;
//   int? course;
//   String? publishedAt;
//   String? createdAt;
//   String? updatedAt;

//   Videos(
//       {this.id,
//       this.name,
//       this.desc,
//       this.url,
//       this.time,
//       this.public,
//       this.course,
//       this.publishedAt,
//       this.createdAt,
//       this.updatedAt});

//   Videos.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     desc = json['desc'];
//     url = json['url'];
//     time = json['time'];
//     public = json['public'];
//     course = json['course'];
//     publishedAt = json['published_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['desc'] = this.desc;
//     data['url'] = this.url;
//     data['time'] = this.time;
//     data['public'] = this.public;
//     data['course'] = this.course;
//     data['published_at'] = this.publishedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

// class CategoryCourses {
//   int? id;
//   String? name;
//   String? urlbanner;
//   String? publishedAt;
//   String? createdAt;
//   String? updatedAt;

//   CategoryCourses(
//       {this.id,
//       this.name,
//       this.urlbanner,
//       this.publishedAt,
//       this.createdAt,
//       this.updatedAt});

//   CategoryCourses.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     urlbanner = json['urlbanner'];
//     publishedAt = json['published_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['urlbanner'] = this.urlbanner;
//     data['published_at'] = this.publishedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
