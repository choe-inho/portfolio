import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/animation/Portfolio_Indicator.dart';
import '../../util/config/App_Constants.dart';
import '../../util/config/Font_Sizes.dart';

/// 로딩 상태
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, required this.loading});
  final String loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final fontSizes = FontSizes.of(context);
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(constants.largePadding(context) * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PortfolioLoadingIndicator(
              style: IndicatorStyle.codingAnimation,
              size: constants.defaultIndicatorSize(context),
            ),
            SizedBox(height: constants.spacingL),
            Text(
              loading,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: fontSizes.bodyLarge(context)
              ),
            ),
          ],
        ),
      ),
    );
  }
}