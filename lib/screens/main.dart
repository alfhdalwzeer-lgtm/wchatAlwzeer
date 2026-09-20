import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const WchatAlwzeerApp());
}

class WchatAlwzeerApp extends StatelessWidget {
  const WchatAlwzeerApp({super.key});

  static const Color gold = Color(0xFFD4AF37);
  static const Color navy = Color(0xFF1E2A31);
  static const Color background = Color(0xFF080B0F);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        fontFamily: 'sans',
      ),
      home: const LoginScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ChatsPage(),
    GroupsPage(),
    CallsPage(),
    StatusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: WchatAlwzeerApp.background,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF111820),
          indicatorColor:
              WchatAlwzeerApp.gold.withOpacity(0.18),
          selectedIndex: _currentIndex,
          height: 72,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'الدردشات',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: 'المجموعات',
            ),
            NavigationDestination(
              icon: Icon(Icons.call_outlined),
              selectedIcon: Icon(Icons.call),
              label: 'المكالمات',
            ),
            NavigationDestination(
              icon: Icon(Icons.circle_outlined),
              selectedIcon: Icon(Icons.circle),
              label: 'الحالة',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// الدردشات
// ============================================================

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'name': 'مستخدم الفهد',
        'message': 'مرحباً بك في الفهد 🐆',
        'time': '10:45 م',
        'count': '2',
      },
      {
        'name': 'الفهد',
        'message': 'أداء وتميز في كل محادثة',
        'time': '9:30 م',
        'count': '5',
      },
      {
        'name': 'الصادق موبايل',
        'message': 'تم إرسال صورة',
        'time': '8:15 م',
        'count': '',
      },
      {
        'name': 'أصدقاء الفهد',
        'message': 'عبدالله: السلام عليكم',
        'time': '7:42 م',
        'count': '12',
      },
    ];

    return SafeArea(
      child: Column(
        children: [
          _TopBar(
            title: 'الفهد',
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              PopupMenuButton<String>(
                color: const Color(0xFF18232C),
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  if (value == 'profile') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'profile',
                    child: Text('الملف الشخصي'),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Text('الإعدادات'),
                  ),
                ],
              ),
            ],
          ),

          // بطاقة الفهد
          Container(
            margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF242019),
                  Color(0xFF111820),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: WchatAlwzeerApp.gold.withOpacity(0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF151D24),
                    border: Border.all(
                      color: WchatAlwzeerApp.gold,
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '🐆',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الفهد',
                        style: TextStyle(
                          color: WchatAlwzeerApp.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'أداء وتميز في كل محادثة',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: WchatAlwzeerApp.gold,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return _ChatTile(
                  name: chat['name']!,
                  message: chat['message']!,
                  time: chat['time']!,
                  count: chat['count']!,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// عنصر المحادثة
// ============================================================

class _ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String count;
  final int index;

  const _ChatTile({
    required this.name,
    required this.message,
    required this.time,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              userName: name,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF18232C),
                    border: Border.all(
                      color: index == 0
                          ? WchatAlwzeerApp.gold
                          : const Color(0xFF303C46),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      index == 0 ? '🐆' : '👤',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                if (index == 0)
                  Positioned(
                    left: 0,
                    bottom: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF080B0F),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: count.isNotEmpty
                              ? WchatAlwzeerApp.gold
                              : Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (count.isNotEmpty)
                        Container(
                          margin:
                              const EdgeInsets.only(right: 8),
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: WchatAlwzeerApp.gold,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              count,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// المجموعات
// ============================================================

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const _TopBar(
            title: 'المجموعات',
            actions: [],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _GroupTile(
                  name: 'مجموعة الفهد',
                  message: 'مرحباً بالجميع 🐆',
                  members: '128 عضو',
                ),
                _GroupTile(
                  name: 'أصدقاء الفهد',
                  message: 'تمت إضافة عضو جديد',
                  members: '46 عضو',
                ),
                _GroupTile(
                  name: 'عائلة الفهد',
                  message: 'عبدالله: مساء الخير',
                  members: '18 عضو',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final String name;
  final String message;
  final String members;

  const _GroupTile({
    required this.name,
    required this.message,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF18232C),
              border: Border.all(
                color: WchatAlwzeerApp.gold.withOpacity(0.5),
              ),
            ),
            child: const Icon(
              Icons.groups,
              color: WchatAlwzeerApp.gold,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$message • $members',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// المكالمات
// ============================================================

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const _TopBar(
            title: 'المكالمات',
            actions: [],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: const [
                _CallTile(
                  name: 'مستخدم الفهد',
                  incoming: true,
                  video: false,
                  time: 'اليوم، 10:20 م',
                ),
                _CallTile(
                  name: 'الفهد',
                  incoming: false,
                  video: true,
                  time: 'اليوم، 8:15 م',
                ),
                _CallTile(
                  name: 'الصادق موبايل',
                  incoming: true,
                  video: false,
                  time: 'أمس، 11:40 م',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CallTile extends StatelessWidget {
  final String name;
  final bool incoming;
  final bool video;
  final String time;

  const _CallTile({
    required this.name,
    required this.incoming,
    required this.video,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xFF18232C),
            child: Text(
              '👤',
              style: TextStyle(fontSize: 26),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      incoming
                          ? Icons.call_received
                          : Icons.call_made,
                      size: 15,
                      color: incoming
                          ? Colors.green
                          : WchatAlwzeerApp.gold,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            video ? Icons.videocam : Icons.call,
            color: WchatAlwzeerApp.gold,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// الحالة
// ============================================================

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const _TopBar(
            title: 'الحالة',
            actions: [],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111820),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF18232C),
                              border: Border.all(
                                color: WchatAlwzeerApp.gold,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '🐆',
                                style:
                                    TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: WchatAlwzeerApp.gold,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      const Color(0xFF111820),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'حالتي',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'اضغط لإضافة حالة جديدة',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    color: WchatAlwzeerApp.gold,
                    size: 54,
                  ),
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    'لا توجد حالات بعد',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'ستظهر هنا حالات جهات اتصالك',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// الشريط العلوي
// ============================================================

class _TopBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const _TopBar({
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: WchatAlwzeerApp.navy,
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Text(
            '🐆',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              color: WchatAlwzeerApp.gold,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ...actions,
        ],
      ),
    );
  }
}
