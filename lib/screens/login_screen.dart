import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController =
      TextEditingController();

  final TextEditingController _nameController =
      TextEditingController();

  final DatabaseHelper _database =
      DatabaseHelper.instance;

  String _countryCode = '+967';
  bool _isLoading = false;

  final Color _gold = const Color(0xFFD4AF37);
  final Color _background = const Color(0xFF080B0F);

  Future<void> _login() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      _showMessage('اكتب اسمك أولاً');
      return;
    }

    if (phone.isEmpty) {
      _showMessage('اكتب رقم الهاتف');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final fullPhone = '$_countryCode$phone';

      final existingUser =
          await _database.getUserByPhone(fullPhone);

      if (existingUser == null) {
        final userId =
            'user_${DateTime.now().millisecondsSinceEpoch}';

        await _database.createUser(
          userId: userId,
          name: name,
          phone: fullPhone,
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainHomeScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'حدث خطأ أثناء حفظ الحساب',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E2A31),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: LeopardBackgroundPainter(
                  gold: _gold,
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 35,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),

                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _gold.withOpacity(0.12),
                        border: Border.all(
                          color: _gold,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '🐆',
                          style: TextStyle(
                            fontSize: 48,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'الفهد',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Al-Wazir Chat',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 45),

                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'أدخل بياناتك للبدء باستخدام الفهد',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    _inputField(
                      controller: _nameController,
                      hint: 'اسمك',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Container(
                          height: 58,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF151B20),
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white10,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _countryCode,
                              dropdownColor:
                                  const Color(0xFF1E252B),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              iconEnabledColor: _gold,
                              items: const [
                                DropdownMenuItem(
                                  value: '+967',
                                  child: Text('+967'),
                                ),
                                DropdownMenuItem(
                                  value: '+966',
                                  child: Text('+966'),
                                ),
                                DropdownMenuItem(
                                  value: '+971',
                                  child: Text('+971'),
                                ),
                                DropdownMenuItem(
                                  value: '+20',
                                  child: Text('+20'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() {
                                  _countryCode = value;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _inputField(
                            controller: _phoneController,
                            hint: 'رقم الهاتف',
                            icon: Icons.phone_outlined,
                            keyboardType:
                                TextInputType.phone,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor:
                              _gold.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'دخول / تسجيل',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'باستمرارك أنت توافق على شروط الاستخدام وسياسة الخصوصية',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'الفهد • خصوصية • أمان',
                      style: TextStyle(
                        color: _gold.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF151B20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white38,
          ),
          prefixIcon: Icon(
            icon,
            color: _gold,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 17,
          ),
        ),
      ),
    );
  }
}

class LeopardBackgroundPainter extends CustomPainter {
  final Color gold;

  LeopardBackgroundPainter({
    required this.gold,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = gold.withOpacity(0.025)
      ..style = PaintingStyle.fill;

    final spots = [
      Offset(size.width * 0.12, size.height * 0.18),
      Offset(size.width * 0.82, size.height * 0.25),
      Offset(size.width * 0.25, size.height * 0.55),
      Offset(size.width * 0.78, size.height * 0.68),
      Offset(size.width * 0.15, size.height * 0.86),
      Offset(size.width * 0.88, size.height * 0.9),
    ];

    for (final spot in spots) {
      canvas.drawCircle(
        spot,
        55,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant LeopardBackgroundPainter oldDelegate,
  ) {
    return oldDelegate.gold != gold;
  }
}
