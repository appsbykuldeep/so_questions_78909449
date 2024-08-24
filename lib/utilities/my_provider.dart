import 'package:done/utilities/provider_service.dart';
import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  // Setter
  Map? _user;
  List<Map<String, dynamic>>? _tasks;
  double? _taskDonePercentage;

  // Getter
  Map? get user => _user;
  List<Map<String, dynamic>>? get tasks => _tasks;
  double? get taskDonePercentage => _taskDonePercentage;

  // Updater
  void setUser(Map? newValue) {
    _user = newValue;
    notifyListeners();
  }

  void setTheme(String newValue) {
    _user!["theme"] = newValue;
    notifyListeners();
  }

  void setUsername(String newValue) {
    _user!["username"] = newValue;
    notifyListeners();
  }

  void setTasks(context, List<Map<String, dynamic>>? newValue) {
    _tasks = newValue;
    notifyListeners();
    ProviderService().updateTaskDonePercentage(
        context); // Mettre à jour l'indicateur de pourcentage
  }

  void setTaskDonePercentage(double? newValue) {
    _taskDonePercentage = newValue;
    notifyListeners();
  }

  void resetProviderInfos() {
    _tasks = null;
    _taskDonePercentage = null;
    notifyListeners();
  }

  void editTask(
    context,
    int taskIndex,
    String fieldName,
    dynamic value,
    bool deleteOperation,
  ) {
    if (fieldName == "images") {
      if (deleteOperation) {
        _tasks![taskIndex][fieldName].remove(value);
      } else {
        _tasks![taskIndex][fieldName].add(value);
      }
    } else {
      if (fieldName == "state") {
        ProviderService().updateTaskDonePercentage(context);
      }
      _tasks![taskIndex][fieldName] = value;
    }
    notifyListeners();
  }

  void deleteTask(context, String taskID) {
    int index = _tasks!.indexWhere((element) => element["ID"] == taskID);
    _tasks!.removeAt(index);
    notifyListeners();
    ProviderService().updateTaskDonePercentage(
        context); // Mettre à jour l'indicateur de pourcentage
  }

  void addTask(context, int index, Map<String, dynamic> data) {
    _tasks!.insert(index, data);
    notifyListeners();
    ProviderService().sortTasks(context); // Retrier les tâches correctement
  }
}
