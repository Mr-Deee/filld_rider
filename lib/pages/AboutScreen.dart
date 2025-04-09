import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, size: 60, color: Colors.white70),
              const SizedBox(height: 20),
              Text(
                'Our Mission, Vision & Core Values',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'We aim to become the industry leader in the LPG Gas Delivery in Ghana by consistently innovating and providing top-notch customer experiences. Below are our core values:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 25),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildHoverCardWithPopup(
                    context: context,
                    icon: Icons.lightbulb_outline,
                    title: 'Innovation',
                    description:
                    'We constantly innovate to meet customer needs efficiently.',
                  ),
                  _buildHoverCardWithPopup(
                    context: context,
                    icon: Icons.handshake_outlined,
                    title: 'Customer Focus',
                    description:
                    'Customer satisfaction is at the heart of everything we do.',
                  ),
                  _buildHoverCardWithPopup(
                    context: context,
                    icon: Icons.shield_outlined,
                    title: 'Integrity',
                    description:
                    'We uphold the highest standards of honesty and ethics.',
                  ),
                  _buildHoverCardWithPopup(
                    context: context,
                    icon: Icons.people_outline,
                    title: 'Teamwork',
                    description:
                    'We work together to achieve common goals and success.',
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Thank you for choosing our service!',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoverCardWithPopup({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
