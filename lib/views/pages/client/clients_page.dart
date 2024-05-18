import 'package:flutter/material.dart';

import '../../../models/client.dart';
import '../../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/no_data_widget.dart';
import 'client_data_source.dart';
import 'client_form.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late Future<List<Client>> futureClients;

  static var apiService = ApiService();
  int _columnIndex = 0;
  bool _columnAscending = true;

  @override
  void initState() {
    super.initState();
    getClients();
  }

  void getClients() {
    setState(() {
      futureClients = apiService.getClientsByEnterprise();
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
                  'Clientes',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var result = await showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return const ClientForm();
                        },
                      );
                      if (result) {
                        getClients();
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.purple,
                        ),
                        Text('Crear Cliente',
                            style: TextStyle(color: Colors.purple)),
                      ],
                    ))
              ],
            ),
            FutureBuilder(
              future: futureClients,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('No hay conexión al servidor');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return LoadingWidget(text: 'Cargando clientes');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return NoData();
                    }

                    if (snapshot.hasData) {
                      var width = MediaQuery.of(context).size.width;
                      var clients = snapshot.data!;

                      void filterByName(String text) {
                        var a = clients
                            .where((client) => client.name!
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                            .toList();
                        setState(() {
                          print(clients.length);
                        });
                      }

                      void sort(int columnIndex, bool ascending) {
                        setState(() {
                          _columnIndex = columnIndex;
                          _columnAscending = ascending;
                          if (columnIndex == 0) {
                            if (ascending) {
                              clients.sort((a, b) =>
                                  a.numberClient!.compareTo(b.numberClient!));
                            } else {
                              clients.sort((a, b) =>
                                  b.numberClient!.compareTo(a.numberClient!));
                            }
                          }
                          if (columnIndex == 1) {
                            if (ascending) {
                              clients.sort((a, b) => a.rut!.compareTo(b.rut!));
                            } else {
                              clients.sort((a, b) => b.rut!.compareTo(a.rut!));
                            }
                          }
                          if (columnIndex == 2) {
                            if (ascending) {
                              clients
                                  .sort((a, b) => a.name!.compareTo(b.name!));
                            } else {
                              clients
                                  .sort((a, b) => b.name!.compareTo(a.name!));
                            }
                          }
                          if (columnIndex == 3) {
                            if (ascending) {
                              clients
                                  .sort((a, b) => a.phone!.compareTo(b.phone!));
                            } else {
                              clients
                                  .sort((a, b) => b.phone!.compareTo(a.phone!));
                            }
                          }
                          if (columnIndex == 4) {
                            if (ascending) {
                              clients.sort((a, b) =>
                                  a.plan!.name.compareTo(b.plan!.name));
                            } else {
                              clients.sort((a, b) =>
                                  b.plan!.name.compareTo(a.plan!.name));
                            }
                          }
                          if (columnIndex == 5) {
                            if (ascending) {
                              clients.sort((a, b) {
                                if (a.expiredAt != null &&
                                    b.expiredAt != null) {
                                  return a.expiredAt!.compareTo(b.expiredAt!);
                                } else {
                                  return 0;
                                }
                              });
                            } else {
                              clients.sort((a, b) {
                                if (a.expiredAt != null &&
                                    b.expiredAt != null) {
                                  return b.expiredAt!.compareTo(a.expiredAt!);
                                } else {
                                  return 0;
                                }
                              });
                            }
                          }
                        });
                      }

                      return clients.isEmpty
                          ? NoData()
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: (width > 1000) ? 30.0 : 0.0,
                                    horizontal: (width > 1000) ? 20.0 : 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: PaginatedDataTable(
                                          sortColumnIndex: _columnIndex,
                                          sortAscending: _columnAscending,
                                          rowsPerPage: 20,
                                          availableRowsPerPage: const [
                                            20,
                                            40,
                                            50
                                          ],
                                          actions: [
                                            IconButton(
                                              icon: const Icon(Icons.refresh),
                                              tooltip: 'Recargar',
                                              onPressed: () {
                                                getClients();
                                              },
                                            ),
                                          ],
                                          primary: true,
                                          showFirstLastButtons: true,
                                          header: const Text('Clientes'),
                                          columns: <DataColumn>[
                                            DataColumn(
                                                label: const Text('N°',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    )),
                                                onSort: sort),
                                            DataColumn(
                                                label: const Text('Rut',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    )),
                                                onSort: sort),
                                            DataColumn(
                                                label: const Text('Nombre',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    )),
                                                onSort: sort),
                                            DataColumn(
                                                label: const Text('Teléfono',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    )),
                                                onSort: sort),
                                            DataColumn(
                                                label: const Text('Plan',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    )),
                                                onSort: sort),
                                            DataColumn(
                                                label: const Text('Expira',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    )),
                                                onSort: sort),
                                            const DataColumn(
                                              label: Text('Acciones',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w900,
                                                  )),
                                            ),
                                          ],
                                          source: ClientsDataSource(
                                              clients: clients,
                                              context: context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
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
