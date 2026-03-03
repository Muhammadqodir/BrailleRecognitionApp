import 'package:braillerecognition/features/home/presentation/widgets/home_appbar.dart';
import 'package:braillerecognition/features/home/presentation/widgets/translate_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showShadow = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 0;
      if (shouldShow != showShadow) {
        setState(() => showShadow = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(showShadow: showShadow),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                //get history again
              },
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 8),
                TranslateOptions(
                  selectedLanguage: "English (GR1)",
                  onLanguageTap: () {},
                  onCameraTap: () {},
                  onImportTap: () {},
                  onKeyboardTap: () {},
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "History",
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontFamily: "PoppinBold"),
                            ),
                          ),
                          CupertinoButton(
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "See more",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            onPressed: () {
                              // Navigate to history page
                            },
                          ),
                        ],
                      ),
                      //Build history list here
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
