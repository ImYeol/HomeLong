import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

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
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TitleWidget(
                      title: state.home.title,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TimerDisplay(),
                    SizedBox(
                      height: 20,
                    ),
                    DateDisplay(),
                    SizedBox(
                      height: 20,
                    ),
                    DetailsSubTitle(),
                    SizedBox(
                      height: 20,
                    ),
                    AverageTimeDisplay()
                  ],
                ),
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

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "00 : 00",
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_big,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DateDisplay extends StatelessWidget {
  const DateDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Monday 25 Jan 2021",
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_middle,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DetailsSubTitle extends StatelessWidget {
  const DetailsSubTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Details",
            style: TextStyle(
                fontSize: AppTheme.subtitle_font_size_small,
                color: AppTheme.font_color,
                fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right,
                color: AppTheme.icon_color, size: AppTheme.icon_size),
            onPressed: () {},
          ),
        ]);
  }
}

class AverageTimeDisplay extends StatelessWidget {
  const AverageTimeDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTitle("Week"),
              SizedBox(
                height: 10,
              ),
              getTimeView(3),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTitle("Month"),
              SizedBox(
                height: 10,
              ),
              getTimeView(30)
            ],
          )
        ],
      ),
    );
  }

  Widget getTitle(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
            fontSize: AppTheme.subtitle_font_size_middle,
            color: AppTheme.font_color,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget getTimeView(double time) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          shape: BoxShape.rectangle),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              time.toString(),
              style: TextStyle(
                  fontSize: AppTheme.subtitle_font_size_big,
                  color: AppTheme.reverse_font_color,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Hour",
              style: TextStyle(
                  fontSize: AppTheme.subtitle_font_size_small,
                  color: AppTheme.reverse_font_color,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ]),
    );
  }
}
