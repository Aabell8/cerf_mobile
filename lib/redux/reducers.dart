import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/model/model.dart';
// import 'package:cerf_mobile/redux/actions.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    tasks: taskReducer(state.tasks, action),
    isStarted: statusReducer(state.isStarted, action),
  );
}

List<Task> taskReducer(List<Task> state, action) {}

bool statusReducer(bool state, action) {}
