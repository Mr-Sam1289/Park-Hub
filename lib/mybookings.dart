import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'HomePage.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  MyBookingsPageState createState() => MyBookingsPageState();
}

class MyBookingsPageState extends State<MyBookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
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
          "My Bookings",
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'In Progress'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent('In Progress'),
          _buildTabContent('Upcoming'),
          _buildTabContent('Past'),
        ],
      ),
    );
  }

  Widget _buildTabContent(String tabTitle) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Invoice')
          .doc(_currentUser?.email) // Use the user's email
          .collection('Invoices')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No invoices for $tabTitle'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var invoiceData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return _buildInvoiceCard(invoiceData);
            },
          );
        }
      },
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoiceData) {
    // Customize this card based on your invoice data
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(invoiceData['lotName'] ?? ''),
        subtitle: Text('Invoice Number: ${invoiceData['invoiceNumber']}'),
        // Add more details as needed
      ),
    );
  }
}
