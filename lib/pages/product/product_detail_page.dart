import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/provider/product_detail_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    const topBarHeight = 48.0; // your Dashboard SafeArea Row
    final listTop = safeTop + topBarHeight + 8; // search bar height + spacing

    final double screenHeight = MediaQuery.of(context).size.height;
    final pageController = PageController();

    return AppScaffold(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(left: 24, right: 24, top: listTop),
            children: [
              // --- Product Image Carousel ---
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: screenHeight * 0.4,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: 5, // Number of product images
                      onPageChanged: (index) =>
                          context.read<ProductDetailProvider>().setPage(index),
                      itemBuilder: (context, index) {
                        return loadAssetImage(
                          name: productImage,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  // --- Custom Dot Indicator ---
                  Positioned(
                    bottom: 8,
                    child: Consumer<ProductDetailProvider>(
                      builder: (cntx, provider, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              width: provider.currentPage == index ? 18 : 8,
                              height: 8.0,
                              decoration: BoxDecoration(
                                //shape: BoxShape.circle,
                                color: provider.currentPage == index
                                    ? Colors.white
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              loadTitleText(title: 'Umbrella Lamp-Large 36" ', fontSize: 18),
              const SizedBox(height: 8),
              loadTitleText(title: '\$199.00'),
              const SizedBox(height: 8),
              Text(
                5 > 0 ? "In Stock: ${5}" : "Out of Stock",
                style: TextStyle(
                  fontSize: 14,
                  color: 5 > 0 ? Colors.black87 : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              // 📜 Description
              const Text(
                "A beautifully handcrafted hanging lamp inspired by the soft curves of an umbrella. "
                "Designed with intricate detailing and woven texture, it casts a warm, diffused glow "
                "that enhances any interior space. Perfect for living rooms, bedrooms, or cafés, this "
                "36-inch large size makes it a statement piece that blends elegance and functionality.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              // 🔹 Features
              const Text(
                "Features",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loadSubText(title: "• Diameter: 36 inches (Large size)"),
                  loadSubText(title: "• Handcrafted with premium materials"),
                  loadSubText(title: "• Soft ambient lighting for cozy spaces"),
                  loadSubText(title: "• Easy ceiling mount"),
                  loadSubText(
                    title: "• Suitable for modern and traditional décor",
                  ),
                ],
              ),
            ],
          ),
          appNavigationBar(
            title: "PRODUCT DETAIL",
            onTap: () {
              context.read<ProductDetailProvider>().resetProductPage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
