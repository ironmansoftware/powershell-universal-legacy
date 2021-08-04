import React from "react";
import { TableCell, TableHead, TableRow, TableSortLabel } from "@material-ui/core";
import { setCellPadding } from "../v2/utilities";

export default function BaseTableHead({ headerGroups, columns }) {
 

  function setTableSortLabel(column) {
    return column.id !== "selection" && column.getSortByToggleProps ? (
      <TableSortLabel
        active={column.isSorted}
        direction={column.isSortedDesc ? "desc" : "asc"}
      />
    ) : null;
  }
  
  return (
    <TableHead>
      {headerGroups.map((headerGroup) => (
        <React.Fragment>
          <TableRow {...headerGroup.getHeaderGroupProps()}>
            {headerGroup.headers.map((column, index) => (
              <TableCell
                {...(column.id === "selection" || !column.getSortByToggleProps
                  ? column.getHeaderProps()
                  : column.getHeaderProps(column.getSortByToggleProps()))}
                align={column.align}
                padding={setCellPadding(column.id, index)}
              >
                {column.render("Header")}
                {setTableSortLabel(column)}
              </TableCell>
            ))}
          </TableRow>
          <TableRow
            style={{
              display: !columns.some((column) => column.showFilter) && "none",
            }}
          >
            {headerGroup.headers.map((column, index) => (
              <TableCell padding={setCellPadding(column.id, index)}>
                {column.showFilter ? column.render("Filter") : null}
              </TableCell>
            ))}
          </TableRow>
        </React.Fragment>
      ))}
    </TableHead>
  );
}