class VkGroupModel {
  final String name;
  final String id;
  final String previewUrl;

  VkGroupModel(this.name, this.id, this.previewUrl);

  static VkGroupModel fromJson(dynamic j) =>
      VkGroupModel(j['name'] as String, j['id'].toString(), j['photo_50'] as String);

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id, 'photo_50': previewUrl};
  }
}
