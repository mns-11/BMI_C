import 'package:flutter/material.dart';
import '../models/reciter.dart';
import '../data/reciters_data.dart';

class ReciterSelector extends StatefulWidget {
  final Reciter selectedReciter;
  final Function(Reciter) onReciterChanged;

  const ReciterSelector({
    super.key,
    required this.selectedReciter,
    required this.onReciterChanged,
  });

  @override
  State<ReciterSelector> createState() => _ReciterSelectorState();
}

class _ReciterSelectorState extends State<ReciterSelector> {
  late Reciter _currentReciter;

  @override
  void initState() {
    super.initState();
    _currentReciter = widget.selectedReciter;
  }

  @override
  void didUpdateWidget(ReciterSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedReciter != widget.selectedReciter) {
      _currentReciter = widget.selectedReciter;
    }
  }

  void _showReciterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'اختر القارئ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          children: [
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: reciters.length,
                itemBuilder: (context, index) {
                  final reciter = reciters[index];
                  final bool isSelected = _currentReciter.name == reciter.name;
                  return SimpleDialogOption(
                    onPressed: () {
                      setState(() {
                        _currentReciter = reciter;
                      });
                      widget.onReciterChanged(reciter);
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? const Color(0xFFD5580F)
                            : Colors.grey.shade200,
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                      title: Text(
                        reciter.name,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? const Color(0xFFD5580F) : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        reciter.country,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.grey, fontFamily: 'Amiri'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFFD5580F).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: _showReciterDialog,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD5580F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.mic,
                  color: Color(0xFFD5580F),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentReciter.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        fontFamily: 'Amiri',
                      ),
                    ),
                    Text(
                      _currentReciter.country,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFFD5580F),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}