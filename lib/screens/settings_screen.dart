import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/soft_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool voiceGuidance = true;
  bool hapticFeedback = true;
  bool highContrast = false;
  double speechRate = 0.5;

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
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                  child: Row(
                    children: [
                      _TopButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.text,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _SectionLabel('Accessibility'),
                    const SizedBox(height: 12),
                    _SettingsGroup(
                      children: [
                        _SwitchTile(
                          icon: Icons.record_voice_over_outlined,
                          title: 'Voice Guidance',
                          subtitle: 'Spoken descriptions of surroundings',
                          value: voiceGuidance,
                          onChanged: (v) => setState(() => voiceGuidance = v),
                        ),
                        const _Divider(),
                        _SwitchTile(
                          icon: Icons.vibration_rounded,
                          title: 'Haptic Feedback',
                          subtitle: 'Vibration cues for key actions',
                          value: hapticFeedback,
                          onChanged: (v) => setState(() => hapticFeedback = v),
                        ),
                        const _Divider(),
                        _SwitchTile(
                          icon: Icons.contrast_rounded,
                          title: 'High Contrast Mode',
                          subtitle: 'Stronger colors for low vision',
                          value: highContrast,
                          onChanged: (v) => setState(() => highContrast = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const _SectionLabel('Speech'),
                    const SizedBox(height: 12),
                    _SettingsGroup(
                      children: [
                        _SliderTile(
                          icon: Icons.speed_rounded,
                          title: 'Speech Rate',
                          value: speechRate,
                          onChanged: (v) => setState(() => speechRate = v),
                        ),
                        const _Divider(),
                        _NavigationTile(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          trailingText: 'English',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const _SectionLabel('General'),
                    const SizedBox(height: 12),
                    _SettingsGroup(
                      children: [
                        _NavigationTile(
                          icon: Icons.camera_alt_outlined,
                          title: 'Camera Permissions',
                          onTap: () {},
                        ),
                        const _Divider(),
                        _NavigationTile(
                          icon: Icons.mic_none_rounded,
                          title: 'Microphone Permissions',
                          onTap: () {},
                        ),
                        const _Divider(),
                        _NavigationTile(
                          icon: Icons.info_outline_rounded,
                          title: 'About & Help',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        'SeeForMe AI · v1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.muted.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.deepTeal,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 66,
      color: AppTheme.mist.withOpacity(0.8),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _IconBadge(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.muted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.deepTeal,
              activeTrackColor: AppTheme.teal.withOpacity(0.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  const _SliderTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title, ${(value * 100).round()} percent',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconBadge(icon: icon),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.deepTeal,
                inactiveTrackColor: AppTheme.mist,
                thumbColor: AppTheme.deepTeal,
                overlayColor: AppTheme.teal.withOpacity(0.15),
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              _IconBadge(icon: icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppTheme.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.deepTeal.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppTheme.deepTeal, size: 20),
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: AppTheme.deepTeal, size: 20),
      ),
    );
  }
}