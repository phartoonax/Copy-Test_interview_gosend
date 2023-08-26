class User {
  int? id;
  String name = '';

  int? nik;
  String password = '';
  String? picture;

  User.empty();

  User({
    this.id,
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
