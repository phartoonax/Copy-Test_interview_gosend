class Orders {
  int? id;
  String name = '';
  int idUser = 0;
  int isnew = 1;
  int dateEpoch = 0;
  String? pictureOrder;
  double? latitude1 = 0.0;
  double? langitude1 = 0.0;
  double? latitude2 = 0.0;
  double? langitude2 = 0.0;

  Orders.empty();

  Orders({
    this.id,
    required this.name,
    required this.idUser,
    required this.isnew,
    required this.dateEpoch,
    this.pictureOrder,
    this.latitude1,
    this.langitude1,
    this.latitude2,
    this.langitude2,
  });

  factory Orders.fromMap(Map<String, dynamic> json) {
    return Orders(
      id: json['id'],
      name: json['nama'],
      idUser: json['iduser'],
      isnew: json['isNew'],
      dateEpoch: json['date'],
      pictureOrder: json['picorder'],
      latitude1: json['lat1'],
      langitude1: json['lang1'],
      latitude2: json['lat2'],
      langitude2: json['lang2'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nama': name,
        'iduser': idUser,
        'isNew': isnew,
        'date': dateEpoch,
        'picorder': pictureOrder,
        'lat1': latitude1,
        'lang1': langitude1,
        'lat2': latitude2,
        'lang2': langitude2,
      };
}
// DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(dateEpoch))