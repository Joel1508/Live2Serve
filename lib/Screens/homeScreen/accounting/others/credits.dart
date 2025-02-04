import 'package:flutter/material.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  final List<Map<String, dynamic>> _creditRecords = [];
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  bool _isAdding = false;

  void _toggleAddContainer() {
    setState(() {
      _isAdding = !_isAdding;
    });
  }

  void _addCreditRecord() {
    final monto = double.tryParse(_montoController.text);
    final descripcion = _descripcionController.text;

    if (monto != null && descripcion.isNotEmpty) {
      setState(() {
        _creditRecords.add({
          'monto': monto,
          'descripcion': descripcion,
          'fecha': DateTime.now(),
        });
        _montoController.clear();
        _descripcionController.clear();
        _isAdding = false;
      });
    }
  }

  void _deleteCreditRecord(int index) {
    setState(() {
      _creditRecords.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4A5A5), Color(0xFFFF9FAFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child:
                          Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                    Column(
                      children: [
                        Text(
                          "Créditos",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Haz el seguimiento de tus deudas",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(width: 28),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _creditRecords.length,
                          itemBuilder: (context, index) {
                            final record = _creditRecords[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "-\$${record['monto'].toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      Text(
                                        record['descripcion'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        "${record['fecha'].toLocal().toString().split(' ')[0]}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == 'borrar') {
                                        _deleteCreditRecord(index);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'borrar',
                                        child: Text("Borrar"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (_isAdding)
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _montoController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: "Monto (\$)"),
                              ),
                              TextField(
                                controller: _descripcionController,
                                decoration:
                                    InputDecoration(labelText: "Descripción"),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFF4A5A5)),
                                    onPressed: _addCreditRecord,
                                    child: Text(
                                      "Añadir",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFF4A5A5)),
                                    onPressed: _toggleAddContainer,
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAddContainer,
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
