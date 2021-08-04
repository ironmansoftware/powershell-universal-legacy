//@ts-check
import React from "react"
import { TableFooter, TablePagination, TableRow, LinearProgress } from "@material-ui/core";
import TablePaginationActions from "../v2/TablePaginationActions";
import { onlyUnique } from "../v2/utilities";

export default function BaseTableFooter({
  userPageSize,
  userPageSizeOptions,
  colSpan,
  count,
  pageIndex,
  gotoPage,
  setPageSize,
  pageSize,
  isVisible,
  loading,
  disablePageSizeAll,
}) {
  function onChangePage(_, newPage) {
    gotoPage(newPage);
  }

  function onChangeRowsPerPage(event) {
    setPageSize(Number(event.target.value));
  }

  var rowsPerPageOptions = [
    userPageSize,
    ...userPageSizeOptions,
  ]

  if (!disablePageSizeAll)
  {
    rowsPerPageOptions.push({ label: "All", value: count })
  }

  return (
    isVisible && <TableFooter>
      <TableRow>  
        {loading ? <LinearProgress style={{marginTop: '20px', marginLeft: '10px' }}/> : <React.Fragment /> }
        <TablePagination
          align="right"
          rowsPerPageOptions={rowsPerPageOptions.sort((a, b) => a - b).filter(onlyUnique)}
          colSpan={colSpan}
          count={count}
          rowsPerPage={pageSize}
          page={pageIndex}
          onChangePage={onChangePage}
          onChangeRowsPerPage={onChangeRowsPerPage}
          ActionsComponent={TablePaginationActions}
        />
      </TableRow>
    </TableFooter>
  );
}