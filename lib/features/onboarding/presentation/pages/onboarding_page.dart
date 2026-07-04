import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flow/core/constants/storage_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/widgets/brand_badge.dart';
import 'package:shop_flow/core/widgets/gradient_button.dart';

/// First-run carousel introducing ShopFlow showcase features.
class OnboardingPage extends StatefulWidget {
  /// Creates onboarding route.
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slideCount = 3;

  Future<void> _finish() async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setBool(StorageKeys.onboardingComplete, true);
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    final slides = <({IconData icon, String title, String body})>[
      (
        icon: Icons.cloud_off_outlined,
        title: l10n.onboardingSlide1Title,
        body: l10n.onboardingSlide1Body,
      ),
      (
        icon: Icons.payment_outlined,
        title: l10n.onboardingSlide2Title,
        body: l10n.onboardingSlide2Body,
      ),
      (
        icon: Icons.translate_rounded,
        title: l10n.onboardingSlide3Title,
        body: l10n.onboardingSlide3Body,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: _finish,
                child: Text(l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slideCount,
                onPageChanged: (int i) => setState(() => _index = i),
                itemBuilder: (BuildContext context, int i) {
                  final slide = slides[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BrandBadge(icon: slide.icon, size: 116),
                        const SizedBox(height: 24),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(_slideCount, (int i) {
                return Semantics(
                  label: l10n.onboardingPageIndicator(i + 1, _slideCount),
                  selected: _index == i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _index == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _index == i
                          ? palette.primary
                          : palette.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: AppGradientButton(
                label: _index < _slideCount - 1
                    ? l10n.onboardingNext
                    : l10n.onboardingGetStarted,
                onPressed: () {
                  if (_index < _slideCount - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } else {
                    unawaited(_finish());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
