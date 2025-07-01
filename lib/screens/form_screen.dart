import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matchbest/provider/api.dart';
import '../theme/gradient_background.dart';
import 'item_detail_screen.dart';

class FormScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final String serviceTitle;

  const FormScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.serviceTitle,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final url = Uri.parse('$api/form');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'contact': _contactController.text.trim(),
        'message': _messageController.text.trim(),
        'categoryTitle': widget.categoryTitle,
        'serviceTitle': widget.serviceTitle,
      }),
    );

    setState(() => _isSubmitting = false);

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Your form has been submitted."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(
                      categoryId: widget.categoryId,
                      categoryTitle: widget.categoryTitle,
                      serviceTitle: widget.serviceTitle,
                    ),
                  ),
                );
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Something went wrong. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    required double fontSize,
    Color labelColor = Colors.white, // 🆕 default set to white
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: fontSize * 0.8,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        SizedBox(height: fontSize * 0.4),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: inputType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter $label...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: validator,
          ),
        ),
        SizedBox(height: fontSize * 1.2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.04;

    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Fill form for ${widget.categoryTitle} Sample Work",
            style: const TextStyle(fontSize: 14),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.grey.shade100.withOpacity(0.0),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Card(
            color: Colors.transparent,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Let’s Get in Touch',
                      style: TextStyle(fontSize: fontSize * 1.3, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: fontSize * 0.2),
                    Text(
                      'Please fill the form to proceed further.',
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // 🆕 Label color set to white
                    _buildTextField(
                      label: 'Your Name',
                      controller: _nameController,
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your name' : null,
                      fontSize: fontSize,
                      labelColor: Colors.white,
                    ),
                    _buildTextField(
                      label: 'Your Email',
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      validator: (value) =>
                      value == null || !value.contains('@') ? 'Enter a valid email' : null,
                      fontSize: fontSize,
                      labelColor: Colors.white,
                    ),
                    _buildTextField(
                      label: 'Your Contact No',
                      controller: _contactController,
                      inputType: TextInputType.phone,
                      validator: (value) =>
                      value == null || value.length < 10 ? 'Enter valid phone number' : null,
                      fontSize: fontSize,
                      labelColor: Colors.white,
                    ),
                    _buildTextField(
                      label: 'Your Message',
                      controller: _messageController,
                      maxLines: 4,
                      fontSize: fontSize,
                      labelColor: Colors.white,
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submitForm,
                        icon: const Icon(Icons.send, color: Colors.white,),
                        label: _isSubmitting
                            ? Padding(
                          padding: EdgeInsets.symmetric(vertical: fontSize * 0.3),
                          child: const CircularProgressIndicator(color: Colors.white),
                        )
                            : Text("Submit", style: TextStyle(fontSize: fontSize, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: TextStyle(color: Color(0xFFFF0600), fontSize: fontSize)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
