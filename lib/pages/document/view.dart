import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:xlist/common/index.dart';
import 'package:xlist/helper/index.dart';
import 'package:xlist/pages/document/index.dart';
// 原导入方式错误，修改为导入主库文件
// import 'package:xlist/routes/app_routes.dart';
import 'package:xlist/routes/app_pages.dart';

class DocumentPage extends GetView<DocumentController> {
  const DocumentPage({Key? key}) : super(key: key);

  // NavigationBar
  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      border: Border.all(width: 0, color: Colors.transparent),
      leading: CommonUtils.backButton,
      middle: Text(
        CommonUtils.formatFileNme(controller.name),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.download_circle),
            onPressed: () => Get.toNamed(Routes.SETTING_DOWNLOAD),
          ),
        ],
      ),
    );
  }

  // WebView
  Widget _buildInAppWebView() {
    return InAppWebView(
      key: controller.webViewKey,
      initialUrlRequest: URLRequest(
        url: WebUri(controller.object.value.rawUrl ?? ''),
        headers: controller.httpHeaders,
      ),
      initialOptions: controller.options,
      onProgressChanged: controller.onProgressChanged,
      onReceivedServerTrustAuthRequest: (app, challenge) async {
        return ServerTrustAuthResponse(
          action: ServerTrustAuthResponseAction.PROCEED,
        );
      },
      androidOnPermissionRequest: (app, origin, resources) async {
        return PermissionRequestResponse(
          resources: resources,
          action: PermissionRequestResponseAction.GRANT,
        );
      },
      shouldOverrideUrlLoading: (app, navigationAction) async {
        final uri = navigationAction.request.url!;

        /// 过滤掉不需要跳转的链接
        if (!['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about']
            .contains(uri.scheme)) {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
            return NavigationActionPolicy.CANCEL;
          }
        }

        return NavigationActionPolicy.ALLOW;
      },
    );
  }

  // PDF
  Widget _buildPdfView() {
    return Container(
      child: SfPdfViewer.network(
        controller.object.value.rawUrl ?? '',
        headers: controller.httpHeaders.value,
        canShowScrollHead: true,
        canShowPaginationDialog: false,
        canShowPasswordDialog: false,
        canShowHyperlinkDialog: false,
        enableDoubleTapZooming: false,
      ),
    );
  }

  // 页面
  Widget _buildPageInfo() {
    if (controller.isLoading.isTrue) {
      return Center(child: CupertinoActivityIndicator());
    }

    // 根据布局模式调整UI
    final isFullscreen =
        controller.layoutMode.value == DocumentLayoutMode.fullscreen;
    final contentPadding =
        isFullscreen ? EdgeInsets.zero : EdgeInsets.all(16.w);
    final navigationBarHeight = isFullscreen
        ? 0
        : kMinInteractiveDimensionCupertino +
            MediaQuery.of(Get.context!).padding.top;

    // 代码类型
    if (PreviewHelper.isCode(controller.name) &&
        !PreviewHelper.isHtml(controller.name) &&
        controller.codeController != null) {
      return SingleChildScrollView(
        padding: contentPadding,
        child: CodeTheme(
          data: CodeThemeData(
            styles: Get.isDarkMode ? atomOneDarkTheme : atomOneLightTheme,
          ),
          child: CodeField(
            controller: controller.codeController!,
            enabled: false,
            minLines: 40,
            lineNumberStyle: LineNumberStyle(margin: 0.r),
            lineNumbers: false,
          ),
        ),
      );
    }

    // PDF
    if (controller.fileType == 'pdf') return _buildPdfView();

    return Stack(
      children: [
        _buildInAppWebView(),
        controller.progress.value < 1.0
            ? LinearProgressIndicator(
                value: controller.progress.value,
                backgroundColor: Colors.transparent,
                minHeight: 2,
              )
            : SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          controller.layoutMode.value == DocumentLayoutMode.fullscreen
              ? null
              : _buildNavigationBar(),
      child: Obx(() => _buildPageInfo()),
    );
  }
}
