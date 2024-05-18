import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../dtos/sign_up_dto.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static final _apiService = ApiService();

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool loadingButton = false;

  final form = FormGroup({
    'name': FormControl<String>(
        value: kDebugMode ? 'Diego Martinez' : '',
        validators: [Validators.required]),
    'username': FormControl<String>(
        value: kDebugMode ? 'diegomartinez' : '',
        validators: [Validators.required]),
    'email': FormControl<String>(
        value: kDebugMode ? 'diegomartinezpavez@icloud.com' : '',
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(
        value: kDebugMode ? 'q1w2e3r4' : '', validators: [Validators.required]),
    'confirmPassword': FormControl<String>(
        value: kDebugMode ? 'q1w2e3r4' : '', validators: [Validators.required]),
    'acceptTerms': FormControl<bool>(
        value: kDebugMode ? true : false,
        validators: [Validators.requiredTrue]),
  }, validators: [
    Validators.mustMatch('password', 'confirmPassword')
  ]);

  @override
  Widget build(BuildContext context) {
    Widget buildWideContainers() {
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
                    const Center(
                      child: Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            child: ReactiveTextField(
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                                icon: Icon(Icons.person),
                              ),
                              formControlName: 'name',
                              validationMessages: {
                                'required': (error) =>
                                    'El nombre no puede estar vacío'
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: ReactiveTextField(
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                labelText: 'Nombre de usuario',
                                icon: Icon(Icons.contacts_sharp),
                                helperText:
                                    'Seudónimo e identificador único para tu perfil de usuario',
                              ),
                              formControlName: 'username',
                              validationMessages: {
                                'required': (error) =>
                                    'El nombre de usuario no puede estar vacío'
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    ReactiveTextField(
                      enableInteractiveSelection: true,
                      enableSuggestions: true,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                      formControlName: 'email',
                      validationMessages: {
                        'required': (error) => 'El correo no puede estar vacío',
                        'email': (error) =>
                            'El formato del correo no es válido',
                      },
                    ),
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
                        'required': (error) => 'Las contraseñas no coinciden',
                        'mustMatch': (error) => 'Las contraseñas no coinciden',
                      },
                    ),

                    const SizedBox(height: 20),

                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return ElevatedButton(
                            onPressed: (!loadingButton && form.valid)
                                ? () => signUp(context)
                                : null,
                            child: Row(children: [
                              const Text('Registrarse'),
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
                            ]));
                      },
                    ),
                    const SizedBox(height: 20),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '¿Ya tienes una cuenta? ',
                            children: <InlineSpan>[
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: TextButton(
                                  onPressed: () => context.go('/auth/login'),
                                  child: const Text(
                                    'Inicia sesión',
                                  ),
                                ),
                              )
                            ])),
                  ]))));
    }

    Widget buildPhoneContainer() {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              const Center(
                child: Text(
                  'Registrarse',
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
                  labelText: 'Nombre',
                  icon: Icon(Icons.person),
                ),
                formControlName: 'name',
                validationMessages: {
                  'required': (error) => 'El nombre no puede estar vacío'
                },
              ),
              ReactiveTextField(
                enableInteractiveSelection: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                  icon: Icon(Icons.contacts_sharp),
                  helperText:
                      'Seudónimo e identificador único para tu perfil de usuario',
                ),
                formControlName: 'username',
                validationMessages: {
                  'required': (error) =>
                      'El nombre de usuario no puede estar vacío'
                },
              ),
              ReactiveTextField(
                enableInteractiveSelection: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                formControlName: 'email',
                validationMessages: {
                  'required': (error) => 'El correo no puede estar vacío',
                  'email': (error) => 'El formato del correo no es válido',
                },
              ),
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
                  'required': (error) => 'Las contraseñas no coinciden',
                  'mustMatch': (error) => 'Las contraseñas no coinciden',
                },
              ),

              const SizedBox(height: 20),

              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return ElevatedButton(
                      onPressed: (!loadingButton && form.valid)
                          ? () => signUp(context)
                          : null,
                      child: Row(children: [
                        const Text('Registrarse'),
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
                      ]));
                },
              ),
              const SizedBox(height: 20),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: '¿Ya tienes una cuenta? ',
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: TextButton(
                            onPressed: () => context.go('/auth/login'),
                            child: const Text(
                              'Inicia sesión',
                            ),
                          ),
                        )
                      ])),
            ])),
      ));
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return buildWideContainers();
        } else {
          return buildPhoneContainer();
        }
      },
    );
  }

  void signUp(BuildContext context) {
    setState(() {
      loadingButton = true;
    });
    print(form.value);
    SignUpDTO signUpDTO = SignUpDTO.fromJson(form.value);

    print(signUpDTO.toJson());

    SignUpPage._apiService
        .signUp(signUpDTO)
        .then((dynamic userWithToken) async {
      setState(() {
        loadingButton = false;
      });
      print('userWithToken: $userWithToken');
      // context.read<AuthService>().saveToken(userWithToken['token']);
      var user = User.fromJson(userWithToken['user']);
      await context.read<AuthService>().saveUser(user);

      context.go('/inicio');

      // await context.router
      //     .replaceNamed('/app/inicio');
    }).catchError((error) {
      setState(() {
        loadingButton = false;
      });
      print('error desde front: $error');
      print(error);

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
