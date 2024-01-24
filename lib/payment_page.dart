import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smartparkin1/invoice.dart';
import 'package:upi_india/upi_india.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
      amount: 1,
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

  Widget _buildTransactionDetailsView() {
    return Expanded(
      child: FutureBuilder(
        future: _transaction,
        builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  _upiErrorHandler(snapshot.error.runtimeType),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
            UpiResponse upiResponse = snapshot.data!;
            String txnId = upiResponse.transactionId ?? "N/A";
            String resCode = upiResponse.responseCode ?? "N/A";
            String txnRef = upiResponse.transactionRefId ?? "N/A";
            String status = upiResponse.status ?? "N/A";
            String approvalRef = upiResponse.approvalRefNo ?? "N/A";
            _checkTxnStatus(status);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _displayTransactionData("Transaction Id", txnId),
                  _displayTransactionData("Response Code", resCode),
                  _displayTransactionData("Reference Id", txnRef),
                  _displayTransactionData("Status", status.toUpperCase()),
                  _displayTransactionData("Approval No", approvalRef),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(""),
            );
          }
        },
      ),
    );
  }

  Widget _buildInvoiceButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the Invoice screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoicePage(
              invoiceNumber: '12345',
              invoiceDate: DateTime.now(),
              lot: 'A',
              slot: 'B',
              reservedHours: 2,
              reservedDate: DateTime.now().add(const Duration(days: 1)),
              totalAmount: 180.0,
              vehicleType: 'Car',
              vehicleNumber: 'ABC123',
              customerName: 'John Doe',
              mobile: '123-456-7890',
              paymentMethod: 'Credit Card',
            ),
          ),
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
      body: Column(
        children: <Widget>[
          _buildUpiAppsGridView(),
          _buildTransactionDetailsView(),
          _buildInvoiceButton(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException _:
        return 'Requested app not installed on the device';
      case UpiIndiaUserCancelledException _:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException _:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException _:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        logger.i("Transaction Successful");
        break;
      case UpiPaymentStatus.SUBMITTED:
        logger.i("Transaction Submitted");
        break;
      case UpiPaymentStatus.FAILURE:
        logger.i("Transaction Failed");
        break;
      default:
        logger.i("Received an unknown transaction status");
    }
  }

  Widget _displayTransactionData(String title, String body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            body,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
