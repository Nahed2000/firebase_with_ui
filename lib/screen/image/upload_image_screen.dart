import 'dart:io';

import 'package:firebase_with_ui/bloc/bloc/images_bloc.dart';
import 'package:firebase_with_ui/bloc/event/crud_event.dart';
import 'package:firebase_with_ui/bloc/state/crud_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../util/helper.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> with Helper {
  //TODO: Create XFILE? variable which will hold selected/captured image
  XFile? _pickedImage;

  //TODO: Create instance from ImagePicker
  late ImagePicker _imagePicker;

  //TODO: Create value variable for ProgressIndicator
  double? _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'UPLOAD IMAGE',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<ImagesBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState &&
            current.processType == ProcessType.create,
        listener: (context, state) {
          state as ProcessState;
          showSnackBar(context, message: state.message, error: !state.status);
         },
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _progressValue,
              minHeight: 10,
              color: Colors.green,
              backgroundColor: Colors.green.shade100,
            ),
            Expanded(
              child: _pickedImage == null
                  ? Center(
                      child: IconButton(
                        onPressed: () async => await _pickImage(),
                        iconSize: 48,
                        icon: const Icon(Icons.camera_enhance_outlined),
                      ),
                    )
                  : Image.file(
                      File(_pickedImage!.path),
                      // fit: BoxFit.cover,
                    ),
            ),
            ElevatedButton.icon(
              onPressed: () => _performImageUpload(),
              icon: const Icon(Icons.cloud_upload),
              label: Text(
                'UPLOAD IMAGE',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  void _performImageUpload() async {
    if (_checkData()) {
      _uploadImage();
    }
  }

  bool _checkData() {
    if (_pickedImage != null) {
      return true;
    }
    showSnackBar(context, message: 'Pick image to upload!', error: true);
    return false;
  }

  void _uploadImage() async {
    _updateProgressValue();
    BlocProvider.of<ImagesBloc>(context)
        .add(CreateEvent(file: File(_pickedImage!.path)));
  }

  void _updateProgressValue({double? value}) {
    setState(() => _progressValue = value);
  }
}
