import 'base_config.dart';

class DevConfig implements BaseConfig {
  @override
  // String get apiUrl => "http://190.114.255.180:8080/";
  String get apiUrl => "http://localhost:8080/";

  @override
  // String get authUrl => "http://190.114.255.180:8080/";
  String get authUrl => "http://localhost:8080/";
}
