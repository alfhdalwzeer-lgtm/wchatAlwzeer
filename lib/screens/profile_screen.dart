import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('الملف الشخصي', style: TextStyle(color: Color(0xFFD4AF37))),
        backgroundColor: const Color(0xFF1E232A),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFD4AF37),
                    child: Icon(Icons.person, size: 60, color: Colors.black),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFD4AF37),
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFFD4AF37)),
              title: Text('الاسم', style: TextStyle(color: Colors.grey)),
              subtitle: Text('Al-Wazir User', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Color(0xFFD4AF37)),
              title: Text('الحالة النصية', style: TextStyle(color: Colors.grey)),
              subtitle: Text('متاح في Al-Wazir Chat', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
