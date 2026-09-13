import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/soft_background.dart';

import 'live_detection_screen.dart';
import 'text_reader_screen.dart';
import 'navigation_screen.dart';
import 'history_screen.dart';
import 'emergency_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SoftBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    0,
                  ),
                  child: _Header(
                    onSettings: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    30,
                    24,
                    0,
                  ),
                  child: _HeroCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LiveDetectionScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    32,
                    24,
                    16,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'More',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _FeatureTile(
                        icon: Icons.document_scanner_outlined,
                        title: 'Read the world',
                        subtitle:
                            'Scan signs, labels and printed text',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const TextReaderScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      _FeatureTile(
                        icon: Icons.navigation_outlined,
                        title: 'Find your way',
                        subtitle:
                            'Voice-assisted navigation support',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const NavigationScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      _FeatureTile(
                        icon: Icons.history_outlined,
                        title: 'Your activity',
                        subtitle:
                            'Review recent visual assistance',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const HistoryScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      _FeatureTile(
                        icon: Icons.support_outlined,
                        title: 'Need help?',
                        subtitle:
                            'Quick access to emergency support',
                        danger: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const EmergencyScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onSettings;

  const _Header({
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppTheme.teal,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    'SeeForMe AI',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: AppTheme.deepTeal,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                'Understand\nyour surroundings.',
                style: TextStyle(
                  fontSize: 31,
                  height: 1.04,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: onSettings,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppTheme.deepTeal,
              size: 21,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatefulWidget {
  final VoidCallback onTap;

  const _HeroCard({
    required this.onTap,
  });

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;

        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 385,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB8D5D7),
                  Color(0xFF88B4B7),
                  Color(0xFF5E8F94),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      AppTheme.deepTeal.withOpacity(0.14),
                  blurRadius: 35,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -50 + (value * 20),
                  right: -30,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Positioned(
                  bottom: -80,
                  left: -30,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color:
                          Colors.black.withOpacity(0.07),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Positioned(
                  left: 26,
                  right: 26,
                  top: 26,
                  child: Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Colors.white.withOpacity(0.18),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'VISUAL ASSISTANCE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 28,
                  right: 28,
                  bottom: 28,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "See what's around you.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 31,
                          height: 1.05,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.7,
                        ),
                      ),

                      const SizedBox(height: 11),

                      const Text(
                        'Real-time object awareness, text reading '
                        'and voice guidance in one simple experience.',
                        style: TextStyle(
                          color: Color(0xFFEAF5F5),
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(17),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              color: AppTheme.deepTeal,
                              size: 19,
                            ),

                            SizedBox(width: 9),

                            Text(
                              'Start Seeing',
                              style: TextStyle(
                                color: AppTheme.deepTeal,
                                fontWeight:
                                    FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),

                            SizedBox(width: 10),

                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppTheme.deepTeal,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeatureTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool danger;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  @override
  State<_FeatureTile> createState() =>
      _FeatureTileState();
}

class _FeatureTileState extends State<_FeatureTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final Color accent =
        widget.danger
            ? AppTheme.danger
            : AppTheme.deepTeal;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          pressed = true;
        });
      },

      onTapCancel: () {
        setState(() {
          pressed = false;
        });
      },

      onTapUp: (_) {
        setState(() {
          pressed = false;
        });

        widget.onTap();
      },

      child: AnimatedScale(
        scale: pressed ? 0.985 : 1,
        duration:
            const Duration(milliseconds: 130),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.78),
            borderRadius:
                BorderRadius.circular(24),

            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.035),
                blurRadius: 24,
                offset: const Offset(0, 9),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  color: accent.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: Icon(
                  widget.icon,
                  color: accent,
                  size: 24,
                ),
              ),

              const SizedBox(width: 17),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.text,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.muted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_outward_rounded,
                color: accent.withOpacity(0.75),
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}