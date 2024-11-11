import 'package:flutter/material.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterNetworkConnectivity flutterNetworkConnectivity =
      FlutterNetworkConnectivity(
    isContinousLookUp:
        true, // optional, false if you cont want continous lookup
    lookUpDuration: const Duration(
        seconds: 5), // optional, to override default lookup duration
    lookUpUrl: 'example.com', // optional, to override default lookup url
  );
  bool messageShowed = false;
  late final WebViewController controller;
  @override
  void initState() {
    startup();
    super.initState();
  }

  void startup() {
    flutterNetworkConnectivity
        .getInternetAvailabilityStream()
        .listen((isInternetAvailable) {
      if (!isInternetAvailable) {
        if (messageShowed == false) {
          Get.snackbar("Ulanish xatosi", "Internet bilan aloqani tekshiring!");
          messageShowed = true;
        }
      } else {
        messageShowed = false;
      }
      // do something
    });
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.virtualgroup.uz/'));
  }

  void builder(context, snapshot) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (await controller.canGoBack()) {
              controller.goBack();
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  @override
  void dispose() {
    flutterNetworkConnectivity.unregisterAvailabilityListener();
    super.dispose();
  }
}
