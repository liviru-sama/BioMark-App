import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),

            // Profile Card
            _buildCard(
              context: context,
              icon: Icons.person_outline,
              label: 'View Profile',
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              color: Colors.blue,
            ),

            SizedBox(height: 20),

            // Change Password Card
            _buildCard(
              context: context,
              icon: Icons.lock_outline,
              label: 'Change Password',
              onPressed: () => Navigator.pushNamed(context, '/passwordChange'),
              color: Colors.orange,
            ),

            SizedBox(height: 20),

            // Edit Details Card
            _buildCard(
              context: context,
              icon: Icons.edit_outlined,
              label: 'Edit Details',
              onPressed: () => Navigator.pushNamed(context, '/editDetails'),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 30, color: color),
              ),
              SizedBox(width: 20),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
