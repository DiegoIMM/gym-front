import 'dart:convert';

import 'package:gym_front/dtos/payment_dto.dart';
import 'package:http/http.dart' as http;

import '../dtos/client_dto.dart';
import '../dtos/edit_plan_dto.dart';
import '../dtos/login_dto.dart';
import '../dtos/plan_dto.dart';
import '../dtos/set_new_pass_dto.dart';
import '../dtos/sign_up_dto.dart';
import '../dtos/update_user_dto.dart';
import '../models/client.dart';
import '../models/environments/environment.dart';
import '../models/payment.dart';
import '../models/plan.dart';
import 'auth_service.dart';

class ApiService {
  final String _authUrl = Environment().config.authUrl;
  final String _apiUrl = Environment().config.apiUrl;

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE",
      };

  Future<Map<String, String>> _getHeadersWithToken() async {
    AuthService authService = AuthService();
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE",
    };
  }

  // manejar los errores de la api
  // TODO: estandarizar envío de mensajes
  Future<dynamic> _handleResponse(http.Response response) async {
    print('status code: ${response.statusCode}');
    print('response body ->: ${response.body}');

    switch (response.statusCode) {
      case 200 || 201:
        var decodedData = json.decode(utf8.decode(response.bodyBytes));
        print('decodedData: $decodedData');
        print('response body ->: ${response.body}');
        print('response body2 ->: ${utf8.decode(response.bodyBytes)}');
        print('entro al 20* con el body: $decodedData');
        print('decodedData: $decodedData');
        return decodedData;
      case 400:
        throw response.body;
      case 401:
        // No hay token, es invalido o hay un error de seguridad
        throw 'No tienes permiso para realizar esta acción';
      case 403:
        var decodedData = json.decode(utf8.decode(response.bodyBytes));
        print('decodedData: $decodedData');
        // Esta to do bien pero no por logica el usuario no deberia estar haciendo esto
        throw decodedData;
      case 404:
        throw 'No se encontró el recurso que buscas';
      case 500:
        throw 'Error interno del servidor, intenta nuevamente o reporta el error si continua después de varios intentos';
      default:
        throw 'Error desconocido';
    }
  }

  Future<dynamic> login(LoginDTO loginDTO) async {
    print('login');

    final response = await http.post(Uri.parse('${_authUrl}login/'),
        body: jsonEncode(loginDTO.toJson()), headers: headers);

    await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    var json = jsonDecode(response.body);
    print('jsonUser:${json['user']}');
    return json;
  }

  Future<dynamic> signUp(SignUpDTO signUpDTO) async {
    print('signUp');

    final response = await http.post(Uri.parse('${_authUrl}register'),
        body: jsonEncode(signUpDTO.toJson()), headers: headers);

    await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    var json = jsonDecode(response.body);
    print('jsonUser:${json['user']}');
    return json;
  }

  Future<dynamic> updateUser(UpdateUserDTO updateUserDTO) async {
    print('updateUser');

    final response = await http.put(Uri.parse('${_authUrl}updateUser'),
        body: jsonEncode(updateUserDTO.toJson()),
        headers: await _getHeadersWithToken());

    await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    var json = jsonDecode(response.body);
    print('jsonUser:${json['user']}');
    return json;
  }

  // Future<String> updatePhoto(int userId, String username) async {
  //   print('updatePhoto');
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   // foto por defecto del servicio
  //   var photo =
  //       'https://firebasestorage.googleapis.com/v0/b/stacklawyers-352318.appspot.com/o/profilePicture%2FdefaultProfilePicture.jpeg?alt=media&token=7521ff30-139b-43d1-8133-85f9e378d0c4&_gl=1*tbxbfe*_ga*MTY4NTI0MjE2My4xNjY2NzEyNDYy*_ga_CW55HF8NVT*MTY4NTkzOTAyMS4xNC4xLjE2ODU5NDA1MzMuMC4wLjA.';
  //   if (result != null) {
  //     Uint8List? fileBytes = result.files.first.bytes;
  //     String fileName = result.files.first.name;
  //
  //     // Upload file
  //     var ref = FirebaseStorage.instance
  //         .ref('profilePicture/$username${DateTime.now()}$fileName');
  //
  //     await ref.putData(fileBytes!);
  //     await ref.getDownloadURL().then((value) async {
  //       Map<String, dynamic> map = {
  //         'userId': userId,
  //         'profilePicture': value,
  //       };
  //
  //       print('Uploaded File URL: $value');
  //       final response = await http.put(
  //           Uri.parse('${_authUrl}updateProfilePicture'),
  //           body: jsonEncode(map),
  //           headers: await _getHeadersWithToken());
  //
  //       await _handleResponse(response).catchError((error) {
  //         print('Errorr: $error');
  //         throw error;
  //       });
  //       photo = value;
  //     });
  //   }
  //
  //   return photo;
  // }

  Future<dynamic> setNewPassword(SetNewPassDTO setNewPassDTO) async {
    print('setNewPassword');

    final response = await http.post(Uri.parse('${_authUrl}setNewPassword'),
        body: jsonEncode(setNewPassDTO.toJson()), headers: headers);

    await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    var json = jsonDecode(response.body);
    return json;
  }

  Future<dynamic> sendUrlRequestNewPassword(String email) async {
    print('requestNewPassword');

    final response = await http.post(
        Uri.parse('${_authUrl}requestNewPassword/$email'),
        headers: headers);

    await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    var json = jsonDecode(response.body);
    return json;
  }

  Future<dynamic> sendUrlRequestValidateEmail(String email) async {
    print('requestValidateEmail');

    final response = await http.post(
        Uri.parse('${_authUrl}requestValidateEmail/$email'),
        headers: await _getHeadersWithToken());

    await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    var json = jsonDecode(response.body);
    return json;
  }

  Future<dynamic> sendTokenToValidateEmail(String token) async {
    print('requestValidateEmail');

    final response = await http
        .post(Uri.parse('${_authUrl}validateEmail/$token'), headers: headers);

    await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    var json = jsonDecode(response.body);
    return json;
  }

  Future<dynamic> createPlan(PlanDTO planDTO) async {
    final response = await http.post(Uri.parse('${_apiUrl}plan/insert'),
        body: jsonEncode(planDTO.toJson()), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    return jsonResult;
  }

  Future<dynamic> editPlan(EditPlanDTO planDTO) async {
    final response = await http.put(Uri.parse('${_apiUrl}plan/update'),
        body: jsonEncode(planDTO.toJson()), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    return jsonResult;
  }

  Future<dynamic> createPayment(PaymentDTO paymentDTO) async {
    final response = await http.post(Uri.parse('${_apiUrl}payment/insert'),
        body: jsonEncode(paymentDTO.toJson()), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    return jsonResult;
  }

  Future<List<Plan>> getAllActivePlans() async {
    final response = await http.get(Uri.parse('${_apiUrl}plan/all/enable'),
        headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      throw error;
    });

    return Plan.fromJsonList(jsonResult);
  }

  Future<List<Plan>> getAllPlans() async {
    final response =
        await http.get(Uri.parse('${_apiUrl}plan/all'), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      throw error;
    });

    return Plan.fromJsonList(jsonResult);
  }

  Future<List<Payment>> getAllActivePayments() async {
    final response =
        await http.get(Uri.parse('${_apiUrl}payment/all'), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      throw error;
    });
    var payments = Payment.fromJsonList(jsonResult);
    
    payments.sort((a, b) => b.date.compareTo(a.date));

    return payments;
  }

  Future<List<Client>> getClientsByEnterprise() async {
    // TODO: Reemplazar a endpoint que usa empresas para buscar los clientes filtrados
    final response =
        await http.get(Uri.parse('${_apiUrl}client/all'), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      throw error;
    });

    return Client.fromJsonList(jsonResult);
  }

  Future<dynamic> createClient(ClientDTO clientDTO) async {
    final response = await http.post(Uri.parse('${_apiUrl}client/insert'),
        body: jsonEncode(clientDTO.toJson()), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    return jsonResult;
  }

  Future<dynamic> editClient(ClientDTO clientDTO) async {
    final response = await http.put(Uri.parse('${_apiUrl}client/update'),
        body: jsonEncode(clientDTO.toJson()), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      print('Errorr: $error');
      throw error;
    });
    return jsonResult;
  }

  Future<Client> getClientByRut(String rut) async {
    // TODO: Reemplazar a endpoint que usa empresas para buscar los clientes filtrados
    final response =
        await http.get(Uri.parse('${_apiUrl}client/$rut'), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      throw error;
    });

    return Client.fromJson(jsonResult);
  }

  Future<Client> getClientByNCliente(String nCliente) async {
    // TODO: Reemplazar a endpoint que usa empresas para buscar los clientes filtrados
    final response =
        await http.get(Uri.parse('${_apiUrl}client/number/$nCliente'), headers: headers);

    var jsonResult = await _handleResponse(response).catchError((error) {
      throw error;
    });

    return Client.fromJson(jsonResult);
  }
}
