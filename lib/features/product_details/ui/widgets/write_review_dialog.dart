import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class WriteReviewDialog extends StatefulWidget {
  final Future<String?> Function({
    required int rating,
    required String title,
    required String comment,
  })
  onSubmit;

  const WriteReviewDialog({super.key, required this.onSubmit});

  @override
  State<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  int rating = 4;
  bool isLoading = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final title = titleController.text.trim();
    final comment = reviewController.text.trim();
    if (title.isEmpty || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter review title and comment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    final errorMessage = await widget.onSubmit(
      rating: rating,
      title: title,
      comment: comment,
    );
    if (!mounted) return;
    setState(() => isLoading = false);

    if (errorMessage == null) {
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Write a Review",
                    style: TextStyles.font24InterW700.copyWith(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.white, size: 24.sp),
                  ),
                ],
              ),
              verticalSpace(12),
              const Divider(color: Colors.white24, thickness: 1),
              verticalSpace(20),
              Text(
                "Your Rating",
                style: TextStyles.font14W600.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              verticalSpace(12),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => rating = index + 1),
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFFD700),
                        size: 28.sp,
                      ),
                    ),
                  );
                }),
              ),
              verticalSpace(24),
              Text(
                "Review Title",
                style: TextStyles.font14W600.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              verticalSpace(12),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "e.g., Best experience ever!",
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFCDDC39)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFCDDC39),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              verticalSpace(24),
              Text(
                "Your Review",
                style: TextStyles.font14W600.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              verticalSpace(12),
              TextField(
                controller: reviewController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Tell us more about your experience...",
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFCDDC39)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFCDDC39),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              verticalSpace(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 20.w,
                      ),
                      minimumSize: Size(80.w, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: const Color(0xFF757575),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  TextButton(
                    onPressed: isLoading ? null : _submitReview,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFCDDC39),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 20.w,
                      ),
                      minimumSize: Size(120.w, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            "Submit Review",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
