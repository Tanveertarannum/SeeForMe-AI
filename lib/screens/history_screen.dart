import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/soft_background.dart';
import '../widgets/section_title.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _HistoryItem(
        icon: Icons.warning_amber_rounded,
        title: 'Obstacle detected',
        subtitle: 'Obstacle • 1.4 m • Left',
        time: '10:32 AM',
        color: AppTheme.warning,
      ),
      _HistoryItem(
        icon: Icons.door_front_door_outlined,
        title: 'Door detected',
        subtitle: 'Door • 4.5 m • Right',
        time: '10:29 AM',
        color: AppTheme.deepTeal,
      ),
      _HistoryItem(
        icon: Icons.document_scanner_outlined,
        title: 'Text recognized',
        subtitle: 'Room 204',
        time: '10:25 AM',
        color: AppTheme.teal,
      ),
      _HistoryItem(
        icon: Icons.person_outline_rounded,
        title: 'Person detected',
        subtitle: 'Person • 3.2 m • Center',
        time: '10:15 AM',
        color: AppTheme.sage,
      ),
      _HistoryItem(
        icon: Icons.stairs_outlined,
        title: 'Stairs detected',
        subtitle: 'Stairs • 3.1 m • Center',
        time: 'Yesterday',
        color: AppTheme.deepTeal,
      ),
    ];

    return Scaffold(
      body: SoftBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              35,
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
                        'History',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text,
                        ),
                      ),
                    ),

                    _TopButton(
                      icon: Icons.delete_outline_rounded,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const SectionTitle(
                  title: 'Recent activity',
                ),

                const SizedBox(height: 8),

                const Text(
                  'A simple record of your recent visual assistance.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.muted,
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.teal.withOpacity(0.11),
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.insights_outlined,
                          color: AppTheme.deepTeal,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '4 assistance events',
                              style: TextStyle(
                                color: AppTheme.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Text(
                        '4',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.deepTeal,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ...items.map(
                  (item) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12),
                    child: _HistoryTile(item: item),
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

class _HistoryItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _HistoryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}

class _HistoryTile extends StatelessWidget {
  final _HistoryItem item;

  const _HistoryTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.79),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),

          Text(
            item.time,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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