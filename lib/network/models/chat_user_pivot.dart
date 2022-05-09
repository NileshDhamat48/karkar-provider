class Pivot {
  int? fromId;
  int? toId;
  String? message;
  String? updatedAt;
  int? isArchived;
  String? createdAt;
  String? chat;

  Pivot({
    this.fromId,
    this.toId,
    this.message,
    this.updatedAt,
    this.isArchived,
    this.createdAt,
    this.chat,
  });

  Pivot.fromJson(Map<String, dynamic> json) {
    fromId = json['from_id'];
    toId = json['to_id'];
    message = json['message'];
    updatedAt = json['updated_at'];
    isArchived = json['is_archived'];
    createdAt = json['created_at'];
    chat = json['chat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from_id'] = fromId;
    data['to_id'] = toId;
    data['message'] = message;
    data['updated_at'] = updatedAt;
    data['is_archived'] = isArchived;
    data['created_at'] = createdAt;
    data['chat'] = chat;
    return data;
  }
}
