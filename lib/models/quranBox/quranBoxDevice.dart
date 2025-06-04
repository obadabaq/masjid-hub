class QuranBoxDevice {
  final String? id;
  final String name;

  QuranBoxDevice({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  factory QuranBoxDevice.fromJson(Map<String, dynamic> json) {
    return QuranBoxDevice(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
