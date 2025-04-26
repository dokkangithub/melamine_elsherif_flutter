import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:melamine_elsherif/domain/entities/address.dart';
import 'package:melamine_elsherif/presentation/viewmodels/checkout/checkout_view_model.dart';
import 'package:melamine_elsherif/presentation/widgets/custom_button.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _aptController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  String? _selectedCountry;
  
  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _aptController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSavedAddresses() async {
    await Provider.of<CheckoutViewModel>(context, listen: false).getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CheckoutViewModel>(
        builder: (context, checkoutViewModel, _) {
          return Column(
            children: [
              // Checkout steps indicator
              _buildCheckoutSteps(1),
              
              // Addresses
              Expanded(
                child: checkoutViewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saved Addresses',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Saved addresses
                            _buildSavedAddresses(checkoutViewModel),
                            
                            const SizedBox(height: 24),
                            const Text(
                              'Add New Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // New address form
                            _buildAddressForm(),
                          ],
                        ),
                      ),
              ),
              
              // Order summary
              _buildOrderSummary(checkoutViewModel),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildCheckoutSteps(int currentStep) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          _buildStepCircle(1, 'Shipping', currentStep >= 1),
          _buildStepDivider(),
          _buildStepCircle(2, 'Delivery', currentStep >= 2),
          _buildStepDivider(),
          _buildStepCircle(3, 'Payment', currentStep >= 3),
        ],
      ),
    );
  }
  
  Widget _buildStepCircle(int step, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Theme.of(context).primaryColor : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepDivider() {
    return Container(
      height: 1,
      width: 40,
      color: Colors.grey[300],
    );
  }
  
  Widget _buildSavedAddresses(CheckoutViewModel viewModel) {
    final addresses = viewModel.addresses;
    
    if (addresses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No saved addresses. Please add a new address.'),
      );
    }
    
    return Column(
      children: addresses.map((address) {
        final isSelected = address.id == viewModel.selectedAddressId;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              children: [
                Text(
                  address.addressType ?? 'Address',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (address.isDefault == true)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${address.firstName} ${address.lastName}'),
                Text(address.address1 ?? ''),
                if (address.address2 != null) Text(address.address2!),
                Text('${address.city}, ${address.province ?? ''} ${address.postalCode ?? ''}'),
                Text(address.country ?? ''),
                if (address.phone != null) Text(address.phone!),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // Navigate to edit address screen
              },
            ),
            onTap: () {
              viewModel.selectAddress(address.id!);
            },
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildAddressForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Full name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Phone number
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Street address
          TextFormField(
            controller: _streetController,
            decoration: const InputDecoration(
              labelText: 'Street Address',
              hintText: 'Enter your street address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your street address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Apartment, suite, etc.
          TextFormField(
            controller: _aptController,
            decoration: const InputDecoration(
              labelText: 'Apartment/Suite/Unit (Optional)',
              hintText: 'Enter apartment, suite, or unit number',
            ),
          ),
          const SizedBox(height: 16),
          
          // City
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'Enter your city',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // State/Province
          TextFormField(
            controller: _stateController,
            decoration: const InputDecoration(
              labelText: 'State/Province',
              hintText: 'Enter your state or province',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your state or province';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // ZIP/Postal Code
          TextFormField(
            controller: _zipController,
            decoration: const InputDecoration(
              labelText: 'ZIP/Postal Code',
              hintText: 'Enter your ZIP or postal code',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your ZIP or postal code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Country
          DropdownButtonFormField<String>(
            value: _selectedCountry,
            decoration: const InputDecoration(
              labelText: 'Country',
              hintText: 'Select your country',
            ),
            items: const [
              DropdownMenuItem(value: 'US', child: Text('United States')),
              DropdownMenuItem(value: 'CA', child: Text('Canada')),
              DropdownMenuItem(value: 'UK', child: Text('United Kingdom')),
              DropdownMenuItem(value: 'AU', child: Text('Australia')),
              // Add more countries as needed
            ],
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your country';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Address label
          const Text(
            'Address Label',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          // Address type buttons
          Row(
            children: [
              _buildAddressTypeButton('Home', Icons.home, true),
              const SizedBox(width: 12),
              _buildAddressTypeButton('Work', Icons.business, false),
              const SizedBox(width: 12),
              _buildAddressTypeButton('Other', Icons.more_horiz, false),
            ],
          ),
          const SizedBox(height: 16),
          
          // Set as default checkbox
          Row(
            children: [
              Checkbox(
                value: false,
                onChanged: (value) {
                  // Set as default
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              const Text('Set as default address'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Save button
          CustomButton(
            text: 'Save Address',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save new address
                final viewModel = Provider.of<CheckoutViewModel>(context, listen: false);
                
                final newAddress = Address(
                  id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a temporary ID
                  customerId: 'current-user-id', // TODO: Get from auth service
                  firstName: _nameController.text.split(' ').first,
                  lastName: _nameController.text.split(' ').last,
                  phone: _phoneController.text,
                  address1: _streetController.text,
                  address2: _aptController.text.isNotEmpty ? _aptController.text : null,
                  city: _cityController.text,
                  province: _stateController.text.isNotEmpty ? _stateController.text : null,
                  postalCode: _zipController.text.isNotEmpty ? _zipController.text : null,
                  country: _selectedCountry ?? 'Egypt', // Default to Egypt if null
                  addressType: 'Home', // TODO: Use selected type
                  isDefault: false, // TODO: Use selected default
                );
                
                viewModel.addAddress(newAddress);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildAddressTypeButton(String label, IconData icon, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // Select this type
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildOrderSummary(CheckoutViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${viewModel.cart?.total?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Proceed to Delivery',
            onPressed: viewModel.selectedAddressId != null
                ? () {
                    // Navigate to delivery options screen
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const DeliveryOptionsScreen()));
                  }
                : () {},
          ),
        ],
      ),
    );
  }
} 