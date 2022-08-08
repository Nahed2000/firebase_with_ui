import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_with_ui/bloc/bloc/images_bloc.dart';
import 'package:firebase_with_ui/bloc/event/crud_event.dart';
import 'package:firebase_with_ui/bloc/state/crud_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/helper.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> with Helper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ImagesBloc>(context).add(ReadEvent());
    //Provider.of<ImagesProvider>(context,listen: false).readImages();
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
          'IMAGES',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/upload_image'),
            icon: const Icon(Icons.camera_alt),
          )
        ],
      ),
      body: BlocConsumer<ImagesBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState &&
            current.processType == ProcessType.delete,
        listener: (context, state) {
          state as ProcessState;
          showSnackBar(context, message: state.message, error: !state.status);
        },
        buildWhen: (previous, current) =>
            current is ReadState || current is LoadingState,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReadState && state.data.isNotEmpty) {
            return GridView.builder(
              itemCount: state.data.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      FutureBuilder<String>(
                        future: state.data[index].getDownloadURL(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());

                          } else if(snapshot.hasData){
                            return CachedNetworkImage(
                              cacheKey: state.data[index].name,
                              width: double.infinity,
                              imageUrl: snapshot.data!,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            );

                          }else{
                            return Icon(Icons.warning_amber);
                          }
                        }
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.black45,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.data[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                color: Colors.red.shade800,
                                onPressed: ()  =>
                                     _deleteImage(index: index),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('NO DATA'),
            );
          }
        },
      ),
    );
  }

  void _deleteImage({required int index})  {
    BlocProvider.of<ImagesBloc>(context).add(DeleteEvent(index: index));
  }
}
