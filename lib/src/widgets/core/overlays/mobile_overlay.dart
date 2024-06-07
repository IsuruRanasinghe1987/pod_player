part of 'package:pod_player/src/pod_player.dart';

class _MobileOverlay extends StatelessWidget {

  const _MobileOverlay();

  @override
  Widget build(BuildContext context) {
    const overlayColor = Colors.black38;
    const itemColor = Colors.white;
    final podCtr = Get.find<PodGetXVideoController>();
    return Stack(
      alignment: Alignment.center,
      children: [
        _VideoGestureDetector(
          child: ColoredBox(
            color: overlayColor,
            child: Row(
              children: [
                Expanded(
                  child: DoubleTapIcon(
                    isForward: false,
                    height: double.maxFinite,
                    onDoubleTap: _isRtl()
                        ? podCtr.onRightDoubleTap
                        : podCtr.onLeftDoubleTap,
                  ),
                ),
                const SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: _AnimatedPlayPauseIcon( size: 42),
                  ),
                ),
                Expanded(
                  child: DoubleTapIcon(
                    isForward: true,
                    height: double.maxFinite,
                    onDoubleTap: _isRtl()
                        ? podCtr.onLeftDoubleTap
                        : podCtr.onRightDoubleTap,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: IgnorePointer(
                  child: podCtr.videoTitle ?? const SizedBox(),
                ),
              ),
              MaterialIconButton(
                toolTipMesg: podCtr.podPlayerLabels.settings,
                color: itemColor,
                onPressed: () {
                  if (podCtr.isOverlayVisible) {
                    _bottomSheet(context);
                  } else {
                    podCtr.toggleVideoOverlay();
                  }
                },
                child: const Icon(
                  Icons.more_vert_rounded,
                ),
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: _MobileOverlayBottomControlles(),
        ),
      ],
    );
  }

  bool _isRtl() {
    final Locale locale = WidgetsBinding.instance.platformDispatcher.locale;
    final langs = [
      'ar', // Arabic
      'fa', // Farsi
      'he', // Hebrew
      'ps', // Pashto
      'ur', // Urdu
    ];
    for (int i = 0; i < langs.length; i++) {
      final lang = langs[i];
      if (locale.toString().contains(lang)) {
        return true;
      }
    }
    return false;
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const SafeArea(child: _MobileBottomSheet()),
    );
  }
}
