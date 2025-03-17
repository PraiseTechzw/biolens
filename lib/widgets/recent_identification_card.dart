import 'package:flutter/material.dart';
import 'dart:io';
import '../models/species.dart';

class RecentIdentificationCard extends StatelessWidget {
  final Identification identification;
  final VoidCallback onTap;
  
  const RecentIdentificationCard({
    Key? key,
    required this.identification,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  Image.file(
                    File(identification.imageUrl.startsWith('/')
                        ? identification.imageUrl.replaceFirst('/', '')
                        : identification.imageUrl),
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        '/placeholder.svg?height=100&width=120',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(identification.confidence),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        '${(identification.confidence * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      identification.species.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateTime.parse(identification.dateTime)
                          .toString()
                          .substring(0, 16),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) {
      return Colors.green;
    } else if (confidence >= 0.7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

