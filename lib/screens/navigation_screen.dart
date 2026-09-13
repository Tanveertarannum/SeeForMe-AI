import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/soft_background.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController pulseController;
  Timer? _mockTimer;

  bool isNavigating = false;
  int _mockStepIndex = 0;

  final List<_RouteStep> _mockSteps = const [
    _RouteStep(
      instruction: 'Head straight for 20 meters',
      distance: '20 m',
      icon: Icons.straight_rounded,
    ),
    _RouteStep(
      instruction: 'Turn left after the crossing',
      distance: '45 m',
      icon: Icons.turn_left_rounded,
    ),
    _RouteStep(
      instruction: 'Continue straight past the entrance',
      distance: '80 m',
      icon: Icons.straight_rounded,
    ),
    _RouteStep(
      instruction: 'Turn right — destination on your left',
      distance: '110 m',
      icon: Icons.turn_right_rounded,
    ),
    _RouteStep(
      instruction: "You've arrived at your destination",
      distance: '0 m',
      icon: Icons.flag_rounded,
    ),
  ];

  final List<String> _quickDestinations = const [
    'Main Entrance',
    'Nearest Exit',
    'Restroom',
    'Reception Desk',
  ];

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _mockTimer?.cancel();
    pulseController.dispose();
    super.dispose();
  }

  void _startNavigation(String destination) {
    setState(() {
      isNavigating = true;
      _mockStepIndex = 0;
    });

    // Mock: automatically advance through steps every 5 seconds.
    // Replace this Timer with real turn-by-turn updates from the
    // navigation/AI service later — see note at bottom of file.
    _mockTimer?.cancel();
    _mockTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_mockStepIndex >= _mockSteps.length - 1) {
        timer.cancel();
        return;
      }
      setState(() => _mockStepIndex++);
    });
  }

  void _endNavigation() {
    _mockTimer?.cancel();
    setState(() {
      isNavigating = false;
      _mockStepIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SoftBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Row(
                  children: [
                    _TopButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () {
                        if (isNavigating) {
                          _endNavigation();
                        }
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Navigation',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.text,
                          ),
                        ),
                      ),
                    ),
                    _TopButton(
                      icon: Icons.volume_up_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isNavigating
                      ? _NavigatingView(
                          key: const ValueKey('navigating'),
                          pulseController: pulseController,
                          currentStep: _mockSteps[_mockStepIndex],
                          stepNumber: _mockStepIndex + 1,
                          totalSteps: _mockSteps.length,
                          onEnd: _endNavigation,
                        )
                      : _SearchView(
                          key: const ValueKey('search'),
                          quickDestinations: _quickDestinations,
                          onDestinationSelected: _startNavigation,
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

class _RouteStep {
  final String instruction;
  final String distance;
  final IconData icon;
  const _RouteStep({
    required this.instruction,
    required this.distance,
    required this.icon,
  });
}

/// Shown before navigation starts — search bar + quick destination chips.
class _SearchView extends StatelessWidget {
  final List<String> quickDestinations;
  final ValueChanged<String> onDestinationSelected;

  const _SearchView({
    super.key,
    required this.quickDestinations,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where would you like to go?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Type a destination or tap the microphone to speak it.',
            style: TextStyle(
              fontSize: 13.5,
              color: AppTheme.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          _SearchBar(onSubmitted: onDestinationSelected),
          const SizedBox(height: 30),
          const Text(
            'Quick destinations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 12),
          ...quickDestinations.map(
            (destination) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QuickDestinationTile(
                label: destination,
                onTap: () => onDestinationSelected(destination),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onSubmitted;
  const _SearchBar({required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Destination search field',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppTheme.muted),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onSubmitted: onSubmitted,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.text,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search a destination',
                  hintStyle: TextStyle(color: AppTheme.muted),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Hook up speech-to-text here later (flutter_tts / speech_to_text).
                onSubmitted('Main Entrance');
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppTheme.deepTeal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickDestinationTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickDestinationTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Navigate to $label',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.78),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.9)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.deepTeal.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.place_outlined,
                  color: AppTheme.deepTeal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.text,
                  ),
                ),
              ),
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

/// Shown while navigation is active — big directional card + step list.
class _NavigatingView extends StatelessWidget {
  final AnimationController pulseController;
  final _RouteStep currentStep;
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onEnd;

  const _NavigatingView({
    super.key,
    required this.pulseController,
    required this.currentStep,
    required this.stepNumber,
    required this.totalSteps,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
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
                    color: AppTheme.deepTeal.withOpacity(0.14),
                    blurRadius: 35,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: pulseController,
                    builder: (_, __) {
                      final scale = 1 + (pulseController.value * 0.12);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                  Icon(
                    currentStep.icon,
                    size: 90,
                    color: Colors.white,
                  ),
                  Positioned(
                    top: 22,
                    child: Semantics(
                      label: 'Step $stepNumber of $totalSteps',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Step $stepNumber of $totalSteps',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.deepTeal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
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
                    color: AppTheme.mist,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.volume_up_outlined,
                    color: AppTheme.deepTeal,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentStep.instruction,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        currentStep.distance,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Semantics(
              button: true,
              label: 'End navigation',
              child: GestureDetector(
                onTap: onEnd,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Text(
                      'End Navigation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.danger,
                      ),
                    ),
                  ),
                ),
              ),
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

// NOTE FOR AI/BACKEND TEAMMATE:
// Replace _startNavigation's Timer.periodic mock with real step updates —
// e.g. a stream of _RouteStep objects from GPS/beacon/AI positioning data.
// The UI (_NavigatingView) only needs a _RouteStep and step counters, so
// no UI changes should be required when you wire in the real service.