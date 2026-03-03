import 'package:braillerecognition/core/widgets/fade_indexed_stack.dart';
import 'package:braillerecognition/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../bloc/navigation_bloc.dart';
import '../bloc/navigation_event.dart';
import '../bloc/navigation_state.dart';
import '../widgets/custom_bottom_navigation.dart';

/// Main page with bottom navigation bar
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: const _MainPageContent(),
    );
  }
}

class _MainPageContent extends StatelessWidget {
  const _MainPageContent();

  /// List of navigation items
  static final List<NavigationItemData> _navigationItems = [
    const NavigationItemData(
      label: 'Home',
      icon: HugeIcons.strokeRoundedHome01,
    ),
    const NavigationItemData(
      label: 'Favorites',
      icon: HugeIcons.strokeRoundedFavourite,
    ),
    const NavigationItemData(
      label: 'Profile',
      icon: HugeIcons.strokeRoundedUser03,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: _buildBottomNavigationBar(context, state),
          body: FadeIndexedStack(
            index: state.currentIndex,
            children: _buildPages(),
          ),
        );
      },
    );
  }

  /// Builds all pages once and maintains their state
  List<Widget> _buildPages() {
    return [
      HomePage(),
      Container(color: Colors.green),
      Container(color: Colors.blue),
    ];
  }

  /// Builds the bottom navigation bar
  Widget _buildBottomNavigationBar(
    BuildContext context,
    NavigationState state,
  ) {
    return CustomBottomNavigation(
      currentIndex: state.currentIndex,
      onTap: (index) {
        context.read<NavigationBloc>().add(TabSelected(index));
      },
      items: _navigationItems,
    );
  }
}
