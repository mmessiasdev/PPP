class PrenatalConsultations {
  int? id;
  String? data;
  String? obs;
  String? professional;
  Profile? profile;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  PrenatalConsultations(
      {this.id,
      this.data,
      this.obs,
      this.professional,
      this.profile,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  PrenatalConsultations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    obs = json['obs'];
    professional = json['professional'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['obs'] = this.obs;
    data['professional'] = this.professional;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Profile {
  int? id;
  String? email;
  int? user;
  String? fullname;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  Profile(
      {this.id,
      this.email,
      this.user,
      this.fullname,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    user = json['user'];
    fullname = json['fullname'];
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
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
