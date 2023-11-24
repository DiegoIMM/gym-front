import 'package:flutter/material.dart';
import 'package:gym_front/models/client.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../dtos/payment_dto.dart';
import '../../../models/payment.dart';
import '../../../models/plan.dart';
import '../../../services/api_service.dart';
import '../../../services/scaffold_messenger_service.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key, this.payment});

  final Payment? payment;

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
      'rutClient': FormControl<String>(
          value: widget.payment != null ? widget.payment!.typeOfPayment : '',
          validators: [
            Validators.required,
          ]),
      'idEmpresa': FormControl<int>(value: 2, validators: [
        Validators.required,
      ]),
      'idPlan': FormControl<int>(
          value: widget.payment != null ? widget.payment!.id : 0,
          validators: [
            Validators.required,
          ]),
      'typeOfPayment': FormControl<String>(
          value: widget.payment != null ? widget.payment!.typeOfPayment : '',
          validators: [
            Validators.required,
          ]),
      'date': FormControl<DateTime>(
          value: widget.payment != null ? widget.payment!.date : DateTime.now(),
          validators: [
            Validators.required,
          ]),
      'expiredAt': FormControl<DateTime>(
          value: widget.payment != null
              ? widget.payment!.expiredAt
              : DateTime.now(),
          validators: [
            Validators.required,
          ]),
      'price': FormControl<int>(
          value: widget.payment != null ? widget.payment!.price : 0,
          validators: [
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
          // scrollable: true,
          // title: widget.question != null
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            widget.payment != null
                ? Text(
                    'Editar pago',
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                : Text(
                    'Crear pago',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
            // ReactiveFormConsumer(builder: (context, _, __) {
            //   return Switch.adaptive(
            //       value: formPayment.control('enabled').value,
            //       onChanged: (value) {
            //         formPayment.control('enabled').value = value;
            //       });
            // }),
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
                            Expanded(
                              child: ReactiveDropdownField(
                                  formControlName: 'rutClient',
                                  hint: const Text('Rut Cliente'),
                                  onChanged: (value) {
                                    calculateExpiredAt();
                                  },
                                  items: allClients
                                      .map((client) => DropdownMenuItem(
                                            value: client.rut,
                                            child: Text(client.rut),
                                          ))
                                      .toList()),
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
                                            child: Text(plan.name),
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
    var plan = allPlans
        .firstWhere((plan) => plan.id == formPayment.control('idPlan').value);
    var client = allClients.firstWhere(
        (client) => client.rut == formPayment.control('rutClient').value);
    formPayment.control('price').value = plan.price;

    // TODO: Validar si es que el cliente tiene plan, se debe sumar a la fecha de expiración y no desde la fecha actual

    print('date: $date');
    print('plan: $plan');
    print('client: $client');

    var expiredAt = date.add(Duration(days: plan.durationInDays()));
    formPayment.control('expiredAt').value = expiredAt;
  }

  void createPayment() {
    if (formPayment.valid) {
      print(formPayment.value);
      //   setear el userId en el form
      // form.control('userId').value = widget.userId;
      print(
          'Formulario enviado -> ${PaymentDTO.fromJson(formPayment.value).toJson()}');

      setState(() {
        isLoading = true;
      });
      apiService
          .createPayment(PaymentDTO.fromJson(formPayment.value))
          .then((value) {
        Provider.of<ScaffoldMessengerService>(context, listen: false)
            .showSnackBar(
          "Plan creado correctamente",
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
