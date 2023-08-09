import 'base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get apiUrl => "http://localhost:3306/api/";

  @override
  String get authUrl => "http://localhost:3306/auth/";
}
