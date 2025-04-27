import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String selectedAddressType = 'Home';
  bool isDefaultAddress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Address',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Contact Details'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              
              const _SectionTitle('Address'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Street Address',
                hintText: 'Enter your street address',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Apartment/Suite/Unit (Optional)',
                hintText: 'Enter apartment, suite, or unit number',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'City',
                hintText: 'Enter your city',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'State/Province',
                hintText: 'Enter your state or province',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'ZIP/Postal Code',
                hintText: 'Enter ZIP or postal code',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Country',
                hintText: 'Select your country',
                onTap: () {
                  // Show country picker
                },
              ),
              const SizedBox(height: 24),
              
              const _SectionTitle('Address Label'),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildAddressTypeButton(
                    type: 'Home',
                    icon: Icons.home_outlined,
                  ),
                  const SizedBox(width: 12),
                  _buildAddressTypeButton(
                    type: 'Work',
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(width: 12),
                  _buildAddressTypeButton(
                    type: 'Other',
                    icon: Icons.more_horiz,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Default Address Switch
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SwitchListTile(
                  value: isDefaultAddress,
                  onChanged: (value) {
                    setState(() {
                      isDefaultAddress = value;
                    });
                  },
                  title: const Text(
                    'Set as default address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  activeColor: const Color(0xFFBD5D5D),
                ),
              ),
              const SizedBox(height: 24),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save address logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBD5D5D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeButton({
    required String type,
    required IconData icon,
  }) {
    final isSelected = selectedAddressType == type;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedAddressType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFBD5D5D) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xFFBD5D5D) : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBD5D5D)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
} 