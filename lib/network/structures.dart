
import '../common/preferences_util.dart';

class Card {
  Card(
      {this.uid = '',
      this.userName = '',
      this.identity = '',
      this.gender = '',
      this.headUrl = '',
      this.birth = '',
      this.mobile = '',
      this.token = ''});

  String uid;
  String userName;
  String identity;
  String gender;
  String headUrl;
  String birth;
  String mobile;
  String token;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        uid: json["uid"] ?? '',
        userName: json["userName"] ?? '',
        identity: json["identity"] ?? '',
        gender: json["gender"] ?? '',
        headUrl: json["headUrl"] ?? '',
        birth: json["birth"] ?? '',
        mobile: json["mobile"] ?? '',
        token: json["token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userName": userName,
        "identity": identity,
        "gender": gender,
        "headUrl": headUrl,
        "birth": birth,
        "mobile": mobile,
        "token": token
      };
}
