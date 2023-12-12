import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

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
                                        child: Center(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text('Rut',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                ),
                                                DataColumn(
                                                  label: Text('Nombre',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                ),
                                                DataColumn(
                                                  label: Text('Teléfono',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                ),
                                                DataColumn(
                                                  label: Text('Plan',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                ),
                                                DataColumn(
                                                  label: Text('Expira',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                ),
                                                DataColumn(
                                                  label: Text('Acciones',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                ),
                                              ],
                                              rows: <DataRow>[
                                                for (var client in clients)
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(
                                                          Text(client.rut)),
                                                      DataCell(
                                                          Text(client.name)),
                                                      DataCell(
                                                          Text(client.phone)),
                                                      DataCell(Text(
                                                          client.plan != null
                                                              ? client
                                                                  .plan!.name
                                                              : 'Sin plan')),
                                                      DataCell(
                                                          client.expiredAt !=
                                                                  null
                                                              ? Tooltip(
                                                                  // mostrar cuanto falta para expirar en lenguaje humano
                                                                  message: client
                                                                              .expiredAt!
                                                                              .difference(DateTime.now())
                                                                              .inDays <
                                                                          0
                                                                      ? 'Expirado'
                                                                      : client.expiredAt!.difference(DateTime.now()).inDays < 1
                                                                          ? 'Expira hoy'
                                                                          : client.expiredAt!.difference(DateTime.now()).inDays < 2
                                                                              ? 'Expira mañana'
                                                                              : 'Expira en ${client.expiredAt!.difference(DateTime.now()).inDays} dias',
                                                                  child: Text(
                                                                    client
                                                                        .expiredAt
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                    style:
                                                                        TextStyle(
                                                                      //Si esta expirado, mostrar en rojo, si le falta menos de 15 dias en naranjo, y si no en verde
                                                                      color: client.expiredAt!.difference(DateTime.now()).inDays <
                                                                              15
                                                                          ? Colors
                                                                              .orange
                                                                          : client.expiredAt!.difference(DateTime.now()).inDays < 0
                                                                              ? Colors.red
                                                                              : Colors.green,
                                                                    ),
                                                                  ),
                                                                )
                                                              : const Text(
                                                                  'Sin plan')),
                                                      DataCell(
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.edit),
                                                              tooltip: 'Editar',
                                                              onPressed:
                                                                  () async {
                                                                var result =
                                                                    await showDialog<
                                                                        dynamic>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ClientForm(
                                                                        client:
                                                                            client);
                                                                  },
                                                                );
                                                                if (result) {
                                                                  getClients();
                                                                }
                                                              },
                                                            ),

                                                            //   un icono con una accion para enviarle un correo al empleado
                                                            Tooltip(
                                                              message:
                                                                  'Enviar correo a ${client.email}',
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // función para enviar correo mediante un mailTo en web
                                                                    print(
                                                                        'Envíar correo a ${client.email}');

                                                                    // ...somewhere in your Flutter app...
                                                                    final mailtoLink =
                                                                        Mailto(
                                                                      to: [
                                                                        client
                                                                            .email
                                                                      ],
                                                                      // cc: [
                                                                      //   'cc1@example.com',
                                                                      //   'cc2@example.com'
                                                                      // ],
                                                                      subject:
                                                                          'Planeta Fitness',
                                                                      body: '',
                                                                    );
                                                                    // Convert the Mailto instance into a string.
                                                                    // Use either Dart's string interpolation
                                                                    // or the toString() method.
                                                                    await launch(
                                                                        '$mailtoLink');
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .email_outlined)),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
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
