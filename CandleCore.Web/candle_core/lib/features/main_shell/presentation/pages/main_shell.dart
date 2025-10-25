import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/bottom_nav_bar.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with AutomaticKeepAliveClientMixin {
  late final PageStorageBucket _pageStorageBucket;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageStorageBucket = PageStorageBucket();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: PageStorage(
        bucket: _pageStorageBucket,
        child: _buildBodyWithErrorBoundary(),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: const BottomNavBar(),
        ),
      ),
    );
  }

  Widget _buildBodyWithErrorBoundary() {
    return ErrorBoundary(
      child: widget.child,
      onError: (error, stackTrace) {
        debugPrint('MainShell error: $error');
        debugPrint('Stack trace: $stackTrace');
      },
    );
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final void Function(Object error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorWidget();
    }

    return widget.child;
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please try again or restart the app',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(ErrorBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _error = null;
    }
  }
}
