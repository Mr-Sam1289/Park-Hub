import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';
import 'invoice.dart';
import 'slot.dart';
import 'package:upi_india/upi_india.dart';

class PaymentScreen extends StatefulWidget {
  final double amountToPay;
  final String lotName;
  final DateTime reserved;
  final int hours;
  final String selectedVehicleType;
  final String selectedVehicleNumber;
  final String slot;
  final String lotId;
  const PaymentScreen({super.key,required this.amountToPay,required this.lotName,required this.reserved,required this.hours, required this.selectedVehicleType,required this.selectedVehicleNumber,required this.slot,required this.lotId});

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {

  final Logger logger = Logger();
  final UpiIndia _upiIndia = UpiIndia();
  Future<UpiResponse>? _transaction;
  List<UpiApp>? apps;

  @override
  void initState() {
    super.initState();
    _initiateUpiAppsFetch();
    _transaction = null; // Initialize _transaction here
  }

  void _initiateUpiAppsFetch() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      logger.i("Error fetching UPI apps: $e");
      apps = [];
    });
  }

  Future<UpiResponse> _initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "8106344345@ibl",
      receiverName: "M ABHISHEK",
      transactionRefId: "Park_Hub",
      transactionNote: "Parking amount",
      amount: widget.amountToPay,
    );
  }

  Widget _buildUpiAppsGridView() {
    return Expanded(
      child: apps != null
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: apps!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _transaction = _initiateTransaction(apps![index]);
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.memory(
                    apps![index].icon,
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    apps![index].name,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }



  Widget _buildInvoiceButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the Invoice screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InvoicePage(
              lot: widget.lotName,
              slot: widget.slot,
              reservedHours: widget.hours,
              reservedDate: widget.reserved,
              totalAmount: widget.amountToPay,
              vehicleType: widget.selectedVehicleType,
              vehicleNumber: widget.selectedVehicleNumber,
              lotId: widget.lotId,
          )
        )
        );
        },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text('Invoice'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SelectSlotPage(
                    lotName: '',
                    reserved: DateTime(2004),
                    hours: 0,
                    selectedVehicleType: '',
                    selectedVehicleNumber: '',
                    amountToPass: 0.0,
                  lotId: '',
                ),
              ),
            );
          },
          icon: const Icon(Ionicons.chevron_back_outline,color: Colors.white,),
        ),
        leadingWidth: 80,
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
          "Payments",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildUpiAppsGridView(),
          _buildInvoiceButton(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }



}
