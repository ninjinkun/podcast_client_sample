import 'package:flutter/material.dart';
import '../models/podcast.dart';
import '../services/api_service.dart';

class PodcastProvider with ChangeNotifier {
  List<Podcast> _podcasts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Podcast> get podcasts => _podcasts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> searchPodcasts(String term) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _podcasts = await ApiService.fetchPodcasts(term);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}