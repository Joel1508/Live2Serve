import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddPartnerScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const AddPartnerScreen({Key? key, this.initialData}) : super(key: key);

  @override
  State<AddPartnerScreen> createState() => _AddPartnerScreenState();
}

class _AddPartnerScreenState extends State<AddPartnerScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  List<String> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from initialData or empty strings
    nameController = TextEditingController(
      text: widget.initialData?['name'] ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.initialData?['description'] ?? '',
    );
    selectedFiles = widget.initialData?['files']?.cast<String>() ?? [];
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

  void cancel() {
    Navigator.pop(context);
  }

  void addPartner() {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      // Handle saving data logic here
      Navigator.pop(context, {
        'name': name,
        'description': description,
        'files': selectedFiles,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDCDD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDCDD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: cancel,
        ),
        centerTitle: true,
        title: const Text(
          'Add Partner',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Partner Name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Color(0xFFFD8D0BD)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Color(0xFFFD8D0BD)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Attach Files',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt, color: Colors.black),
                  label: const Text('Camera',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEAEDE6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo, color: Colors.black),
                  label: const Text('Gallery',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEAEDE6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: pickFiles,
                  icon: const Icon(Icons.attach_file, color: Colors.black),
                  label: const Text('Files',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEAEDE6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: selectedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.file_present),
                    title: Text(selectedFiles[index].split('/').last),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: cancel,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFD8D0BD)),
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: addPartner,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFD8D0BD)),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
