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
    // Handle empty input
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove any non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Convert to double and format with commas and two decimal places
    double value = double.parse(newText) / 100;
    String formattedValue = NumberFormat('#,##0.00', 'en_US').format(value);

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

  String selectedCategory = "Select Category";
  List<String> incomeCategories = [
    "Select Category",
    "Sales",
    "Commissions",
    "Investments",
    "Freelance",
    "Salaries and Bonuses"
  ];
  List<String> expenseCategories = [
    "Select Category",
    "Personal Expenses",
    "Business Expenses",
    "Transportation",
    "Healthcare",
    "Entertainment"
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
          balanceBox.get('current') ?? Balance(currentBalance: 0.0);

      final transactionAmount =
          double.parse(amountController.text.replaceAll(',', ''));

      // Update balance
      balance.currentBalance +=
          isIncome ? transactionAmount : -transactionAmount;

      // Add to balance history
      balance.history.add(BalanceHistory(
        date: DateTime.now(),
        amount: isIncome ? transactionAmount : -transactionAmount,
      ));

      final transaction = Transaction(
        amount: transactionAmount,
        title: titleController.text,
        category: selectedCategory,
        date: selectedDate ?? DateTime.now(),
        paymentMethod: selectedPaymentMethod ?? 'Digital',
        isIncome: isIncome,
        imageUrl: selectedImage?.path,
        note: noteController.text,
      );

      // Save updated balance and transaction
      await balanceBox.put('current', balance);
      await transactionBox.add(transaction);

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
        SnackBar(content: Text('Please enter an amount')),
      );
      return false;
    }
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title')),
      );
      return false;
    }
    if (selectedCategory == "Select Category") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
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
      selectedCategory = "Select Category";
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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Add Transaction",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 50), // Spacer
                  ],
                ),

                // Transaction Type Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTypeToggleButton('INCOME', true),
                    SizedBox(width: 10),
                    _buildTypeToggleButton('EXPENSE', false),
                  ],
                ),

                SizedBox(height: 20),

                // Amount Input
                _buildAmountInput(),

                SizedBox(height: 20),

                // Title Imput
                _buildTitleInput(),

                // Category Dropdown
                _buildCategoryDropdown(),

                // Date Picker
                _buildDatePicker(),

                // Payment Method
                _buildPaymentMethodPicker(),

                // Note Input
                _buildNoteInput(),

                // Image Picker
                _buildImagePicker(),

                // Add Transaction Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _saveTransaction,
                    child: Text(
                      'Add Transaction',
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
          hintText: 'Enter Transaction Title',
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
          selectedCategory = "Select Category";
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
            hintText: "+ \$0.00",
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
              ? "Select Date"
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
              selectedDate = pickedDate;
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
          selectedPaymentMethod ?? "Select Payment Method",
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text('Select Payment Method'),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      selectedPaymentMethod = 'Cash';
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Cash'),
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
          hintText: 'Add a note (Optional)',
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
          selectedImage == null ? "Add Image (optional)" : "Image Selected",
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
                  title: Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from Gallery'),
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
