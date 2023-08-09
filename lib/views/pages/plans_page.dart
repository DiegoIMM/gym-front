import 'package:flutter/material.dart';
import 'package:gym_front/views/pages/plan_form.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Planes',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              ElevatedButton(
                  onPressed: () async {
                    var result = await showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return PlanForm();
                      },
                    );
                    print("result: $result");
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.purple,
                      ),
                      Text('Crear Plan',
                          style: TextStyle(color: Colors.purple)),
                    ],
                  ))
            ],
          ),
          const Text("Tabla aquí")
        ]));
  }
}
