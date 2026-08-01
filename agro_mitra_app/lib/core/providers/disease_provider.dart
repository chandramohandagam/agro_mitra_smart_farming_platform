import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/disease_service.dart';
import '../models/disease_model.dart';

enum DiseaseStatus { idle, loading, detected, error }

class DiseaseProvider extends ChangeNotifier {
  final DiseaseService _service = DiseaseService();
  final ImagePicker _picker = ImagePicker();

  DiseaseStatus _status = DiseaseStatus.idle;
  DiseaseDetectionResult? _result;
  String? _errorMessage;
  XFile? _selectedImage;

  DiseaseStatus get status => _status;
  DiseaseDetectionResult? get result => _result;
  String? get errorMessage => _errorMessage;
  XFile? get selectedImage => _selectedImage;

  Future<void> pickAndDetect(ImageSource source) async {
    _status = DiseaseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedImage = await _picker.pickImage(source: source);
      if (_selectedImage == null) {
        _status = DiseaseStatus.idle;
        notifyListeners();
        return;
      }

      _result = await _service.detectDisease(_selectedImage!.path);
      _status = DiseaseStatus.detected;
    } catch (e) {
      _status = DiseaseStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void reset() {
    _status = DiseaseStatus.idle;
    _result = null;
    _selectedImage = null;
    notifyListeners();
  }
}
