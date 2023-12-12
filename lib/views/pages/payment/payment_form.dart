import 'package:flutter/material.dart';
import 'package:gym_front/models/client.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../dtos/payment_dto.dart';
import '../../../models/plan.dart';
import '../../../services/api_service.dart';
import '../../../services/scaffold_messenger_service.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final ApiService apiService = ApiService();

  bool isLoading = false;

  late FormGroup formPayment;

  late List<Plan> allPlans = [];
  late List<Client> allClients = [];

  @override
  initState() {
    getClients();
    getPlans();
    super.initState();
    formPayment = FormGroup({
      'rutClient': FormControl<Client>(value: null, validators: [
        Validators.required,
      ]),
      'idEmpresa': FormControl<int>(value: 1, validators: [
        Validators.required,
      ]),
      'idPlan': FormControl<int>(value: null, validators: [
        Validators.required,
      ]),
      'typeOfPayment': FormControl<String>(value: 'Efectivo', validators: [
        Validators.required,
      ]),
      'date': FormControl<DateTime>(value: DateTime.now(), validators: [
        Validators.required,
      ]),
      'expiredAt': FormControl<DateTime>(
          value: DateTime.now(),
          disabled: true,
          validators: [
            Validators.required,
          ]),
      'price': FormControl<int>(value: 0, disabled: true, validators: [
        Validators.required,
      ]),
    });
  }

  void getClients() {
    setState(() {
      apiService.getClientsByEnterprise().then((clients) => {
            for (var client in clients)
              {
                setState(() {
                  allClients.add(client);
                })
              }
          });
    });
  }

  void getPlans() {
    setState(() {
      apiService.getAllActivePlans().then((plans) => {
            for (var plan in plans)
              {
                setState(() {
                  allPlans.add(plan);
                })
              }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: formPayment,
        child: SimpleDialog(
          insetPadding: const EdgeInsets.all(8),
          // icon: const Icon(Icons.question_mark),
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.black, width: 2),
          ),

          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Crear pago',
              style: Theme.of(context).textTheme.displayMedium,
            ),
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
                          formControlName: 'expiredAt',
                          decoration: const InputDecoration(
                            labelText: 'Fecha de expiración',
                          ),
                          readOnly: true,
                        ),
                        Row(
                          children: [
                            // Expanded(
                            //   child: ReactiveDropdownField(
                            //       formControlName: 'rutClient',
                            //       hint: const Text('Rut Cliente'),
                            //       onChanged: (value) {
                            //         calculateExpiredAt();
                            //       },
                            //       items: allClients
                            //           .map((client) => DropdownMenuItem(
                            //                 value: client.rut,
                            //                 child: Text(
                            //                     '${client.rut} - ${client.name}'),
                            //               ))
                            //           .toList()),
                            // ),
                            Expanded(
                              child: ReactiveDropdownSearch<Client, Client>(
                                formControlName: 'rutClient',
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Selecciona un cliente",
                                    labelText: "Cliente",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                popupProps: PopupProps.dialog(
                                  isFilterOnline: true,
                                  showSearchBox: true,
                                  dialogProps: DialogProps(
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.shade100,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cerrar'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onDismissed: () {
                                    print("dismissed!");
                                    calculateExpiredAt();
                                  },
                                  searchDelay: Duration.zero,
                                  emptyBuilder: (context, text) => Center(
                                    child: Text("No hay resultados para $text"),
                                  ),
                                ),

                                showClearButton: true,
                                // onSaved: (value) {
                                //   calculateExpiredAt();
                                // },
                                items: allClients,
                                itemAsString: (Client? u) =>
                                    '${u!.rut} - ${u.name}',
                              ),
                            ),
                            Expanded(
                              child: ReactiveDropdownField(
                                  formControlName: 'idPlan',
                                  hint: const Text('Plan'),
                                  onChanged: (value) {
                                    calculateExpiredAt();
                                  },
                                  items: allPlans
                                      .map((plan) => DropdownMenuItem(
                                            value: plan.id,
                                            child: Text(
                                                '${plan.name} - \$${plan.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'),
                                          ))
                                      .toList()),
                            ),
                          ],
                        ),
                        ReactiveDropdownField(
                            formControlName: 'typeOfPayment',
                            hint: const Text('Tipo de pago'),
                            items: const [
                              DropdownMenuItem(
                                value: 'Efectivo',
                                child: Text('Efectivo'),
                              ),
                              DropdownMenuItem(
                                value: 'Crédito',
                                child: Text('Crédito'),
                              ),
                              DropdownMenuItem(
                                value: 'Debito',
                                child: Text('Debito'),
                              ),
                            ]),
                        ReactiveTextField(
                          formControlName: 'price',
                          decoration: const InputDecoration(
                            labelText: 'Total a pagar',
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red.shade100,
                              ),
                              child: const Text('Cancelar'),
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
                                  backgroundColor: Colors.green.shade100,
                                ),
                                onPressed: (isLoading || !formPayment.valid)
                                    ? null
                                    : createPayment,
                                child: Row(children: [
                                  const Text('Crear'),
                                  isLoading
                                      ? Container(
                                          width: 16,
                                          height: 16,
                                          padding: const EdgeInsets.all(2.0),
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Container(),
                                ]),
                              );
                            }),
                          ],
                        ),
                      ],
                    ))),
          ],
        ));
  }

  void calculateExpiredAt() {
    var date = formPayment.control('date').value;

    if (formPayment.control('idPlan').value == null ||
        formPayment.control('rutClient').value == null) {
      print('entró');
      return;
    }

    var plan = allPlans
        .firstWhere((plan) => plan.id == formPayment.control('idPlan').value);

    print('plan: $plan');

    var client = allClients.firstWhere((client) =>
        client.rut == (formPayment.control('rutClient').value as Client).rut);
    formPayment.control('price').value = plan.price;
    print('client: $client');

    // si cliente tiene fecha de expiración sumar desde esa fecha fecha, si no, sumar desde hoy

    if (client.expiredAt != null) {
      var expiredAt =
          client.expiredAt!.add(Duration(days: plan.durationInDays()));
      setState(() {
        formPayment.control('expiredAt').value = expiredAt;
      });
    } else {
      var expiredAt = date.add(Duration(days: plan.durationInDays()));
      setState(() {
        formPayment.control('expiredAt').value = expiredAt;
      });
    }
  }

  void createPayment() {
    if (formPayment.valid) {
      print(formPayment.rawValue);
      //   setear el userId en el form
      // form.control('userId').value = widget.userId;

      print('Formulario enviado -> ${PaymentDTO(
        rutClient: (formPayment.control('rutClient').value as Client).rut,
        idEmpresa: formPayment.control('idEmpresa').value,
        idPlan: formPayment.control('idPlan').value,
        typeOfPayment: formPayment.control('typeOfPayment').value,
        date: formPayment.control('date').value,
        expiredAt: formPayment.control('expiredAt').value,
        price: formPayment.control('price').value,
      ).toJson()}');

      setState(() {
        isLoading = true;
      });
      apiService
          .createPayment(PaymentDTO(
        rutClient: (formPayment.control('rutClient').value as Client).rut,
        idEmpresa: formPayment.control('idEmpresa').value,
        idPlan: formPayment.control('idPlan').value,
        typeOfPayment: formPayment.control('typeOfPayment').value,
        date: formPayment.control('date').value,
        expiredAt: formPayment.control('expiredAt').value,
        price: formPayment.control('price').value,
      ))
          .then((value) {
        Provider.of<ScaffoldMessengerService>(context, listen: false)
            .showSnackBar(
          "Pago creado correctamente",
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
      formPayment.markAllAsTouched();
    }
  }
}
