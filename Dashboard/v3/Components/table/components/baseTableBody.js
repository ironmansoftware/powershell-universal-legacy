import React from "react";
import { TableBody, TableCell, TableRow } from "@material-ui/core";
import { setCellPadding, setEmptyRows } from "../v2/utilities";

export default function BaseTableBody({
  getTableBodyProps,
  prepareRow,
  totalData,
  pageSize,
  pageIndex,
  visibleColumns,
  // getCellProps,
  isDense,
  page
}) {
  return (
    <TableBody {...getTableBodyProps()}>
      {page.map((row, i) => {
        prepareRow(row);
        return (
          <TableRow {...row.getRowProps()}>
            {row.cells.map((cell, index) => {
              return (
                <TableCell
                  {...cell.getCellProps()}
                  style={cell.column?.style}
                  align={cell.column?.align}
                  padding={setCellPadding(cell.column.id, index)}
                >
                  {cell.render("Cell")}
                </TableCell>
              );
            })}
          </TableRow>
        );
      })}
      {setEmptyRows({ totalData, pageSize, pageIndex, visibleColumns, isDense })}
    </TableBody>
  );
}