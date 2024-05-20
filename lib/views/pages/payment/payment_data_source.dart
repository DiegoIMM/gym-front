import 'package:flutter/material.dart';
import 'package:gym_front/models/payment.dart';

import '../../../services/api_service.dart';

class PaymentsDataSource extends DataTableSource {
  final List<Payment> payments;
  final BuildContext context;

  PaymentsDataSource({required this.payments, required this.context});

  static var apiService = ApiService();

  @override
  DataRow getRow(int index) {
    var payment = payments[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
            Text(payment.getFormattedDate())),
        DataCell(Text(payment.client.name ?? 'Sin cliente')),
        DataCell(Text(payment.plan.name)),
        DataCell(Text(payment.getFormattedExpiredAt())),
        DataCell(Text(payment.getFormattedPrice())),

      ],
    );
  }

  void getPayments() {
    apiService.getAllActivePayments().then((value) {
      payments.clear();
      payments.addAll(value);
    });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => payments.length;

  @override
  int get selectedRowCount => 0;
}
