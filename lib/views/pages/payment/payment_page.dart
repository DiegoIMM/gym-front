import 'package:flutter/material.dart';
import 'package:gym_front/views/pages/payment/payment_data_source.dart';
import 'package:gym_front/views/pages/payment/payment_form.dart';

import '../../../models/payment.dart';
import '../../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/no_data_widget.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PaymentPage> {
  late Future<List<Payment>> futurePayments;

  static var apiService = ApiService();
  int _columnIndex = 0;
  bool _columnAscending = true;
  @override
  void initState() {
    super.initState();
    getPayments();
  }

  void getPayments() {
    setState(() {
      futurePayments = apiService.getAllActivePayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pagos',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var result = await showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return const PaymentForm();
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
                        Text('Nuevo pago',
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
                    return LoadingWidget(text: 'Cargando pagos');
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

                      void filterByName(String text) {
                        var a = payments
                            .where((payment) => payment.client.name!
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                            .toList();
                        setState(() {
                          print(payments.length);
                        });
                      }

                      void sort(int columnIndex, bool ascending) {

                        setState(() {
                          _columnIndex = columnIndex;
                          _columnAscending = ascending;
                          if (columnIndex == 0) {
                            if (ascending) {
                              payments.sort((a, b) => b.date.compareTo(a.date));
                            } else {
                              payments.sort((a, b) => a.date.compareTo(b.date));
                            }
                          }
                          if (columnIndex == 1) {
                            if (ascending) {
                              payments.sort((a, b) =>
                                  a.client.name!.compareTo(b.client.name!));
                            } else {
                              payments.sort((a, b) =>
                                  b.client.name!.compareTo(a.client.name!));
                            }
                          }
                          if (columnIndex == 2) {
                            if (ascending) {
                              payments.sort(
                                  (a, b) => a.plan.name.compareTo(b.plan.name));
                            } else {
                              payments.sort(
                                  (a, b) => b.plan.name.compareTo(a.plan.name));
                            }
                          }
                          if (columnIndex == 3) {
                            if (ascending) {
                              payments.sort(
                                  (a, b) => a.expiredAt.compareTo(b.expiredAt));
                            } else {
                              payments.sort(
                                  (a, b) => b.expiredAt.compareTo(a.expiredAt));
                            }
                          }
                          if (columnIndex == 4) {
                            if (ascending) {
                              payments
                                  .sort((a, b) => a.price.compareTo(b.price));
                            } else {
                              payments
                                  .sort((a, b) => b.price.compareTo(a.price));
                            }
                          }
                        });
                      }
                      return payments.isEmpty
                          ? NoData()
                          : Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: (width > 1000) ? 8.0 : 0.0,
                                  horizontal: (width > 1000) ? 50.0 : 8.0,
                                ),
                                child: Row(children: [
                                  Expanded(
                                    child: PaginatedDataTable(
                                      sortColumnIndex: _columnIndex,
                                      sortAscending: _columnAscending,
                                      rowsPerPage: 20,
                                      availableRowsPerPage: const [20, 40, 50],
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.refresh),
                                          tooltip: 'Recargar',
                                          onPressed: () {
                                            getPayments();
                                          },
                                        ),
                                      ],
                                      primary: true,
                                      showFirstLastButtons: true,
                                      header: const Text('Pagos'),
                                      columns: [
                                        DataColumn(
                                            label: const Text('Fecha',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                )),
                                            onSort: (columnIndex, ascending) {
                                              sort(columnIndex, ascending);
                                            }),
                                        DataColumn(
                                            label: const Text('Cliente',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                )),
                                            onSort: (columnIndex, ascending) {
                                              sort(columnIndex, ascending);
                                            }),
                                        DataColumn(
                                            label: const Text('Plan',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                )),
                                            onSort: (columnIndex, ascending) {
                                              sort(columnIndex, ascending);
                                            }),
                                        DataColumn(
                                            label: const Text('Vencimiento',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                )),
                                            onSort: (columnIndex, ascending) {
                                              sort(columnIndex, ascending);
                                            }),
                                        DataColumn(
                                            label: const Text('Precio',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                )),
                                            onSort: (columnIndex, ascending) {
                                              sort(columnIndex, ascending);
                                            }),
                                      ],
                                      source: PaymentsDataSource(
                                          payments: payments, context: context),
                                    ),
                                  
                                  ),
                                ]),
                              ),
                            ]);
                    } else {
                      return const Text('No hay datos');
                    }
                }
              },
            ),
          ])),
    );
  }
}
