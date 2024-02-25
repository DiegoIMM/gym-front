import 'package:flutter/material.dart';
import 'package:gym_front/models/client.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/api_service.dart';
import 'client_form.dart';

class ClientsDataSource extends DataTableSource {
  final List<Client> clients;
  final BuildContext context;

  ClientsDataSource({required this.clients, required this.context});

  static var apiService = ApiService();

  @override
  DataRow getRow(int index) {
    var client = clients[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
            Text(client.numberClient.toString() ?? 'Sin número de cliente')),
        DataCell(Text(client.rut ?? 'Sin RUT')),
        DataCell(Text(client.name ?? 'Sin nombre')),
        DataCell(Text(client.phone ?? 'Sin teléfono')),
        DataCell(Text(client.plan != null ? client.plan!.name : 'Sin plan')),
        DataCell(client.expiredAt != null
            ? Tooltip(
                // mostrar cuanto falta para expirar en lenguaje humano
                message: client.timeToExpire,
                child: Text(
                  client.expiredAt.toString().substring(0, 10),
                  style: TextStyle(
                      //Si esta expirado, mostrar en rojo, si le falta menos de 15 dias en naranjo, y si no en verde
                      color: client.color),
                ),
              )
            : const Text('Sin plan')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar',
                onPressed: () async {
                  var result = await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ClientForm(client: client);
                    },
                  );
                  if (result) {
                    getClients();
                  }
                },
              ),

              //   un icono con una accion para enviarle un correo al empleado
              client.email != null
                  ? Tooltip(
                      message: 'Enviar correo a ${client.email}',
                      child: IconButton(
                          onPressed: () async {
                            // función para enviar correo mediante un mailTo en web
                            print('Envíar correo a ${client.email}');

                            // ...somewhere in your Flutter app...
                            final mailtoLink = Mailto(
                              to: [client.email!],
                              // cc: [
                              //   'cc1@example.com',
                              //   'cc2@example.com'
                              // ],
                              subject: 'Planeta Fitness',
                              body: '',
                            );
                            // Convert the Mailto instance into a string.
                            // Use either Dart's string interpolation
                            // or the toString() method.
                            await launch('$mailtoLink');
                          },
                          icon: const Icon(Icons.email_outlined)),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  void getClients() {
    apiService.getClientsByEnterprise().then((value) {
      clients.clear();
      clients.addAll(value);
    });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clients.length;

  @override
  int get selectedRowCount => 0;
}
