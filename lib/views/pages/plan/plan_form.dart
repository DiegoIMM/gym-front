import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gym_front/dtos/plan_dto.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../dtos/edit_plan_dto.dart';
import '../../../models/plan.dart';
import '../../../services/api_service.dart';
import '../../../services/scaffold_messenger_service.dart';

class PlanForm extends StatefulWidget {
  const PlanForm({super.key, this.plan});

  final Plan? plan;

  @override
  State<PlanForm> createState() => _PlanFormState();
}

class _PlanFormState extends State<PlanForm> {
  final ApiService apiService = ApiService();

  bool isLoading = false;

  late FormGroup formPlan;

  @override
  initState() {
    super.initState();
    formPlan = FormGroup({
      'id':
          FormControl<int>(value: widget.plan != null ? widget.plan!.id : null),
      'enabled': FormControl<bool>(
          value: widget.plan != null ? widget.plan!.enabled : true,
          validators: [
            Validators.required,
          ]),
      'name': FormControl<String>(
          value: widget.plan != null ? widget.plan!.name : '',
          validators: [
            Validators.required,
          ]),
      'description': FormControl<String>(
          value: widget.plan != null ? widget.plan!.description : '',
          validators: [
            Validators.required,
          ]),
      'period': FormControl<String>(
          value: widget.plan != null ? widget.plan!.period : 'Mensual',
          validators: [
            Validators.required,
          ]),
      'price': FormControl<int>(
          value: widget.plan != null ? widget.plan!.price : 0,
          validators: [Validators.number(), Validators.required]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: formPlan,
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
            widget.plan != null
                ? Text(
                    'Editar plan',
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                : Text(
                    'Crear plan',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
            ReactiveFormConsumer(builder: (context, _, __) {
              return Switch.adaptive(
                  value: formPlan.control('enabled').value,
                  onChanged: (value) {
                    formPlan.control('enabled').value = value;
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
                        // Agregar un panel de información warning
                        if (widget.plan != null)
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  color: Colors.yellow.shade100,
                                  child: const Column(
                                    children: [
                                      Text(
                                        '¡Atención!',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                          'Al editar un plan, se modificarán todos los registros de pagos asociados a este plan.'),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),

                        ReactiveTextField(
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            icon: Icon(Icons.short_text),
                          ),
                          formControlName: 'name',
                          validationMessages: {
                            'required': (error) =>
                                'El nombre no puede estar vacío',
                            'minLength': (error) =>
                                'Redacta un poco mejor el nombre',
                          },
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField(
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            icon: Icon(Icons.short_text),
                          ),
                          formControlName: 'description',
                          validationMessages: {
                            'required': (error) =>
                                'La description no puede estar vacío',
                          },
                        ),
                        ReactiveDropdownField(
                          decoration: const InputDecoration(
                            labelText: 'Periodicidad',
                            icon: Icon(Icons.flag),
                          ),
                          formControlName: 'period',
                          items: const [
                            DropdownMenuItem(
                              value: 'Diario',
                              child: Text('Diario'),
                            ),
                            DropdownMenuItem(
                              value: 'Semanal',
                              child: Text('Semanal'),
                            ),
                            DropdownMenuItem(
                              value: 'BiSemanal',
                              child: Text('BiSemanal'),
                            ),
                            DropdownMenuItem(
                              value: 'Mensual',
                              child: Text('Mensual'),
                            ),
                            DropdownMenuItem(
                              value: 'Trimestral',
                              child: Text('Trimestral'),
                            ),
                            DropdownMenuItem(
                              value: 'Semestral',
                              child: Text('Semestral'),
                            ),
                            DropdownMenuItem(
                              value: 'Anual',
                              child: Text('Anual'),
                            ),
                          ],
                          validationMessages: {
                            'required': (error) =>
                                'Debes seleccionar un periodo',
                          },
                        ),
                        ReactiveTextField(
                          enableInteractiveSelection: false,
                          scribbleEnabled: true,
                          decoration: const InputDecoration(
                            labelText: 'Precio',
                            icon: Icon(Icons.short_text),
                          ),
                          formControlName: 'price',
                          validationMessages: {
                            'number': (error) => 'El precio debe ser un número',
                            'required': (error) =>
                                'El precio no puede estar vacío',
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red.shade200,
                              ),
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            widget.plan == null
                                ? ReactiveFormConsumer(
                                    builder: (context, _, __) {
                                    return ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.green.shade200,
                                      ),
                                      onPressed: (isLoading || !formPlan.valid)
                                          ? null
                                          : createPlan,
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
                                : ReactiveFormConsumer(
                                    builder: (context, _, __) {
                                    return ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.yellow.shade200,
                                      ),
                                      onPressed: (isLoading || !formPlan.valid)
                                          ? null
                                          : editPlan,
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
                    ))),
          ],
        ));
  }

  void createPlan() {
    if (formPlan.valid) {
      print(formPlan.value);
      //   setear el userId en el form
      // form.control('userId').value = widget.userId;
      print(
          'Formulario enviado -> ${PlanDTO.fromJson(formPlan.value).toJson()}');

      setState(() {
        isLoading = true;
      });
      apiService.createPlan(PlanDTO.fromJson(formPlan.value)).then((value) {
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
      formPlan.markAllAsTouched();
    }
  }

  void editPlan() {
    if (formPlan.valid) {
      print(formPlan.value);
      //   setear el userId en el form
      // form.control('userId').value = widget.userId;
      print(
          'Formulario enviado -> ${EditPlanDTO.fromJson(formPlan.value).toJson()}');

      setState(() {
        isLoading = true;
      });
      apiService.editPlan(EditPlanDTO.fromJson(formPlan.value)).then((value) {
        Provider.of<ScaffoldMessengerService>(context, listen: false)
            .showSnackBar(
          "Plan editado correctamente",
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
      formPlan.markAllAsTouched();
    }
  }
}
