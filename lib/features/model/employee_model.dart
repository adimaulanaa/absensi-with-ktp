import 'dart:convert';

class EmployeeModel {
  String? id;
  String? name;
  String? sak;
  String? standard;
  DateTime? createdOn;
  DateTime? updatedOn;
  bool? isSucces;

  EmployeeModel({
    this.id,
    this.name,
    this.sak,
    this.standard,
    this.createdOn,
    this.updatedOn,
    this.isSucces = false,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'sak': sak,
      'standard': standard,
      'created_on': createdOn.toString(),
      'updated_on': updatedOn.toString(),
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      sak: map['sak'] ?? '',
      standard: map['standard'] ?? '',
      createdOn:
          map['created_on'] != null ? DateTime.parse(map['created_on']) : null,
      updatedOn:
          map['updated_on'] != null ? DateTime.parse(map['updated_on']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'notes(_id: $id, name: $name, sak: $sak, standard: $standard, created_on: $createdOn, updated_on: $updatedOn)';
}
