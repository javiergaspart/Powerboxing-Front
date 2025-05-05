import 'package:flutter/material.dart';
import '../models/trainer.dart';

class TrainerProvider with ChangeNotifier {
  Trainer? _trainer;

  Trainer? get trainer => _trainer;

  String? get trainerId => _trainer?.id;

  void setTrainer(Trainer trainer) {
    _trainer = trainer;
    notifyListeners();
  }

  void clearTrainer() {
    _trainer = null;
    notifyListeners();
  }
}
