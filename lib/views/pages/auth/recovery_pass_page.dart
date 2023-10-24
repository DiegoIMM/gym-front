import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../services/api_service.dart';

class RecoveryPassPage extends StatefulWidget {
  const RecoveryPassPage({Key? key}) : super(key: key);
  static final _apiService = ApiService();

  @override
  State<RecoveryPassPage> createState() => _RecoveryPassPageState();
}

class _RecoveryPassPageState extends State<RecoveryPassPage> {
  bool loadingButton = false;

  final form = FormGroup({
    'email': FormControl<String>(
        value: kDebugMode ? 'diegomartinezpavez@icloud.com' : '',
        validators: [Validators.required, Validators.email]),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ReactiveForm(
                formGroup: form,
                child: ListView(children: <Widget>[
                  // const Icon(
                  //   Icons.gavel_rounded,
                  //   size: 100,
                  // ),
                  // const Text(
                  //   'Bienvenido a Gym',
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w900,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'Recuperar contraseña',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  IntrinsicHeight(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                        Flexible(
                          child: ReactiveTextField(
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                            formControlName: 'email',
                            validationMessages: {
                              'required': (error) =>
                                  'El correo no puede estar vacío',
                              'email': (error) =>
                                  'El formato del correo no es válido',
                            },
                          ),
                        ),
                        ReactiveFormConsumer(
                          builder: (context, form, child) {
                            return ElevatedButton(
                              onPressed: (!loadingButton && form.valid)
                                  ? () => sendUrlRequestNewPassword()
                                  : null,
                              child: Row(children: [
                                const Text('Solicitar restablecer contraseña'),
                                loadingButton
                                    ? Container(
                                        width: 16,
                                        height: 16,
                                        padding: const EdgeInsets.all(2.0),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Container(),
                              ]),
                            );
                          },
                        ),
                      ]))
                ]))));
  }

  void sendUrlRequestNewPassword() async {
    setState(() {
      loadingButton = true;
    });
    await RecoveryPassPage._apiService
        .sendUrlRequestNewPassword(form.controls['email']!.value.toString())
        .then((value) {
      print('asdffasd');
      print(value);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value['message']),
        backgroundColor: Colors.green,
      ));
      setState(() {
        loadingButton = false;
      });
    }).catchError((onError) {
      print('errrrr');
      print(onError);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError),
        backgroundColor: Colors.red,
      ));
      setState(() {
        loadingButton = false;
      });
    });
  }
}
