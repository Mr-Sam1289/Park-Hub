import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';
import 'package:logger/logger.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var logger = Logger();

  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  @override
  void initState(){
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value){
      setState(() {
        apps = value;
      });
    }).catchError((e){
      logger.i("Error fetching UPI apps: $e");
      apps = [];
    });
    super.initState();
  }

Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
        app: app,
        receiverUpiId: "8106344345@ibl",
        receiverName: "M ABHISHEK",
        transactionRefId: "Park_Hub",
      transactionNote: "Parking amount",
      amount: 1000,
    );
}

Widget displayUpiApps() {
  if (apps == null) {
    return const Center(child: CircularProgressIndicator());
  }
  else if (apps!.isEmpty) {
    return Center(
      child: Text(
        "No Apps found to handle transaction.",
        style: header,
      ),
    );
  }
  else {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Wrap(
          children: apps!.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                _transaction = initiateTransaction(app);
                setState(() {});
              },
              child: SizedBox(
                height: 150,
                width: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 100,
                      width: 100,
                    ),
                    Text(app.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException _:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException _:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException _:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException _:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status){
    switch(status){
      case UpiPaymentStatus.SUCCESS: logger.i("Transaction Successful");
      break;
      case UpiPaymentStatus.SUBMITTED: logger.i("Transaction Submitted");
      break;
      case UpiPaymentStatus.FAILURE: logger.i("Transaction Failed");
      break;
      default:logger.i("Received an unknown transaction status");
    }
  }

  Widget displayTransactionData(title,body){
    return Padding(
        padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title: ",style: header),
        Flexible(
            child:Text(
              body,
              style: value,
            )
        ),
      ],
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("Payments",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: displayUpiApps()),
          Expanded(
              child:FutureBuilder(
                future: _transaction,
                builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot){


                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }


                  if (snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return Center(
                        child: Text(
                          _upiErrorHandler(snapshot.error.runtimeType),
                          style: header,
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
                        padding:const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          displayTransactionData("Transaction Id",txnId),
                          displayTransactionData("Response Code",resCode),
                          displayTransactionData("Reference Id",txnRef),
                          displayTransactionData("Status",status.toUpperCase()),
                          displayTransactionData("Approval No",approvalRef),
                        ],
                      ),
                    );
                  }
                  else{
                    return const Center(
                      child: Text(""),
                    );
                  }
                },
              ))
        ],
      ),
    );
  }
}
