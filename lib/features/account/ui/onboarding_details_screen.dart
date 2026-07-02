import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/login_and_signup/data/models/get_onboarding_step_response.dart';
import 'package:willizo/features/login_and_signup/data/repo/login_and_signup_repo.dart';

class OnboardingDetailsScreen extends StatefulWidget {
  const OnboardingDetailsScreen({super.key});

  @override
  State<OnboardingDetailsScreen> createState() =>
      _OnboardingDetailsScreenState();
}

class _OnboardingDetailsScreenState extends State<OnboardingDetailsScreen> {
  late Future<GetOnboardingStepResponseModel?> _statusFuture;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _statusFuture = _loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: FutureBuilder<GetOnboardingStepResponseModel?>(
          future: _statusFuture,
          builder: (context, snapshot) {
            final data = snapshot.data?.data;
            return Padding(
              padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
              child: Column(
                children: [
                  _Header(hasChanges: _hasChanges),
                  verticalSpace(22),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  else if (data == null)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Failed to load details',
                          style: TextStyles.font14whiteColorColorW400,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: data.totalSteps,
                        separatorBuilder: (_, __) => verticalSpace(10),
                        itemBuilder: (context, index) {
                          final stepNumber = index + 1;
                          return _StepRow(
                            stepNumber: stepNumber,
                            title: OnboardingStepPresenter.title(stepNumber),
                            value: OnboardingStepPresenter.summary(
                              data.answerForStep(stepNumber),
                            ),
                            onTap: () async {
                              await context.pushNamed(
                                Routes.getStepRoute(stepNumber),
                                arguments: {'isEditing': true},
                              );
                              if (!context.mounted) return;
                              setState(() {
                                _hasChanges = true;
                                _statusFuture = _loadStatus();
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<GetOnboardingStepResponseModel?> _loadStatus() async {
    final result = await getIt<LoginAndSignupRepo>().getOnboardingStatus();
    return result.fold((_) => null, (response) => response);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.hasChanges});

  final bool hasChanges;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context, hasChanges),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
              size: 20.r,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Your Details',
            textAlign: TextAlign.center,
            style: TextStyles.font24WhiteColorW700,
          ),
        ),
        SizedBox(width: 34.r),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.stepNumber,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final int stepNumber;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.greyColor27,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 34.r,
              height: 34.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$stepNumber',
                style: TextStyles.font14BlackColorW700,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.font16WhiteColorW600),
                  verticalSpace(4),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorColor79W400.copyWith(
                      color: AppColors.greyColorColorA0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.primaryColor,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingStepPresenter {
  static const Map<int, String> _titles = {
    1: 'Name',
    2: 'Age',
    3: 'Gender',
    4: 'Height',
    5: 'Weight',
    6: 'Target weight',
    7: 'Primary goal',
    8: 'Workout days',
    9: 'Experience level',
    10: 'Workout place',
    11: 'Activity level',
    12: 'Health issues',
    13: 'Best workout time',
    14: 'Dietary restrictions',
    15: 'Food allergies',
    16: 'Disliked foods',
    17: 'Meals per day',
    18: 'Gym machines',
    19: 'Free weights',
    20: 'Supportive tools',
    21: 'Where did you hear about us',
  };

  static String title(int stepNumber) {
    return _titles[stepNumber] ?? 'Step $stepNumber';
  }

  static String summary(Map<String, dynamic>? answer) {
    if (answer == null || answer.isEmpty) return 'Not answered';

    final values = <String>[];
    for (final entry in answer.entries) {
      final value = entry.value;
      if (value == null) continue;
      if (value is List && value.isEmpty) continue;
      values.add(_formatValue(value));
    }

    if (values.isEmpty) return 'Not answered';
    return values.join(', ');
  }

  static String _formatValue(dynamic value) {
    if (value is List) return value.join(', ');
    if (value is bool) return value ? 'Yes' : 'No';
    return value.toString();
  }
}
