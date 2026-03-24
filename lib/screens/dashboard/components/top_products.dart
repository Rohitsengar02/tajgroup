import 'package:flutter/material.dart';
import '../../../constants.dart';

class TopProductsList extends StatelessWidget {
  const TopProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              const Icon(Icons.more_horiz, color: textSecondaryColor),
            ],
          ),
          const SizedBox(height: defaultPadding),
          _buildItem(
             "https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&q=80&w=150&h=150", 
             "Parle-G Biscuit 800g", 
             "FMCG Snacks", 
             "₹78,000",
          ),
          _buildItem(
             "https://images.unsplash.com/photo-1550508138-062400ceae21?auto=format&fit=crop&q=80&w=150&h=150", 
             "Tata Salt 1kg", 
             "Grocery", 
             "₹45,200",
          ),
          _buildItem(
             "https://images.unsplash.com/photo-1621939514649-280e2ee25f60?auto=format&fit=crop&q=80&w=150&h=150", 
             "Maggi 2-Min Noodles", 
             "FMCG Snacks", 
             "₹62,400",
          ),
          _buildItem(
             "https://images.unsplash.com/photo-1631451095765-2c91616fc9e6?auto=format&fit=crop&q=80&w=150&h=150", 
             "Amul Butter 500g", 
             "Dairy", 
             "₹98,100",
          ),
          _buildItem(
             "https://images.unsplash.com/photo-1627483262268-9c2b5b22fceb?auto=format&fit=crop&q=80&w=150&h=150", 
             "Surf Excel Matic", 
             "Detergent", 
             "₹112,000",
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String imageUrl, String name, String category, String revenue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
             borderRadius: BorderRadius.circular(8),
             child: Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimaryColor)),
                Text(category, style: const TextStyle(color: textSecondaryColor, fontSize: 11)),
              ],
            ),
          ),
          Text(revenue, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
