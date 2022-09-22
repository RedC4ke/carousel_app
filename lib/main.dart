import 'dart:math';

import 'package:carousel_app/carousel_card.dart';
import 'package:carousel_app/cubit/carousel_cubit.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => CarouselCubit(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _carouselController = PageController(viewportFraction: 0.6);

  @override
  void initState() {
    super.initState();
    final carouselCubit = context.read<CarouselCubit>();
    _carouselController.addListener(() {
      final page = _carouselController.page?.round();
      if (page == null) return;
      if (carouselCubit.state.selectedCardIndex != page) {
        carouselCubit.selectCard(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carousel app"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const SizedBox(height: 36),
                ExpandablePageView.builder(
                  controller: _carouselController,
                  // allows our shadow to be displayed outside of widget bounds
                  clipBehavior: Clip.none,
                  itemCount: 3,
                  itemBuilder: (_, index) {
                    if (!_carouselController.position.haveDimensions) {
                      return const SizedBox();
                    }

                    return AnimatedBuilder(
                      animation: _carouselController,
                      builder: (_, __) => Transform.scale(
                        scale: max(
                          0.8,
                          (1 - (_carouselController.page! - index).abs() / 2),
                        ),
                        child: CarouselCard(
                          icon: Icons.bolt_outlined,
                          label: 'Power',
                          index: index,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SmoothPageIndicator(
                  controller: _carouselController,
                  count: 3,
                  effect: SwapEffect(
                    dotColor: Colors.grey.shade300,
                    activeDotColor: Colors.blue.shade300,
                    dotHeight: 8,
                    dotWidth: 32,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
