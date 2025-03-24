class CoursesModel {
  int? id;
  String? title;
  String? desc;
  String? nivel;
  int? time;
  String? urlbanner;
  String? price; // Alterado de Null? para String?
  bool? private; // Alterado de Null? para bool?
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

  factory CoursesModel.fromJson(Map<String, dynamic> json) {
    return CoursesModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      nivel: json['nivel'] as String?,
      time: json['time'] as int?,
      urlbanner: json['urlbanner'] as String?,
      price: json['price']?.toString(), // Converte para String se não for nulo
      private: json['private'] as bool?, // Assume que é um booleano
      proof: json['proof'] != null ? Proof.fromJson(json['proof']) : null,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['desc'] = desc;
    data['nivel'] = nivel;
    data['time'] = time;
    data['urlbanner'] = urlbanner;
    data['price'] = price;
    data['private'] = private;
    if (proof != null) {
      data['proof'] = proof!.toJson();
    }
    data['published_at'] = publishedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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

  Proof({
    this.id,
    this.questions,
    this.title,
    this.course,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Proof.fromJson(Map<String, dynamic> json) {
    return Proof(
      id: json['id'] as int?,
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((v) => Questions.fromJson(v))
              .toList()
          : null,
      title: json['title'] as String?,
      course: json['course'] as int?,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    data['course'] = course;
    data['published_at'] = publishedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Questions {
  int? id;
  String? question;
  List<String>? options;
  String? correctAnswer;

  Questions({
    this.id,
    this.question,
    this.options,
    this.correctAnswer,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      id: json['id'] as int?,
      question: json['question'] as String?,
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswer: json['correctAnswer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['options'] = options;
    data['correctAnswer'] = correctAnswer;
    return data;
  }
}
