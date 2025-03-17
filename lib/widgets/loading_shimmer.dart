import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  
  const LoadingShimmer({
    Key? key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SpeciesCardShimmer extends StatelessWidget {
  const SpeciesCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          const LoadingShimmer(
            height: 150,
            borderRadius: 0,
          ),
          
          // Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LoadingShimmer(
                  height: 16,
                  width: 120,
                ),
                SizedBox(height: 4),
                LoadingShimmer(
                  height: 12,
                  width: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpeciesDetailsShimmer extends StatelessWidget {
  const SpeciesDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header image
          const LoadingShimmer(
            height: 250,
            borderRadius: 0,
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const LoadingShimmer(
                  height: 24,
                  width: 200,
                ),
                const SizedBox(height: 8),
                
                // Scientific name
                const LoadingShimmer(
                  height: 16,
                  width: 180,
                ),
                const SizedBox(height: 24),
                
                // Quick facts card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoadingShimmer(
                          height: 18,
                          width: 100,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(
                              child: LoadingShimmer(
                                height: 40,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: LoadingShimmer(
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(
                              child: LoadingShimmer(
                                height: 40,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: LoadingShimmer(
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Description section
                const LoadingShimmer(
                  height: 18,
                  width: 120,
                ),
                const SizedBox(height: 8),
                const LoadingShimmer(
                  height: 100,
                ),
                
                const SizedBox(height: 24),
                
                // Habitat section
                const LoadingShimmer(
                  height: 18,
                  width: 80,
                ),
                const SizedBox(height: 8),
                const LoadingShimmer(
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

