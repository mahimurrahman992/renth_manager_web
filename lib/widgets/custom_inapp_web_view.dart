import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DynamicWebViewScreen extends StatefulWidget {
  final String initialUrl;

  const DynamicWebViewScreen({
    super.key,
    required this.initialUrl,
  });

  @override
  State<DynamicWebViewScreen> createState() => _DynamicWebViewScreenState();
}

class _DynamicWebViewScreenState extends State<DynamicWebViewScreen> {
  InAppWebViewController? _webViewController;

  String _pageTitle = 'Loading...';
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _webViewController?.reload(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Linear progress indicator while page loads
          if (_progress < 1.0)
            LinearProgressIndicator(value: _progress),

          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(widget.initialUrl),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              // Dynamics 1: Update title as soon as HTML title tag changes
              onTitleChanged: (controller, title) {
                if (title != null && title.isNotEmpty) {
                  setState(() {
                    _pageTitle = title;
                  });
                }
              },
              // Dynamics 2: Fallback title grab when loading completes
              onLoadStop: (controller, url) async {
                final title = await controller.getTitle();
                if (title != null && title.isNotEmpty) {
                  setState(() {
                    _pageTitle = title;
                  });
                }
              },
              // Updates progress bar
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}