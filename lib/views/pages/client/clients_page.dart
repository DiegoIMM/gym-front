import 'package:flutter/material.dart';

import '../../../models/client.dart';
import '../../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/no_data_widget.dart';
import 'client_form.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late Future<List<Client>> futureClients;

  static var apiService = ApiService();

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
    return Padding(
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
                    var clients = snapshot.data!;

                    return clients.isEmpty
                        ? NoData()
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: (width > 1000) ? 8.0 : 0.0,
                                    horizontal: (width > 1000) ? 50.0 : 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DataTable(
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'Nombre',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Teléfono',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Plan',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Correo',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Acciones',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                          ],
                                          rows: <DataRow>[
                                            for (var client in clients)
                                              DataRow(
                                                cells: <DataCell>[
                                                  DataCell(Text(client.name)),
                                                  DataCell(Text(client.phone)),
                                                  DataCell(Text(
                                                      client.plan != null
                                                          ? client.plan!.name
                                                          : 'Sin plan')),
                                                  DataCell(Text(client.email)),
                                                  DataCell(
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      tooltip: 'Editar',
                                                      onPressed: () async {
                                                        var result =
                                                            await showDialog<
                                                                dynamic>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ClientForm(
                                                                client: client);
                                                          },
                                                        );
                                                        if (result) {
                                                          getClients();
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
