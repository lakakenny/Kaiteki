import 'package:kaiteki/api/model/misskey/user.dart';

class MisskeyUserkeyResponse {
  String accessToken;
  MisskeyUser user;

  MisskeyUserkeyResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json["accessToken"];

    if (json["user"] != null)
      user = MisskeyUser.fromJson(json["user"]);
  }
}