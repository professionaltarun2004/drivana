import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 20),
          Text(
            'Account Settings',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.edit, color: Colors.blue.shade700),
            title: Text('Edit Profile', style: GoogleFonts.poppins()),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              // TODO: Implement edit profile
            },
          ).animate().slideX(begin: -0.2, duration: 600.ms),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.lock, color: Colors.blue.shade700),
            title: Text('Change Password', style: GoogleFonts.poppins()),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              // TODO: Implement change password
            },
          ).animate().slideX(begin: -0.2, duration: 600.ms),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.logout, color: Colors.red.shade700),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(color: Colors.red.shade700),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              // TODO: Implement logout
            },
          ).animate().slideX(begin: -0.2, duration: 600.ms),
          SizedBox(height: 20),
          Text(
            'Recent Activity',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(Icons.car_rental, color: Colors.blue.shade700),
                  title: Text(
                    'Booked Honda Civic',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'Apr 19, 2025',
                    style: GoogleFonts.poppins(color: Colors.grey.shade600),
                  ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(Icons.payment, color: Colors.blue.shade700),
                  title: Text(
                    'Payment Completed',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'Apr 18, 2025',
                    style: GoogleFonts.poppins(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 20),
          Text(
            'Saved Addresses',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(Icons.location_on, color: Colors.blue.shade700),
              title: Text(
                '123 Main St, Hyderabad',
                style: GoogleFonts.poppins(),
              ),
              trailing: Icon(Icons.edit, color: Colors.blue.shade700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                // TODO: Implement edit address
              },
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 20),
          Text(
            'Payment Methods',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  leading: Icon(Icons.payment, color: Colors.blue.shade700),
                  title: Text('UPI', style: GoogleFonts.poppins()),
                  trailing: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    // TODO: Implement UPI selection
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  leading: Icon(Icons.money, color: Colors.blue.shade700),
                  title: Text('Cash', style: GoogleFonts.poppins()),
                  trailing: Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    // TODO: Implement Cash selection
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  leading: Icon(Icons.credit_card, color: Colors.blue.shade700),
                  title: Text('Others', style: GoogleFonts.poppins()),
                  trailing: Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    // TODO: Implement Others selection
                  },
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}
