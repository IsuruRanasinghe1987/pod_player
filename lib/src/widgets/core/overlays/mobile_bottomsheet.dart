part of 'package:pod_player/src/pod_player.dart';

class _MobileBottomSheet extends StatelessWidget {

  const _MobileBottomSheet();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PodGetXVideoController>(
      builder: (podCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (podCtr.vimeoOrVideoUrls.isNotEmpty)
            _bottomSheetTiles(
              title: podCtr.podPlayerLabels.quality,
              icon: Icons.video_settings_rounded,
              subText: '${podCtr.vimeoPlayingVideoQuality}p',
              onTap: () {
                Navigator.of(context).pop();
                Timer(const Duration(milliseconds: 100), () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => const SafeArea(
                      child: _VideoQualitySelectorMob(
                        onTap: null,
                      ),
                    ),
                  );
                });
                // await Future.delayed(
                //   const Duration(milliseconds: 100),
                // );
              },
            ),
          _bottomSheetTiles(
            title: podCtr.podPlayerLabels.loopVideo,
            icon: Icons.loop_rounded,
            subText: podCtr.isLooping
                ? podCtr.podPlayerLabels.optionEnabled
                : podCtr.podPlayerLabels.optionDisabled,
            onTap: () {
              Navigator.of(context).pop();
              podCtr.toggleLooping();
            },
          ),
          _bottomSheetTiles(
            title: podCtr.podPlayerLabels.playbackSpeed,
            icon: Icons.slow_motion_video_rounded,
            subText: podCtr.currentPaybackSpeed,
            onTap: () {
              Navigator.of(context).pop();
              Timer(const Duration(milliseconds: 100), () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const SafeArea(
                    child: _VideoPlaybackSelectorMob(
                      onTap: null,
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  ListTile _bottomSheetTiles({
    required String title,
    required IconData icon,
    String? subText,
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      onTap: onTap,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              title,
            ),
            if (subText != null) const SizedBox(width: 6),
            if (subText != null)
              const SizedBox(
                height: 4,
                width: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (subText != null) const SizedBox(width: 6),
            if (subText != null)
              Text(
                subText,
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class _VideoQualitySelectorMob extends StatelessWidget {
  final void Function()? onTap;

  const _VideoQualitySelectorMob({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: podCtr.vimeoOrVideoUrls
            .map(
              (e) => ListTile(
                title: Text('${e.quality}p'),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();

                  podCtr.changeVideoQuality(e.quality);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _VideoPlaybackSelectorMob extends StatelessWidget {
  final void Function()? onTap;

  const _VideoPlaybackSelectorMob({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: podCtr.videoPlaybackSpeeds
            .map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();
                  podCtr.setVideoPlayBack(e);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MobileOverlayBottomControlles extends StatelessWidget {

  const _MobileOverlayBottomControlles();

  @override
  Widget build(BuildContext context) {
    const durationTextStyle = TextStyle(color: Colors.white70);
    const itemColor = Colors.white;

    return GetBuilder<PodGetXVideoController>(
      id: 'full-screen',
      builder: (podCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              GetBuilder<PodGetXVideoController>(
                id: 'video-progress',
                builder: (podCtr) {
                  return Row(
                    children: [
                      Text(
                        podCtr.calculateVideoDuration(podCtr.videoPosition),
                        style: const TextStyle(color: itemColor),
                      ),
                      const Text(
                        ' / ',
                        style: durationTextStyle,
                      ),
                      Text(
                        podCtr.calculateVideoDuration(podCtr.videoDuration),
                        style: durationTextStyle,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              MaterialIconButton(
                toolTipMesg: podCtr.isFullScreen
                    ? podCtr.podPlayerLabels.exitFullScreen ??
                        'Exit full screen${kIsWeb ? ' (f)' : ''}'
                    : podCtr.podPlayerLabels.fullscreen ??
                        'Fullscreen${kIsWeb ? ' (f)' : ''}',
                color: itemColor,
                onPressed: () {
                  if (podCtr.isOverlayVisible) {
                    if (podCtr.isFullScreen) {
                      podCtr.disableFullScreen(context);
                    } else {
                      podCtr.enableFullScreen();
                    }
                  } else {
                    podCtr.toggleVideoOverlay();
                  }
                },
                child: Icon(
                  podCtr.isFullScreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                ),
              ),
            ],
          ),
          GetBuilder<PodGetXVideoController>(
            id: 'overlay',
            builder: (podCtr) {
              if (podCtr.isFullScreen) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  child: Visibility(
                    visible: podCtr.isOverlayVisible,
                    child: PodProgressBar(
                      alignment: Alignment.topCenter,
                      podProgressBarConfig: podCtr.podProgressBarConfig,
                    ),
                  ),
                );
              }
              return PodProgressBar(
                alignment: Alignment.bottomCenter,
                podProgressBarConfig: podCtr.podProgressBarConfig,
              );
            },
          ),
        ],
      ),
    );
  }
}
