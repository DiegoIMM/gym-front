import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../services/api_service.dart';
import '../../widgets/loading_widget.dart';

// api/validate-email

class ValidateEmail extends StatefulWidget {
  ValidateEmail({super.key, required this.token});

  final String token;
  String text = '';

  @override
  State<ValidateEmail> createState() => _ValidateEmailState();
}

class _ValidateEmailState extends State<ValidateEmail> {
  bool loadingValidation = true;
  static final _apiService = ApiService();
  final form = FormGroup({
    'token': FormControl<String>(
      value: '',
    ),
  });

  sendTokenToValidateEmail() {
    setState(() {
      loadingValidation = true;
    });
    _apiService.sendTokenToValidateEmail(widget.token).then((value) {
      print('value');
      print(value['message']);
      widget.text = value['message'];
      setState(() {
        loadingValidation = false;
      });
    }).catchError((onError) {
      print('errrrr');
      print(onError);
      widget.text = onError;

      setState(() {
        loadingValidation = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      form.control('token').value = widget.token;
    });

    sendTokenToValidateEmail();
  }

  @override
  Widget build(BuildContext context) {
    return loadingValidation
        ? LoadingWidget(text: 'Validando correo')
        : Center(child: Text(widget.text));
  }
}
