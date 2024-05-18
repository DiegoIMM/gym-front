import 'base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get apiUrl => "http://186.64.113.167:8080/";
  // String get apiUrl => "http://localhost:8080/";

  @override
  String get authUrl => "http://186.64.113.167:8080/";
  // String get authUrl => "http://localhost:8080/";
}
