import 'base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get apiUrl => "http://localhost:8081/";

  @override
  String get authUrl => "http://localhost:8081/";
}
