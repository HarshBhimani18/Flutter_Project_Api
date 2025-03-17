import 'package:flutter/material.dart';

class BaseColor {
  static const color = Colors.pink;
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        backgroundColor: BaseColor.color,
        elevation: 0,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [BaseColor.color, Colors.red.shade300],
        //   ),
        // ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // App Logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, size: 50, color: BaseColor.color),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Matrimony App',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sections
              _buildSection('Meet Our Team', [
                _buildInfoRow('Developed by', 'Bhimani Harsh (23010101027)'),
                _buildInfoRow('Mentored by', 'Prof. Mehul Bhundiya (Faculty of Department of Computer Science and Engineering)'),
                _buildInfoRow('Explored by', 'ASWDC, School of Computer Science'),
                _buildInfoRow('Eulogized by', 'Darshan University, Rajkot, Gujarat - INDIA'),
              ]),

              _buildSection('About ASWDC', [
                // Image.asset('assets/images/aswdcLogo.png'),
                const SizedBox(height: 16),
                const Text(
                  'ASWDC is Application, Software and Website Development Center @ Darshan University run by Students and Staff of School Of Computer Science.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sole purpose of ASWDC is to bridge gap between university curriculum & industry demands. Students learn cutting edge technologies, develop real world application & experiences professional environment @ ASWDC under guidance of industry experts & faculty members.',
                ),
              ]),

              _buildSection('Contact Us', [
                _buildContactRow(Icons.email, 'aswdc@darshan.ac.in'),
                _buildContactRow(Icons.phone, '+91-7984427174'),
                _buildContactRow(Icons.language, 'www.darshan.ac.in'),
              ]),

              _buildActionButtons(),

              // Footer
              const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '© 2025 Darshan University',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'All Rights Reserved - ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Made with ', style: TextStyle(color: Colors.white70)),
                        Icon(Icons.favorite, color: Colors.white, size: 16),
                        Text(' in India', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: BaseColor.color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title :',
              style: const TextStyle(
                color: BaseColor.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: BaseColor.color),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionButton(Icons.share, 'Share App'),
          const Divider(height: 1),
          _buildActionButton(Icons.apps, 'More Apps'),
          const Divider(height: 1),
          _buildActionButton(Icons.star, 'Rate Us'),
          const Divider(height: 1),
          _buildActionButton(Icons.thumb_up, 'Like us on Facebook'),
          const Divider(height: 1),
          _buildActionButton(Icons.update, 'Check For Update'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: BaseColor.color),
            const SizedBox(width: 16),
            Text(text),
          ],
        ),
      ),
    );
  }
}