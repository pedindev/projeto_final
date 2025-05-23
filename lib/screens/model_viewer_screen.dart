import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/model_3d.dart';

class ModelViewerScreen extends StatelessWidget {
  final Model3D model;

  const ModelViewerScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.name),
        backgroundColor: const Color(0xFF336633),
        foregroundColor: Colors.white,
      ),
      body: ModelViewer(
        backgroundColor: const Color(0xFFEEEEEE),
        src: 'assets/${model.glbPath}',
        alt: 'Um modelo 3D de ${model.name}',
        ar: true,
        autoRotate: true,
        cameraControls: true,
        disableZoom: false,
        loading: Loading.eager,
        relatedCss: '''
          model-viewer {
            width: 100%;
            height: 100%;
            background-color: #EEEEEE;
          }
        ''',
        innerModelViewerHtml: '''
          <style>
            model-viewer {
              width: 100%;
              min-height: 100vh;
            }
          </style>
        ''',
      ),
    );
  }
} 