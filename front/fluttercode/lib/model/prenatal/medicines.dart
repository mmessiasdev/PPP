class PrenatalMedicines {
  int? id;
  String? name;
  String? dosage;
  String? obs;
  Profile? profile;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  PrenatalMedicines(
      {this.id,
      this.name,
      this.dosage,
      this.obs,
      this.profile,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  PrenatalMedicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dosage = json['dosage'];
    obs = json['obs'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dosage'] = this.dosage;
    data['obs'] = this.obs;
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
