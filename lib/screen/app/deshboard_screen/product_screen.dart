import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/models/process_response.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';
import 'package:store_app/provider/products_provider.dart';
import 'package:store_app/utils/context_extenssion.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../widgets/app_text_field.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key,this.product});
  final Product? product;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late TextEditingController _nameTextController;
  late TextEditingController _infoTextController;
  late TextEditingController _priceTextController;
  late TextEditingController _quantityTextController;
  late ImagePicker _imagePicker;
  XFile? _pickedImage;

@override
  void initState() {
  _imagePicker = ImagePicker();
  _nameTextController =TextEditingController(text: widget.product?.name);
  _infoTextController =TextEditingController(text: widget.product?.info);
  _priceTextController =TextEditingController(text: widget.product?.price.toString());
  _quantityTextController =TextEditingController(text: widget.product?.quantity.toString());
    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _infoTextController.dispose();
    _priceTextController.dispose();
    _quantityTextController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
        child: ListView(
          children: [
            Text("Product",style: GoogleFonts.cairo(
              fontSize: 22.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),),

            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _buildImageWidget(),
              ),
            ),
            SizedBox(height: 20.h,),
            AppTextField(hint:'Name', keyboardType:  TextInputType.text, controller: _nameTextController),
            SizedBox(height: 10.h,),
            AppTextField(hint:'info', keyboardType:  TextInputType.text, controller: _infoTextController),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Expanded(child: AppTextField(hint:'price', keyboardType:   const TextInputType.numberWithOptions(decimal: false ,signed: false), controller: _priceTextController)),
                SizedBox(width: 10.w,),
                Expanded(child: AppTextField(hint: 'quantity',  keyboardType: const TextInputType.numberWithOptions(decimal: false ,signed: false), controller: _quantityTextController)),

              ],
            ),
            SizedBox(height: 20.h,),
            ElevatedButton(
                onPressed: (){_performSave();}, child: Text('save'))
          ],
        ),
      ),
    );
  }

  void _performSave(){
  if(_checkData()){
    _save();
  }
  }

  Future<void> _pickImage() async {
    final XFile? imageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (imageFile != null) {
      setState(() => _pickedImage = imageFile);
    }
  }


  bool _checkData(){
  if(_nameTextController.text.isNotEmpty
      && _infoTextController.text.isNotEmpty
      && _priceTextController.text.isNotEmpty
      && _quantityTextController.text.isNotEmpty
  ){
    return true;
  }

  context.showSnackBar(message: "error data",error: true);
    return false;
  }

  Future<void> _save ()async{
  //TODO : Call Database save function from ProductProvider as (Intermediate) Layer between UI & Controller ?
   ProcessResponse processResponse = isUpdateProduct
      ? await Provider.of<ProductsProvider>(context,listen: false).update(product)
      : await Provider.of<ProductsProvider>(context,listen: false).create(product);
   context.showSnackBar(message: processResponse.message ,error: processResponse.success);
   if(processResponse.success){
     isUpdateProduct ? Navigator.pop(context) : clear();
   }
  }

  Product get product{
    Product product =isUpdateProduct ? widget.product! : Product();
    product.name = _nameTextController.text;
    product.info = _infoTextController.text;
    product.price = double.parse(_priceTextController.text);
    product.quantity = int.parse(_quantityTextController.text);
    product.imagePath = _pickedImage?.path ?? widget.product?.imagePath ?? '';
    return product;
  }

  void clear(){
    _nameTextController.clear();
    _infoTextController.clear();
    _priceTextController.clear();
    _quantityTextController.clear();
  }

  bool get isUpdateProduct => widget.product != null ;
  String get title => isUpdateProduct
      ? 'Update Product'
       : 'Create Product' ;

  Widget _buildImageWidget() {
    if (_pickedImage != null) {
      return Image.file(
        File(_pickedImage!.path),
        height: 150,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    }

    if (isUpdateProduct && widget.product!.imagePath.isNotEmpty) {
      return Image.file(
        File(widget.product!.imagePath),
        height: 150,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      Icons.camera_alt,
      size: 90,
    );
  }

}



