import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/home/home.dart';

class homePage extends StatelessWidget {
  const homePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.share,
                  color: AppTheme.icon_color, size: AppTheme.icon_size),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const CircularProgressIndicator();
            } else if (state is HomeLoaded) {
              return Column(
                children: [
                  TitleWidget(
                    title: state.home.title,
                  ),
                ],
              );
            }
          },
        ));
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
            fontSize: AppTheme.header_font_size,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
