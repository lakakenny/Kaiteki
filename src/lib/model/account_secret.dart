import 'package:shared_preferences/shared_preferences.dart';

class AccountSecret {
  String instance;
  String username;
  String accessToken;

  AccountSecret(String instance, String username, String accessToken) {
    assert(instance != null);
    this.instance = instance;

    assert(username != null);
    this.username = username;

    assert(accessToken != null);
    this.accessToken = accessToken;
  }

  AccountSecret.fromValue(String key, String value) {
    assert(key.substring(0, 2) == "a;", "Key doesn't have the correct prefix");
    
    var keySplit = key.substring(2).split('@');
    username = keySplit[0];
    instance = keySplit[1];
    accessToken = value;
  }

  String toKey() => "a;$username@$instance";
  String toValue() => accessToken;

  static Future<List<String>> getAvailableSecrets() async {
    var preferences = await SharedPreferences.getInstance();
    var accounts = preferences.getStringList("accounts");
    return accounts;
  }

  static Future<List<AccountSecret>> getSecrets() async {
    var accounts = <String>[];
    var preferences = await SharedPreferences.getInstance();
    accounts = await getAvailableSecrets() ?? <String>[];

    var futures = accounts.map((a) async {
      var key = "a;$a";
      var value = preferences.getString(key);

      if (value == null)
        return null;

      return AccountSecret.fromValue(key, value);
    });

    var secrets = await Future.wait(futures);

    return secrets.toList(growable: false);
  }

  Future<void> save() async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(toKey(), toValue());
  }
}