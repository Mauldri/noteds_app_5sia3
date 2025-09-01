class UserModel {
  final int? userId;
  final String userName;
  final String userPassword;

  UserModel({
    this.userId,
    required this.userName,
    required this.userPassword,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    userId: json['userid'],
    userName: json['username'],
    userPassword: json['userpassword'],
    );

    Map<String, dynamic> toMap() => {
      'userid': userId,
      'username': userName,
      'userpassword': userPassword,
    };
    
}