import 'package:flutter/material.dart';

import '../components/neumorphic.dart';
import '../components/photoTile.dart';
import '../theme.dart';
import 'libraryScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static final _pages = <_OnboardingPage>[
    _OnboardingPage(
      topBar: _WordmarkBar(),
      art: const _OrganizedArt(),
      title: 'Your memories, beautifully organized.',
      body: 'Photogram brings your photos together, keeps them organized, '
          'and helps you turn moments into memories.',
      indicatorStyle: _IndicatorStyle.neumorphicDots,
    ),
    _OnboardingPage(
      topBar: const _SkipBar(variant: _SkipVariant.flat),
      art: const _StorageArt(),
      title: 'Your photos, your storage.',
      body: 'Start with simple managed storage, or choose a storage space '
          'you control.',
      indicatorStyle: _IndicatorStyle.recordIcons,
    ),
    _OnboardingPage(
      topBar: const _SkipBar(variant: _SkipVariant.pill),
      art: const _EventArt(),
      title: 'Memories that happen automatically.',
      body: 'Connect your calendar and Photogram can turn the moments around '
          'your events into beautiful albums and memories.',
      indicatorStyle: _IndicatorStyle.activePill,
      buttonLabel: 'Continue',
    ),
    _OnboardingPage(
      topBar: const _SkipBar(variant: _SkipVariant.pill),
      art: const _ShareArt(),
      title: 'Share the moment.',
      body: 'Create a memory once, then share it with everyone who matters.',
      indicatorStyle: _IndicatorStyle.raisedDots,
      buttonLabel: 'Get started',
    ),
  ];

  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LibraryScreen()),
    );
  }

  void _next() {
    if (_page == _pages.length - 1) {
      _enterApp();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _OnboardingPageView(
                page: _pages[i],
                onSkip: _enterApp,
              ),
            ),
            Positioned(
              left: AppSpacing.containerMargin,
              right: AppSpacing.containerMargin,
              bottom: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PageIndicator(
                    count: _pages.length,
                    active: _page,
                    style: _pages[_page].indicatorStyle,
                  ),
                  if (_pages[_page].buttonLabel != null) ...[
                    const SizedBox(height: 20),
                    _ActionButton(
                      label: _pages[_page].buttonLabel!,
                      onTap: _next,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.topBar,
    required this.art,
    required this.title,
    required this.body,
    required this.indicatorStyle,
    this.buttonLabel,
  });

  final Widget topBar;
  final Widget art;
  final String title;
  final String body;
  final _IndicatorStyle indicatorStyle;
  final String? buttonLabel;
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page, required this.onSkip});

  final _OnboardingPage page;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopBar(onSkip: onSkip, child: page.topBar),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin,
              ),
              child: page.art,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
          child: Column(
            children: [
              const SizedBox(height: 28),
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                page.body,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.onSurfaceVariant),
              ),
              SizedBox(height: page.buttonLabel != null ? 132 : 48),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.child, required this.onSkip});

  final Widget child;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final isSkip = child is _SkipBar;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.containerMargin,
        12,
        AppSpacing.containerMargin,
        0,
      ),
      child: isSkip
          ? Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onSkip,
                child: child,
              ),
            )
          : Center(child: child),
    );
  }
}

class _WordmarkBar extends StatelessWidget {
  const _WordmarkBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Photogram',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6),
      ),
    );
  }
}

enum _SkipVariant { flat, pill }

class _SkipBar extends StatelessWidget {
  const _SkipBar({required this.variant});

  final _SkipVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == _SkipVariant.flat) {
      return Text(
        'Skip',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
      );
    }
    return Neumorphic(
      radius: AppRadii.headerPill,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.canvas,
      child: Text(
        'Skip',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

enum _IndicatorStyle { neumorphicDots, recordIcons, activePill, raisedDots }

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.active,
    required this.style,
  });

  final int count;
  final int active;
  final _IndicatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: _spacing(i)),
          _Dot(
            key: Key('page-dot-$i'),
            active: i == active,
            style: style,
          ),
        ],
      ],
    );
  }

  double _spacing(int index) {
    switch (style) {
      case _IndicatorStyle.recordIcons:
        return 24;
      case _IndicatorStyle.raisedDots:
        return 16;
      case _IndicatorStyle.neumorphicDots:
      case _IndicatorStyle.activePill:
        return 12;
    }
  }
}

class _Dot extends StatelessWidget {
  const _Dot({super.key, required this.active, required this.style});

  final bool active;
  final _IndicatorStyle style;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case _IndicatorStyle.neumorphicDots:
        final size = active ? 12.0 : 10.0;
        return Neumorphic(
          radius: 12,
          variant: active ? NeumorphicVariant.concave : NeumorphicVariant.convex,
          color: active ? AppColors.primary : AppColors.surfaceContainerHigh,
          child: SizedBox(width: size, height: size),
        );
      case _IndicatorStyle.recordIcons:
        return Transform.scale(
          scale: active ? 1.25 : 1,
          child: Icon(
            Icons.fiber_manual_record,
            size: 12,
            color: active
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
        );
      case _IndicatorStyle.activePill:
        if (active) {
          return Neumorphic(
            variant: NeumorphicVariant.concave,
            radius: 4,
            color: AppColors.primary,
            child: const SizedBox(width: 32, height: 8),
          );
        }
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
        );
      case _IndicatorStyle.raisedDots:
        return Neumorphic(
          radius: 12,
          variant: active ? NeumorphicVariant.concave : NeumorphicVariant.convex,
          color: active ? AppColors.primary : AppColors.canvas,
          child: const SizedBox(width: 12, height: 12),
        );
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        radius: 32,
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: AppColors.canvas,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 20, color: AppColors.onSurface),
          ],
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.seed,
    required this.size,
    this.radius = AppRadii.grid,
    this.border = 6,
    this.rotation = 0,
    this.circle = false,
  });

  final String seed;
  final Size size;
  final double radius;
  final double border;
  final double rotation;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final inner = SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circle ? 999 : radius - border),
        child: PlaceholderArtwork(seed: seed),
      ),
    );
    final framed = Neumorphic(
      radius: circle ? 999 : radius,
      padding: EdgeInsets.all(border),
      color: AppColors.canvas,
      child: inner,
    );
    if (rotation == 0) {
      return framed;
    }
    return Transform.rotate(angle: rotation, child: framed);
  }
}

class _OrganizedArt extends StatelessWidget {
  const _OrganizedArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 16,
            child: _Frame(
              seed: 'collage-circle',
              size: const Size(112, 112),
              border: 4,
              circle: true,
            ),
          ),
          Positioned(
            bottom: 64,
            left: 0,
            child: _Frame(
              seed: 'collage-mid',
              size: const Size(96, 128),
              radius: 16,
              border: 4,
              rotation: -0.1,
            ),
          ),
          Positioned(
            top: 22,
            left: 54,
            child: _Frame(
              seed: 'collage-main',
              size: const Size(192, 256),
              radius: 24,
              border: 6,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 0,
            child: _Frame(
              seed: 'collage-corner',
              size: const Size(128, 128),
              radius: 16,
              border: 4,
              rotation: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageNode extends StatelessWidget {
  const _StorageNode({
    required this.icon,
    required this.label,
    required this.variant,
    this.iconSize = 36,
  });

  final IconData icon;
  final String label;
  final NeumorphicVariant variant;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      variant: variant,
      radius: 48,
      color: AppColors.canvas,
      child: SizedBox(
        width: 96,
        height: 96,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _StorageArt extends StatelessWidget {
  const _StorageArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _StorageNode(
            icon: Icons.photo_library,
            label: 'Library',
            variant: NeumorphicVariant.convex,
          ),
          const SizedBox(
            height: 120,
            child: _FlowPainter(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StorageNode(
                  icon: Icons.cloud,
                  label: 'Managed',
                  variant: NeumorphicVariant.concave,
                  iconSize: 30,
                ),
                _StorageNode(
                  icon: Icons.dns,
                  label: 'My Storage',
                  variant: NeumorphicVariant.concave,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowPainter extends StatelessWidget {
  const _FlowPainter();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _FlowPainterPainter(), size: Size.infinite);
  }
}

class _FlowPainterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..color = AppColors.shadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final highlight = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (final endX in [0.25 * size.width, 0.75 * size.width]) {
      final path = Path()
        ..moveTo(size.width / 2, 0)
        ..cubicTo(
          size.width / 2,
          size.height / 2,
          endX,
          size.height / 2,
          endX,
          size.height,
        );
      canvas.drawPath(path, base);
      canvas.drawPath(path, highlight);
    }
  }

  @override
  bool shouldRepaint(covariant _FlowPainterPainter oldDelegate) => false;
}

class _EventArt extends StatelessWidget {
  const _EventArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 340,
      child: Stack(
        children: [
          Positioned(
            left: 139,
            top: 16,
            child: Container(
              width: 1,
              height: 32,
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Opacity(
              opacity: 0.4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Neumorphic(
                      variant: NeumorphicVariant.concave,
                      radius: 20,
                      color: AppColors.canvas,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.event,
                          size: 22,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Birthday Dinner',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'Saturday • 18:00',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: Neumorphic(
              radius: 16,
              padding: const EdgeInsets.all(12),
              color: AppColors.canvas,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 192,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const PlaceholderArtwork(seed: 'birthday-dinner'),
                          Center(
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xCCFFFFFF),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 28,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Birthday Dinner',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                '42 photos',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Neumorphic(
                          radius: 16,
                          color: AppColors.canvas,
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkNode extends StatelessWidget {
  const _NetworkNode({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      radius: 24,
      color: AppColors.canvas,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
    );
  }
}

class _ShareArt extends StatelessWidget {
  const _ShareArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342,
      height: 320,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _NetworkPainter()),
          ),
          const Positioned(
            top: 64,
            left: 34,
            child: _NetworkNode(icon: Icons.chat_bubble_outline),
          ),
          const Positioned(
            top: 80,
            right: 34,
            child: _NetworkNode(icon: Icons.mail_outline),
          ),
          const Positioned(
            bottom: 64,
            left: 51,
            child: _NetworkNode(icon: Icons.ios_share),
          ),
          const Positioned(
            bottom: 80,
            right: 41,
            child: _NetworkNode(icon: Icons.photo_camera_outlined),
          ),
          Center(
            child: Neumorphic(
              radius: 16,
              padding: const EdgeInsets.all(12),
              color: AppColors.canvas,
              child: SizedBox(
                width: 176,
                child: Column(
                  children: [
                    SizedBox(
                      height: 128,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: const PlaceholderArtwork(seed: 'summer-trip'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Summer Trip',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '128 photos',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: AppColors.outlineVariant),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.shadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const dashWidth = 4.0;
    const dashGap = 6.0;
    const center = Offset(171, 160);

    final starts = [
      Offset(0.25 * size.width, 0.30 * size.height),
      Offset(0.80 * size.width, 0.35 * size.height),
      Offset(0.25 * size.width, 0.70 * size.height),
      Offset(0.75 * size.width, 0.65 * size.height),
    ];
    for (final start in starts) {
      final delta = center - start;
      final distance = delta.distance;
      final unit = delta / distance;
      var travelled = 0.0;
      while (travelled < distance) {
        final segment = (distance - travelled).clamp(0.0, dashWidth);
        canvas.drawLine(
          start + unit * travelled,
          start + unit * (travelled + segment),
          paint,
        );
        travelled += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) => false;
}
