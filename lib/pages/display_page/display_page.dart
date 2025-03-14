import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:SteadyEye/general/app_localizations.dart';
import 'package:SteadyEye/pages/display_page/wigdt/bookmark_manager.dart';
import 'package:SteadyEye/pages/display_page/wigdt/scroll_controls.dart';
import 'package:SteadyEye/pages/display_page/wigdt/scrolling_text_view.dart';
import '../../general/app_setting_provider.dart';
import '../../general/document_provider.dart';
import '../../general/navbar_with_return_button.dart';
import 'wigdt/draggable_button.dart';

class DisplayPage extends StatefulWidget {
  final String title;
  final String? documentName;

  const DisplayPage({super.key, required this.title, this.documentName});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late double xPos;
  late double yPos;
  double textOffset = 0;

  late ScrollController _scrollController;
  double _bookmarkedPosition = 0.0;
  bool _isRestored = false;

  // GlobalKeys for tutorial targets.
  final GlobalKey _scrollControlsKey = GlobalKey();
  final GlobalKey _draggableButtonKey = GlobalKey();
  final GlobalKey _bookmarkKey = GlobalKey();

  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.documentName != null) {
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      if (!documentProvider.loading) {
        _restoreBookmarkPosition();
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final settings = Provider.of<AppSettingProvider>(context, listen: false);
      final buttonSize = settings.fontSize * 2;

      setState(() {
        if (settings.xPos != 0 && settings.yPos != 0) {
          xPos = settings.xPos;
          yPos = settings.yPos;
        } else {
          xPos = (screenWidth / 2) - (buttonSize / 2);
          yPos = (screenHeight / 2) - (buttonSize / 2);
          settings.setXPos(xPos);
          settings.setYPos(yPos);
        }
      });

      _showTutorialIfNeeded();
    });
  }

  Future<void> _restoreBookmarkPosition() async {
    if (widget.documentName == null || _isRestored) return;
    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    if (documentProvider.loading) return;

    List<Map<String, dynamic>> bookmarks = await documentProvider.getBookmarks(widget.documentName!);
    if (bookmarks.isEmpty) return;

    double savedPosition = bookmarks.last['position'];

    setState(() {
      _bookmarkedPosition = savedPosition;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_bookmarkedPosition);
        _isRestored = true;
      }
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('displayPageTutorialShown') ?? false;
    if (!hasShown) {
      _showTutorial();
      await prefs.setBool('displayPageTutorialShown', true);
    }
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      alignSkip: Alignment.topRight,
      onFinish: () {
        debugPrint('Tutorial finished');
        return true;
      },
      onSkip: () {
        debugPrint('Tutorial skipped');
        return true;
      },
    );
    tutorialCoachMark?.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "ScrollControls",
        keyTarget: _scrollControlsKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildTooltip(
              context.tr('scrollControlsTitle'),
              context.tr('scrollControlsInstructions'),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "DraggableButton",
        keyTarget: _draggableButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildTooltip(
              context.tr('fixationPointTitle'),
              context.tr('fixationPointInstructions'),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "BookmarkManager",
        keyTarget: _bookmarkKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        paddingFocus: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTooltip(
              context.tr('bookmarkTitle'),
              context.tr('bookmarkInstructions'),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildTooltip(String title, String description) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.black.withOpacity(0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: settings.fontSize, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(color: Colors.white, fontSize: settings.fontSize),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    final buttonSize = settings.fontSize * 2;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = settings.fontSize;
    double buttonIconsSize = settings.buttonIconsSize;
    Color backgroundColor = settings.backgroundColor;

    if (screenWidth < 1000) {
      fontSize = settings.fontSize > 40 ? 40 : settings.fontSize;
      buttonIconsSize = settings.buttonIconsSize > 60 ? 60 : settings.buttonIconsSize;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: NavbarWithReturnButton(fontSize: fontSize, buttonIconsSize: buttonIconsSize),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;
            return Stack(
              children: [
                Positioned.fill(
                  child: ScrollingTextView(
                    text: widget.title,
                    textOffset: textOffset,
                    scrollController: _scrollController,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    key: _scrollControlsKey,
                    child: ScrollControls(),
                  ),
                ),
                Positioned(
                  left: xPos,
                  top: yPos,
                  child: DraggableButton(
                    key: _draggableButtonKey,
                    xPos: xPos,
                    yPos: yPos,
                    onPositionChanged: (dx, dy) {
                      setState(() {
                        xPos += dx;
                        yPos += dy;
                        final minX = 0.0;
                        final maxX = availableWidth - buttonSize;
                        final minY = 0.0;
                        final maxY = availableHeight - buttonSize;
                        double currentYPos = yPos;
                        xPos = xPos.clamp(minX, maxX);
                        yPos = yPos.clamp(minY, maxY);
                        settings.setXPos(xPos);
                        settings.setYPos(yPos);
                        final textMiddleY = availableHeight / 2;
                        if (currentYPos > textMiddleY) {
                          textOffset = -60;
                        } else if (currentYPos < textMiddleY - 40) {
                          textOffset = 60;
                        } else {
                          textOffset = 0;
                        }
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BookmarkManager(
                      key: _bookmarkKey,
                      documentName: widget.documentName,
                      scrollController: _scrollController,
                      onBookmarkPressed: () {
                        _setToPause();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    tutorialCoachMark = null;
    super.dispose();
  }

  void _setToPause() {
    final settings = Provider.of<AppSettingProvider>(context, listen: false);
    if (!settings.isPaused) {
      settings.togglePause();
    }
  }
}
