import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String lot;
  final String slot;
  final int reservedHours;
  final DateTime reservedDate;
  final double totalAmount;
  final String vehicleType;
  final String vehicleNumber;
  final String customerName;
  final String mobile;
  final String paymentMethod;

  const InvoicePage({
    super.key,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.lot,
    required this.slot,
    required this.reservedHours,
    required this.reservedDate,
    required this.totalAmount,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.customerName,
    required this.mobile,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.blue.shade500],
              ),
            ),
          ),
          title: const Text(
            "Make Payment",
            style: TextStyle(color: Colors.white),
          ),
        ),

        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice #$invoiceNumber',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Date: ${invoiceDate.toLocal()}'),
            const SizedBox(height: 20),
            buildInvoiceDetails(),
            const SizedBox(height: 20),
            const Divider(),
            buildTotalAmount(),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reservation Details',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        buildDetailRow('Lot', lot),
        buildDetailRow('Slot', slot),
        buildDetailRow('Reserved Hours', reservedHours.toString()),
        buildDetailRow('Reserved Date', reservedDate.toLocal().toString()),
        buildDetailRow('Vehicle Type', vehicleType),
        buildDetailRow('Vehicle Number', vehicleNumber),
        buildDetailRow('Customer Name', customerName),
        buildDetailRow('Mobile', mobile),
        buildDetailRow('Payment Method', paymentMethod),
      ],
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }


  Widget buildTotalAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Total Amount:',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          '\$$totalAmount',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ],
    );
  }
}
