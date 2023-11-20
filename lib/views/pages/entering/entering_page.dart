import 'package:flutter/material.dart';
import 'package:gym_front/models/client.dart';
import 'package:gym_front/services/api_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rut_utils/rut_utils.dart';

class EnteringPage extends StatefulWidget {
  const EnteringPage({super.key});

  @override
  State<EnteringPage> createState() => _EnteringPageState();
}

class _EnteringPageState extends State<EnteringPage> {
  late Future<List<Client>> futureClients;

  static var apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getClients();
  }

  void getClients() {
    setState(() {
      futureClients = apiService.getClientsByEnterprise();
    });
  }

  var formClient = FormGroup({
    'rut': FormControl<String>(value: '', validators: [
      Validators.required,
      Validators.delegate((control) {
        final rut = control.value;
        // retornar error si el rut tiene un caracter distinto a un numero o una letra k
        if (!rut.contains(RegExp(r'[^0-9kK]'))) {
          return {'formatRut': true};
        }

        if (rut.isEmpty) {
          return null;
        }
        if (!isRutValid(rut)) {
          return {'formatRut': true};
        }
        return null;
      }),
    ]),
    'idEmpresa': FormControl<int>(value: 2, validators: [
      Validators.required,
    ]),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Text(
              'Consultar ingreso',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ReactiveForm(
                formGroup: formClient,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ReactiveTextField(
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            onChanged: (control) {
                              var unformattedRut =
                                  deFormatRut(control.value.toString());
                              var formattedRut = formatRut(unformattedRut);
                              setState(() {
                                formClient.control('rut').value = formattedRut;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Rut',
                              icon: Icon(Icons.short_text),
                            ),
                            formControlName: 'rut',
                            validationMessages: {
                              'required': (error) =>
                                  'El rut no puede estar vacío',
                              'formatRut': (error) =>
                                  'El rut ingresado no es válido',
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red.shade200,
                          ),
                          child: const Text('Limpiar resultados'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ReactiveFormConsumer(builder: (context, _, __) {
                          return ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green.shade200,
                            ),
                            onPressed: (isLoading || !formClient.valid)
                                ? null
                                : getClient,
                            child: Row(children: [
                              const Text('Consultar'),
                              isLoading
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
                        })
                      ],
                    ),
                  ],
                )),
            Text('Resultado aquí')
          ])),
    );
  }

  void getClient() {
    if (formClient.valid) {
      print(formClient.value);

      setState(() {
        isLoading = true;
      });
      // apiService
      //     .createClient(ClientDTO.fromJson(formClient.value))
      //     .then((value) {
      //   Provider.of<ScaffoldMessengerService>(context, listen: false)
      //       .showSnackBar(
      //     "Cliente creado correctamente",
      //   );
      //
      //   //   Cerrar el dialogo
      //   Navigator.of(context).pop(true);
      // }).catchError((error) {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(error.toString()),
      //     ),
      //   );
      // });
    } else {
      print('Formulario invalido');
      formClient.markAllAsTouched();
    }
  }
}
