import 'package:flutter/material.dart';

import '../../models/payment.dart';
import '../../services/api_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/no_data_widget.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PaymentPage> {
  late Future<List<Payment>> futurePayments;

  static var apiService = ApiService();

  @override
  void initState() {
    super.initState();
    getPayments();
  }

  void getPayments() {
    setState(() {
      // futurePlans = apiService.getAllActivePlans();
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
                        return const Text("TODO: Crear form pagos");
                      },
                    );
                    if (result) {
                      getPayments();
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
            future: futurePayments,
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
                    var payments = snapshot.data!;

                    return payments.isEmpty
                        ? NoData()
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var payment in payments)
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: (width > 1000) ? 8.0 : 0.0,
                                        horizontal: (width > 1000) ? 50.0 : 8.0,
                                      ),
                                      child: Text(payment.name)),
                              ],
                            ),
                          );
                  } else {
                    return const Text('No hay datos');
                  }
              }
            },
          ),
        ]));
  }
}
