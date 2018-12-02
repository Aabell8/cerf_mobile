import 'package:cerf_mobile/model/Task.dart';

class AppState {
  final List<Task> tasks;
  bool isStarted = false;

  AppState({
    this.tasks,
    this.isStarted
  });

  AppState.initialState() : tasks = List.unmodifiable(<Task>[]);
}