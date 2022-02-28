import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc.dart';
import 'package:untitled1/cubit.dart';
import 'package:untitled1/repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LoginCubit()),
            BlocProvider(
              create: (_) => AuthenticationBloc(
                profileRepository: ProfileRepository(),
              ),
            ),
          ],
          child: BlocBuilder<LoginCubit, LoginState>(builder: (
            context,
            state,
          ) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.watch<AuthenticationBloc>().state.toString()),
                  if (state.status == Status.init && (context.read<AuthenticationBloc>().state is AuthenticationUnauthenticated || context.read<AuthenticationBloc>().state is AuthenticationUnknown)) ...[
                    TextField(
                      onChanged: (email) =>
                          context.read<LoginCubit>().emailChanged(email),
                    ),
                    TextField(
                      onChanged: (password) =>
                          context.read<LoginCubit>().passwordChanged(password),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LoginCubit>().submitted();
                      },
                      child: const Text('Войти'),
                    ),
                  ],
                  if (state.status == Status.loading) ...[
                    const CircularProgressIndicator(),
                  ],
                  if (state.status == Status.failure) ...[
                    const Text('error'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LoginCubit>().changeInit();
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                  if (state.status == Status.success) ...[
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                        context.read<LoginCubit>().changeInit();
                      },

                      child: const Text('Выйти'),
                    ),
                  ]
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
