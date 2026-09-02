import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_core/resto_core.dart';
import '../cubit/admin_dashboard_cubit.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        final products = state.products;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إدارة قائمة المأكولات والمخزون (Menu & Stock)',
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCharcoal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'التحكم في توفر الأصناف، إضافة وجبات جديدة، وإدارة صور ومواصفات الأطباق',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariantLight,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryTerracotta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(RestoIcons.plus, size: 18),
                    label: Text(
                      'إضافة صنف جديد للقائمة',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _showAddProductDialog(context, state.categories),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Menu Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 420,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final allImgs = product.allImages;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(
                        color: product.isAvailable
                            ? AppColors.outlineLight
                            : AppColors.errorRed.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with multiple photo badge
                        GestureDetector(
                          onTap: () => _showProductPhotosDialog(context, product),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 110,
                                    height: 110,
                                    color: AppColors.surfaceLight,
                                    child: const Icon(Icons.restaurant, size: 32, color: AppColors.secondaryTerracotta),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.photo_library, color: Colors.white, size: 10),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${allImgs.length}',
                                        style: GoogleFonts.cairo(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Info & Controls
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.name,
                                          style: GoogleFonts.cairo(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.primaryCharcoal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                                        tooltip: 'إدارة صور الصنف',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        color: AppColors.secondaryTerracotta,
                                        onPressed: () => _showProductPhotosDialog(context, product),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    CurrencyFormatter.format(product.price),
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryTerracotta,
                                    ),
                                  ),
                                  Text(
                                    product.categoryName,
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: AppColors.onSurfaceVariantLight,
                                    ),
                                  ),
                                ],
                              ),

                              // Status & Switch (Protected from overflow)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.isAvailable ? 'متوفر الآن' : 'غير متوفر',
                                      style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: product.isAvailable
                                            ? AppColors.successGreen
                                            : AppColors.errorRed,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: product.isAvailable,
                                      activeThumbColor: AppColors.successGreen,
                                      onChanged: (_) {
                                        context
                                            .read<AdminDashboardCubit>()
                                            .toggleProductAvailability(product.id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Add Product Modal Form
  void _showAddProductDialog(BuildContext context, List<CategoryModel> categories) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final prepTimeController = TextEditingController(text: '25');
    final newPhotoUrlController = TextEditingController();
    String selectedCategory = categories.isNotEmpty ? categories.first.id : 'cat_grills';
    String selectedCategoryName = categories.isNotEmpty ? categories.first.name : 'مشويات وفحم';
    final List<String> productPhotos = [];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(RestoIcons.plus, color: AppColors.secondaryTerracotta, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'إضافة طبق جديد للقائمة',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              content: SizedBox(
                width: 580,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Category
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'اسم الطبق / الوجبة *',
                                labelStyle: GoogleFonts.cairo(fontSize: 13),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedCategory,
                              decoration: InputDecoration(
                                labelText: 'الفئة',
                                labelStyle: GoogleFonts.cairo(fontSize: 13),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: categories.map((c) {
                                return DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name, style: GoogleFonts.cairo(fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() {
                                    selectedCategory = val;
                                    selectedCategoryName =
                                        categories.firstWhere((c) => c.id == val).name;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price & Prep Time
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'السعر (ج.م) *',
                                labelStyle: GoogleFonts.cairo(fontSize: 13),
                                prefixText: 'EGP ',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: prepTimeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'وقت التحضير (دقائق)',
                                labelStyle: GoogleFonts.cairo(fontSize: 13),
                                suffixText: 'دقيقة',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextField(
                        controller: descController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'وصف الطبق والمكونات الرئيسية',
                          labelStyle: GoogleFonts.cairo(fontSize: 13),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Photos Section
                      Text(
                        'صور الصنف (يمكنك إضافة أكثر من صورة):',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),

                      // Add photo input bar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: newPhotoUrlController,
                              decoration: InputDecoration(
                                hintText: 'أدخل رابط الصورة (URL) أو اختر نموذجاً سريعا',
                                hintStyle: GoogleFonts.cairo(fontSize: 11),
                                isDense: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryCharcoal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.add, size: 16),
                            label: Text('إضافة صورة', style: GoogleFonts.cairo(fontSize: 12)),
                            onPressed: () {
                              final url = newPhotoUrlController.text.trim();
                              if (url.isNotEmpty) {
                                setModalState(() {
                                  productPhotos.add(url);
                                  newPhotoUrlController.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Quick photo presets
                      Wrap(
                        spacing: 8,
                        children: [
                          _presetChip('مشويات فحم', AppAssets.kebabImg, productPhotos, setModalState),
                          _presetChip('طاجن بامية', AppAssets.molokhiaImg, productPhotos, setModalState),
                          _presetChip('حمام محشي', AppAssets.grillsImg, productPhotos, setModalState),
                          _presetChip('حواوشي بلدي', AppAssets.hawawshiImg, productPhotos, setModalState),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Thumbnails of added photos
                      if (productPhotos.isNotEmpty)
                        Container(
                          height: 90,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.outlineLight),
                          ),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: productPhotos.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, photoIndex) {
                              final pUrl = productPhotos[photoIndex];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      pUrl,
                                      width: 74,
                                      height: 74,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 74,
                                        height: 74,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.broken_image, size: 20),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          productPhotos.removeAt(photoIndex);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black87,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(Icons.close, color: Colors.white, size: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.outlineLight),
                          ),
                          child: Text(
                            'لم تتم إضافة أي صور بعد (سيتم استخدام صورة افتراضية إن تركت فارغة)',
                            style: GoogleFonts.cairo(fontSize: 11, color: AppColors.onSurfaceVariantLight),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('إلغاء', style: GoogleFonts.cairo(color: AppColors.onSurfaceVariantLight)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryTerracotta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: Text('حفظ وإضافة للمنيو', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                    if (name.isEmpty || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى إدخال اسم الصنف والسعر بشكل صحيح')),
                      );
                      return;
                    }

                    final defaultImg = productPhotos.isNotEmpty ? productPhotos.first : AppAssets.kebabImg;
                    final newProd = ProductModel(
                      id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      description: descController.text.trim().isNotEmpty
                          ? descController.text.trim()
                          : 'طبق مصري طازج ولذيذ محضر يومياً بعناية في مطبخ ريستو',
                      price: price,
                      imageUrl: defaultImg,
                      images: productPhotos.isNotEmpty ? productPhotos : [defaultImg],
                      categoryId: selectedCategory,
                      categoryName: selectedCategoryName,
                      preparationTimeMinutes: int.tryParse(prepTimeController.text.trim()) ?? 25,
                      isAvailable: true,
                    );

                    context.read<AdminDashboardCubit>().addProduct(newProd);
                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تمت إضافة "$name" بنجاح مع ${newProd.allImages.length} صور!'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _presetChip(String label, String url, List<String> photos, StateSetter setModalState) {
    return ActionChip(
      label: Text(label, style: GoogleFonts.cairo(fontSize: 10)),
      avatar: const Icon(Icons.image, size: 12),
      onPressed: () {
        setModalState(() {
          if (!photos.contains(url)) {
            photos.add(url);
          }
        });
      },
    );
  }

  // Manage Photos for Existing Product Dialog
  void _showProductPhotosDialog(BuildContext context, ProductModel product) {
    final photoUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final allImgs = List<String>.from(product.allImages);

            return AlertDialog(
              title: Text(
                'صور الصنف: ${product.name}',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصور الحالية (${allImgs.length}):',
                      style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: allImgs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, idx) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              allImgs[idx],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.restaurant),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'إضافة صورة جديدة:',
                      style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: photoUrlController,
                            decoration: InputDecoration(
                              hintText: 'رابط صورة إضافية (URL)',
                              hintStyle: GoogleFonts.cairo(fontSize: 11),
                              isDense: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryTerracotta,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add_photo_alternate, size: 16),
                          label: Text('إضافة', style: GoogleFonts.cairo(fontSize: 12)),
                          onPressed: () {
                            final url = photoUrlController.text.trim();
                            if (url.isNotEmpty) {
                              final updatedImages = List<String>.from(product.allImages)..add(url);
                              final updatedProduct = product.copyWith(images: updatedImages);
                              context.read<AdminDashboardCubit>().addProduct(updatedProduct);
                              photoUrlController.clear();
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تمت إضافة الصورة بنجاح!')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('إغلاق', style: GoogleFonts.cairo()),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
