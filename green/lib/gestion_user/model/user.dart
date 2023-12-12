class User {
  final String? id;
  final String? email;
  final String? password;
  final String? nom;
  final String? prenom;

  final String? adress;
  final String? cin;
  final String? userName;
  final String? numTel;
  final int? score;
  final String? lastPassword;
  final bool? isValid;
  final String? imageRes;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? token;

  User({
    this.id,
    this.email,
    this.password,
    required this.nom,
    required this.prenom,
    this.adress,
    this.cin,
    this.userName,
    this.numTel,
    this.score,
    this.lastPassword,
    this.isValid,
    this.imageRes,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.token,
  });


  
// Méthode pour convertir un objet User en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      // Ajouter les autres champs ici
    };
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      password: json['password'],
      nom: json['nom'],
      prenom: json['prenom'],
      adress: json['adress'],
      cin: json['cin'],
      userName: json['userName'],
      numTel: json['numTel'],
      score: json['score'],
      lastPassword: json['lastPassword'],
      isValid: json['isValid'],
      imageRes: json['imageRes'],
      role: json['role'],
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
      v: json['__v'],
      token: json['token'],
    );
  }
  @override
String toString() {
  return 'User{id: $id, '
      'email: $email, '
      'nom: $nom, '
      'prenom: $prenom, '
      'adress: $adress, '
      'cin: $cin, '
      'userName: $userName, '
      'numTel: $numTel, '
      'score: $score, '
      'lastPassword: $lastPassword, '
      'isValid: $isValid, '
      'imageRes: $imageRes, '
      'role: $role, '
      'createdAt: $createdAt, '
      'updatedAt: $updatedAt, '
      'v: $v, '
      'token: $token}';
}

}

DateTime? parseDateTime(String? dateTimeString) {
  if (dateTimeString != null) {
    return DateTime.parse(dateTimeString);
  }
  return null;
}
