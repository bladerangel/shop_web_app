import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

class ManageEditProductScreen extends StatefulWidget {
  static const route = '/manage_edit_product';

  @override
  _ManageEditProductScreenState createState() =>
      _ManageEditProductScreenState();
}

class _ManageEditProductScreenState extends State<ManageEditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;

  ProductProvider _editProduct = ProductProvider(
    id: null,
    title: null,
    description: null,
    price: null,
    imageUrl: null,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final ProductProvider product = ModalRoute.of(context).settings.arguments;
      if (product != null) {
        _editProduct = product;
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus &&
        ((!_imageUrlController.text.startsWith('http') &&
                !_imageUrlController.text.startsWith('https')) ||
            (!_imageUrlController.text.endsWith('.jpg') &&
                !_imageUrlController.text.endsWith('.jpeg') &&
                !_imageUrlController.text.endsWith('.png')))) {
      return;
    }
    setState(() {});
  }

  void _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editProduct.id != null) {
      final ProductsProvider productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      productsProvider.updateProduct(_editProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      final ProductsProvider productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      await productsProvider.addProduct(_editProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Edit Product',
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editProduct.title,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(
                        _priceFocusNode,
                      ),
                      onSaved: (value) => _editProduct = _editProduct.copy(
                        title: value,
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Title is required field.' : null,
                    ),
                    TextFormField(
                      initialValue: _editProduct.price?.toString(),
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(
                        _descriptionFocusNode,
                      ),
                      onSaved: (value) => _editProduct = _editProduct.copy(
                        price: double.parse(value),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Price is required field.';
                        }

                        if (double.tryParse(value) == null) {
                          return 'Price is invalid number.';
                        }

                        if (double.tryParse(value) <= 0) {
                          return 'Price must be greater than 0.';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _editProduct.description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) => _editProduct = _editProduct.copy(
                        description: value,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Description is required field.';
                        }

                        if (value.length < 10) {
                          return 'Description must be greater than 10.';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (value) {
                              _saveForm();
                            },
                            onSaved: (value) =>
                                _editProduct = _editProduct.copy(
                              imageUrl: value,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Image URL is required field.';
                              }

                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Image URL is invalid url.';
                              }

                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg') &&
                                  !value.endsWith('.png')) {
                                return 'Image URL is invalid extension.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
