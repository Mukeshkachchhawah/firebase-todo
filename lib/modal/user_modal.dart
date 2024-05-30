class UserModal {
  String? uid;
  String? name;
  String? email;
  String? age;
  String? dob;
  String? mobNo;
  String? gender;
  String? address;
  String? password;
  String? confirmPassword;

  // bool isDone;

  UserModal(
      {this.uid,
      this.name,
      this.email,
      this.age,
      this.address,
      this.dob,
      this.gender,
      this.mobNo,
      this.password,
      this.confirmPassword});

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        age: json['age'],
        address: json['address'],
        dob: json['dob'],
        gender: json['gender'],
        mobNo: json['mobNo'],
        password: json['password'],
        confirmPassword: json['confirmPassword']);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "age": age,
      "dob": dob,
      "mobNo": mobNo,
      "gender": gender,
      "address": address,
      "password": password,
      "confirmPassword": confirmPassword
    };
  }
}
