import 'package:flutter/material.dart';

import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/app_radius.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';

/// A single promotional slide's content.
class _Promo {
  const _Promo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
}

/// Swipeable hero carousel of promotional offer cards at the top of Home.
///
/// Purely presentational (demo showcase) — the CTA scrolls the catalog into
/// view rather than deep-linking a campaign.
class HomePromoBanner extends StatefulWidget {
  /// Creates the promo carousel.
  const HomePromoBanner({super.key});

  @override
  State<HomePromoBanner> createState() => _HomePromoBannerState();
}

class _HomePromoBannerState extends State<HomePromoBanner> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    final List<_Promo> promos = <_Promo>[
      _Promo(
        title: l10n.homeBannerSaleTitle,
        subtitle: l10n.homeBannerSaleSubtitle,
        icon: Icons.local_fire_department_rounded,
        gradient: <Color>[palette.primary, palette.secondary],
      ),
      _Promo(
        title: l10n.homeBannerShippingTitle,
        subtitle: l10n.homeBannerShippingSubtitle,
        icon: Icons.local_shipping_rounded,
        gradient: <Color>[palette.secondary, palette.accent],
      ),
      _Promo(
        title: l10n.homeBannerFreshTitle,
        subtitle: l10n.homeBannerFreshSubtitle,
        icon: Icons.auto_awesome_rounded,
        gradient: <Color>[palette.accent, palette.primary],
      ),
    ];

    return Semantics(
      container: true,
      label: l10n.homeBannerCarouselA11y,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: SizedBox(
              height: 148,
              child: PageView.builder(
                controller: _controller,
                itemCount: promos.length,
                onPageChanged: (int i) => setState(() => _index = i),
                itemBuilder: (BuildContext context, int i) =>
                    _PromoCard(promo: promos[i], ctaLabel: l10n.homeBannerCta),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _Dots(count: promos.length, index: _index, palette: palette),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo, required this.ctaLabel});

  final _Promo promo;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final onGradient = palette.onAccent; // dark ink reads on all brand hues

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: HomeSpacing.chipGap + 2),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brXl,
        gradient: LinearGradient(
          colors: promo.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: promo.gradient.first.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  promo.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: onGradient,
                        fontWeight: FontWeight.w800,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  promo.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: onGradient.withValues(alpha: 0.85),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: palette.surfaceElevated,
                    borderRadius: AppRadius.brPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        ctaLabel,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: palette.primary),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: palette.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(promo.icon, size: 56, color: onGradient.withValues(alpha: 0.9)),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.index,
    required this.palette,
  });

  final int count;
  final int index;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int i) {
        final bool active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: active ? 20 : 6,
          decoration: BoxDecoration(
            color: active
                ? palette.primary
                : palette.muted.withValues(alpha: 0.4),
            borderRadius: AppRadius.brPill,
          ),
        );
      }),
    );
  }
}
