import 'base_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get apiUrl => "https://data--service--qkc5zpgqqt26.code.run/api/";

  @override
  String get authUrl => "https://data--service--qkc5zpgqqt26.code.run/auth/";
}
