import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/image_model.dart';

class HomeState {
  final bool isLoading;
  final List<ImageFile> recentFiles;
  final String? errorMessage;
  final bool isRefreshing;

  const HomeState({
    this.isLoading = false,
    this.recentFiles = const [],
    this.errorMessage,
    this.isRefreshing = false,
  });

  HomeState copyWith({
    bool? isLoading,
    List<ImageFile>? recentFiles,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      recentFiles: recentFiles ?? this.recentFiles,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState()) {
    _loadRecentFiles();
  }

  Future<void> selectImage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Trigger image picker via service
      // final imageFile = await ImagePickerService.pickImage();
      // await _processImage(imageFile);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to select image: $e',
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await _loadRecentFiles();
    state = state.copyWith(isRefreshing: false);
  }

  Future<void> _loadRecentFiles() async {
    try {
      // Load from SharedPreferences or file system
      final recent = <ImageFile>[];
      state = state.copyWith(recentFiles: recent);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to load recent files');
    }
  }


  Future<void> addRecentFile(ImageFile file) async {
    final updated = [file, ...state.recentFiles];
    state = state.copyWith(recentFiles: updated.take(10).toList());
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final homeStateProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
      (ref) => HomeNotifier(),
);
