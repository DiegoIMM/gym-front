import 'package:flutter/material.dart';
import 'package:gym_front/views/pages/plan/plan_form.dart';
import 'package:gym_front/views/widgets/plan_card.dart';

import '../../../models/plan.dart';
import '../../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/no_data_widget.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  late Future<List<Plan>> futurePlans;

  static var apiService = ApiService();

  @override
  void initState() {
    super.initState();
    getPlans();
  }

  void getPlans() {
    setState(() {
      futurePlans = apiService.getAllActivePlans();
    });
  }

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
                        return const PlanForm();
                      },
                    );
                    if (result) {
                      getPlans();
                    }
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
          FutureBuilder(
            future: futurePlans,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('No hay conexión al servidor');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return LoadingWidget(text: 'Cargando preguntas');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return NoData();
                  }

                  if (snapshot.hasData) {
                    var width = MediaQuery.of(context).size.width;
                    var plans = snapshot.data!;

                    return plans.isEmpty
                        ? NoData()
                        : SingleChildScrollView(
                            child:
                                //Hacer un grid con dos columnas, que se muestren las cards de planes con una altura fija
                                //y que se vayan acomodando en el grid

                                GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: (width / 2) / 200,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: plans.map((plan) {
                                      return PlanCard(plan: plan);
                                    }).toList()));
                  } else {
                    return const Text('No hay datos');
                  }
              }
            },
          ),
        ]));
  }
}
