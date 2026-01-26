// lib/features/home/home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/global_provider.dart';
import '../shared/widgets/glass_card.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(homeStateProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: GradientText('MetaClean', gradientColors),
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectImage(context),
                      child: GlassCard(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, size: 120),
                            SizedBox(height: 24),
                            Text('Select Photos', style: Theme.of(context).textTheme.headlineMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
                  QuickActionsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
