import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_front/dtos/client_dto.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rut_utils/rut_utils.dart';

import '../../../models/client.dart';
import '../../../services/api_service.dart';
import '../../../services/scaffold_messenger_service.dart';

class ClientForm extends StatefulWidget {
  const ClientForm({super.key, this.client});

  final Client? client;

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final ApiService apiService = ApiService();

  bool isLoading = false;

  late FormGroup formClient;

  @override
  initState() {
    super.initState();
    formClient = FormGroup({
      'enabled': FormControl<bool>(
          value: widget.client != null ? widget.client!.enabled : true,
          validators: [
            Validators.required,
          ]),
      'rut': FormControl<String>(
          disabled: widget.client != null,
          value: widget.client != null
              ? widget.client!.rut
              : kDebugMode
                  ? '11111111-1'
                  : '',
          validators: [
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
      'name': FormControl<String>(
          value: widget.client != null
              ? widget.client!.name
              : kDebugMode
                  ? 'Diego'
                  : '',
          validators: [
            Validators.required,
          ]),
      'email': FormControl<String>(
          value: widget.client != null
              ? widget.client!.email
              : kDebugMode
                  ? 'diego@icloud.com'
                  : '',
          validators: [Validators.required, Validators.email]),
      'phone': FormControl<String>(
          value: widget.client != null
              ? widget.client!.phone
              : kDebugMode
                  ? '+56912123434'
                  : '+569',
          validators: [
            Validators.required,
            Validators.pattern(r'^(\+?56)?(\s?)(0?9)(\s?)[9876543210]\d{7}$',
                validationMessage: 'No es un número de teléfono válido')
          ]),
      'auxiliarPhone': FormControl<String>(
          value: widget.client != null
              ? widget.client!.auxiliarPhone
              : kDebugMode
                  ? '+56912123434'
                  : '+569',
          validators: [
            Validators.required,
            Validators.pattern(r'^(\+?56)?(\s?)(0?9)(\s?)[9876543210]\d{7}$',
                validationMessage: 'No es un número de teléfono válido')
          ]),
      'idEmpresa': FormControl<int>(
          value: widget.client != null ? widget.client!.empresa!.id : 1,
          validators: [
            Validators.required,
          ]),
      'city': FormControl<String>(
          value: widget.client != null
              ? widget.client!.city
              : kDebugMode
                  ? 'Santiago'
                  : null),
      'comuna': FormControl<String>(
          value: widget.client != null
              ? widget.client!.comuna
              : kDebugMode
                  ? 'Santiago'
                  : null),
      'address': FormControl<String>(
          value: widget.client != null
              ? widget.client!.address
              : kDebugMode
                  ? 'Santiago'
                  : null),
      'birthDate': FormControl<DateTime>(
          value: widget.client != null ? widget.client!.birthDate : null,
          validators: [Validators.required]),
      'idPlan': FormControl<int>(
          value: widget.client != null ? widget.client!.idPlan : null),
      'idPayment': FormControl<int>(
          value: widget.client != null ? widget.client!.idPayment : null),
      'expiredAt': FormControl<DateTime>(
          value: widget.client != null ? widget.client!.expiredAt : null),
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: formClient,
        child: SimpleDialog(
            insetPadding: const EdgeInsets.all(8),
            // icon: const Icon(Icons.question_mark),
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.black, width: 2),
            ),
            // scrollable: true,
            // title: widget.question != null
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.client != null
                      ? Text(
                          'Editar cliente',
                          style: Theme.of(context).textTheme.displayMedium,
                        )
                      : Text(
                          'Crear cliente',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                  ReactiveFormConsumer(builder: (context, _, __) {
                    return Switch.adaptive(
                        value: formClient.control('enabled').value,
                        onChanged: (value) {
                          formClient.control('enabled').value = value;
                        });
                  }),
                ]),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReactiveTextField(
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          icon: Icon(Icons.short_text),
                        ),
                        formControlName: 'name',
                        validationMessages: {
                          'required': (error) =>
                              'El nombre no puede estar vacío'
                        },
                      ),
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
                                  formClient.control('rut').value =
                                      formattedRut;
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
                          Expanded(
                            child: ReactiveTextField(
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              onChanged: (control) {
                                setState(() {
                                  formClient.control('email').value =
                                      control.value.toString().trim();
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                icon: Icon(Icons.short_text),
                              ),
                              formControlName: 'email',
                              validationMessages: {
                                'required': (error) =>
                                    'El email no puede estar vacío',
                                'email': (error) => 'Ingresa un correo válido',
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ReactiveTextField(
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono',
                                icon: Icon(Icons.short_text),
                              ),
                              formControlName: 'phone',
                              validationMessages: {
                                'required': (error) =>
                                    'El teléfono no puede estar vacío'
                              },
                            ),
                          ),
                          Expanded(
                            child: ReactiveTextField(
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono Auxiliar',
                                icon: Icon(Icons.short_text),
                              ),
                              formControlName: 'auxiliarPhone',
                              validationMessages: {
                                'required': (error) =>
                                    'El teléfono auxiliar no puede estar vacío',
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ReactiveTextField(
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                labelText: 'Ciudad',
                                icon: Icon(Icons.short_text),
                              ),
                              formControlName: 'city',
                              validationMessages: {
                                'required': (error) =>
                                    'La ciudad no puede estar vacío',
                                'minLength': (error) =>
                                    'Redacta un poco mejor la ciudad',
                              },
                            ),
                          ),
                          Expanded(
                            child: ReactiveTextField(
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                labelText: 'Comuna',
                                icon: Icon(Icons.short_text),
                              ),
                              formControlName: 'comuna',
                              validationMessages: {
                                'required': (error) =>
                                    'La comuna no puede estar vacío',
                                'minLength': (error) =>
                                    'Redacta un poco mejor la comuna',
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ReactiveTextField(
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          icon: Icon(Icons.short_text),
                        ),
                        formControlName: 'address',
                        validationMessages: {
                          'required': (error) =>
                              'La dirección no puede estar vacío',
                          'minLength': (error) =>
                              'Redacta un poco mejor la dirección',
                        },
                      ),
                      const SizedBox(height: 16),

                      ReactiveDatePicker(
                        formControlName: 'birthDate',
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, picker, child) {
                          return ReactiveTextField(
                            scribbleEnabled: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Fecha de nacimiento',
                              hintText:
                                  '<--- Toca el icono para seleccionar la fecha',
                              icon: IconButton(
                                onPressed: picker.showPicker,
                                icon: const Icon(Icons.calendar_today),
                              ),
                            ),
                            formControlName: 'birthDate',
                            validationMessages: {
                              'required': (error) =>
                                  'La fecha de nacimiento no puede estar vacío',
                            },
                          );
                        },
                      ),
                      //Añadir un datepicker con el mismo estilo que el resto del formulario
                      /*  ReactiveDatePicker(
                        formControlName: 'birthDate',
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, picker, child) {
                          return IconButton(
                            onPressed: picker.showPicker,
                            icon: const Icon(Icons.calendar_today),
                          );
                        },
                      ),*/

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red.shade200,
                            ),
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          widget.client == null
                              ? ReactiveFormConsumer(builder: (context, _, __) {
                                  return ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green.shade200,
                                    ),
                                    onPressed: (isLoading || !formClient.valid)
                                        ? null
                                        : createClient,
                                    child: Row(children: [
                                      const Text('Crear'),
                                      isLoading
                                          ? Container(
                                              width: 16,
                                              height: 16,
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child:
                                                  const CircularProgressIndicator(
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : Container(),
                                    ]),
                                  );
                                })
                              : ReactiveFormConsumer(builder: (context, _, __) {
                                  return ElevatedButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.yellow.shade200,
                                    ),
                                    onPressed: (isLoading || !formClient.valid)
                                        ? null
                                        : editClient,
                                    child: Row(children: [
                                      const Text('Editar'),
                                      isLoading
                                          ? Container(
                                              width: 16,
                                              height: 16,
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child:
                                                  const CircularProgressIndicator(
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
                  ),
                ),
              ),
            ]));
  }

  void createClient() {
    if (formClient.valid) {
      print(formClient.value);

      //   setear el userId en el form
      // form.control('userId').value = widget.userId;
      print(
          'Formulario enviado -> ${ClientDTO.fromJson(formClient.value).toJson()}');

      setState(() {
        isLoading = true;
      });
      apiService
          .createClient(ClientDTO.fromJson(formClient.value))
          .then((value) {
        Provider.of<ScaffoldMessengerService>(context, listen: false)
            .showSnackBar(
          "Cliente creado correctamente",
        );

        //   Cerrar el dialogo
        Navigator.of(context).pop(true);
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      });
    } else {
      print('Formulario invalido');
      formClient.markAllAsTouched();
    }
  }

  void editClient() {
    if (formClient.valid) {
      print(formClient.rawValue);

      //   setear el userId en el form
      // form.control('userId').value = widget.userId;
      print(
          'Formulario enviado -> ${ClientDTO.fromJson(formClient.rawValue).toJson()}');

      setState(() {
        isLoading = true;
      });
      apiService
          .editClient(ClientDTO.fromJson(formClient.rawValue))
          .then((value) {
        Provider.of<ScaffoldMessengerService>(context, listen: false)
            .showSnackBar(
          "Cliente editado correctamente",
        );

        //   Cerrar el dialogo
        Navigator.of(context).pop(true);
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      });
    } else {
      print('Formulario invalido');
      formClient.markAllAsTouched();
    }
  }
}
