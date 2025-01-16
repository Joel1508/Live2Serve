import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AddPartnerScreen extends StatefulWidget {
  final Map<String, dynamic>? existingPartner;

  const AddPartnerScreen({Key? key, this.existingPartner}) : super(key: key);

  @override
  State<AddPartnerScreen> createState() => _AddPartnerScreenState();
}

class _AddPartnerScreenState extends State<AddPartnerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> selectedFiles = [];
  bool isLoading = false;
  late Box _partnersBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
    _initializeFields();
    _initializeConnectivityListener();
  }

  // Initialize Hive
  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    _partnersBox = await Hive.openBox('partnersBox',
        encryptionCipher: _getEncryptionCipher());
  }

  // Get encryption cipher for Hive (Optional)
  HiveAesCipher _getEncryptionCipher() {
    final key = sha256
        .convert(utf8.encode('your-secure-password'))
        .bytes
        .sublist(0, 32);
    return HiveAesCipher(key);
  }

  void _initializeFields() {
    if (widget.existingPartner != null) {
      nameController.text = widget.existingPartner!['name'] ?? '';
      descriptionController.text = widget.existingPartner!['description'] ?? '';
      selectedFiles = List<String>.from(widget.existingPartner!['files'] ?? []);
    }
  }

  void _initializeConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _syncUnsentPartners();
      }
    });
  }

  Future<void> _syncUnsentPartners() async {
    // Implement synchronization logic for unsynced partners.
    print('Syncing unsent partners...');
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.paths.whereType<String>());
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        selectedFiles.add(pickedImage.path);
      });
    }
  }

  void addPartner() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final partner = {
        'name': name,
        'description': description,
        'files': selectedFiles,
        'isSynced': false,
      };

      await _savePartner(partner);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Partner "$name" added successfully! Sync pending.')),
      );
      Navigator.pop(context, partner);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add partner: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save partner to Hive
  Future<void> _savePartner(Map<String, dynamic> partner) async {
    await _partnersBox.add(partner);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF9FAFB),
      appBar: AppBar(
        title: const Text('Add Partner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(nameController, 'Partner Name'),
            const SizedBox(height: 16),
            _buildTextField(descriptionController, 'Description', maxLines: 3),
            const SizedBox(height: 16),
            _buildFilePicker(),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: addPartner,
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Attach Files',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo),
              label: const Text('Gallery'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: pickFiles,
              icon: const Icon(Icons.attach_file),
              label: const Text('Files'),
            ),
          ],
        ),
      ],
    );
  }
}
