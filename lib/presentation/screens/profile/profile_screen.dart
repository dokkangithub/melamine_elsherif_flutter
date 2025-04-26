import 'package:flutter/material.dart';
import 'package:melamine_elsherif/presentation/screens/auth/login_screen.dart';
import 'package:melamine_elsherif/presentation/widgets/custom_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with user info
          SliverToBoxAdapter(
            child: _buildProfileHeader(context),
          ),
          // User statistics
          SliverToBoxAdapter(
            child: _buildProfileStats(),
          ),
          // Quick actions
          SliverToBoxAdapter(
            child: _buildQuickActions(context),
          ),
          // Menu options
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildMenuItem(
                  context,
                  icon: Icons.person,
                  title: 'Personal Information',
                  onTap: () {
                    // Navigate to personal info screen
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    // Navigate to notifications screen
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.security,
                  title: 'Privacy & Security',
                  onTap: () {
                    // Navigate to privacy & security screen
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.language,
                  title: 'Language & Region',
                  onTap: () {
                    // Navigate to language & region screen
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    // Navigate to help & support screen
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () {
                    // Navigate to about us screen
                  },
                ),
                const SizedBox(height: 20),
                _buildSignOutButton(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Avatar
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile_avatar.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'John Smith',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'john.smith@email.com',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              // Navigate to edit profile screen
              Navigator.pushNamed(context, '/profile/edit');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xBD5D5D)),
              foregroundColor: const Color(0xBD5D5D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(count: 12, label: 'Orders'),
          _buildDivider(),
          _buildStatItem(count: 24, label: 'Saved'),
          _buildDivider(),
          _buildStatItem(count: 2145, label: 'Points'),
          _buildDivider(),
          _buildStatItem(count: 8, label: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildStatItem({required int count, required String label}) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xBD5D5D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionItem(
            context,
            icon: Icons.shopping_bag,
            label: 'My Orders',
            onTap: () {
              // Navigate to orders screen
              Navigator.pushNamed(context, '/orders');
            },
          ),
          _buildQuickActionItem(
            context,
            icon: Icons.location_on,
            label: 'Shipping Address',
            onTap: () {
              // Navigate to addresses screen
              Navigator.pushNamed(context, '/addresses');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xBD5D5D),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          // Show custom confirmation dialog
          CustomDialog.show(
            context: context,
            title: 'Sign Out',
            message: 'Are you sure you want to sign out?',
            icon: Icon(
              Icons.logout,
              color: Colors.red[400],
              size: 70,
            ),
            actions: [
              CustomDialogAction(
                label: 'Cancel',
                onPressed: () {
                  // Dialog is automatically dismissed
                },
              ),
              CustomDialogAction(
                label: 'Sign Out',
                isPrimary: true,
                onPressed: () {
                  // Perform sign out
                  // Navigate to login screen and clear all routes
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red[400],
          elevation: 0,
          side: BorderSide(color: Colors.red[400]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: const Icon(Icons.exit_to_app),
        label: const Text('Sign Out'),
      ),
    );
  }
} 