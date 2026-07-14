import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class CheckoutPaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;

  const CheckoutPaymentWebViewScreen({super.key, required this.checkoutUrl});

  @override
  State<CheckoutPaymentWebViewScreen> createState() =>
      _CheckoutPaymentWebViewScreenState();
}

class _CheckoutPaymentWebViewScreenState
    extends State<CheckoutPaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.checkoutUrl.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop(false);
      });
      return;
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            final url = request.url.toLowerCase();
            if (_isSuccessUrl(url)) {
              Navigator.of(context).pop(true);
              return NavigationDecision.prevent;
            }
            if (_isCancelUrl(url)) {
              Navigator.of(context).pop(false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  bool _isSuccessUrl(String url) {
    return url.contains('success') ||
        url.contains('paid=true') ||
        url.contains('payment_status=paid');
  }

  bool _isCancelUrl(String url) {
    return url.contains('cancel') ||
        url.contains('canceled') ||
        url.contains('payment_status=cancel');
  }

  Future<void> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checkoutUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.darkColor,
        appBar: AppBar(
          backgroundColor: AppColors.darkColor,
          leading: IconButton(
            onPressed: _handleBack,
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          title: Text('Payment', style: TextStyles.font18WhiteColor700),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              LinearProgressIndicator(
                color: AppColors.primaryColor,
                backgroundColor: AppColors.greyColorColor79,
              ),
          ],
        ),
      ),
    );
  }
}
