import 'dart:math' as math;

import 'package:f_compass/src/common/state_management/state_management.dart';
import 'package:f_compass/src/features/compass/models/compass_model.dart';
import 'package:f_compass/src/features/compass/view_models/compass_view_model.dart';
import 'package:f_compass/src/features/settings/routes/setting_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompassView extends StatefulWidget {
  final CompassViewModel compassViewModel;

  const CompassView({super.key, required this.compassViewModel});

  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.compassViewModel.initialize();
    });
  }

  @override
  void dispose() {
    widget.compassViewModel.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('F Compass'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(SettingRoutes.setting),
          ),
        ],
      ),
      body: StateBuilderWidget<CompassViewModel, CompassModel>(
        viewModel: widget.compassViewModel,
        builder: (context, model) {
          if (!model.isAvailable) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  model.errorMessage ?? 'Compass unavailable.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          }

          final radians = -model.headingDegrees * math.pi / 180;
          final cardinal = CompassModel.cardinalLabel(model.headingDegrees);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 2,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'N',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: radians,
                        child: Icon(
                          Icons.navigation,
                          size: 120,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  '${model.headingDegrees.toStringAsFixed(1)}°',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  cardinal,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
