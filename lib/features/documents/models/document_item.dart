import 'package:flutter/material.dart';

enum DocumentType {
  pdf,
  docx,
  txt,
  link,
}

enum DocumentStatus {
  ready,
  processing,
  uploaded,
  none,
}

class DocumentItem {
  final String id;
  final String title;
  final DocumentType type;
  final String folder;
  final String dateDisplay;
  final List<String> tags;
  final DocumentStatus status;
  final int sizeInKb;
  final DateTime updatedAt;

  const DocumentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.folder,
    required this.dateDisplay,
    required this.tags,
    this.status = DocumentStatus.none,
    required this.sizeInKb,
    required this.updatedAt,
  });

  DocumentItem copyWith({
    String? id,
    String? title,
    DocumentType? type,
    String? folder,
    String? dateDisplay,
    List<String>? tags,
    DocumentStatus? status,
    int? sizeInKb,
    DateTime? updatedAt,
  }) {
    return DocumentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      folder: folder ?? this.folder,
      dateDisplay: dateDisplay ?? this.dateDisplay,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      sizeInKb: sizeInKb ?? this.sizeInKb,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Color for document icon container background
  Color get iconContainerBg {
    switch (type) {
      case DocumentType.pdf:
        return const Color(0xFFFEF2F2); // Red-50
      case DocumentType.docx:
        return const Color(0xFFEFF6FF); // Blue-50
      case DocumentType.txt:
        return const Color(0xFFF8FAFC); // Slate-50
      case DocumentType.link:
        return const Color(0xFFF0FDFA); // Teal-50
    }
  }

  /// Color for document icon border
  Color get iconContainerBorder {
    switch (type) {
      case DocumentType.pdf:
        return const Color(0xFFFECDD3); // Red-200
      case DocumentType.docx:
        return const Color(0xFFBFDBFE); // Blue-200
      case DocumentType.txt:
        return const Color(0xFFE2E8F0); // Slate-200
      case DocumentType.link:
        return const Color(0xFF99F6E4); // Teal-200
    }
  }

  /// Primary color for document type
  Color get typeColor {
    switch (type) {
      case DocumentType.pdf:
        return const Color(0xFFEF4444); // Red-500
      case DocumentType.docx:
        return const Color(0xFF3B82F6); // Blue-500
      case DocumentType.txt:
        return const Color(0xFF64748B); // Slate-500
      case DocumentType.link:
        return const Color(0xFF0D9488); // Teal-600
    }
  }

  /// Status badge label
  String get statusLabel {
    switch (status) {
      case DocumentStatus.ready:
        return 'Ready';
      case DocumentStatus.processing:
        return 'Processing';
      case DocumentStatus.uploaded:
        return 'Uploaded';
      case DocumentStatus.none:
        return '';
    }
  }

  /// Status badge text and icon color
  Color get statusColor {
    switch (status) {
      case DocumentStatus.ready:
        return const Color(0xFF10B981); // Emerald-500
      case DocumentStatus.processing:
        return const Color(0xFFD97706); // Amber-600
      case DocumentStatus.uploaded:
        return const Color(0xFF475569); // Slate-600
      case DocumentStatus.none:
        return Colors.transparent;
    }
  }

  /// Status badge background color
  Color get statusBgColor {
    switch (status) {
      case DocumentStatus.ready:
        return const Color(0xFFECFDF5); // Emerald-50
      case DocumentStatus.processing:
        return const Color(0xFFFFFBEB); // Amber-50
      case DocumentStatus.uploaded:
        return const Color(0xFFF1F5F9); // Slate-100
      case DocumentStatus.none:
        return Colors.transparent;
    }
  }

  /// Initial mock list of documents matching the user's UI screenshot
  static List<DocumentItem> get initialDocuments => [
        DocumentItem(
          id: 'doc-1',
          title: 'Q3 Financial Summary.pdf',
          type: DocumentType.pdf,
          folder: 'Financials',
          dateDisplay: 'Today, 9:42 AM',
          tags: ['#q3', '#finance'],
          status: DocumentStatus.ready,
          sizeInKb: 14200,
          updatedAt: DateTime(2026, 10, 15, 9, 42),
        ),
        DocumentItem(
          id: 'doc-2',
          title: 'Engineering Architecture v2.docx',
          type: DocumentType.docx,
          folder: 'Engineering',
          dateDisplay: 'Yesterday',
          tags: ['#architecture', '#backend'],
          status: DocumentStatus.processing,
          sizeInKb: 48600,
          updatedAt: DateTime(2026, 10, 14, 15, 20),
        ),
        DocumentItem(
          id: 'doc-3',
          title: 'Draft Notes - Oct 14.txt',
          type: DocumentType.txt,
          folder: 'General',
          dateDisplay: 'Oct 14',
          tags: ['#meeting', '#draft'],
          status: DocumentStatus.uploaded,
          sizeInKb: 1200,
          updatedAt: DateTime(2026, 10, 14, 10, 0),
        ),
        DocumentItem(
          id: 'doc-4',
          title: 'API Reference - Auth.link',
          type: DocumentType.link,
          folder: 'Engineering',
          dateDisplay: 'Oct 12',
          tags: ['#api', '#security'],
          status: DocumentStatus.none,
          sizeInKb: 250,
          updatedAt: DateTime(2026, 10, 12, 11, 15),
        ),
      ];
}
