import 'package:flutter/material.dart';
import 'package:gym_front/models/client.dart';
import 'package:gym_front/services/api_service.dart';
import 'package:gym_front/views/widgets/plan_card.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../services/scaffold_messenger_service.dart';

class EnteringNPage extends StatefulWidget {
  const EnteringNPage({super.key});

  @override
  State<EnteringNPage> createState() => _EnteringNPageState();
}

class _EnteringNPageState extends State<EnteringNPage> {
  Client? client;

  static var apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  var formClient = FormGroup({
    'ncliente':
        FormControl<String>(value: '', validators: [Validators.required]),
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
              'Consultar ingreso por número de cliente',
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
                            decoration: const InputDecoration(
                              labelText: 'N° de cliente',
                              icon: Icon(Icons.short_text),
                            ),
                            formControlName: 'ncliente',
                            validationMessages: {
                              'required': (error) =>
                                  'El N° no puede estar vacío',
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
                              formClient.control('ncliente').value = '';
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
                          surfaceTintColor: client!.color,
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
                                                  .displaySmall),
                                          Tooltip(
                                            // mostrar cuanto falta para expirar en lenguaje humano
                                            message: client!.timeToExpire,
                                            child: Text(
                                              client!.getFormattedExpireDate(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 40,
                                                  //Si esta expirado, mostrar en rojo, si le falta menos de 15 dias en naranjo, y si no en verde
                                                  color: client!.color),
                                            ),
                                          ),
                                        ],
                                      ),
                                const Divider(),
                                Row(
                                  children: [
                                    Text('N° Cliente: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                    Text(client?.numberClient.toString() ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Rut: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                    Text(client?.rut ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text('Correo: ${client?.email}'),
                                Text('Teléfono: ${client?.phone}'),
                                Text(
                                    'Fecha nacimiento: ${client?.getFormattedBirthDate()}'),
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
                : const Text('Ingrese un N° para consultar'),
          ])),
    );
  }

  void getClient() {
    setState(() {
      isLoading = true;
    });
    if (formClient.valid) {
      print(formClient.value);
      print(formClient.value['ncliente'].toString());

      apiService
          .getClientByNCliente(formClient.value['ncliente'].toString())
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
