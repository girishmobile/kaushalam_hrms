import 'package:flutter/material.dart';
import 'package:neeknots_admin/common/app_scaffold.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/core/constants/string_constant.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/utility/utils.dart';

class AllProductPage extends StatelessWidget {
  const AllProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          _listOfProducts(context),
          headerSection(context),
          _searchBar(context),
          appNavigationBar(
            title: "ALL PRODUCTS",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget headerSection(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final topBarHeight = 48.0; // from Dashboard SafeArea Row
    return Positioned(
      top: safeTop + topBarHeight + 8 + 48 + 16,
      left: 24,
      right: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 8,
        children: [
          loadSubText(title: '1020 Products'),
          Icon(Icons.manage_search_rounded, size: 24, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final topBarHeight = 48.0; // from Dashboard SafeArea Row

    return Positioned(
      top: safeTop + topBarHeight + 8,
      left: 24,
      right: 24,
      child: appTextField(hintText: "search", icon: Icons.search),
    );
  }

  Widget _listOfProducts(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return ListView.separated(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: listTop(context, extra: 24),
        bottom: safeBottom,
      ),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteName.productDetailPage);
            },
            child: _buildProductItem(),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: 20,
    );
  }

  Widget _buildProductItem() {
    return appGlassEffect(
      padding: const EdgeInsets.only(left: 1, right: 4, top: 1, bottom: 1),
      child: Row(
        spacing: 8,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: loadAssetImage(
              name: productImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  "Astribatry product",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  formatPrice(99),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                // Stock info
                Text(
                  10 > 0 ? "In Stock: ${10}" : "Out of Stock",
                  style: TextStyle(
                    fontSize: 12,
                    color: 10 > 0 ? Colors.black54 : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          appForwardIcon(),
        ],
      ),
    );
  }
}
