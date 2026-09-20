import 'package:flutter/material.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  String _countryCode = '+967';
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'أدخل رقم الهاتف أولاً',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // انتقال مؤقت للواجهة الرئيسية.
    // لاحقًا سنربطه بتسجيل الدخول الحقيقي وحفظ الحساب.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF070A0D),
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: LeopardBackgroundPainter(),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.18),
                      const Color(0xFF070A0D).withOpacity(0.96),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),

                      // شعار الفهد
                      Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF111820),
                          border: Border.all(
                            color: const Color(0xFFD4AF37),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37)
                                  .withOpacity(0.22),
                              blurRadius: 35,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🐆',
                            style: TextStyle(
                              fontSize: 62,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'الفهد',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Al-Wazir Chat',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          letterSpacing: 1.3,
                        ),
                      ),

                      const SizedBox(height: 48),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'أدخل رقم هاتفك للبدء في استخدام الفهد',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // رقم الهاتف
                      Row(
                        children: [
                          Container(
                            height: 58,
                            width: 94,
                            decoration: BoxDecoration(
                              color: const Color(0xFF151D24),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF303C46),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _countryCode,
                                dropdownColor:
                                    const Color(0xFF18232C),
                                iconEnabledColor:
                                    const Color(0xFFD4AF37),
                                isExpanded: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: '+967',
                                    child: Text(
                                      '+967',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '+966',
                                    child: Text(
                                      '+966',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '+971',
                                    child: Text(
                                      '+971',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '+20',
                                    child: Text(
                                      '+20',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xFF151D24),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF303C46),
                                ),
                              ),
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'رقم الهاتف',
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // زر الدخول
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFD4AF37),
                            disabledBackgroundColor:
                                const Color(0xFF806A20),
                            foregroundColor: Colors.black,
                            elevation: 8,
                            shadowColor:
                                const Color(0xFFD4AF37)
                                    .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<
                                            Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'دخول / تسجيل',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'بالضغط على دخول، أنت توافق على شروط الاستخدام وسياسة الخصوصية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 35),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD4AF37),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'الفهد • خصوصية • أمان',
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD4AF37),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeopardBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD4AF37).withOpacity(0.035);

    final positions = [
      Offset(size.width * 0.12, size.height * 0.16),
      Offset(size.width * 0.78, size.height * 0.20),
      Offset(size.width * 0.25, size.height * 0.42),
      Offset(size.width * 0.82, size.height * 0.48),
      Offset(size.width * 0.12, size.height * 0.68),
      Offset(size.width * 0.72, size.height * 0.76),
      Offset(size.width * 0.35, size.height * 0.88),
    ];

    for (final position in positions) {
      canvas.drawCircle(position, 42, paint);

      final innerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = const Color(0xFFD4AF37).withOpacity(0.055);

      canvas.drawCircle(position, 25, innerPaint);

      canvas.drawCircle(
        position.translate(18, -12),
        12,
        innerPaint,
      );

      canvas.drawCircle(
        position.translate(-15, 14),
        10,
        innerPaint,
      );
    }

    final goldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFD4AF37).withOpacity(0.08);

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.34),
      size.width * 0.42,
      goldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
