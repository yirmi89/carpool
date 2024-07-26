import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color carColor = Color(0xFF333F48); // Dark Gray
    const Color textColor = Color(0xFF263A6D); // Text Color

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Update Your Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(
              context,
              icon: Icons.person,
              hintText: 'First Name',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.person,
              hintText: 'Last Name',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.email,
              hintText: 'Email',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.child_care,
              hintText: 'Number of Children',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.calendar_today,
              hintText: 'Days Available',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.school,
              hintText: 'Place of Destination',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.home,
              hintText: 'Place of Residence',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.directions_car,
              hintText: 'Vehicle Information',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.contact_phone,
              hintText: 'Emergency Contact',
              iconColor: carColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              icon: Icons.access_time,
              hintText: 'Preferred Driving Times',
              iconColor: carColor,
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement save functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: carColor,
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required IconData icon, required String hintText, bool obscureText = false, required Color iconColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(icon, color: iconColor, size: 32),
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color(0x99BEBEBE),
            ),
            contentPadding: const EdgeInsets.only(left: 50),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFBEBEBE), width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4A73DA), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
