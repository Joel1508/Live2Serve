import 'package:flutter/material.dart';

class SavingsScreen extends StatefulWidget {
  @override
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final List<Map<String, dynamic>> _registrosAhorros = [];
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  bool _isAdding = false;

  void _toggleAddContainer() {
    setState(() {
      _isAdding = !_isAdding;
    });
  }

  void _agregarRegistroAhorro() {
    final monto = double.tryParse(_montoController.text);
    final descripcion = _descripcionController.text;

    if (monto != null && descripcion.isNotEmpty) {
      setState(() {
        _registrosAhorros.add({
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

  void _eliminarRegistroAhorro(int index) {
    setState(() {
      _registrosAhorros.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCFCFCF), Color(0xFFFDEDCDD)],
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
                          "Ahorros",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Haz el seguimiento de tus ahorros",
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
                          itemCount: _registrosAhorros.length,
                          itemBuilder: (context, index) {
                            final registro = _registrosAhorros[index];
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
                                        "\$${registro['monto'].toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        registro['descripcion'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        "${registro['fecha'].toLocal().toString().split(' ')[0]}",
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
                                        _eliminarRegistroAhorro(index);
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
                                        backgroundColor: Color(0xFFFB5DAB9)),
                                    onPressed: _agregarRegistroAhorro,
                                    child: Text(
                                      "Añadir",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFFB5DAB9)),
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
        backgroundColor: Color(0xFFF5EBA7D),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
