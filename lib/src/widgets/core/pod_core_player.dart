part of 'package:pod_player/src/pod_player.dart';

class _PodCoreVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoPlayerCtr;
  final double videoAspectRatio;

  const _PodCoreVideoPlayer({
    required this.videoPlayerCtr,
    required this.videoAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>();
    return Builder(
      builder: (ctrx) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode:
              (podCtr.isFullScreen ? FocusNode() : podCtr.keyboardFocusWeb) ??
                  FocusNode(),
          onKey: (value) => podCtr.onKeyBoardEvents(
            event: value,
            appContext: ctrx,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: videoAspectRatio,
                  child: VideoPlayer(videoPlayerCtr),
                ),
              ),
              GetBuilder<PodGetXVideoController>(
                id: 'podVideoState',
                builder: (_) => GetBuilder<PodGetXVideoController>(
                  id: 'video-progress',
                  builder: (podCtr) {
                    if (podCtr.videoThumbnail == null) {
                      return const SizedBox();
                    }

                    if (podCtr.podVideoState == PodVideoState.paused &&
                        podCtr.videoPosition == Duration.zero) {
                      return SizedBox.expand(
                        child: TweenAnimationBuilder<double>(
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          tween: Tween<double>(begin: 0.7, end: 1),
                          duration: const Duration(milliseconds: 400),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: podCtr.videoThumbnail,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const _VideoOverlays(),
              IgnorePointer(
                child: GetBuilder<PodGetXVideoController>(
                  id: 'podVideoState',
                  builder: (podCtr) {
                    final loadingWidget = podCtr.onLoading?.call(context) ??
                        const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );

                    if (kIsWeb) {
                      switch (podCtr.podVideoState) {
                        case PodVideoState.loading:
                          return loadingWidget;
                        case PodVideoState.paused:
                          return const Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          );
                        case PodVideoState.playing:
                          return Center(
                            child: TweenAnimationBuilder<double>(
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              tween: Tween<double>(begin: 1, end: 0),
                              duration: const Duration(seconds: 1),
                              child: const Icon(
                                Icons.pause,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          );
                        case PodVideoState.error:
                          return const SizedBox();
                      }
                    } else {
                      if (podCtr.podVideoState == PodVideoState.loading) {
                        return loadingWidget;
                      }
                      return const SizedBox();
                    }
                  },
                ),
              ),
              if (!kIsWeb)
                GetBuilder<PodGetXVideoController>(
                  id: 'full-screen',
                  builder: (podCtr) => podCtr.isFullScreen
                      ? const SizedBox()
                      : GetBuilder<PodGetXVideoController>(
                          id: 'overlay',
                          builder: (podCtr) => podCtr.isOverlayVisible ||
                                  !podCtr.alwaysShowProgressBar
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: PodProgressBar(
                                    alignment: Alignment.bottomCenter,
                                    podProgressBarConfig:
                                        podCtr.podProgressBarConfig,
                                  ),
                                ),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}
