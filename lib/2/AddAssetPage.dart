import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moc_01/modelHive.dart';

class AddAssetPage extends StatefulWidget {
  final Asset? asset;
  final int? index;

  const AddAssetPage({super.key, this.asset, this.index});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _serialNumberController = TextEditingController();

  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      _nameController.text = widget.asset!.name;
      _typeController.text = widget.asset!.type;
      _descriptionController.text = widget.asset!.description;
      _serialNumberController.text = widget.asset!.serialNumber;
      _isAvailable = widget.asset!.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveAsset() async {
    try {
      setState(() => _isLoading = true);

      final assetBox = Hive.box<Asset>('assets');

      final newAsset = Asset(
        name: _nameController.text,
        type: _typeController.text,
        description: _descriptionController.text,
        serialNumber: _serialNumberController.text,
        isAvailable: _isAvailable,
      );

      if (widget.index == null) {
        await assetBox.add(newAsset);
      } else {
        await assetBox.putAt(widget.index!, newAsset);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset saved successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving asset: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asset == null ? 'Add Asset' : 'Edit Asset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _typeController,
                label: 'Type',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a type' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _serialNumberController,
                label: 'Serial Number',
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter a serial number'
                    : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Available'),
                subtitle: Text(_isAvailable
                    ? 'Asset is available'
                    : 'Asset is not available'),
                value: _isAvailable,
                onChanged: (value) => setState(() => _isAvailable = value),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade700,
                    disabledBackgroundColor: Colors.blue.shade200,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _saveAsset();
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Asset'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      maxLines: maxLines,
      validator: validator,
);
}
}
