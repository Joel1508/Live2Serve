import 'package:flutter/material.dart';
import 'date.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class AddTransactionScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onTransactionAdded;

  AddTransactionScreen({this.onTransactionAdded});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isIncome = true; // Toggle between Income and Expense
  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String selectedCategory = "Select Category"; // Default category placeholder
  List<String> categories = []; // Dynamic list based on income/expense type
  DateTime? selectedDate; // Store the selected date
  String? selectedPaymentMethod; // Store the selected payment method
  File? _image; // Store the selected image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEDCDD),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Color(0xFFFCFCFCF), Color(0xFFFDEDCDD)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                  ),
                  Text(
                    "Add Transaction",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.note_add),
                    onPressed: () {
                      // Action for document icon
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Transaction Type Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncome = true; // Toggle to Income
                        categories = [
                          "Sales",
                          "Commissions",
                          "Investments",
                          "Freelance / Side Hustles",
                          "Salaries and bonuses"
                        ];
                        selectedCategory = "Select Category"; // Reset dropdown
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isIncome ? Color(0xFFF8ABC8B) : Color(0xFFFCEDDCA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "INCOME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncome = false; // Toggle to Expense
                        categories = [
                          "Personal Expenses",
                          "Business Expenses",
                          "Transportation",
                          "Healthcare",
                          "Entertainment"
                        ];
                        selectedCategory = "Select Category"; // Reset dropdown
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            !isIncome ? Color(0xFFFF94449) : Color(0xFFFFFCAD0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "EXPENSE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !isIncome ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Amount Input
              Center(
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
              ),
              SizedBox(height: 20),

              // Input Fields
              Expanded(
                child: ListView(
                  children: [
                    _buildInputField(
                      controller: titleController,
                      icon: Icons.title,
                      placeholder: "Title",
                    ),
                    _buildCategorySelector(),
                    _buildDateField(), // Date & Time Field
                    _buildPaymentMethodButton(),
                    // Note
                    _buildInputField(
                      controller: null,
                      icon: Icons.note,
                      placeholder: "Note",
                    ),
                    // slect the image
                    _buildPictureField(),
                  ],
                ),
              ),

              // Add Button
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate and save the transaction
                    bool saved = await _saveTransaction();

                    // If transaction is successfully saved, navigate back
                    if (saved) {
                      Navigator.pop(
                          context); // This will return to the previous screen
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF979DAB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();

  get path => null;

  // Method to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Picture Field
  Widget _buildPictureField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(Icons.add_photo_alternate, color: Colors.black54),
        title: Text(
          _image == null ? "Add Picture" : "Picture Added",
          style: TextStyle(color: Colors.black87),
        ),
        onTap: () async {
          // Show bottom sheet with options to choose from gallery or camera
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Take a Picture"),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text("Select from Gallery"),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Payment Method Selector
  Widget _buildPaymentMethodButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () async {
          // Show dialog to select payment method
          String? selectedMethod = await _showPaymentMethodDialog();
          if (selectedMethod != null) {
            setState(() {
              // Store the selected method
              selectedPaymentMethod = selectedMethod;
            });
          }
        },
        child: Row(
          children: [
            Icon(Icons.attach_money, color: Colors.black54),
            SizedBox(width: 13),
            Text(
              selectedPaymentMethod ?? "Digital/Cash",
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog to choose "Digital" or "Cash"
  Future<String?> _showPaymentMethodDialog() async {
    String? selectedMethod;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Digital'),
                onTap: () {
                  selectedMethod = 'Digital';
                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: Text('Cash'),
                onTap: () {
                  selectedMethod = 'Cash';
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
    return selectedMethod;
  }

  // Category Selector
  Widget _buildCategorySelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        items:
            ["Select Category", ...categories] // Always include the placeholder
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
        style: TextStyle(color: Colors.black), // Ensure visibility
      ),
    );
  }

  // Helper to create input fields
  Widget _buildInputField({
    required TextEditingController? controller,
    required IconData icon,
    required String placeholder,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black54),
          hintText: placeholder,
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Date & Time Field
  Widget _buildDateField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.black54),
        title: Text(
          selectedDate == null
              ? "Date & Time"
              : "${selectedDate!.toLocal()}".split(' ')[0],
          style: TextStyle(color: Colors.black87),
        ),
        onTap: () async {
          DateTime? date = await selectDate(context);
          if (date != null) {
            setState(() {
              selectedDate = date;
            });
          }
        },
      ),
    );
  }

  // function to save the transaction
  Future<bool> _saveTransaction() async {
    if (amountController.text.isEmpty ||
        titleController.text.isEmpty ||
        selectedCategory == "Select Category" ||
        selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return false;
    }

    final supabase = Supabase.instance.client;

    try {
      double amount;
      try {
        String cleanAmount =
            amountController.text.replaceAll('\$', '').replaceAll(',', '');
        amount = double.parse(cleanAmount);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid amount format')),
        );
        return false;
      }

      String sanitizedTitle = titleController.text
          .trim()
          .replaceAll('"', "'")
          .replaceAll('\n', ' ');
      String sanitizedCategory = selectedCategory.trim();
      String sanitizedPaymentMethod =
          (selectedPaymentMethod ?? 'Digital').trim();

      final transaction = {
        'amount': amount,
        'title': sanitizedTitle,
        'category': sanitizedCategory,
        'date': (selectedDate ?? DateTime.now()).toIso8601String(),
        'payment_method': sanitizedPaymentMethod,
        'image_url': _image?.path
      };

      print('Final Transaction Payload:');
      transaction.forEach((key, value) {
        print('$key: $value (${value.runtimeType})');
      });

      final response = await supabase.from('transactions').insert(transaction);

      print('Insertion response: $response');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction added successfully')),
      );

      setState(() {
        amountController.clear();
        titleController.clear();
        selectedCategory = "Select Category";
        selectedDate = null;
        selectedPaymentMethod = null;
        _image = null;
      });

      return true;
    } catch (e, stack) {
      print('Detailed Transaction Insertion Error:');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Full Stack Trace: $stack');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving transaction: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );

      return false;
    }
  }
}

extension on PostgrestFilterBuilder {
  execute() {}
}

extension on String {
  get error => null;

  get data => null;

  void clear() {}
}
