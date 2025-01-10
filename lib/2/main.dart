import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moc_01/2/AddAssetPage.dart';
import 'package:moc_01/modelHive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AssetAdapter());
  await Hive.openBox<Asset>('assets');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final assetBox = Hive.box<Asset>('assets');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Management'),
      ),
      body: ValueListenableBuilder(
        valueListenable: assetBox.listenable(),
        builder: (context, Box<Asset> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No assets available.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final asset = box.getAt(index);
              return ListTile(
                title: Text(asset!.name),
                subtitle: Text(
                    '${asset.type} - ${asset.isAvailable ? "Available" : "In Use"}'),
                trailing: Icon(
                  asset.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: asset.isAvailable ? Colors.green : Colors.red,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAssetPage(asset: asset, index: index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAssetPage()),
        ),
        child: const Icon(Icons.add),
     ),
);
}
}
