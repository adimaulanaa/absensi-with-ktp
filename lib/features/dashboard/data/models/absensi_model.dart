import 'dart:convert';

class AbsensiModel {
  String? id;
  String? idCard;
  String? name;
  String? sak;
  String? standard;
  String? type;
  DateTime? createOn;
  bool? isSucces;

  AbsensiModel({
    this.id,
    this.idCard,
    this.name,
    this.sak,
    this.standard,
    this.type,
    this.createOn,
    this.isSucces = false,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'id_card': idCard,
      'name': name,
      'sak': sak,
      'standard': standard,
      'type': type.toString(),
      'created_on': createOn.toString(),
    };
  }

  factory AbsensiModel.fromMap(Map<String, dynamic> map) {
    return AbsensiModel(
      id: map['_id']?.toInt() ?? 0,
      idCard: map['id_card'] ?? '',
      name: map['name'] ?? '',
      sak: map['sak'] ?? '',
      standard: map['standard'] ?? '',
      type: map['type'] ?? '',
      createOn:
          map['created_on'] != null ? DateTime.parse(map['created_on']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AbsensiModel.fromJson(String source) =>
      AbsensiModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'notes(_id: $id, id_card: $idCard, name: $name, sak: $sak, standard: $standard, type: $type, created_on: $createOn)';
}
