import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_application/counter_bloc.dart';
import 'package:flutter_bloc_application/user_bloc/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = CounterBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
          create: (context) => counterBloc,
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(counterBloc),
        ),
      ],
      child: Builder(builder: (context) {
        final counterBloc = BlocProvider.of<CounterBloc>(context);
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  BlocBuilder<CounterBloc, int>(
                    builder: (context, state) {
                      final users =
                          context.select((UserBloc bloc) => bloc.state.users);
                      return Column(
                        children: [
                          Text(
                            state.toString(),
                            style: const TextStyle(fontSize: 33),
                          ),
                          if (users.isNotEmpty)
                            ...users.map((e) => Text(e.name)),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      final job = state.job;
                      return Column(
                        children: [
                          if (state.isLoading)
                            const CircularProgressIndicator(),
                          if (job.isNotEmpty) ...job.map((e) => Text(e.name))
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    counterBloc.add(CounterIncEvent());
                  },
                  icon: const Icon(Icons.plus_one)),
              IconButton(
                onPressed: () {
                  counterBloc.add(CounterDecEvent());
                },
                icon: const Icon(Icons.exposure_minus_1),
              ),
              IconButton(
                onPressed: () {
                  final userBloc = context.read<UserBloc>();
                  userBloc.add(
                      UserGetUsersEvent(counterBloc.state));
                },
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {
                  final userBloc = context.read<UserBloc>();
                  userBloc.add(
                      UserGetUsersJobEvent(counterBloc.state));
                },
                icon: const Icon(Icons.work),
              ),
            ],
          ),
        );
      }),
    );
  }
}
