import 'package:FRES.CO/Screens/homeScreen/accounting/models/balance_model.dart';
import 'package:FRES.CO/Screens/homeScreen/accounting/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class _NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Manejar entrada vacía
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Eliminar caracteres no numéricos
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Evitar errores al parsear valores vacíos
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Convertir a entero
    int value = int.parse(newText);

    // Formatear con separadores de miles (sin decimales)
    String formattedValue = NumberFormat('#,##0', 'es_CO').format(value);

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class AddTransactionScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onTransactionAdded;

  AddTransactionScreen({this.onTransactionAdded});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isIncome = true;
  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String selectedCategory = "Seleccionar categoría";
  List<String> incomeCategories = [
    "Seleccionar categoría",
    "Ventas",
    "Comisiones",
    "Inversiones",
    "Freelance",
    "Salario y bonos"
  ];
  List<String> expenseCategories = [
    "Seleccionar categoría",
    "Gastos personales",
    "Gastos empresa",
    "Transporte",
    "Salud",
    "Entretenimiento"
  ];

  DateTime? selectedDate;
  String? selectedPaymentMethod;
  File? selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_validateInputs()) return;

    try {
      // Ensure boxes are open
      if (!Hive.isBoxOpen('transactions')) {
        await Hive.openBox<Transaction>('transactions');
      }

      if (!Hive.isBoxOpen('balance')) {
        await Hive.openBox<Balance>('balance');
      }

      final transactionBox = Hive.box<Transaction>('transactions');
      final balanceBox = Hive.box<Balance>('balance');

      // Get or create balance
      Balance balance =
          balanceBox.get('actual') ?? Balance(currentBalance: 0.0, history: []);

      final transactionAmount =
          double.parse(amountController.text.replaceAll(',', ''));

      // Crear un nuevo balance en lugar de modificar el existente
      Balance updatedBalance = Balance(
        currentBalance: balance.currentBalance +
            (isIncome ? transactionAmount : -transactionAmount),
        history: List.from(balance.history)
          ..add(BalanceHistory(
            date: DateTime.now(),
            amount: isIncome ? transactionAmount : -transactionAmount,
          )),
      );

      // Save updated balance and transaction
      await balanceBox.put('actual', updatedBalance); // Guardar correctamente
      await transactionBox.add(Transaction(
        amount: transactionAmount,
        title: titleController.text,
        category: selectedCategory,
        date: selectedDate ?? DateTime.now(),
        paymentMethod: selectedPaymentMethod ?? 'Digital',
        isIncome: isIncome,
        imageUrl: selectedImage?.path,
        note: noteController.text,
      ));

      _showSuccessMessage('Transaction saved successfully');
      _resetForm();
    } catch (e) {
      print('Transaction save error: $e');
      _showErrorMessage('Error saving transaction: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _validateInputs() {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese un monto')),
      );
      return false;
    }
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese un título')),
      );
      return false;
    }
    if (selectedCategory == "Seleccionar categoría") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, seleccione una categoría')),
      );
      return false;
    }
    return true;
  }

  void _resetForm() {
    setState(() {
      amountController.clear();
      titleController.clear();
      noteController.clear();
      selectedCategory = "Seleccionar categoría";
      selectedDate = null;
      selectedPaymentMethod = null;
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Color(0xFFFCFCFCF), Color(0xFFFF9FAFB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Añadir transacción",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTypeToggleButton('INGRESO', true),
                    SizedBox(width: 10),
                    _buildTypeToggleButton('GASTO', false),
                  ],
                ),
                SizedBox(height: 20),
                _buildAmountInput(),
                SizedBox(height: 20),
                _buildTitleInput(),
                _buildCategoryDropdown(),
                _buildDatePicker(),
                _buildPaymentMethodPicker(),
                _buildNoteInput(),
                _buildImagePicker(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _saveTransaction,
                    child: Text(
                      'Añadir transacción',
                      style: TextStyle(color: Colors.black87),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFB5DAB9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: titleController,
        decoration: InputDecoration(
          hintText: 'Título',
          prefixIcon: Icon(Icons.title, color: Colors.black54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTypeToggleButton(String label, bool type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isIncome = type;
          selectedCategory = "Seleccionar categoría";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isIncome == type
              ? (type ? Color(0xFFF8ABC8B) : Color(0xFFFF94449))
              : (type ? Color(0xFFFFFCAD0) : Color(0xFFFFFCAD0)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome == type ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _NumberFormatter(),
          ],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "\$0.00",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        items: (isIncome ? incomeCategories : expenseCategories)
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value!;
          });
        },
        decoration: InputDecoration(
          icon: Icon(Icons.category, color: Colors.black54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.black54),
        title: Text(
          selectedDate == null
              ? "Seleccionar fecha"
              : "${selectedDate!.toLocal()}".split(' ')[0],
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );

          if (pickedDate != null) {
            setState(() {
              selectedDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second,
              );
            });
          }
        },
      ),
    );
  }

  Widget _buildPaymentMethodPicker() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(Icons.payment, color: Colors.black54),
        title: Text(
          selectedPaymentMethod ?? "Seleccionar método de pago",
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text('Seleccionar método de pago'),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      selectedPaymentMethod = 'Efectivo';
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Efectivo'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      selectedPaymentMethod = 'Digital';
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Digital'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: noteController,
        decoration: InputDecoration(
          hintText: 'Añadir una nota (Opcional)',
          prefixIcon: Icon(Icons.note, color: Colors.black54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(Icons.image, color: Colors.black54),
        title: Text(
          selectedImage == null
              ? "Añadir imagen (Opcional)"
              : "Imagen seleccionada",
        ),
        trailing: selectedImage != null
            ? Image.file(selectedImage!, width: 50, height: 50)
            : null,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Tomar foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Escoger de la galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
