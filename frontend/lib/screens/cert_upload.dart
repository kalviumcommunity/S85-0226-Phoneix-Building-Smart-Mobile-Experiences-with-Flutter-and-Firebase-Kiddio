import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CertUpload extends StatefulWidget {
  final String userId;
  const CertUpload({Key? key, required this.userId}) : super(key: key);

  @override
  State<CertUpload> createState() => _CertUploadState();
}

class _CertUploadState extends State<CertUpload> {
  File? _imageFile;
  bool _uploading = false;
  double _progress = 0.0;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _upload() async {
    if (_imageFile == null) return;
    setState(() {
      _uploading = true;
      _progress = 0.0;
    });

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'certifications/${widget.userId}/$fileName';
    final uploadTask = storageRef.child(path).putFile(_imageFile!);

    uploadTask.snapshotEvents.listen((TaskSnapshot snap) {
      final p = snap.totalBytes > 0 ? snap.bytesTransferred / snap.totalBytes : 0.0;
      setState(() => _progress = p);
    }, onError: (e) {
      // ignore errors here; handled below
    });

    try {
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      // Save metadata in Firestore
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('certifications')
          .doc();

      await docRef.set({
        'url': url,
        'uploadedAt': FieldValue.serverTimestamp(),
        'fileName': fileName,
      });

      if (mounted) {
        setState(() {
          _uploading = false;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Certification uploaded')));
    } catch (e) {
      if (mounted) setState(() => _uploading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Certification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null) ...[
              Image.file(_imageFile!, height: 240, fit: BoxFit.contain),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text('Choose Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _uploading ? null : _upload,
              icon: const Icon(Icons.cloud_upload),
              label: Text(_uploading ? 'Uploading... (${(_progress * 100).toStringAsFixed(0)}%)' : 'Upload Certification'),
            ),
            const SizedBox(height: 12),
            if (_uploading)
              LinearProgressIndicator(value: _progress)
            else
              const SizedBox(height: 4),
            const SizedBox(height: 12),
            const Text(
              'Uploaded certifications are saved under your user document in Firestore (collection: certifications). The file is stored in Firebase Storage under certifications/<userId>/.',
            ),
          ],
        ),
      ),
    );
  }
}
