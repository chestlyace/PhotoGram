import 'package:flutter/material.dart';

import '../theme.dart';
import 'photoTile.dart';

class TileSpan {
  const TileSpan(this.cols, this.rows);

  final int cols;
  final int rows;
}

class GridPlacement {
  const GridPlacement(this.col, this.row, this.colSpan, this.rowSpan);

  final int col;
  final int row;
  final int colSpan;
  final int rowSpan;

  int get colEnd => col + colSpan;
  int get rowEnd => row + rowSpan;
}

/// Places [spans] onto a [columnCount]-column grid in reading order,
/// scanning for the first free block that fits each span.
List<GridPlacement> placeSpans(List<TileSpan> spans, int columnCount) {
  final occupied = <Set<int>>[];
  final placements = <GridPlacement>[];

  for (final span in spans) {
    GridPlacement? found;
    for (var row = 0; found == null; row++) {
      while (row >= occupied.length) {
        occupied.add({});
      }
      for (var col = 0; col + span.cols <= columnCount; col++) {
        var fits = true;
        for (var r = 0; r < span.rows && fits; r++) {
          if (row + r >= occupied.length) {
            break;
          }
          for (var c = col; c < col + span.cols; c++) {
            if (occupied[row + r].contains(c)) {
              fits = false;
              break;
            }
          }
        }
        if (fits) {
          found = GridPlacement(col, row, span.cols, span.rows);
          break;
        }
      }
    }
    for (var r = 0; r < found.rowSpan; r++) {
      while (found.row + r >= occupied.length) {
        occupied.add({});
      }
      for (var c = found.col; c < found.colEnd; c++) {
        occupied[found.row + r].add(c);
      }
    }
    placements.add(found);
  }
  return placements;
}

/// True when the spans form a clean grid with no holes: every row except the
/// last is fully occupied, and the last row is a contiguous run from the left.
/// A trailing partial row (like a single search result) is allowed.
bool isPackedLayout(List<TileSpan> spans, int columnCount) {
  final placements = placeSpans(spans, columnCount);
  final occupiedRows = <int, List<int>>{};
  var rowCount = 0;
  for (final placement in placements) {
    if (placement.rowEnd > rowCount) {
      rowCount = placement.rowEnd;
    }
    for (var r = placement.row; r < placement.rowEnd; r++) {
      for (var c = placement.col; c < placement.colEnd; c++) {
        occupiedRows.putIfAbsent(r, () => []).add(c);
      }
    }
  }
  for (var r = 0; r < rowCount; r++) {
    final cols = occupiedRows[r] ?? <int>[];
    cols.sort();
    final isLast = r == rowCount - 1;
    final expected = isLast ? cols.length : columnCount;
    if (cols.length != expected) {
      return false;
    }
    for (var i = 0; i < cols.length; i++) {
      if (cols[i] != i) {
        return false;
      }
    }
  }
  return true;
}

/// Produces a hole-free layout for any count on a 3-column grid: full rows
/// of three squares, with the tail row as a 2/3-wide tile plus a square.
List<TileSpan> packedSpans(int count) {
  final spans = <TileSpan>[];
  var remaining = count;
  while (remaining > 0) {
    if (remaining >= 3) {
      spans
        ..add(const TileSpan(1, 1))
        ..add(const TileSpan(1, 1))
        ..add(const TileSpan(1, 1));
      remaining -= 3;
    } else if (remaining == 2) {
      spans
        ..add(const TileSpan(2, 1))
        ..add(const TileSpan(1, 1));
      remaining = 0;
    } else {
      spans.add(const TileSpan(1, 1));
      remaining = 0;
    }
  }
  return spans;
}

/// A fixed-cell mosaic where tiles can span multiple columns and rows,
/// like the Google Photos grid. Tiles are square; the outer container
/// clips them to its rounded corners.
class MosaicGrid extends StatelessWidget {
  const MosaicGrid({
    super.key,
    required this.seeds,
    required this.spans,
    this.columnCount = 3,
    this.gap = 0,
    this.radius = AppRadii.grid,
    this.onPhotoTap,
  }) : assert(seeds.length == spans.length);

  final List<String> seeds;
  final List<TileSpan> spans;
  final int columnCount;
  final double gap;
  final double radius;
  final ValueChanged<int>? onPhotoTap;

  @override
  Widget build(BuildContext context) {
    final placements = placeSpans(spans, columnCount);
    var rowCount = 0;
    for (final placement in placements) {
      if (placement.rowEnd > rowCount) {
        rowCount = placement.rowEnd;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: NeumorphicShadows.convex,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cell =
              (constraints.maxWidth - (columnCount - 1) * gap) / columnCount;
          final step = cell + gap;
          final height = rowCount * cell + (rowCount - 1) * gap;

          return SizedBox(
            width: constraints.maxWidth,
            height: height,
            child: Stack(
              children: [
                for (var i = 0; i < placements.length; i++)
                  Positioned(
                    left: placements[i].col * step,
                    top: placements[i].row * step,
                    width: placements[i].colSpan * cell +
                        (placements[i].colSpan - 1) * gap,
                    height: placements[i].rowSpan * cell +
                        (placements[i].rowSpan - 1) * gap,
                    child: GestureDetector(
                      onTap: onPhotoTap == null ? null : () => onPhotoTap!(i),
                      child: PhotoTile(seed: seeds[i], variation: i),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
