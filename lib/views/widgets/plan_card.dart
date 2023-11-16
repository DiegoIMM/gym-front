import 'package:flutter/material.dart';
import 'package:gym_front/models/plan.dart';

import '../pages/plan/plan_form.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan});

  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(plan.name,
                    style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                Chip(
                    label: Text('Plan ${plan.period}'),
                    backgroundColor: Colors.green.shade50),
              ],
            ),
            Text(plan.description,
                style: Theme.of(context).textTheme.labelSmall),
            const Spacer(),
            Row(
              children: [
                // Ingresar precio y parsear a moneda
                Text(
                    '\$${plan.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                OutlinedButton(
                    onPressed: () async {
                      var result = await showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return PlanForm(
                            plan: plan,
                          );
                        },
                      );

                      print("result: $result");
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.purple,
                        ),
                        Text('Editar Plan',
                            style: TextStyle(color: Colors.purple)),
                      ],
                    )),
                const SizedBox(width: 8),
                // TODO: Botón y función para eliminar
                // TextButton(
                //     onPressed: () async {
                //       var result = await showDialog<dynamic>(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return SimpleDialog(
                //               insetPadding: const EdgeInsets.all(8),
                //               // icon: const Icon(Icons.question_mark),
                //               elevation: 16,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(16),
                //                 side: const BorderSide(
                //                     color: Colors.black, width: 2),
                //               ),
                //               // scrollable: true,
                //               // title: widget.question != null
                //               title: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Text(
                //                       'Eliminar plan',
                //                       style: Theme.of(context)
                //                           .textTheme
                //                           .displayMedium,
                //                     )
                //                   ]),
                //               children: [
                //                 Text("Confirmar eliminar"),
                //
                //                 // Botones para eliminar
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.end,
                //                   children: [
                //                     TextButton(
                //                         onPressed: () async {
                //                           Navigator.pop(context, true);
                //                         },
                //                         child: const Row(
                //                           children: [
                //                             Icon(
                //                               Icons.delete_forever,
                //                               color: Colors.red,
                //                             ),
                //                             Text('Eliminar Plan',
                //                                 style: TextStyle(
                //                                     color: Colors.purple)),
                //                           ],
                //                         )),
                //                     const SizedBox(width: 8),
                //                     TextButton(
                //                         onPressed: () async {
                //                           Navigator.pop(context, false);
                //                         },
                //                         child: const Row(
                //                           children: [
                //                             Icon(
                //                               Icons.cancel,
                //                               color: Colors.red,
                //                             ),
                //                             Text('Cancelar',
                //                                 style: TextStyle(
                //                                     color: Colors.purple)),
                //                           ],
                //                         )),
                //                   ],
                //                 ),
                //               ]);
                //         },
                //       );
                //       print("result: $result");
                //     },
                //     child: const Row(
                //       children: [
                //         Icon(
                //           Icons.delete_forever,
                //           color: Colors.red,
                //         ),
                //         Text('Eliminar Plan',
                //             style: TextStyle(color: Colors.purple)),
                //       ],
                //     )),
                // const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
