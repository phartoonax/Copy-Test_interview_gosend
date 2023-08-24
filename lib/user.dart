import 'dart:typed_data';

class User {
  int id = 0;
  String name = '';

  int? nik = 0;
  String password = '';
  Uint8List? picture;

  User.empty();

  User({
    required this.id,
    required this.name,
    this.nik,
    required this.password,
    this.picture,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nama'],
      nik: json['nik'],
      password: json['pass'],
      picture: json['pic'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nama': name,
        'nik': nik,
        'pass': password,
        'pic': picture,
      };
}
