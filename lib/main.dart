import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_application/counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CounterBloc()..add(CounterIncEvent());
    return BlocProvider<CounterBloc>(
      create: (context) => bloc,
      child: Scaffold(
        body: Center(
          child: BlocBuilder<CounterBloc, int>(
              bloc: bloc,
              builder: (context, state) {
                return Text(
                  state.toString(),
                  style: const TextStyle(fontSize: 33),
                );
              }),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  bloc.add(CounterIncEvent());
                },
                icon: const Icon(Icons.plus_one)),
            IconButton(
              onPressed: () {
                bloc.add(CounterDecEvent());
              },
              icon: const Icon(Icons.exposure_minus_1),
            ),
          ],
        ),
      ),
    );
  }
}
