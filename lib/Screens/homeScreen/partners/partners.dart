import 'package:flutter/material.dart';
import 'package:app/Screens/homeScreen/partners/add_partner.dart';

class PartnersScreen extends StatefulWidget {
  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  List<Map<String, dynamic>> partnersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDCDD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Top Section: Back button, title, and add partner icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Partners',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  onPressed: () async {
                    final newPartner = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPartnerScreen(),
                      ),
                    );

                    if (newPartner != null) {
                      setState(() {
                        partnersList.add(newPartner);
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: partnersList.length,
                  itemBuilder: (context, index) {
                    return _buildPartnerRow(partnersList[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerRow(Map<String, dynamic> partner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.grey, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showPartnerDetails(partner);
                },
                child: Text(
                  partner['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {
                _showEditDeleteMenu(partner);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDeleteMenu(Map<String, dynamic> partner) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editPartner(partner);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deletePartner(partner);
              },
            ),
          ],
        );
      },
    );
  }

  void _editPartner(Map<String, dynamic> partner) async {
    final updatedPartner = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPartnerScreen(initialData: partner),
      ),
    );

    if (updatedPartner != null) {
      setState(() {
        final index = partnersList.indexOf(partner);
        partnersList[index] = updatedPartner;
      });
    }
  }

  void _deletePartner(Map<String, dynamic> partner) {
    setState(() {
      partnersList.remove(partner);
    });
  }

  void _showPartnerDetails(Map<String, dynamic> partner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(partner['name']),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                if (partner['description'] != null &&
                    partner['description'].isNotEmpty)
                  Text('Description: ${partner['description']}'),
                // Conditionally display the selected files, if available
                if (partner['files'] != null && partner['files'].isNotEmpty)
                  Text('Files: ${partner['files'].join(', ')}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
