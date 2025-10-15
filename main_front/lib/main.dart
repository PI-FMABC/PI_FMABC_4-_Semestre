// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/folders.dart';
import 'screens/index.dart';
import 'screens/gallery.dart';
import 'screens/image_viewer.dart';
import 'screens/home_prof.dart';
import 'screens/folders_prof.dart';
import 'screens/index_prof.dart';
import 'screens/gallery_prof.dart';
import 'screens/add_folder_prof.dart';

void main() {
  runApp(const AtlasApp());
}

class AtlasApp extends StatelessWidget {
  const AtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas de Citologia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF003b64),
        fontFamily: 'OpenSans',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/folders': (context) => const FoldersScreen(),
        '/index': (context) => const IndexScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/image-viewer': (context) => const ImageViewerScreen(),
        '/prof': (context) => HomeProfScreen(),
        '/folders_prof': (context) => FoldersProfScreen(),
        '/index_prof': (context) => IndexProfScreen(),
        '/gallery_prof': (context) => const GalleryProfScreen(),
        '/add_folder_prof': (context) => const AddFoldersScreen(),
        // '/image-viewer_prof': (context) => const ImageViewerProfScreen(),
      },
    );
  }
}
