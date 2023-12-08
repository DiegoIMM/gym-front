import 'package:flutter/material.dart';
import 'package:gym_front/models/client.dart';
import 'package:gym_front/services/api_service.dart';
import 'package:gym_front/views/widgets/plan_card.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rut_utils/rut_utils.dart';

import '../../../services/scaffold_messenger_service.dart';

class EnteringPage extends StatefulWidget {
  const EnteringPage({super.key});

  @override
  State<EnteringPage> createState() => _EnteringPageState();
}

class _EnteringPageState extends State<EnteringPage> {
  Client? client;

  static var apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  var formClient = FormGroup({
    'rut': FormControl<String>(value: '', validators: [
      Validators.required,
      Validators.delegate((control) {
        final rut = control.value;
        // retornar error si el rut tiene un caracter distinto a un numero o una letra k
        // if (!rut.contains(RegExp(r'[^0-9kK]'))) {
        //   return {'formatRut': true};
        // }
        //
        // if (rut.isEmpty) {
        //   return null;
        // }
        // if (!isRutValid(rut)) {
        //   return {'formatRut': true};
        // }
        // return null;
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
                            setState(() {
                              client = null;
                              formClient.control('rut').value = '';
                              formClient.clearValidators();
                              formClient.markAsUntouched();
                            });
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
            client != null
                ? Row(
                    children: [
                      Expanded(
                        child: Card(
                          surfaceTintColor: client!.expiredAt == null
                              ? Colors.red
                              : client!.expiredAt!
                                          .difference(DateTime.now())
                                          .inDays <
                                      15
                                  ? Colors.orange
                                  : client!.expiredAt!
                                              .difference(DateTime.now())
                                              .inDays <
                                          0
                                      ? Colors.red
                                      : Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                client!.expiredAt == null
                                    ? const Text('Sin plan contratado')
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${client?.name}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge),
                                          Tooltip(
                                            // mostrar cuanto falta para expirar en lenguaje humano
                                            message: client!.expiredAt!
                                                        .difference(
                                                            DateTime.now())
                                                        .inDays <
                                                    0
                                                ? 'Expirado'
                                                : client!.expiredAt!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays <
                                                        1
                                                    ? 'Expira hoy'
                                                    : client!.expiredAt!
                                                                .difference(
                                                                    DateTime
                                                                        .now())
                                                                .inDays <
                                                            2
                                                        ? 'Expira mañana'
                                                        : 'Expira en ${client!.expiredAt?.difference(DateTime.now()).inDays} dias',
                                            child: Text(
                                              client!.expiredAt
                                                  .toString()
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 40,
                                                //Si esta expirado, mostrar en rojo, si le falta menos de 15 dias en naranjo, y si no en verde
                                                color: client!.expiredAt!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays <
                                                        15
                                                    ? Colors.orange
                                                    : client!.expiredAt!
                                                                .difference(
                                                                    DateTime
                                                                        .now())
                                                                .inDays <
                                                            0
                                                        ? Colors.red
                                                        : Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                const Divider(),
                                Row(
                                  children: [
                                    Text('Rut: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                    Text(formatRut(client?.rut ?? ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text('Correo: ${client?.email}'),
                                Text('Teléfono: ${client?.phone}'),
                                Text(
                                    'Fecha nacimiento: ${client?.birthDate?.toString().substring(0, 10) ?? 'Sin fecha'}'),
                                Text('Ciudad: ${client?.city}'),
                                Text('Dirección: ${client?.address}'),
                                client!.plan != null
                                    ? SizedBox(
                                        height: 200,
                                        child: PlanCard(
                                          plan: client!.plan!,
                                          canEdit: false,
                                        ))
                                    : const Text('Sin plan'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Text('Ingrese un rut para consultar'),
          ])),
    );
  }

  void getClient() {
    setState(() {
      isLoading = true;
    });
    if (formClient.valid) {
      print(formClient.value);
      print(formClient.value['rut'].toString());

      apiService
          .getClientByRut(formClient.value['rut'].toString())
          .then((value) {
        Provider.of<ScaffoldMessengerService>(context, listen: false)
            .showSnackBar(
          "Cliente consultado correctamente",
        );

        print('value: $value');
        setState(() {
          isLoading = false;
          client = value;
        });
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
