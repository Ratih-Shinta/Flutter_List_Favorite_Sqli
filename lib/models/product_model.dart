class Photo {
  int? id;
  String? photographer;
  String? alt;
  String? src;

  Photo({
    required this.id,
    required this.photographer,
    required this.alt,
    required this.src,
  });

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photographer = json['photographer'];
    alt = json['alt'];
    if (json['src'] != null && json['src']['original'] != null) {
      src = json['src']['original'] ;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photographer'] = this.photographer;
    data['alt'] = this.alt;
    data['src'] = this.src;
    return data;
  }
}