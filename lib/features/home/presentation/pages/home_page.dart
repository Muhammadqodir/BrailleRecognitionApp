import 'package:braillerecognition/core/dialogs/select_dialog.dart';
import 'package:braillerecognition/features/home/domain/entities/language.dart';
import 'package:braillerecognition/features/home/presentation/bloc/language_bloc.dart';
import 'package:braillerecognition/features/home/presentation/bloc/language_event.dart';
import 'package:braillerecognition/features/home/presentation/bloc/language_state.dart';
import 'package:braillerecognition/features/home/presentation/widgets/home_appbar.dart';
import 'package:braillerecognition/features/home/presentation/widgets/translate_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _onLanguageTap(BuildContext context, List<Language> langs, Language? selected) async {
    print("test");
    final int initialIndex = selected != null
        ? langs.indexWhere((l) => l.id == selected.id).clamp(0, langs.length - 1)
        : 0;

    final Language? result = await showSelectLangDialog<Language>(
      langs: langs,
      selectedIndex: initialIndex,
      context: context,
      labelBuilder: (lang) => lang.name,
    );

    if (result != null && context.mounted) {
      context.read<LanguageBloc>().add(SelectLanguage(result.id));
    }
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
                BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {
                    final langs = state is LanguageLoaded ? state.languages : <Language>[];
                    final selected = state is LanguageLoaded ? state.selectedLanguage : null;
                    final label = selected?.name ?? 'Select Language';

                    return TranslateOptions(
                      selectedLanguage: label,
                      onLanguageTap: () => _onLanguageTap(context, langs, selected),
                      onCameraTap: () {},
                      onImportTap: () {},
                      onKeyboardTap: () {},
                    );
                  },
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
