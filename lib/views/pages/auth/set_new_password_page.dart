import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../dtos/set_new_pass_dto.dart';
import '../../../services/api_service.dart';


class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({required this.token, Key? key}) : super(key: key);
  final String token;

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  bool loadingButton = false;
  static final _apiService = ApiService();

  final form = FormGroup({
    'token': FormControl<String>(
      value: '',
    ),
    'password':
        FormControl<String>(value: '', validators: [Validators.required]),
    'confirmPassword':
        FormControl<String>(value: '', validators: [Validators.required]),
  }, validators: [
    Validators.mustMatch('password', 'confirmPassword')
  ]);

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
                  //   'Bienvenido a Ayuda Abogados',
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w900,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'Crear nueva contraseña',
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
                        ReactiveTextField(
                          formControlName: 'password',
                          obscureText: true,
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            icon: Icon(Icons.password_rounded),
                          ),
                          validationMessages: {
                            'required': (error) =>
                                'La contraseña no puede estar en blanco',
                          },
                        ),
                        ReactiveTextField(
                          formControlName: 'confirmPassword',
                          obscureText: true,
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar contraseña',
                            icon: Icon(Icons.security_rounded),
                          ),
                          validationMessages: {
                            'required': (error) =>
                                'Las contraseñas no coinciden',
                            'mustMatch': (error) =>
                                'Las contraseñas no coinciden',
                          },
                        ),
                        ReactiveFormConsumer(
                          builder: (context, form, child) {
                            return ElevatedButton(
                              onPressed: (!loadingButton && form.valid)
                                  ? sendRecoveryEmail
                                  : null,
                              child: Row(children: [
                                const Text('Restablecer contraseña'),
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

  void sendRecoveryEmail() async {
    setState(() {
      form.control('token').value = widget.token;

      loadingButton = true;
    });
    var setNewPassDTO = SetNewPassDTO(
      token: form.control('token').value,
      password: form.control('password').value,
    );
    print(setNewPassDTO.toJson());
    await _apiService.setNewPassword(setNewPassDTO).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['message']),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Iniciar sesión',
            onPressed: () {
              context.go('/auth/login');
            },
          )));
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
