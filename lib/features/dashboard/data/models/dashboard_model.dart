import 'dart:convert';

class DashboardModel {
  int? idx;
  String? id;
  String? name;
  String? username;
  String? password;
  String? biomatricId;
  String? faceId;
  String? fingerprintId;
  String? tokens;
  String? isAdmin;
  DateTime? createdOn;
  String? createdBy;
  DateTime? updatedOn;
  String? updatedBy;

  DashboardModel({
    this.idx = 0,
    this.id,
    this.name,
    this.username,
    this.password,
    this.biomatricId,
    this.faceId,
    this.fingerprintId,
    this.tokens,
    this.isAdmin,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'password': password,
      'biomatric_id': biomatricId,
      'face_id': faceId,
      'fingerprint_id': fingerprintId,
      'tokens': tokens,
      'is_admin': isAdmin,
      'created_on': createdOn.toString(),
      'created_by': createdBy,
      'updated_on': updatedOn.toString(),
      'updated_by': updatedBy,
    };
  }

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      biomatricId: map['biomatric_id'] ?? '',
      faceId: map['face_id'] ?? '',
      fingerprintId: map['fingerprint_id'] ?? '',
      tokens: map['tokens'] ?? '',
      isAdmin: map['is_admin'] ?? '',
      createdOn: map['created_on'] != null ? DateTime.parse(map['created_on']) : null,
      createdBy: map['created_by'] ?? '',
      updatedOn: map['updated_on'] != null ? DateTime.parse(map['updated_on']) : null, 
      updatedBy: map['updated_by'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardModel.fromJson(String source) => DashboardModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'user(_id: $id, name: $name, username: $username, password: $password, biomatric_id: $biomatricId, face_id: $faceId, fingerprint_id: $fingerprintId, tokens: $tokens, is_admin: $isAdmin, created_on: $createdOn, created_by: $createdBy, updated_on: $updatedOn, updated_by: $updatedBy)';
}
