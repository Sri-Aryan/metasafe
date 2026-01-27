import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/global_provider.dart';
import 'app_router.dart';

class MetaCleanApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'MetaClean',
      theme: theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(ProviderScope(child: MetaCleanApp()));
}
