import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/screen/model/bottomNavigationState.dart';
import 'package:homg_long/screen/bloc/bottomNavigationCubit.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
            builder: (context, state) {
          if (state is PageLoading) {
            context.watch<BottomNavigationCubit>().init(context);
            return Center(child: CircularProgressIndicator());
          } else if (state is HomePageLoaded) {
            return state.widget;
          } else if (state is RankPageLoaded) {
            return state.widget;
          } else if (state is SettingPageLoaded) {
            return state.widget;
          } else {
            return Container();
          }
        }),
        bottomNavigationBar: _buildOriginDesign(context));
  }

  Widget _buildOriginDesign(BuildContext context) {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Theme.of(context).focusColor,
      strokeColor: Colors.white,
      unSelectedColor: Theme.of(context).disabledColor,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      bubbleCurve: Curves.linear,
      opacity: 1.0,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          selectedTitle: Text("Home"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.people),
          selectedTitle: Text("Rank"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.settings),
          selectedTitle: Text("Setting"),
        ),
      ],
      currentIndex: context.watch<BottomNavigationCubit>().currentPage,
      onTap: (index) => context.read<BottomNavigationCubit>().dispatch(index),
    );
  }
}
