import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';

class CameraScreen extends StatefulWidget {
  final Function(String photoPath) onPhotoCaptured;

  const CameraScreen({
    super.key,
    required this.onPhotoCaptured,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIdx = 0;
  bool _isInitialized = false;
  bool _isTakingPhoto = false;
  FlashMode _flashMode = FlashMode.off;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        await _setupCameraController(_cameras![_selectedCameraIdx]);
      } else {
        setState(() {
          _errorMessage = 'No camera devices detected on this hardware.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Camera permission or initialization error: $e';
      });
    }
  }

  Future<void> _setupCameraController(
      CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      await _controller!.setFlashMode(_flashMode);
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize camera controller: $e';
        });
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPhoto) {
      return;
    }

    try {
      setState(() {
        _isTakingPhoto = true;
      });

      final XFile photo = await _controller!.takePicture();
      final docsDir = await getApplicationDocumentsDirectory();
      final savedPath = p.join(
          docsDir.path, 'evidence_${const Uuid().v4().substring(0, 8)}.jpg');

      await File(photo.path).copy(savedPath);

      if (mounted) {
        widget.onPhotoCaptured(savedPath);
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPhoto = false;
        });
      }
    }
  }

  void _switchCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIdx = (_selectedCameraIdx + 1) % _cameras!.length;
    _setupCameraController(_cameras![_selectedCameraIdx]);
  }

  void _toggleFlash() {
    if (_controller == null) return;
    final nextMode =
        _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    _controller!.setFlashMode(nextMode);
    setState(() {
      _flashMode = nextMode;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        foregroundColor: Colors.white,
        title: const Text(
          'Capture Visual Evidence',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _flashMode == FlashMode.torch
                  ? Icons.flash_on_rounded
                  : Icons.flash_off_rounded,
              color: Colors.white,
            ),
            onPressed: _toggleFlash,
          ),
          if (_cameras != null && _cameras!.length > 1)
            IconButton(
              icon: const Icon(Icons.flip_camera_android_rounded,
                  color: Colors.white),
              onPressed: _switchCamera,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.videocam_off_rounded,
                        size: 48, color: EchoTheme.dangerRed),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Return to Capture'),
                    ),
                  ],
                ),
              ),
            )
          : !_isInitialized
              ? const Center(
                  child: CircularProgressIndicator(color: EchoTheme.accentGold))
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    // Camera viewfinder
                    CameraPreview(_controller!),

                    // Viewfinder Framing Overlay
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    // Bottom Shutter Controls
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: InkWell(
                          onTap: _takePicture,
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 76,
                            height: 76,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: EchoTheme.accentGold,
                                shape: BoxShape.circle,
                              ),
                              child: _isTakingPhoto
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Icon(Icons.camera_alt_rounded,
                                      color: EchoTheme.textPrimary, size: 32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
