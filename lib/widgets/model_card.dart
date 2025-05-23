import 'package:flutter/material.dart';
import '../models/model_3d.dart';
import '../services/supabase_rating_service.dart';
import '../screens/rating_screen.dart';
import '../screens/model_viewer_screen.dart';

class ModelCard extends StatefulWidget {
  final Model3D model;
  
  const ModelCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  
  @override
  _ModelCardState createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  final SupabaseRatingService _ratingService = SupabaseRatingService();
  double _averageRating = 0.0;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadAverageRating();
  }
  
  Future<void> _loadAverageRating() async {
    try {
      final average = await _ratingService.getAverageRating(widget.model.id);
      
      if (mounted) {
        setState(() {
          _averageRating = average;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Erro ao carregar média: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do modelo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.model.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Informações do modelo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Categoria: ${_formatCategory(widget.model.category)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 4,
                            width: 32,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(widget.model.category),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _isLoading ? 'Carregando...' : _averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botão de avaliação
                SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.star, size: 18),
                    label: const Text(
                      'Avaliar',
                      style: TextStyle(fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RatingScreen(model: widget.model),
                        ),
                      );
                      _loadAverageRating();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Botão de visualização 3D
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.view_in_ar, size: 18),
                    label: const Text(
                      'Visual 3D',
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF336633),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModelViewerScreen(model: widget.model),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatCategory(String category) {
    switch (category) {
      case 'calcados':
        return 'Calçados';
      case 'caixas':
        return 'Caixas';
      case 'comidas':
        return 'Comidas';
      case 'utensilios':
        return 'Utensílios';
      default:
        return category;
    }
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'calcados':
        return const Color(0xFF0000A0); // Azul escuro neon
      case 'caixas':
        return const Color(0xFFFF5500); // Laranja neon
      case 'comidas':
        return const Color(0xFF7B1FA2); // Roxo
      case 'utensilios':
        return const Color(0xFF00796B); // Verde-azulado
      default:
        return Colors.grey;
    }
  }
}