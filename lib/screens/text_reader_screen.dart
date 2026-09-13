import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/soft_background.dart';
import '../widgets/section_title.dart';

class TextReaderScreen extends StatelessWidget {
  const TextReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SoftBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              30,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TopButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Text(
                        'Text Reader',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text,
                        ),
                      ),
                    ),

                    _TopButton(
                      icon: Icons.volume_up_outlined,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const SectionTitle(
                  title: 'Read what you see.',
                ),

                const SizedBox(height: 8),

                const Text(
                  'Point the camera at a sign, label or '
                  'printed text and SeeForMe will read it aloud.',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: AppTheme.muted,
                  ),
                ),

                const SizedBox(height: 20),

                // Camera preview
                Container(
                  height: 320,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFBFD9DA),
                        Color(0xFF91B8BA),
                        Color(0xFF74999C),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 35,
                        left: 25,
                        child: _SoftShape(
                          width: 95,
                          height: 180,
                        ),
                      ),

                      Positioned(
                        right: 25,
                        bottom: 30,
                        child: _SoftShape(
                          width: 120,
                          height: 180,
                        ),
                      ),

                      Center(
                        child: Container(
                          width: 130,
                          height: 85,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.75),
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.document_scanner_outlined,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),

                      const Positioned(
                        top: 18,
                        left: 18,
                        child: _StatusPill(
                          text: 'OCR READY',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detected text',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'BLOCK A\n'
                        'MAIN ENTRANCE\n'
                        'ROOM 204',
                        style: TextStyle(
                          fontSize: 21,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.volume_up_outlined,
                              ),
                              label: const Text(
                                'Read Aloud',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.deepTeal,
                                foregroundColor:
                                    Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    17,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppTheme.mist,
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.copy_outlined,
                              color:
                                  AppTheme.deepTeal,
                              size: 21,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Tip',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.deepTeal,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Keep the text inside the scanning frame '
                  'and hold your phone steady for better results.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.82),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Icon(
          icon,
          color: AppTheme.deepTeal,
          size: 20,
        ),
      ),
    );
  }
}

class _SoftShape extends StatelessWidget {
  final double width;
  final double height;

  const _SoftShape({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(80),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;

  const _StatusPill({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 1,
          fontWeight: FontWeight.w800,
          color: AppTheme.deepTeal,
        ),
      ),
    );
  }
}