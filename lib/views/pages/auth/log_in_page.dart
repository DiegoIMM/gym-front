import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../dtos/login_dto.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);
  static final _apiService = ApiService();

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool loadingButton = false;

  final form = FormGroup({
    'users': FormControl<String>(value: '', validators: [Validators.required]),
    'pass': FormControl<String>(value: '', validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ReactiveForm(
              formGroup: form,
              child: Center(
                child: ListView(
                  children: <Widget>[
                    const Icon(
                      Icons.fitness_center_rounded,
                      size: 100,
                    ),
                    const Center(
                      child: Text(
                        'Bienvenido a Planeta Fitness',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // const Spacer(),
                    const Center(
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ReactiveTextField(
                      enableInteractiveSelection: true,
                      enableSuggestions: true,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        icon: Icon(Icons.email),
                      ),
                      formControlName: 'users',
                      validationMessages: {
                        'required': (error) => 'El correo no puede estar vacío',
                      },
                    ),
                    ReactiveTextField(
                      formControlName: 'pass',
                      obscureText: true,
                      enableInteractiveSelection: true,
                      enableSuggestions: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        icon: Icon(Icons.password),
                      ),
                      validationMessages: {
                        'required': (error) =>
                            'La contraseña no puede estar en blanco',
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: RichText(
                    //       textAlign: TextAlign.center,
                    //       text: TextSpan(
                    //           text: '¿Olvidaste tu clave? ',
                    //           children: <InlineSpan>[
                    //             WidgetSpan(
                    //               alignment: PlaceholderAlignment.baseline,
                    //               baseline: TextBaseline.alphabetic,
                    //               child: TextButton(
                    //                 onPressed: () =>
                    //                     context.go('/auth/recovery-password'),
                    //                 child: const Text(
                    //                   'Recuperar contraseña',
                    //                 ),
                    //               ),
                    //             )
                    //           ])),
                    // ),
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return ElevatedButton(
                          onPressed: (!loadingButton && form.valid)
                              ? () => login(context)
                              : null,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Iniciar sesión'),
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
                    // const Spacer(),
                  ],
                ),
              ),
            )));
  }

  void login(BuildContext context) async {
    setState(() {
      loadingButton = true;
    });
    LoginDTO loginDTO = LoginDTO.fromJson(form.value);

    LogInPage._apiService.login(loginDTO).then((dynamic userJson) async {
      var user = User.fromJson(userJson);
      await context.read<AuthService>().saveUser(user);
      context.go('/ingreso');

      setState(() {
        loadingButton = false;
      });
    }).catchError((error) {
      print('error desde front: $error');
      print(error);
      setState(() {
        loadingButton = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ));
    });
  }
}
