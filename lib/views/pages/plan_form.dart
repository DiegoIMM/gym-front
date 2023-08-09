import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gym_front/dtos/plan_dto.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../services/api_service.dart';

class PlanForm extends StatelessWidget {
  PlanForm({super.key});

  final ApiService apiService = ApiService();
  bool isLoading = false;
  final formPlan = FormGroup({
    'enabled': FormControl<bool>(value: true, validators: [
      Validators.required,
    ]),
    'name': FormControl<String>(value: '', validators: [
      Validators.required,
    ]),
    'description': FormControl<String>(value: '', validators: [
      Validators.required,
    ]),
    'period': FormControl<String>(value: '', validators: [
      Validators.required,
    ]),
    'price': FormControl<int>(
        value: 0, validators: [Validators.number, Validators.required]),
  });

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
            false
                ? Text(
                    'Editar pregunta',
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
                              value: 'Mensual',
                              child: Text('Mensual'),
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
                                onPressed: (isLoading || !formPlan.valid)
                                    ? null
                                    : createPlan,
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

      //   setState(() {
      //     _isLoading = true;
      //   });
      //   _apiService.addQuestion(QuestionDTO.fromJson(form.value)).then((value) {
      //     Provider.of<ScaffoldMessengerService>(context, listen: false)
      //         .showSnackBar(
      //       "Pregunta creada correctamente",
      //     );
      //
      //     //   Cerrar el dialogo
      //     Navigator.of(context).pop();
      //   }).catchError((error) {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(error.toString()),
      //       ),
      //     );
      //   });
      // } else {
      //   print('Formulario invalido');
      //   form.markAllAsTouched();
    }
  }
}