class VerfiquedExitBalances {
  int? id;
  String? value;
  String? publishedAt;
  String? createdAt;
  String? bankkey;

  String? updatedAt;

  VerfiquedExitBalances(
      {this.id,
      this.value,
      this.publishedAt,
      this.bankkey, 

      this.createdAt,
      this.updatedAt});

  VerfiquedExitBalances.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    publishedAt = json['published_at'];
    bankkey = json['bankkey'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['bankkey'] = this.bankkey;

    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}