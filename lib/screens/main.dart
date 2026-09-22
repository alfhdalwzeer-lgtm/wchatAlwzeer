import 'package:flutter/material.dart';

void main() {
  runApp(const AlWazirChatApp());
}

class AlWazirChatApp extends StatelessWidget {
  const AlWazirChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111B21),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 3; // تبويب الدردشات افتراضياً

  final List<Widget> _screens = const [
    StatusScreen(),
    CallsScreen(),
    GroupsScreen(),
    ChatsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2C34),
        title: const Text(
          'الفهد',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFFFFD700)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFFD700)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFFFD700)),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1F2C34),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'الحالة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'المكالمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'المجموعات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'الدردشات',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.message, color: Color(0xFF111B21)),
        onPressed: () {},
      ),
    );
  }
}

// شاشة الدردشات الرئيسية
class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF1F2C34),
            child: Icon(Icons.person, color: Color(0xFFFFD700)),
          ),
          title: const Text(
            'مستخدم الفهد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'وعليكم السلام! تطبيق ممتاز جداً.',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: const Text(
            '10:01 ص',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatDetailScreen()),
            );
          },
        ),
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFD700),
            child: Icon(Icons.star, color: Color(0xFF111B21)),
          ),
          title: const Text(
            'الفهد',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'مرحباً بك في التطبيق',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: const Text(
            '09:45 ص',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

// شاشة المحادثة التفصيلية
class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2C34),
        title: Row(
          children: const [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFFD700),
              child: Icon(Icons.person, color: Color(0xFF111B21), size: 20),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مستخدم الفهد', style: TextStyle(fontSize: 16, color: Colors.white)),
                Text('متصل الآن', style: TextStyle(fontSize: 12, color: Color(0xFFFFD700))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam, color: Color(0xFFFFD700)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call, color: Color(0xFFFFD700)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFFFFD700)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2C34),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('السلام عليكم، مرحباً بك في الفهد\n10:00 ص', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005C4B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('وعليكم السلام! تطبيق ممتاز جداً.\n10:01 ص', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF1F2C34),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFFFFD700)),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF1F2C34),
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(20),
                        height: 180,
                        child: Column(
                          children: [
                            const Text('مركز الوسائط', style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _mediaOption(Icons.camera_alt, 'الكاميرا'),
                                _mediaOption(Icons.image, 'المعرض'),
                                _mediaOption(Icons.videocam, 'فيديو'),
                                _mediaOption(Icons.insert_drive_file, 'الملفات'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFFFFD700)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaOption(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF111B21),
          child: Icon(icon, color: Color(0xFFFFD700)),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

// شاشة الحالة
class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFD700),
            child: Icon(Icons.person, color: Color(0xFF111B21)),
          ),
          title: const Text('حالتي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('اضغط لإضافة حالة جديدة', style: TextStyle(color: Colors.grey)),
        ),
        const Divider(color: Colors.grey),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFFFFD700), size: 48),
                SizedBox(height: 16),
                Text('لا توجد حالات بعد', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('شاشة المكالمات', style: TextStyle(color: Colors.white)));
  }
}

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('شاشة المجموعات', style: TextStyle(color: Colors.white)));
  }
}
