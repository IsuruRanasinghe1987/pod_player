part of 'package:pod_player/src/pod_player.dart';

class _WebOverlay extends StatelessWidget {
  const _WebOverlay();

  @override
  Widget build(BuildContext context) {
    const overlayColor = Colors.black38;
    final podCtr = Get.find<PodGetXVideoController>();
    return Stack(
      children: [
        Positioned.fill(
          child: _VideoGestureDetector(
            onTap: podCtr.togglePlayPauseVideo,
            onDoubleTap: () => podCtr.toggleFullScreenOnWeb(context),
            child: const ColoredBox(
              color: overlayColor,
              child: SizedBox.expand(),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: _WebOverlayBottomControlles(
          ),
        ),
        Positioned.fill(
          child: GetBuilder<PodGetXVideoController>(
            id: 'double-tap',
            builder: (podCtr) {
              return Row(
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: DoubleTapIcon(
                        onDoubleTap: () {},
                        isForward: false,
                        iconOnly: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IgnorePointer(
                      child: DoubleTapIcon(
                        onDoubleTap: () {},
                        isForward: true,
                        iconOnly: true,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        IgnorePointer(child: podCtr.videoTitle ?? const SizedBox()),
      ],
    );
  }
}

class _WebOverlayBottomControlles extends StatelessWidget {

  const _WebOverlayBottomControlles();

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>();
    const durationTextStyle = TextStyle(color: Colors.white70);
    const itemColor = Colors.white;

    return MouseRegion(
      onHover: (event) => podCtr.onOverlayHover(),
      onExit: (event) => podCtr.onOverlayHoverExit(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PodProgressBar(
              podProgressBarConfig: podCtr.podProgressBarConfig,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const _AnimatedPlayPauseIcon(),
                        GetBuilder<PodGetXVideoController>(
                          id: 'volume',
                          builder: (podCtr) => MaterialIconButton(
                            toolTipMesg: podCtr.isMute
                                ? podCtr.podPlayerLabels.unmute ??
                                    'Unmute${kIsWeb ? ' (m)' : ''}'
                                : podCtr.podPlayerLabels.mute ??
                                    'Mute${kIsWeb ? ' (m)' : ''}',
                            color: itemColor,
                            onPressed: podCtr.toggleMute,
                            child: Icon(
                              podCtr.isMute
                                  ? Icons.volume_off_rounded
                                  : Icons.volume_up_rounded,
                            ),
                          ),
                        ),
                        GetBuilder<PodGetXVideoController>(
                          id: 'video-progress',
                          builder: (podCtr) {
                            return Row(
                              children: [
                                Text(
                                  podCtr.calculateVideoDuration(
                                    podCtr.videoPosition,
                                  ),
                                  style: durationTextStyle,
                                ),
                                const Text(
                                  ' / ',
                                  style: durationTextStyle,
                                ),
                                Text(
                                  podCtr.calculateVideoDuration(
                                    podCtr.videoDuration,
                                  ),
                                  style: durationTextStyle,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        const _WebSettingsDropdown(),
                        MaterialIconButton(
                          toolTipMesg: podCtr.isFullScreen
                              ? podCtr.podPlayerLabels.exitFullScreen ??
                                  'Exit full screen${kIsWeb ? ' (f)' : ''}'
                              : podCtr.podPlayerLabels.fullscreen ??
                                  'Fullscreen${kIsWeb ? ' (f)' : ''}',
                          color: itemColor,
                          onPressed: () => _onFullScreenToggle(podCtr, context),
                          child: Icon(
                            podCtr.isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onFullScreenToggle(
    PodGetXVideoController podCtr,
    BuildContext context,
  ) {
    if (podCtr.isOverlayVisible) {
      if (podCtr.isFullScreen) {
        if (kIsWeb) {
          uni_html.document.exitFullscreen();
          podCtr.disableFullScreen(context);
          return;
        } else {
          podCtr.disableFullScreen(context);
        }
      } else {
        if (kIsWeb) {
          uni_html.document.documentElement?.requestFullscreen();
          podCtr.enableFullScreen();
          return;
        } else {
          podCtr.enableFullScreen();
        }
      }
    } else {
      podCtr.toggleVideoOverlay();
    }
  }
}
